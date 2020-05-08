import Foundation

struct EntryModel: Equatable {

    let title: String?
    let author: String?
    let creation: Date?
    let thumbnailURL: URL?
    let commentsCount: Int?
    let url: URL?
    let isFavorite: Bool
    let over18: Bool
    
    var isSafeContent: Bool {
        return !over18
    }
    
    var asDictionary: [String: AnyObject] {
        return [
            "title": title.map { $0 as AnyObject },
            "author": author.map { $0 as AnyObject },
            "created_utc": creation.map { $0.timeIntervalSince1970 as AnyObject },
            "thumbnail": thumbnailURL.map { $0.absoluteString as AnyObject },
            "num_comments": commentsCount.map { $0 as AnyObject },
            "url": url.map { $0.absoluteString as AnyObject },
            "over_18": over18 as AnyObject
            ]
            .compactMapValues { $0 }
    }
    
    init(title: String?,
        author: String?,
        creation: Date?,
        thumbnailURL: URL?,
        commentsCount: Int?,
        url: URL?,
        isFavorite: Bool,
        over18: Bool) {
        self.title = title
        self.author = author
        self.creation = creation
        self.thumbnailURL = thumbnailURL
        self.commentsCount = commentsCount
        self.url = url
        self.isFavorite = isFavorite
        self.over18 = over18
    }
    
    init(withDictionary dictionary: [String: AnyObject], isFavorite: Bool) {
        
        func dateFromDictionary(withAttributeName attribute: String) -> Date? {
            
            guard let rawDate = dictionary[attribute] as? Double else {
                
                return nil
            }
            
            return Date(timeIntervalSince1970: rawDate)
        }
        
        func urlFromDictionary(withAttributeName attribute: String) -> URL? {
            
            guard let rawURL = dictionary[attribute] as? String else {
                
                return nil
            }
            
            return URL(string: rawURL)
        }
        
        self.title = dictionary["title"] as? String
        self.author = dictionary["author"] as? String
        self.creation = dateFromDictionary(withAttributeName: "created_utc")
        self.thumbnailURL = urlFromDictionary(withAttributeName: "thumbnail")
        self.commentsCount = dictionary["num_comments"] as? Int
        self.url = urlFromDictionary(withAttributeName: "url")
        self.isFavorite = isFavorite
        self.over18 = dictionary["over_18"] as? Bool ?? false
    }
    
    func updating(isFavorite: Bool? = nil) -> EntryModel {
        return EntryModel(
            title: self.title,
            author: self.author,
            creation: self.creation,
            thumbnailURL: self.thumbnailURL,
            commentsCount: self.commentsCount,
            url: self.url,
            isFavorite: isFavorite ?? self.isFavorite,
            over18: self.over18
        )
    }
    
    public static func == (lhs: EntryModel, rhs: EntryModel) -> Bool {
        guard let leftUrl = lhs.url, let rightUrl = rhs.url else {
            return false
        }
        return leftUrl == rightUrl
    }
}
