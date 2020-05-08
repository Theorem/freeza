//
//  SettingsView.swift
//  freeza
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

final class SettingsView: UIView {
        
    let settingsTable: UITableView = createSettingsTableView()

    init(numberOfSettings: Int) {
        super.init(frame: .zero)
        addSubviews()
        setConstraints(numberOfSettings: numberOfSettings)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(settingsTable)
    }
    
    func setConstraints(numberOfSettings: Int) {
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsTable.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 0),
            settingsTable.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: 0),
            settingsTable.heightAnchor.constraint(equalToConstant: CGFloat(numberOfSettings) * SettingsCell.height)
        ])
    }
    
    func setStyle() {
        backgroundColor = Palette.darkTableBackground.color
        settingsTable.backgroundColor = Palette.white.color
    }
    
}

private func createSettingsTableView() -> UITableView {
    let settingsTableView = UITableView()
    
    settingsTableView.backgroundColor = .white
    settingsTableView.register(SettingsCell.self)
    settingsTableView.rowHeight = SettingsCell.height
    settingsTableView.allowsSelection = false
    settingsTableView.separatorColor = .clear
    settingsTableView.layer.borderColor = Palette.tableSeparator.color.cgColor
    settingsTableView.layer.borderWidth = 1
    settingsTableView.bounces = false
    
    return settingsTableView
}
