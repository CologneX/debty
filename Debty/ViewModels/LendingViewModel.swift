//
//  LendingViewModel.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 24/04/24.
//

import Foundation
@Observable class LendingViewModel {
    var lendings: [LenderDataModel] = []
    var filter: LendingFilter = .all
    var selectedContact: ContactInfo? = nil
    var contactList: [ContactInfo] = []
    var searchContact: String = ""
    var searchLending: String = ""
    var AddDataForm: AddDataModel = AddDataModel(title: "", details: "", lender_id: UUID(), borrower_id: nil, amount: 0)
    func getLendings() async throws {
        do {
            lendings = try await LendingsAPI.getLending(filter: filter, search: searchLending)
        } catch {
            await presentAlert(title: "Failed to fetch Lendings!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
            throw error
        }
    }
    
    func addLending() async throws {
        do {
            AddDataForm.borrower_id = selectedContact?.user_id
            try await LendingsAPI.addLending(item: AddDataForm)
            try await getLendings()
        } catch {
            await presentAlert(title: "Failed to add Lending!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
            throw error
        }
    }
    
    func getContacts() async {
        do {
            contactList = try await LendingsAPI.getContact(search: searchContact)
        } catch {
            await presentAlert(title: "Failed to fetch Contacts!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
        }
    }
    
    func addContact(username: String) async throws {
        do {
            try await LendingsAPI.addContact(username: username)
        }
        catch {
            await presentAlert(title: "Failed to add Contact!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
            throw error
        }
    }
    func confirmLending(id: UUID) async throws {
        do {
            try await LendingsAPI.confirmLending(id: id)
        }
        catch {
            await presentAlert(title: "Failed to change lending status!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
            throw error
        }
    }
}
