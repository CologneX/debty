//
//  Lendings.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 24/04/24.
//

import Foundation
struct LenderDataModel: Decodable, Identifiable, Encodable {
    let id: UUID
    let title: String
    let details: String?
    let lender_id: UUID
    let borrower_id: UUID
    let borrower_username: String
    let status: String
    let amount: Int
    let deadline_at: Date?
    let created_at: Date
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case details
        case lender_id
        case borrower_id
        case borrower_username
        case status
        case amount
        case deadline_at
        case created_at
    }
}

struct BorrowerDataModel: Decodable, Identifiable, Encodable {
    let id: UUID
    let title: String
    let details: String?
    let lender_id: UUID
    let lender_username: String
    let borrower_id: UUID
    let status: String
    let amount: Int
    let deadline_at: Date?
    let created_at: Date
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case details
        case lender_id
        case lender_username
        case borrower_id
        case status
        case amount
        case deadline_at
        case created_at
    }
}


struct AddDataModel: Encodable {
    var title: String
    var details: String
    var deadline_at: Date?
    var lender_id: UUID
    var borrower_id: UUID?
    var amount: Int

    enum CodingKeys: CodingKey {
        case title
        case details
        case lender_id
        case deadline_at
        case borrower_id
        case amount
    }
}

struct LoginInformation: Encodable {
    var email: String
    var password: String
    
    enum CodingKeys: CodingKey {
        case email
        case password
    }
}

struct ContactInfo: Decodable, Equatable {
    var user_id: UUID
    var username: String
    
    enum CodingKeys: CodingKey {
        case user_id
        case username
    }
}

struct User: Decodable, Encodable {
    let id: UUID
    let device_id: UUID
    let username:String
    let status: String
    let contacts: [UUID]
}

struct AddContact: Encodable {
    let user_id: UUID
    let contacts: [UUID]
}
