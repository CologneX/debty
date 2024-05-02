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
            .resizable()
            .border(Color.accentColor)
            .frame(width: 28, height: 28)
            .clipShape(Circle())
    }
}
#Preview {
    AvatarView()
}
