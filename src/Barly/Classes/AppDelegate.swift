//
//  AppDelegate.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import Cocoa
import Sparkle

class AppDelegate: NSObject, NSApplicationDelegate, SPUStandardUserDriverDelegate {
    private lazy var updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: self
    )
    var statusBarController: StatusBarController?
    var hotkeyManager: HotkeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController(updaterController: updaterController)
        hotkeyManager = HotkeyManager { [weak self] in
            Task { @MainActor in
                self?.statusBarController?.toggleExpandCollapse()
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        statusBarController?.restoreDisplayModeIfNeeded()
    }

    // MARK: - SPUStandardUserDriverDelegate

    func supportsGentleScheduledUpdateReminders() -> Bool {
        return true
    }
}
