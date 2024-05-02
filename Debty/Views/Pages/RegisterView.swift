//
//  RegisterView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 28/04/24.
//

import SwiftUI
struct RegisterInformation {
    var email : String
    var password: String
    var username: String
}

struct RegisterView: View {
    @State var registerInformation: RegisterInformation = RegisterInformation(email: "", password: "", username: "")
    @State var isLoading: Bool = false
    var body: some View {
        NavigationStack{
            Spacer(minLength: 100)
            Text("Register")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 50)
            VStack{
                VStack{
                    HStack{
                        Text("Email")
                        Spacer()
                    }
                    TextField("\("youremail@gmail.com")", text: $registerInformation.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                .padding()
                .background(
                    .regularMaterial,
                    in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                )
                VStack{
                    HStack{
                        Text("Password")
                        Spacer()
                    }
                    SecureField("\("Password123")", text: $registerInformation.password)
                        .textContentType(.password)
                }.padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
                VStack{
                    HStack{
                        Text("Username")
                        Spacer()
                    }
                    TextField("\("johndoe")", text: $registerInformation.username)
                }.padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
                Button{
                    Task {
                        isLoading = true
                        do {
                            // check in database if the username exist or not
                            let response = try await supabase.from("devices")
                                .select("*")
                                .eq("username", value: registerInformation.username)
                                .execute()
                            if response.count! > 0 {
                                let data = try await auth.signUp(email: registerInformation.email, password: registerInformation.password)
                                try await supabase.from("devices")
                                    .update([
                                        "username": registerInformation.username
                                    ])
                                    .eq("user_id", value: data.user.id)
                                    .execute()
                                if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
                                    try await Authentication.updateDeviceToken(token: deviceToken)
                                }
                            }
                            isLoading = false
                        } catch {
                            presentAlert(title: "Error", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
                            isLoading = false
                        }
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(registerInformation.email.isEmpty || registerInformation.password.isEmpty || registerInformation.username.isEmpty || isLoading)
                Spacer(minLength: 300)
            }
            
        }
        .padding()
    }
}

#Preview {
    RegisterView()
}
