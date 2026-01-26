//
//  ClutterApp.swift
//  Clutter
//
//  Created by Dominic Rodemer on 10.12.25.
//

import SwiftUI

@main
struct ClutterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.appDelegate, self.appDelegate)
        }
        .windowResizability(.contentSize)
    }
}
