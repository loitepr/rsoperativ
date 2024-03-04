//
//  BarentsWatch struct.swift
//  RS Operativ
//
//  Created by Preben Løite on 02/03/2024.
//

import Foundation
import MapKit
import SwiftUI

struct BarentsWatch: Codable, Identifiable {
    var id: String { return "\(UUID())" }
    let courseOverGround: Double?
    let latitude, longitude: Double?
    let name: String?
    let rateOfTurn, shipType: Int?
    let speedOverGround: Double?
    let trueHeading, navigationalStatus, mmsi: Int?
    let msgtime: String?
}

struct Token: Codable, Identifiable {
    var id: String { return "\(UUID())" }
    let accessToken: String
    let expiresIn: Int
    let tokenType, scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
    }
}


