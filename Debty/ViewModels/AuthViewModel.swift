//
//  AuthViewModel.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 25/04/24.
//

import Foundation
@Observable class AuthViewModel {
    var user = try await auth.user()
}
