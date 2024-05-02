//
//  DebtViewModel.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 24/04/24.
//

import Foundation
@Observable
class DebtViewModel {
    var debts: [BorrowerDataModel] = []
    var filter: LendingFilter = .all
    var searchDebts: String = ""
    func getDebts() async throws {
        do {
            debts = try await DebtsAPI.getDebts(search: searchDebts, filter: filter)
        } catch {
            await presentAlert(title: "Failed to fetch Borrowings!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
            throw error
        }
    }
    func completeDebts(id: UUID) async throws {
        do {
            try await DebtsAPI.pendingDebt(id: id)
        }
        catch {
            await presentAlert(title: "Failed to change borrowing status!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
            throw error
        }
    }
    //
    //    func addDebt(data: AddDebt) async throws {
    //        do {
    //            try await DebtsAPI.addDebt(item: data)
    //        } catch {
    //            throw APIError.failAdding
    //        }
    //
    //        do {
    //            try await getDebts()
    //        } catch {
    //            await presentAlert(title:"Cannot fetch data", subTitle: error.localizedDescription, primaryAction:
    //                    .init(title: "OK", style: .default)
    //            )
    //        }
    //    }
    //
    //    func deleteDebt(at offsets: IndexSet) {
    //        // 1. Get the ID of the deleted row
    //        guard let index = offsets.first else { return }
    //        let deletedDebt = debts[index]
    //        let deletedDebtId = deletedDebt.id
    //        // 2. Call API to delete the item based on ID
    //        Task {
    //            do {
    //                try await DebtsAPI.deleteDebt(id: deletedDebtId)
    //                debts.remove(atOffsets: offsets)
    //            } catch {
    //                await presentAlert(title:"Cannot delete data", subTitle: error.localizedDescription, primaryAction:
    //                        .init(title: "OK", style: .default)
    //                )
    //            }
    //            do {
    //                try await getDebts()
    //            } catch {
    //                await presentAlert(title:"Cannot fetch data", subTitle: error.localizedDescription, primaryAction:
    //                        .init(title: "OK", style: .default)
    //                )
    //
    //            }
    //        }
    //    }
}
