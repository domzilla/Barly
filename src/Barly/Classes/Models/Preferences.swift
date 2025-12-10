//
//  Preferences.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import Foundation

enum PreferenceKeys {
    static let isAutoCollapseEnabled = "isAutoCollapseEnabled"
    static let autoCollapseDelay = "autoCollapseDelay"
    static let showPreferencesOnLaunch = "showPreferencesOnLaunch"
}

enum PreferenceDefaults {
    static let isAutoCollapseEnabled = true
    static let autoCollapseDelay = 10 // seconds
    static let showPreferencesOnLaunch = true
}
