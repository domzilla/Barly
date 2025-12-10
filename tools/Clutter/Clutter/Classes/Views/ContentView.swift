//
//  ContentView.swift
//  Clutter
//
//  Created by Dominic Rodemer on 10.12.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.appDelegate) private var appDelegate

    var body: some View {
        VStack(spacing: 20) {
            GroupBox("Main Menu Items") {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button("Add") {
                            appDelegate.mainMenuController.addMenuItem()
                        }

                        Button("Remove") {
                            appDelegate.mainMenuController.removeMenuItem()
                        }
                        .disabled(appDelegate.mainMenuController.count == 0)
                    }

                    Text("Count: \(appDelegate.mainMenuController.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            GroupBox("Menu Bar Items") {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button("Add") {
                            appDelegate.statusItemController.addStatusItem()
                        }

                        Button("Remove") {
                            appDelegate.statusItemController.removeStatusItem()
                        }
                        .disabled(appDelegate.statusItemController.count == 0)
                    }

                    Text("Count: \(appDelegate.statusItemController.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .frame(width: 280)
    }
}

// MARK: - Environment Key for AppDelegate

private struct AppDelegateKey: EnvironmentKey {
    static let defaultValue: AppDelegate = AppDelegate()
}

extension EnvironmentValues {
    var appDelegate: AppDelegate {
        get { self[AppDelegateKey.self] }
        set { self[AppDelegateKey.self] = newValue }
    }
}

#Preview {
    ContentView()
}
