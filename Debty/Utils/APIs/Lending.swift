//
//  Lending.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 24/04/24.
//
import Foundation
import Supabase
enum LendingFilter: CaseIterable, Encodable, Sendable {
    case all
    case overdue
    case completed
    case cancelled
    case pending
    case paid
    case unpaid
}
class LendingsAPI {
    static func getLending(filter: LendingFilter, search: String) async throws -> [LenderDataModel] {
        let query = try supabase
            .rpc("get_lendings")
        if filter != .all {
            _ = query.eq("status", value: "\(filter)")
        }
        if !search.isEmpty {
            _ = query.ilike("title", pattern: "%\(search)%")
        }
        do {
            guard let debts: [LenderDataModel] = try await query
                .order("created_at", ascending: false)
                .execute()
                .value else {
                throw APIError.failFetching
            }
            return debts
        } catch {
            throw error
        }
    }
    static func deleteLending(id: UUID) async throws -> Void {
        do {
            try await supabase.from("lendings").delete().eq("id", value: id).execute()
        } catch {
            throw error
        }
    }
    static func addLending(item: AddDataModel) async throws -> Void {
        guard !item.title.isEmpty else {
            throw APIError.failAdding
        }
        do {
            try await supabase
                .from("lendings")
                .insert(item)
                .execute()
        } catch {
            throw error
        }
    }
    static func getContact(search: String) async throws -> [ContactInfo] {
        let query = try supabase
            .rpc("get_contacts")
        if !search.isEmpty {
            _ = query.ilike("username", pattern: "%\(search)%")
        }
        do {
            let contacts: [ContactInfo] = try await query
                .execute()
                .value
            return contacts
        } catch {
            throw error
        }
    }
    static func addContact(username: String) async throws {
        do {
            try await supabase.rpc("add_contact", params:(["new_username": username]))
                .execute()
        } catch {
            throw error
        }
    }
    static func confirmLending(id: UUID) async throws {
        do {
            try await supabase.rpc("update_lending_to_paid", params: ["lending_id":id])
                .execute()
        }
        catch {
            throw error
        }
    }
}
