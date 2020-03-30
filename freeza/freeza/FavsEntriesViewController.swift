import Foundation
import UIKit

class FavsEntriesViewController: UITableViewController {

    static let showImageSegueIdentifier = "showImageSegue"
    let viewModel = FavouritesEntriesViewModel(with: FavouritesEntriesUserDefaultsStorage.shared)
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let errorLabel = UILabel()
    var entryToDisplay: EntryViewModel?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadEntries()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animate(alongsideTransition: { [weak self] (context) in
            
            self?.configureErrorLabelFrame()
            
            }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == FavsEntriesViewController.showImageSegueIdentifier {
            
            if let urlViewController = segue.destination as? URLViewController {
                urlViewController.delegate = self
                urlViewController.isFav = true
                urlViewController.entry = self.entryToDisplay
            }
        }
    }

    @objc func retryFromErrorToolbar() {
        
        self.loadEntries()
        self.dismissErrorToolbar()
    }
    
    @objc func dismissErrorToolbar() {
        
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    private func loadEntries() {

        self.activityIndicatorView.startAnimating()
        self.viewModel.loadEntries {
            
            self.entriesReloaded()
        }
    }
    
    private func configureViews() {

        func configureActivityIndicatorView() {
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicatorView)
        }

        func configureTableView() {
            
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 110.0
            
        }
        
        func configureToolbar() {

            self.configureErrorLabelFrame()

            let errorItem = UIBarButtonItem(customView: self.errorLabel)
            let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let retryItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(TopEntriesViewController.retryFromErrorToolbar))
            let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            let closeItem = UIBarButtonItem(image: UIImage(named: "close-button"), style: .plain, target: self, action: #selector(TopEntriesViewController.dismissErrorToolbar))
            
            fixedSpaceItem.width = 12
            
            self.toolbarItems = [errorItem, flexSpaceItem, retryItem, fixedSpaceItem, closeItem]
        }
        
        configureActivityIndicatorView()
        configureTableView()
        configureToolbar()
    }
    
    private func configureErrorLabelFrame() {
        
        self.errorLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 92, height: 22)
    }
    
    private func entriesReloaded() {
        
        self.activityIndicatorView.stopAnimating()
        self.tableView.reloadData()
        
        if self.viewModel.hasError {

            self.errorLabel.text = self.viewModel.errorMessage
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
        
    private func presentEntry(withEntry entry: EntryViewModel) {
        self.entryToDisplay = entry
        self.performSegue(withIdentifier: TopEntriesViewController.showImageSegueIdentifier, sender: self)
    }
}

extension FavsEntriesViewController { // UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let entryTableViewCell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.cellId, for: indexPath as IndexPath) as! EntryTableViewCell
        
        entryTableViewCell.entry = self.viewModel.entries[indexPath.row]
        
        return entryTableViewCell
    }
}

extension FavsEntriesViewController { // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entry = self.viewModel.entries[indexPath.row]
        self.presentEntry(withEntry: entry)
    }
}

extension FavsEntriesViewController: URLViewControllerDelegate {
    
    func addToFavorites(entry: EntryViewModel) -> Bool {
        do {
            try FavouritesEntriesUserDefaultsStorage.shared.add(entry: entry)
            return true
        } catch _ {
            return false
        }
    }
    
    func removeFromFavorites(entry: EntryViewModel) -> Bool {
        do {
            try FavouritesEntriesUserDefaultsStorage.shared.remove(entry: entry)
            return true
        } catch _ {
            return false
        }
    }
    
}
