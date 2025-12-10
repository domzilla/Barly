//
//  MenuManager.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import SwiftUI
import Cocoa

@MainActor
class MenuManager: NSObject {

    // MARK: - Properties

    private var preferencesWindow: NSWindow?
    var displayModeManager: DisplayModeManager?

    // MARK: - Context Menu

    func createContextMenu() -> NSMenu {
        let menu = NSMenu()

        // Add "Hide Notch" / "Show Notch" toggle
        let is16by10 = isCurrentResolution16by10()
        let notchItem = NSMenuItem(
            title: is16by10 ? String(localized: "Show Notch") : String(localized: "Hide Notch"),
            action: #selector(toggleNotch(_:)),
            keyEquivalent: ""
        )
        notchItem.target = self
        menu.addItem(notchItem)
        menu.addItem(NSMenuItem.separator())

        let prefsItem = NSMenuItem(
            title: String(localized: "Preferences..."),
            action: #selector(showPreferences(_:)),
            keyEquivalent: ","
        )
        prefsItem.target = self
        menu.addItem(prefsItem)

        let aboutItem = NSMenuItem(
            title: String(localized: "About Barly"),
            action: #selector(showAbout(_:)),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)

        let updatesItem = NSMenuItem(
            title: String(localized: "Check for Updates..."),
            action: #selector(checkForUpdates(_:)),
            keyEquivalent: ""
        )
        updatesItem.target = self
        menu.addItem(updatesItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(
            title: String(localized: "Quit"),
            action: #selector(quit(_:)),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        return menu
    }

    private func isCurrentResolution16by10() -> Bool {
        let displayID = CGMainDisplayID()
        guard let mode = CGDisplayCopyDisplayMode(displayID) else { return false }

        let width = Double(mode.width)
        let height = Double(mode.height)

        // 16:10 = 1.6, with some tolerance for rounding
        let aspectRatio = width / height
        return abs(aspectRatio - 1.6) < 0.01
    }

    // MARK: - Menu Actions

    @objc private func toggleNotch(_ sender: Any?) {
        displayModeManager?.toggle()
    }

    @objc private func showPreferences(_ sender: Any?) {
        showPreferencesWindow()
    }

    @objc private func showAbout(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil)
    }

    @objc private func checkForUpdates(_ sender: Any?) {
        // TODO: Implement Sparkle integration later
    }

    @objc private func quit(_ sender: Any?) {
        NSApp.terminate(nil)
    }

    // MARK: - Preferences Window

    func showPreferencesWindow() {
        NSApp.activate(ignoringOtherApps: true)

        if preferencesWindow == nil {
            let contentView = PreferencesView()
            let hostingController = NSHostingController(rootView: contentView)

            let window = NSWindow(contentViewController: hostingController)
            window.title = String(localized: "Welcome to Barly")
            window.styleMask = [.titled, .closable]
            window.setContentSize(NSSize(width: 640, height: 420))
            window.center()

            preferencesWindow = window
        }

        preferencesWindow?.makeKeyAndOrderFront(nil)
    }
}
