//
//  StatusItemController.swift
//  Clutter
//
//  Created by Dominic Rodemer on 10.12.25.
//

import Cocoa

@Observable
@MainActor
class StatusItemController {
    private(set) var count = 0
    private var statusItems: [NSStatusItem] = []

    func addStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = item.button {
            button.image = NSImage(systemSymbolName: "ladybug.fill", accessibilityDescription: "Clutter item")
        }

        statusItems.append(item)
        count = statusItems.count
    }

    func removeStatusItem() {
        guard let item = statusItems.popLast() else { return }
        NSStatusBar.system.removeStatusItem(item)
        count = statusItems.count
    }
}
