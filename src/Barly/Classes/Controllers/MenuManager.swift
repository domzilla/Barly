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

    // MARK: - Context Menu

    func createContextMenu() -> NSMenu {
        let menu = NSMenu()

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

    // MARK: - Menu Actions

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
