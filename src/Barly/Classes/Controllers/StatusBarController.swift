//
//  StatusBarController.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import Cocoa
import Sparkle

@MainActor
class StatusBarController: NSObject {
    // MARK: - Status Bar Items

    /// The arrow button for expand/collapse
    private let arrowItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    /// The pipe separator that expands to hide items
    private let separatorItem = NSStatusBar.system.statusItem(withLength: 20)

    // MARK: - Properties

    private let menuController: MenuController
    private let displayModeManager = DisplayModeManager()
    private let activationPolicyManager = ActivationPolicyManager()
    private var autoCollapseTimer: Timer?

    private let separatorVisibleLength: CGFloat = 20
    private let separatorExpandedLength: CGFloat = 10000

    private var isCollapsed: Bool {
        self.separatorItem.length == self.separatorExpandedLength
    }

    /// Check if separator is in valid position (to the left of arrow)
    private var isSeparatorValidPosition: Bool {
        guard
            let arrowX = arrowItem.button?.window?.frame.origin.x,
            let separatorX = separatorItem.button?.window?.frame.origin.x else { return false }

        // Separator should be to the LEFT of arrow (lower X value)
        return separatorX < arrowX
    }

    // MARK: - Initialization

    init(updaterController: SPUStandardUpdaterController) {
        self.menuController = MenuController(updaterController: updaterController)
        super.init()
        self.setupUI()
        self.setupDisplayModeManager()

        // Auto-collapse after 1 second on launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.collapseStatusBar()
        }

        self.showPreferencesOnLaunchIfNeeded()
    }

    private func setupDisplayModeManager() {
        self.menuController.displayModeManager = self.displayModeManager
    }

    private func setupUI() {
        // Setup separator (pipe) - created first, will be on the left
        if let button = separatorItem.button {
            button.image = NSImage(named: "seprator")
        }
        self.separatorItem.autosaveName = "barly_separator"

        // Setup arrow button - created second, will be on the right
        if let button = arrowItem.button {
            button.image = NSImage(named: "collapse")
            button.target = self
            button.action = #selector(self.arrowButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        self.arrowItem.autosaveName = "barly_arrow"
    }

    private func showPreferencesOnLaunchIfNeeded() {
        let showOnLaunch = UserDefaults.standard.object(forKey: PreferenceKeys.showPreferencesOnLaunch) as? Bool
            ?? PreferenceDefaults.showPreferencesOnLaunch

        if showOnLaunch {
            self.menuController.showPreferencesWindow()
        }
    }

    // MARK: - Expand/Collapse

    @objc
    private func arrowButtonClicked(_: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        let isRightClick = event.type == .rightMouseUp
        let isControlClick = event.type == .leftMouseUp && event.modifierFlags.contains(.control)

        if isRightClick || isControlClick {
            // Show context menu on right-click or control-click
            self.arrowItem.menu = self.menuController.createContextMenu()
            self.arrowItem.button?.performClick(nil)
            self.arrowItem.menu = nil
        } else {
            // Toggle expand/collapse on left-click
            self.toggleExpandCollapse()
        }
    }

    func toggleExpandCollapse() {
        if self.isCollapsed {
            self.expandStatusBar()
        } else {
            if !self.isSeparatorValidPosition {
                self.showInvalidPositionAlert()
            }
            self.collapseStatusBar()
        }
    }

    private func showInvalidPositionAlert() {
        let alert = NSAlert()
        alert.messageText = String(localized: "Separator in Wrong Position")
        alert
            .informativeText =
            String(
                localized: "The separator is on the wrong side. Please drag the separator (|) to the left of the arrow icon in your status bar for Barly to work correctly."
            )
        alert.alertStyle = .warning
        alert.addButton(withTitle: String(localized: "OK"))
        alert.runModal()
    }

    func restoreDisplayModeIfNeeded() {
        self.displayModeManager.restoreOriginalModeIfNeeded()
    }

    private func collapseStatusBar() {
        guard self.isSeparatorValidPosition, !self.isCollapsed else {
            self.startAutoCollapseTimerIfNeeded()
            return
        }

        self.separatorItem.length = self.separatorExpandedLength

        if let button = arrowItem.button {
            button.image = NSImage(named: "expand")
        }

        self.activationPolicyManager.deactivate()
    }

    private func expandStatusBar() {
        guard self.isCollapsed else { return }

        self.separatorItem.length = self.separatorVisibleLength

        if let button = arrowItem.button {
            button.image = NSImage(named: "collapse")
        }

        self.activationPolicyManager.activateIfEnabled()
        self.startAutoCollapseTimerIfNeeded()
    }

    // MARK: - Auto-Collapse Timer

    private func startAutoCollapseTimerIfNeeded() {
        self.autoCollapseTimer?.invalidate()

        let isAutoCollapseEnabled = UserDefaults.standard.object(forKey: PreferenceKeys.isAutoCollapseEnabled) as? Bool
            ?? PreferenceDefaults.isAutoCollapseEnabled

        guard isAutoCollapseEnabled, !self.isCollapsed else { return }

        let delay = UserDefaults.standard.object(forKey: PreferenceKeys.autoCollapseDelay) as? Int
            ?? PreferenceDefaults.autoCollapseDelay

        self.autoCollapseTimer = Timer.scheduledTimer(
            withTimeInterval: TimeInterval(delay),
            repeats: false
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.collapseStatusBar()
            }
        }
    }
}
