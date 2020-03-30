//
//  SettingsViewController.swift
//  freeza
//
//  Created by Kimi on 29/03/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var allowExplicitContentSwitch: UISwitch!
    
    public static let ExplicitContentChangedNotificationName = Notification.Name(rawValue: "settings::allow_explicit_content_value_changed")
    public static let ExplicitContentChangedNotification = Notification(name: ExplicitContentChangedNotificationName)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allowExplicitContentSwitch.isOn = SettingsViewController.canShowExplicitContent()
    }
    
    @IBAction func onAllowExplicitContentValueChanged(_ sender: Any) {
        allowExplicitContent(allowExplicitContentSwitch.isOn)
        NotificationCenter.default.post(SettingsViewController.ExplicitContentChangedNotification)
    }
}

extension SettingsViewController {
    static func canShowExplicitContent() -> Bool {
        return UserDefaults.standard.bool(forKey: "settings::allow_explicit_content")
    }
}

extension SettingsViewController {
    func allowExplicitContent(_ allowed: Bool) {
        UserDefaults.standard.set(allowed, forKey: "settings::allow_explicit_content")
    }
}
