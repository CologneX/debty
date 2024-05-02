//
//  ProfileView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 23/04/24.
//

import SwiftUI
struct ProfileView: View {
    @Binding var profile: ProfileViewModel
    @Binding var isLoginScreenPresented: Bool
    @State var showLogoutAlert: Bool = false
    @State var isLoadinUsername: Bool = false
    var body: some View {
        if (profile.profile != nil) {
            NavigationStack{
                GroupBox(label:
                            Label(profile.username ?? "Loading", systemImage: "person.fill")
                    .task {
                        isLoadinUsername = true
                        await profile.getUsername()
                        isLoadinUsername = false
                    }
                         
                         , content: {
                    Text(profile.profile?.email ?? "No Profile")
                    
                })
                .padding(.horizontal)
                Form{
                    Button("Log Out", role: .destructive, action: {
                        showLogoutAlert.toggle()
                    })
                    .alert(Text("Log Out"), isPresented: $showLogoutAlert,
                           actions: {
                        Button("Cancel", role: .cancel){}
                        Button("Log Out", role: .destructive){
                            Task {
                                try await auth.signOut()
                            }
                        }
                    }, message: {
                        Text("Are you sure you want to log out?")
                    })
                }
                .navigationTitle("Profile")
            }
        } else {
            ContentUnavailableView {
                Label("You are not authenticated!", systemImage: "xmark")
            } description: {
                Text("Log in first to access our services")
                Button("Login", action: {
                    isLoginScreenPresented.toggle()
                })
            }
        }
    }
}

