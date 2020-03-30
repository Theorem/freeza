import UIKit

class EntryTableViewCell: UITableViewCell {

    static let cellId = "EntryTableViewCell"
    
    var entry: EntryViewModel? {
        
        didSet {
            
            self.configureForEntry()
        }
    }
    
    @IBOutlet private weak var thumbnailButton: UIButton!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var entryTitleLabel: UILabel!
    
    @IBOutlet weak var ageLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var olderLabelWidthConstraint: NSLayoutConstraint!
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.configureViews()
    }
    
    private func configureViews() {
        
        func configureThumbnailImageView() {
        
            self.thumbnailButton.layer.borderColor = UIColor.black.cgColor
            self.thumbnailButton.layer.borderWidth = 1
        }
        
        func configureCommentsCountLabel() {
            
            self.commentsCountLabel.layer.cornerRadius = self.commentsCountLabel.bounds.size.height / 2
        }
        
        configureThumbnailImageView()
        configureCommentsCountLabel()
    }
    
    private func configureForEntry() {
        
        guard let entry = self.entry else {
            
            return
        }
        
        self.thumbnailButton.setImage(entry.thumbnail, for: [])
        self.authorLabel.text = entry.author
        self.commentsCountLabel.text = entry.commentsCount()
        self.ageLabel.text = entry.age
        self.entryTitleLabel.text = entry.title
        self.olderLabelWidthConstraint.constant = entry.isOlder ? 52.0 : 0
        self.ageLabelLeadingConstraint.constant = entry.isOlder ? 12.0 : 0
        
        entry.loadThumbnail { [weak self] in
            
            self?.thumbnailButton.setImage(entry.thumbnail, for: [])
        }
    }
}
