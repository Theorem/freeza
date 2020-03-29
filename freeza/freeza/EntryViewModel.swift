import Foundation
import UIKit

class EntryViewModel: Codable {
    
    var hasError = false
    var errorMessage: String? = nil

    var thumbnail = UIImage(named: "thumbnail-placeholder")!
    
    var age: String {
        
        get {
            
            guard let creation = self.creation else {
                
                return "---"
            }
            
            return creation.age()
        }
    }
    
    
    private var thumbnailFetched = false
    
    let title: String
    let author: String
    let commentsCountNumber: Int
    let url: URL?
    let creation: Date?
    let thumbnailURL: URL?


    init(withModel model: EntryModel) {
        
        func markAsMissingRequiredField() {
            
            self.hasError = true
            self.errorMessage = "Missing required field"
        }

        self.title = model.title ?? "Untitled"
        self.author = model.author ?? "Anonymous"
        self.thumbnailURL = model.thumbnailURL
        self.commentsCountNumber = model.commentsCount ?? 0
        self.creation = model.creation
        self.url = model.url

        if model.title == nil ||
            model.author == nil ||
            model.creation == nil ||
            model.commentsCount == nil {
            
            markAsMissingRequiredField()
        }
    }

    private enum CodingKeys: String, CodingKey {
        case title
        case author
        case thumbnailURL
        case commentsCountNumber
        case creation
        case url
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        title = try values.decode(String.self, forKey: .title)
        author = try values.decode(String.self, forKey: .author)
        thumbnailURL = try values.decodeIfPresent(URL.self, forKey: .thumbnailURL)
        commentsCountNumber = try values.decodeIfPresent(Int.self, forKey: .commentsCountNumber) ?? 0
        creation = try values.decodeIfPresent(Date.self, forKey: .author)
        url = try values.decodeIfPresent(URL.self, forKey: .url)
    }
    
    func commentsCount() -> String {
        return " \(commentsCountNumber) " // Leave space for the rounded corner. I know, not cool, but does the trick.
    }
    
    func loadThumbnail(withCompletion completion: @escaping () -> ()) {

        guard let thumbnailURL = self.thumbnailURL, self.thumbnailFetched == false else {
            
            return
        }
        
        let downloadThumbnailTask = URLSession.shared.downloadTask(with: thumbnailURL) { [weak self] (url, urlResponse, error) in

            guard let strongSelf = self,
                let url = url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                
                return
            }

            strongSelf.thumbnail = image
            strongSelf.thumbnailFetched = true
            
            DispatchQueue.main.async {
                
                completion()
            }
        }
            
        downloadThumbnailTask.resume()
    }
}
