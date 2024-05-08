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
    func getLendingSummary(filter_date: DateFilter) async throws{
        do {
            lendingSummary = try await supabase.rpc("get_total_lending", params: [
                "start_date":filter_date.start,
                "end_date":filter_date.end
                
            ])
            .execute()
            .value
        }
        catch {
            await presentAlert(title: "Error fetching lendings!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
        }
    }
    
    func getBorrowingSummary(filter_date: DateFilter) async throws {
        do {
            debtSummary = try await supabase.rpc("get_total_borrowing", params: [
                "start_date":filter_date.start,
                "end_date":filter_date.end
            ])
            .execute()
            .value
        }
        catch {
            await presentAlert(title: "Error fetching borrowings!", subTitle: error.localizedDescription, primaryAction: .init(title: "Ok", style: .default))
        }
    }
}
