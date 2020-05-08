import UIKit

protocol EntryTableViewCellDelegate: class {
    
    func tappedFavorite(entry: EntryViewModel)
}

class EntryTableViewCell: UITableViewCell {

    static let cellId = "EntryTableViewCell"
    
    var entry: EntryViewModel? {
        
        didSet {
            self.configureForEntry()
        }
    }
    
    @IBOutlet private weak var safeContentLabel: PaddedLabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var entryTitleLabel: UILabel!
    
    weak var delegate: EntryTableViewCellDelegate?
    
    @IBOutlet weak var heartImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureViews()
    }
    
    private func configureViews() {
        
        func configureSafeContentLabel() {
            self.safeContentLabel.textColor = Palette.red.color
            self.safeContentLabel.text = "nsfw"
            self.safeContentLabel.font = UIFont.boldSystemFont(ofSize: 12)
            self.safeContentLabel.leftInset = 5
            self.safeContentLabel.rightInset = 5
            self.safeContentLabel.topInset = 3
            self.safeContentLabel.bottomInset = 3
            self.safeContentLabel.layer.cornerRadius = 5
            self.safeContentLabel.layer.borderColor = Palette.red.color.cgColor
            self.safeContentLabel.layer.borderWidth = 1
        }
        
        func configureThumbnailImageView() {
        
            self.thumbnailImageView.layer.borderColor = UIColor.black.cgColor
            self.thumbnailImageView.layer.borderWidth = 1
            self.thumbnailImageView.contentMode = .scaleToFill
        }
        
        func configureCommentsCountLabel() {
            
            self.commentsCountLabel.layer.cornerRadius = self.commentsCountLabel.bounds.size.height / 2
        }
        
        func configureHeartImageView() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedFavorite))
            heartImageView.isUserInteractionEnabled = true
            heartImageView.addGestureRecognizer(tapGesture)
        }
        
        configureThumbnailImageView()
        configureCommentsCountLabel()
        configureHeartImageView()
        configureSafeContentLabel()
    }
    
    @objc private func tappedFavorite() {
        guard let entry = entry else {
            return
        }
        self.delegate?.tappedFavorite(entry: entry)
    }
    
    private func configureForEntry() {
        
        guard let entry = self.entry else {
            
            return
        }
        
        self.thumbnailImageView.image = entry.thumbnail
        self.authorLabel.text = entry.author
        self.commentsCountLabel.text = entry.commentsCount
        self.ageLabel.text = entry.age
        self.entryTitleLabel.text = entry.title
        
        self.heartImageView.image = entry.isFavorite ?
            Asset.heart_fill.image:
            Asset.heart_empty.image
        
        self.safeContentLabel.isHidden = entry.model.isSafeContent
        
        entry.loadThumbnail { [weak self] in
            self?.thumbnailImageView.image = entry.thumbnail
        }
    }
}
