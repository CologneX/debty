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
    @State var isLoadingUsername: Bool = false
    @State var isAnonymous: Bool = false
    var body: some View {
        if (profile.profile != nil) {
            NavigationStack{
                ZStack {
                    Color.accentColor
                    VStack{
                        if isLoadingUsername && profile.username == nil {
                            ProgressView()
                        } else {
                            Label(profile.username ?? "No Username", systemImage: "person.fill")
                                .font(.title2)
                                .bold()
                        }
                        Text(profile.profile?.email ?? "No Email")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .padding([.bottom, .trailing, .leading])
                }
                .frame(maxHeight: 150)
                .background(Color.accentColor)
                .task {
                    isLoadingUsername = true
                    await profile.getUsername()
                    isLoadingUsername = false
                }
                Form{
                    // Switch for toggling anonymous mode
                    Section{
                        Toggle("Anonymous Mode", isOn: $isAnonymous)
                    }
                    .alert("Miskin", isPresented: $isAnonymous, actions: {
                        Button("Ok", role: .cancel){}
                    }, message: {
                        Text("It seems that you have not bought the premium version of the app. Please buy the premium version to access this feature.")
                    })
                    
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
                .navigationBarTitleDisplayMode(.inline)
                
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

