//
//  SettingsViewController.swift
//  freeza
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    fileprivate let _viewModel: SettingsViewModel
    
    fileprivate let _view: SettingsView
    
    init(viewModel: SettingsViewModel) {
        _viewModel = viewModel
        _view = SettingsView(numberOfSettings: viewModel.settingsCellViewModels.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        self._view.settingsTable.reloadData()
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _viewModel.settingsCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(cellClass: SettingsCell.self, for: indexPath)
        
        settingsCell.bind(viewModel: _viewModel.settingsCellViewModels[indexPath.row])
        
        return settingsCell
    }
    
    func setupDelegates() {
        _view.settingsTable.delegate = self
        _view.settingsTable.dataSource = self
    }
}
