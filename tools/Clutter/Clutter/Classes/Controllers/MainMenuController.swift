//
//  MainMenuController.swift
//  Clutter
//
//  Created by Dominic Rodemer on 10.12.25.
//

import Cocoa

@Observable
@MainActor
class MainMenuController {
    private(set) var count = 0
    private var menuCounter = 0
    private var addedMenuItems: [NSMenuItem] = []

    func addMenuItem() {
        menuCounter += 1
        let menuName = "Menu Item \(menuCounter)"

        let menuItem = NSMenuItem(title: menuName, action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: menuName)
        menuItem.submenu = submenu

        // Insert after the "App" menu (at index 1, or at end if only App menu exists)
        let insertIndex = min(1, NSApp.mainMenu?.items.count ?? 0)
        NSApp.mainMenu?.insertItem(menuItem, at: NSApp.mainMenu?.items.count ?? insertIndex)

        addedMenuItems.append(menuItem)
        count = addedMenuItems.count
    }

    func removeMenuItem() {
        guard let menuItem = addedMenuItems.popLast() else { return }
        NSApp.mainMenu?.removeItem(menuItem)
        count = addedMenuItems.count
    }
}
