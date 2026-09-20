//
//  PreferencesView.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage(PreferenceKeys.isAutoCollapseEnabled) private var isAutoCollapseEnabled = PreferenceDefaults
        .isAutoCollapseEnabled
    @AppStorage(PreferenceKeys.autoCollapseDelay) private var autoCollapseDelay = PreferenceDefaults.autoCollapseDelay
    @AppStorage(PreferenceKeys.showPreferencesOnLaunch) private var showPreferencesOnLaunch = PreferenceDefaults
        .showPreferencesOnLaunch
    @AppStorage(PreferenceKeys.isFullExpandEnabled) private var isFullExpandEnabled = PreferenceDefaults
        .isFullExpandEnabled

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Icon and description
            HStack(alignment: .center, spacing: 16) {
                Image(nsImage: NSImage(named: NSImage.applicationIconName) ?? NSImage())
                    .resizable()
                    .frame(width: 100, height: 100)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 12) {
                    Text(
                        "Barly is now running. Reorder status bar icons by \u{2318}-dragging. Drag icons to the left of the separator  |  to hide them."
                    )
                    .font(.system(size: 13))
                    .fixedSize(horizontal: false, vertical: true)

                    Text("Right-click (or \u{2303}-click) the arrow icon to show the Barly menu.")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 16)

            // Status bar mock
            StatusBarMockView()

            Spacer()

            // Auto-collapse duration
            HStack(spacing: 8) {
                Picker(String(localized: "Auto-collapse after:"), selection: self.$autoCollapseDelay) {
                    Text("5 seconds").tag(5)
                    Text("10 seconds").tag(10)
                    Text("15 seconds").tag(15)
                    Text("30 seconds").tag(30)
                    Text("1 minute").tag(60)
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("PreferencesView.autoCollapseDelayPicker")

                Spacer()
            }
            .padding(.bottom, 16)

            // Checkboxes
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Enable auto-collapse", isOn: self.$isAutoCollapseEnabled)
                    .font(.system(size: 13))
                    .accessibilityIdentifier("PreferencesView.autoCollapseToggle")

                Toggle("Fully expand status bar (shows Dock icon temporarily)", isOn: self.$isFullExpandEnabled)
                    .font(.system(size: 13))
                    .accessibilityIdentifier("PreferencesView.fullExpandToggle")

                Toggle("Show this window when starting Barly", isOn: self.$showPreferencesOnLaunch)
                    .font(.system(size: 13))
                    .accessibilityIdentifier("PreferencesView.showPreferencesOnLaunchToggle")
            }

            Spacer()

            // Footer buttons
            HStack {
                Button(String(localized: "Quit")) {
                    NSApp.terminate(nil)
                }
                .controlSize(.large)
                .accessibilityIdentifier("PreferencesView.quitButton")

                Spacer()

                Button(String(localized: "Close")) {
                    NSApp.keyWindow?.close()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .accessibilityIdentifier("PreferencesView.closeButton")
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
        .frame(width: 640, height: 420)
    }
}

#Preview {
    PreferencesView()
}
