//
//  LoginView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 25/04/24.
//

import SwiftUI
import AuthenticationServices
import NearbyInteraction
struct AuthView: View {
    @State var isLoading: Bool = false
    @State var data: LoginInformation = LoginInformation(email: "", password: "")
    var body: some View {
        NavigationStack{
            Spacer(minLength: 100)
            Text("Sign In")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 50)
            VStack{
                VStack{
                    HStack{
                        Text("Email")
                        Spacer()
                    }
                    TextField("\("youremail@gmail.com")", text: $data.email)
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
                    SecureField("\("Password123")", text: $data.password)
                        .textContentType(.password)
                }
                .padding()
                .background(
                    .regularMaterial,
                    in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                )
                Button{
                    Task{
                        do {
                            try await auth.signIn(email: data.email, password: data.password)
                            if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
                                try await Authentication.updateDeviceToken(token: deviceToken)
                            }
                            // Insert discovery token to database                            
                            
                        } catch {
                            presentAlert(title: "Failed to Log In", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
                        }
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(data.email.isEmpty || data.password.isEmpty || isLoading)
                SignInWithAppleButton { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    Task {
                        do {
                            guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential
                            else {
                                return
                            }
                            
                            guard let idToken = credential.identityToken
                                .flatMap({ String(data: $0, encoding: .utf8) })
                            else {
                                return
                            }
                            try await auth.signInWithIdToken(
                                credentials: .init(
                                    provider: .apple,
                                    idToken: idToken
                                )
                            )
                            if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
                                try await Authentication.updateDeviceToken(token: deviceToken)
                            }

                            
                        } catch {
                            dump(error)
                        }
                    }
                }
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(minHeight: 40, maxHeight: 40)
                Spacer()
                NavigationLink {
                    RegisterView()
                } label: {
                    Text("Don't have an account? Register")
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
        }
    }
}

#Preview {
    AuthView()
}
