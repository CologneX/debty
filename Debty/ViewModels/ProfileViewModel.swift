//
//  ProfileViewModel.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 25/04/24.
//

import Foundation
import Supabase
@Observable class ProfileViewModel {
    var profile: Auth.User? = nil
    var username: String? = nil
    func getProfile() async {
        do {
            profile = try await Authentication.getUser()
        } catch {
            await presentAlert(title: "Failed to fetch Profile!", subTitle: error.localizedDescription, primaryAction: .init(title: "Retry", style: .default, handler: {_ in
                Task {
                    await self.getProfile()
                }})
            )}
    }
    func getUsername() async {
        do {
//            username =
            var gg = try await supabase.from("devices").select().eq("user_id", value: "c75654ec-04ca-4171-9c14-2cba85c99f0c").execute().value
            print(gg)
        } catch {
            await presentAlert(title: "Failed to fetch Username!", subTitle: error.localizedDescription, primaryAction: .init(title: "Retry", style: .default, handler: {_ in
                Task {
                    await self.getUsername()
                }})
            )}
        
    }
}
