//
//  Auth.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 25/04/24.
//

import Foundation
import AuthenticationServices
import Supabase
class Authentication {
    static func getUser() async throws -> Auth.User {
        do {
            return try await auth.user()
        } catch {
            throw error
        }
        
    }
    static func loginEmail(email: String, password: String) async throws -> Void {
        do {
            try await auth.signIn(email: email, password: password)
        } catch {
            throw error
        }
    }
    
    static func loginApple() async throws -> Void {
        do {
            try await auth.signInWithOAuth(provider: .apple) {
                (session: ASWebAuthenticationSession) in
                
            }
        } catch {
            throw error
        }
    }
    static func updateDeviceToken(token: String) async throws -> Void {
        do {
            try await supabase.rpc( "update_device_token", params: ["device_token": token])
                .execute()
        } catch {
            throw error
        }
    }
}
