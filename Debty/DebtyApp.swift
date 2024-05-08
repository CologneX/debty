//
//  DebtyApp.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 22/04/24.
//

import SwiftUI
@main
struct DebtyApp: App {
    @State var profile: ProfileViewModel = ProfileViewModel()
    @State var isLoginScreenPresented: Bool = false
    @State var isAuthenticated: Bool? = nil
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            Group {
                switch isAuthenticated {
                case true:
                    if isLoginScreenPresented {
                        AuthView()
                    } else {
                        ContentView(profile: $profile, isAuthenticated: $isAuthenticated, isLoginScreenPresented: $isLoginScreenPresented)
                    }
                case false:
                    if isLoginScreenPresented {
                        AuthView()
                    } else {
                        ContentView(profile: $profile, isAuthenticated: $isAuthenticated, isLoginScreenPresented: $isLoginScreenPresented)
                    }
                default:
                    SplashScreenView()
                }
            }
            .task {
                for await state in auth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                        isAuthenticated = state.session != nil
                        profile.profile = state.session?.user
                        if state.session != nil {
                            await profile.getProfile()
                            isLoginScreenPresented = false
                        }
                    }
                }
            }
        }
    }
}
