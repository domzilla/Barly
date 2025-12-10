//
//  AppDelegate.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarController: MenuBarController?
    var hotkeyManager: HotkeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        menuBarController = MenuBarController()
        hotkeyManager = HotkeyManager { [weak self] in
            Task { @MainActor in
                self?.menuBarController?.toggleExpandCollapse()
            }
        }
    }
}
