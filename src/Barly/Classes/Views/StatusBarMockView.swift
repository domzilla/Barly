//
//  StatusBarMockView.swift
//  Barly
//
//  Created by Dominic Rodemer on 12.12.25.
//

import SwiftUI

private struct SeparatorPositionKey: PreferenceKey {
    static var defaultValue: Anchor<CGPoint>?
    static func reduce(value: inout Anchor<CGPoint>?, nextValue: () -> Anchor<CGPoint>?) {
        value = nextValue() ?? value
    }
}

struct StatusBarMockView: View {

    private var currentDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d  HH:mm"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(spacing: 8) {
            // Mock status bar
            HStack(spacing: 0) {
                Spacer()

                // Hidden items (left of separator)
                HStack(spacing: 12) {
                    Image(systemName: "scanner")
                    Image(systemName: "circle.square.fill")
                }
                .foregroundStyle(.secondary)

                // Separator (pipe)
                Image(nsImage: NSImage(named: "seprator") ?? NSImage())
                    .padding(.horizontal, 12)
                    .anchorPreference(key: SeparatorPositionKey.self, value: .center) { $0 }

                // Arrow (collapse indicator)
                Image(nsImage: NSImage(named: "collapse") ?? NSImage())

                Spacer()
                    .frame(width: 16)

                // Shown items (right of arrow)
                HStack(spacing: 12) {
                    Image(systemName: "wifi")
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 10, weight: .semibold))
                    Text("75%")
                        .font(.system(size: 13))
                    Image(systemName: "battery.75")
                    Text(currentDateTime)
                        .font(.system(size: 13))
                }
            }
            .font(.system(size: 14))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(nsColor: .darkGray))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlayPreferenceValue(SeparatorPositionKey.self) { anchor in
                GeometryReader { geometry in
                    if let anchor = anchor {
                        HStack(spacing: 4) {
                            Text("Hidden")
                            Image(systemName: "arrow.up")
                            Text("Shown")
                        }
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .position(x: geometry[anchor].x - 1, y: geometry.size.height + 16)
                    }
                }
            }
        }
        .padding(.bottom, 24)
    }
}

#Preview {
    StatusBarMockView()
        .padding()
}
