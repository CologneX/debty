//
//  SplashScreenView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 27/04/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        NavigationStack{
            Spacer()
            Image("Debty")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            ProgressView()
                .progressViewStyle(.automatic)
            Spacer()
        }
    }
}

#Preview {
    SplashScreenView()
}
