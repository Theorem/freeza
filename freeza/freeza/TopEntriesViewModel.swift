import Foundation

protocol EntriesProvider {
    
    var entries: [EntryViewModel] { get }
    
    func loadEntries(withCompletion completionHandler: @escaping () -> ())
    
    var errorMessage: String? { get }

    func toggleFavorite(entry: EntryViewModel)
    
    var shouldShowMore: Bool { get }
    
    var onEntriesUpdated: () -> () { get set }
}

class TopEntriesViewModel: EntriesProvider {

    
    var shouldShowMore: Bool {
        return true
    }
    
    var errorMessage: String? = nil
    var entries = [EntryViewModel]()

    private let client: Client
    private var afterTag: String? = nil

    let _favoriteService: FavoriteEntriesServiceProtocol
    
    let _onFavoriteUpdated: (EntryModel) -> ()
    
    var onEntriesUpdated: () -> () = { }
    
    init(withClient client: Client,
         favoriteService: FavoriteEntriesServiceProtocol,
         onFavoriteUpdated: @escaping (EntryModel) -> ()) {
        self._favoriteService = favoriteService
        self.client = client
        self._onFavoriteUpdated = onFavoriteUpdated
    }
    
    func reload(entry: EntryViewModel) {
        guard let index = entries.firstIndex(where: {
            $0.model.url == entry.url
        }) else {
            return
        }
        
        entries[index] = EntryViewModel(withModel: entry.model)
        onEntriesUpdated()
    }
    
    func toggleFavorite(entry: EntryViewModel) {
        _onFavoriteUpdated(entry.model)
    }
    
    func loadEntries(withCompletion completionHandler: @escaping () -> ()) {
        
        self.client.fetchTop(after: self.afterTag, completionHandler: { [weak self] responseDictionary in
            
                guard let strongSelf = self else {
                    
                    return
                }
            
                guard let data = responseDictionary["data"] as? [String: AnyObject],
                    let children = data["children"] as? [[String:AnyObject]] else {
                    
                    strongSelf.errorMessage = "Invalid responseDictionary."
                        
                    return
                }
            
                strongSelf.afterTag = data["after"] as? String
            
                let newEntries = children.map { dictionary -> EntryViewModel in

                    // Empty [String: AnyObject] dataDictionary will result in a non-nill EntryViewModel
                    // with hasErrors set to true.
                    let dataDictionary = dictionary["data"] as? [String: AnyObject] ?? [:]
                    
                    let entryModel = EntryModel(
                        withDictionary: dataDictionary,
                        isFavorite: strongSelf._favoriteService.isFavorite(entryUrl: dataDictionary["url"] as? String))
                    let entryViewModel = EntryViewModel(withModel: entryModel)
                    
                    return entryViewModel
                }
            
            strongSelf.entries.append(contentsOf: newEntries)
            
                strongSelf.errorMessage = nil

            DispatchQueue.main.async() {
                    
                    completionHandler()
                }
            
            }, errorHandler: { [weak self] message in
                
                guard let strongSelf = self else {
                    
                    return
                }

                strongSelf.errorMessage = message
                
                DispatchQueue.main.async() {
                    
                    completionHandler()
                }
        })
    }
}
