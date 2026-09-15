//
//  DNSPickerView.swift
//  Folk VPN
//
//  Created by Anant Kumar on 14/09/26.
//

import SwiftUI

struct DNSPickerView: View {
    var onDismiss: () -> Void

    @AppStorage(DNSOption.storageKey) private var storedRaw: String = DNSOption.automatic.rawValue

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(DNSOption.allCases) { option in
                            DNSRow(
                                option: option,
                                isSelected: option.rawValue == storedRaw
                            ) {
                                storedRaw = option.rawValue
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Text("DNS")
                .font(.geist(.title2, weight: .bold))
                .foregroundStyle(.black)

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 36, height: 36)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .glassEffect(.regular, in: .circle)
        }
    }
}

private struct DNSRow: View {
    let option: DNSOption
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.name)
                        .font(.geist(.body, weight: .semibold))
                        .foregroundStyle(.black)
                    Text(option.description)
                        .font(.geist(.footnote))
                        .foregroundStyle(.black.opacity(0.6))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 8)

                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.black : Color.black.opacity(0.25), lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.top, 2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .glassEffect(.regular, in: .rect(cornerRadius: 14))
    }
}

#Preview {
    DNSPickerView(onDismiss: {})
}
