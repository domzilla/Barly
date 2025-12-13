//
//  BarlyApp.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import SwiftUI

@main
struct BarlyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
