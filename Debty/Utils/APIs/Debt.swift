//
//  Api.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 23/04/24.
//

import Foundation
import Supabase

class DebtsAPI {
    static func getDebts(search: String, filter: LendingFilter) async throws -> [BorrowerDataModel] {
        let query = try supabase.rpc("get_borrowings")
        if filter != .all {
            _ = query.eq("status", value: "\(filter)")
        }
        if !search.isEmpty {
            _ = query.ilike("title", pattern: "%\(search)%")
        }
        do {
            guard let debts: [BorrowerDataModel] = try await query
                .execute()
                .value else {
                throw APIError.failFetching
            }
            return debts
        } catch {
            throw error
        }
    }
    static func deleteDebt(id: UUID) async throws {
        do {
            try await supabase
                .rpc("delete_debt", params: ["debt_id": id.uuidString])
                .execute()
        } catch {
            throw error
        }
    }
    static func pendingDebt(id: UUID) async throws {
        do {
            try await supabase.rpc("update_lending_to_pending", params: ["lending_id":id])
                .execute()
        }
        catch {
            throw error
        }
    }
}

enum APIError: Error {
    case failFetching
    case failDeleting
    case failAdding
}
