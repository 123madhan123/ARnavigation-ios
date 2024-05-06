//
//  profileModel.swift
//  AR Main Navigation
//
//  Created by ELISHA RAJ on 01/03/24.
//

import Foundation


    struct UserDeatils: Codable {
        let status: Bool
        let user: User
    }

    // MARK: - User
    struct User: Codable {
        let sNo: Int
        let username, password, confirmPassword, mailid: String
        let dateOfJoin: String
        let mobileNumber: Int

        enum CodingKeys: String, CodingKey {
            case sNo
            case username = "Username"
            case password = "Password"
            case confirmPassword = "ConfirmPassword"
            case mailid
            case dateOfJoin = "Date Of Join"
            case mobileNumber = "MobileNumber"
        }
    }
