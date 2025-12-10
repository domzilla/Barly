//
//  PreferencesView.swift
//  Barly
//
//  Created by Dominic Rodemer on 09.12.25.
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage(PreferenceKeys.isAutoCollapseEnabled) private var isAutoCollapseEnabled = PreferenceDefaults.isAutoCollapseEnabled
    @AppStorage(PreferenceKeys.autoCollapseDelay) private var autoCollapseDelay = PreferenceDefaults.autoCollapseDelay
    @AppStorage(PreferenceKeys.showPreferencesOnLaunch) private var showPreferencesOnLaunch = PreferenceDefaults.showPreferencesOnLaunch

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Icon and description
            HStack(alignment: .center, spacing: 16) {
                ZStack {
                    Image(nsImage: NSImage(named: NSImage.applicationIconName) ?? NSImage())
                        .resizable()
                        .frame(width: 140, height: 140)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Barly is now running. You can find its icon in the right side of your menu bar. Click it to expand/collapse hidden menu bar items.")
                        .font(.system(size: 13))
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Right-click (or \u{2318}-click) the menu bar icon to show the Barly menu.")
                        .font(.system(size: 13, weight: .bold))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 20)

            // Auto-collapse duration
            HStack(spacing: 8) {
                Text("Auto-collapse after:")
                    .font(.system(size: 13))

                Picker("", selection: $autoCollapseDelay) {
                    Text("5 seconds").tag(5)
                    Text("10 seconds").tag(10)
                    Text("15 seconds").tag(15)
                    Text("30 seconds").tag(30)
                    Text("1 minute").tag(60)
                }
                .pickerStyle(.menu)
                .frame(width: 180)

                Spacer()
            }
            .padding(.bottom, 16)

            // Checkboxes
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Enable auto-collapse", isOn: $isAutoCollapseEnabled)
                    .font(.system(size: 13))

                Toggle("Show this window when starting Barly", isOn: $showPreferencesOnLaunch)
                    .font(.system(size: 13))
            }

            Spacer()
                .frame(minHeight: 30, maxHeight: .infinity)

            // Footer buttons
            HStack {
                Button(String(localized: "Quit")) {
                    NSApp.terminate(nil)
                }
                .controlSize(.large)

                Spacer()

                Button(String(localized: "Close")) {
                    NSApp.keyWindow?.close()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
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
