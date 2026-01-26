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
                            self.appDelegate.mainMenuController.addMenuItem()
                        }

                        Button("Remove") {
                            self.appDelegate.mainMenuController.removeMenuItem()
                        }
                        .disabled(self.appDelegate.mainMenuController.count == 0)
                    }

                    Text("Count: \(self.appDelegate.mainMenuController.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            GroupBox("Status Bar Items") {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button("Add") {
                            self.appDelegate.statusBarItemController.addStatusItem()
                        }

                        Button("Remove") {
                            self.appDelegate.statusBarItemController.removeStatusItem()
                        }
                        .disabled(self.appDelegate.statusBarItemController.count == 0)
                    }

                    Text("Count: \(self.appDelegate.statusBarItemController.count)")
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
    static let defaultValue: AppDelegate = .init()
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
