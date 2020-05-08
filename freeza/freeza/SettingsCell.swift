//
//  SettingsCell.swift
//  freeza
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

final class SettingsCell: UITableViewCell {
    
    static let height: CGFloat = 50
    
    let titleLabel: UILabel = createTitleLabel()
    let optionSwitch: UISwitch = createSwitch()
    
    var viewModel: SettingsCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel: SettingsCellViewModel) {
        titleLabel.text = viewModel.title
        optionSwitch.isOn = viewModel.enabled
        self.viewModel = viewModel
        
        optionSwitch.addTarget(self, action: #selector(onSwitchToggled), for: UIControl.Event.valueChanged)
    }
    
    @objc func onSwitchToggled() {
        self.viewModel?.onSwitchToggled()
    }
    
}

private extension SettingsCell {
    
    func loadSubviews() {
        let stackedViews = [titleLabel, optionSwitch].stacked(
            axis: .horizontal,
            spacing: .constant(5),
            alignment: .center,
            distribution: .fill
        )
        
        [titleLabel, optionSwitch, stackedViews].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stackedViews.loadInto(
            containerView: self.contentView,
            insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        )
    }

}

private func createTitleLabel() -> UILabel {
    let titleLabel = UILabel()
    
    return titleLabel
}

private func createSwitch() -> UISwitch {
    let switchView = UISwitch()
    
    return switchView
}
