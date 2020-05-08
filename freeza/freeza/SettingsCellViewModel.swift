//
//  SettingsCellViewModel.swift
//  freeza
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

extension Settings.Key {
    var title: String {
        switch self {
        case .filterNSFWContent:
            return "Content & Privacy Restrictions"
        }
    }
}

struct SettingsCellViewModel {
    
    let title: String
    
    var enabled: Bool {
        return _settings[_settingKey] ?? false
    }
    
    let onToggled: () -> ()
    
    fileprivate let _settings: Settings
    fileprivate let _settingKey: Settings.Key
    
    init(settings: Settings,
         settingKey: Settings.Key,
         onToggled: @escaping () -> ()
    ) {
        _settingKey = settingKey
        _settings = settings
        title = _settingKey.title
        self.onToggled = onToggled
    }
    
    func onSwitchToggled() {
        _settings[_settingKey] = !enabled
        onToggled()
    }
}
