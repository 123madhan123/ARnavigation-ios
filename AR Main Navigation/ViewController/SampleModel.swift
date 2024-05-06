//
//  SampleModel.swift
//  AdvancePratice
//
//  Created by Prasanth on 13/02/24.
//

import Foundation


struct SampleModel: Codable {
    let activity, type: String
    let participants: Int
    let price: Double
    let link, key: String
    let accessibility: Double
}

