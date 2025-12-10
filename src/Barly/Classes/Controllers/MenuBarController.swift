//
//  MenuBarController.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import Cocoa

@MainActor
class MenuBarController: NSObject {

    // MARK: - Status Bar Items

    /// The arrow button for expand/collapse
    private let arrowItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    /// The pipe separator that expands to hide items
    private let separatorItem = NSStatusBar.system.statusItem(withLength: 20)

    // MARK: - Properties

    private let menuManager = MenuManager()
    private let displayModeManager = DisplayModeManager()
    private var autoCollapseTimer: Timer?

    private let separatorVisibleLength: CGFloat = 20
    private let separatorExpandedLength: CGFloat = 10_000

    private var isCollapsed: Bool {
        separatorItem.length == separatorExpandedLength
    }

    /// Check if separator is in valid position (to the left of arrow)
    private var isSeparatorValidPosition: Bool {
        guard
            let arrowX = arrowItem.button?.window?.frame.origin.x,
            let separatorX = separatorItem.button?.window?.frame.origin.x
        else { return false }

        // Separator should be to the LEFT of arrow (lower X value)
        return separatorX < arrowX
    }

    // MARK: - Initialization

    override init() {
        super.init()
        setupUI()
        setupDisplayModeManager()

        // Auto-collapse after 1 second on launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.collapseMenuBar()
        }

        showPreferencesOnLaunchIfNeeded()
    }

    private func setupDisplayModeManager() {
        menuManager.displayModeManager = displayModeManager
    }

    private func setupUI() {
        // Setup separator (pipe) - created first, will be on the left
        if let button = separatorItem.button {
            button.image = NSImage(named: "seprator")
        }
        separatorItem.autosaveName = "barly_separator"

        // Setup arrow button - created second, will be on the right
        if let button = arrowItem.button {
            button.image = NSImage(named: "collapse")
            button.target = self
            button.action = #selector(arrowButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        arrowItem.autosaveName = "barly_arrow"
    }

    private func showPreferencesOnLaunchIfNeeded() {
        let showOnLaunch = UserDefaults.standard.object(forKey: PreferenceKeys.showPreferencesOnLaunch) as? Bool
            ?? PreferenceDefaults.showPreferencesOnLaunch

        if showOnLaunch {
            menuManager.showPreferencesWindow()
        }
    }

    // MARK: - Expand/Collapse

    @objc private func arrowButtonClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        let isRightClick = event.type == .rightMouseUp
        let isControlClick = event.type == .leftMouseUp && event.modifierFlags.contains(.control)

        if isRightClick || isControlClick {
            // Show context menu on right-click or control-click
            arrowItem.menu = menuManager.createContextMenu()
            arrowItem.button?.performClick(nil)
            arrowItem.menu = nil
        } else {
            // Toggle expand/collapse on left-click
            toggleExpandCollapse()
        }
    }

    func toggleExpandCollapse() {
        isCollapsed ? expandMenuBar() : collapseMenuBar()
    }

    func restoreDisplayModeIfNeeded() {
        displayModeManager.restoreOriginalModeIfNeeded()
    }

    private func collapseMenuBar() {
        guard isSeparatorValidPosition, !isCollapsed else {
            startAutoCollapseTimerIfNeeded()
            return
        }

        separatorItem.length = separatorExpandedLength

        if let button = arrowItem.button {
            button.image = NSImage(named: "expand")
        }
    }

    private func expandMenuBar() {
        guard isCollapsed else { return }

        separatorItem.length = separatorVisibleLength

        if let button = arrowItem.button {
            button.image = NSImage(named: "collapse")
        }

        startAutoCollapseTimerIfNeeded()
    }

    // MARK: - Auto-Collapse Timer

    private func startAutoCollapseTimerIfNeeded() {
        autoCollapseTimer?.invalidate()

        let isAutoCollapseEnabled = UserDefaults.standard.object(forKey: PreferenceKeys.isAutoCollapseEnabled) as? Bool
            ?? PreferenceDefaults.isAutoCollapseEnabled

        guard isAutoCollapseEnabled, !isCollapsed else { return }

        let delay = UserDefaults.standard.object(forKey: PreferenceKeys.autoCollapseDelay) as? Int
            ?? PreferenceDefaults.autoCollapseDelay

        autoCollapseTimer = Timer.scheduledTimer(
            withTimeInterval: TimeInterval(delay),
            repeats: false
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.collapseMenuBar()
            }
        }
    }
}
