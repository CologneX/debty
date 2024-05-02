//
//  SummaryView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 30/04/24.
//


import Foundation
import Supabase
@Observable class SummaryViewModel {
    var lendingSummary: Double? = nil
    var debtSummary: Double? = nil
    func getLendingSummary(filterDate: Date?) async throws{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let filterDateFormatted = filterDate != nil ? formatter.string(from: filterDate!) : nil
        do {
            lendingSummary = try await supabase.rpc("get_total_lending", params: ["filter_date": filterDateFormatted])
                .execute()
                .value
        }
        catch {
            await presentAlert(title: "Error fetching lendings!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
        }
    }
    
    func getBorrowingSummary(filterDate: Date?) async throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let filterDateFormatted = filterDate != nil ? formatter.string(from: filterDate!) : nil
        do {
            debtSummary = try await supabase.rpc("get_total_borrowing", params: ["filter_date": filterDateFormatted])
                .execute()
                .value
        }
        catch {
            await presentAlert(title: "Error fetching borrowings!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
        }
    }
}
