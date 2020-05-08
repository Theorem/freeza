//
//  SettingsViewModel.swift
//  freeza
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

class SettingsViewModel {
    
    let settings: Settings
    
    let settingsCellViewModels: [SettingsCellViewModel]
    
    init(settings: Settings, onSettingsChanged: @escaping () -> ()) {
        self.settings = settings
        self.settingsCellViewModels = buildSettingsCellViewModels(
            settings: settings,
            onToggled: onSettingsChanged
        )
    }

}

fileprivate func buildSettingsCellViewModels(settings: Settings, onToggled: @escaping () -> ()) -> [SettingsCellViewModel] {
    return settings.allSetings.map { settingsKey in
        SettingsCellViewModel(
            settings: settings,
            settingKey: settingsKey,
            onToggled: onToggled
        )
    }
}
