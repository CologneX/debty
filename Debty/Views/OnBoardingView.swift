//
//  MainView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 22/04/24.
//

import SwiftUI
struct OnBoardingView: View {
    var body: some View {
        TabView {
            OnBoardingFirst()
            OnBoardingSecond()
        } //: TAB
        .tabViewStyle(PageTabViewStyle())
    }
}

struct OnBoardingFirst: View {
    var body: some View {
        VStack {
            Text("OnBoarding First")
        }
    }
}

struct OnBoardingSecond: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var body: some View {
        VStack {
            Text("OnBoarding Second")
            Button("Continue") {
                isOnboarding = false
            }
        }
    }
}
#Preview {
    OnBoardingView()
}
