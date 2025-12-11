//
//  AppDelegate.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var hotkeyManager: HotkeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController()
        hotkeyManager = HotkeyManager { [weak self] in
            Task { @MainActor in
                self?.statusBarController?.toggleExpandCollapse()
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        statusBarController?.restoreDisplayModeIfNeeded()
    }
}
