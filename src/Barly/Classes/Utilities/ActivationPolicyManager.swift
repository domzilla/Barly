//
//  ActivationPolicyManager.swift
//  Barly
//
//  Created by Dominic Rodemer on 11.12.25.
//

import Cocoa

/// Manages the app's activation policy to show Barly's dock icon temporarily
/// and display an empty menu bar, giving more space for status bar items.
@MainActor
class ActivationPolicyManager {

    // MARK: - Properties

    private var resignActiveObserver: NSObjectProtocol?
    private var hasActivatedBefore = false
    private var emptyMenu: NSMenu?

    private var isActive: Bool {
        NSApp.activationPolicy() == .regular
    }

    // MARK: - Initialization

    init() {
        // Observe when app loses focus to deactivate
        resignActiveObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.deactivate()
            }
        }

        // Create empty menu to override SwiftUI's default menus
        let mainMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)

        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu

        let quitItem = NSMenuItem(
            title: String(localized: "Quit Barly"),
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        appMenu.addItem(quitItem)

        emptyMenu = mainMenu
    }

    deinit {
        if let observer = resignActiveObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // MARK: - Private Methods

    private func performActivation() {
        // Set empty menu to override SwiftUI's default menus
        NSApp.mainMenu = emptyMenu

        // Use the newer activation API
        if let frontApp = NSWorkspace.shared.frontmostApplication {
            NSRunningApplication.current.activate(from: frontApp)
        } else {
            NSApp.activate()
        }
        NSApp.setActivationPolicy(.regular)
    }

    // MARK: - Public Methods

    /// Activates full expand mode if the preference is enabled.
    /// Switches to regular activation policy and activates the app.
    func activateIfEnabled() {
        let isFullExpandEnabled = UserDefaults.standard.object(forKey: PreferenceKeys.isFullExpandEnabled) as? Bool
            ?? PreferenceDefaults.isFullExpandEnabled

        guard isFullExpandEnabled, !isActive else { return }

        if hasActivatedBefore {
            performActivation()
        } else {
            hasActivatedBefore = true
            // Hack: For first activation, activate the Dock first, then our app
            // This is needed for proper activation in SwiftUI apps
            NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.dock").first?.activate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.performActivation()
            }
        }
    }

    /// Deactivates full expand mode.
    /// Switches back to accessory activation policy and deactivates the app.
    func deactivate() {
        guard isActive else { return }

        // Yield activation to another app
        if let nextApp = NSWorkspace.shared.runningApplications.first(where: { $0 != .current }) {
            NSApp.yieldActivation(to: nextApp)
        } else {
            NSApp.deactivate()
        }
        NSApp.setActivationPolicy(.accessory)
    }
}
