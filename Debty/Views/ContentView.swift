//
//  ContentView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 22/04/24.
//

import SwiftUI
struct ContentView: View {
    @Binding var profile: ProfileViewModel
    @Binding var isAuthenticated: Bool?
    @Binding var isLoginScreenPresented: Bool
    var body: some View {
        TabView{
            DebtsView(profile: $profile, isAuthenticated: $isAuthenticated, isLoginScreenPresented: $isLoginScreenPresented)
                .tabItem {
                    Label("Debts", systemImage: "creditcard.trianglebadge.exclamationmark")
                }
            LendingsView(profile: $profile, isAuthenticated: $isAuthenticated, isLoginScreenPresented: $isLoginScreenPresented)
                .tabItem {
                    Label("Lendings", systemImage: "banknote.fill")
                }
            SummaryView(profile: $profile, isAuthenticated: $isAuthenticated, isLoginScreenPresented: $isLoginScreenPresented)
                .tabItem {
                    Label("Summary", systemImage: "doc.fill")}
        }
    }
}
