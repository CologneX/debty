//
//  TestView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 29/04/24.
//

import SwiftUI
struct AvatarView: View {
    var body: some View {
        Image(systemName: "person.circle")
            .symbolRenderingMode(.hierarchical)
            .resizable()
            .frame(width: 28, height: 28)
            .foregroundStyle(Color.accentColor)
    }
}
#Preview {
    AvatarView()
}
