//
//  Models.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 23/04/24.
//

import Foundation
struct Debts: Decodable, Identifiable, Encodable {
    let id: UUID
    let title: String
    let details: String?
    let lender_id: UUID?
    let borrower_id: UUID?
    let amount: Int
    let created_at: Date
    let deleted_at: Date?
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case details
        case lender_id
        case borrower_id
        case amount
        case created_at
        case deleted_at
    }
}

struct AddDebt: Encodable {
    var title: String
    var details: String
    var lender_id: UUID
    var borrower_id: UUID
    var amount: Int
    
    enum CodingKeys: CodingKey {
        case title
        case details
        case lender_id
        case borrower_id
        case amount
    }
}
