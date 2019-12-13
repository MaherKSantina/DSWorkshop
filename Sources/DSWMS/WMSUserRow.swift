//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Foundation
import DSCore

struct WMSUserRow: DSModel {
    var id: Int?
    var email: String

    static func routePath() throws -> String {
        return ""
    }
}

extension WMSUserRow: WMSUserRepresentable {
    var userId: Int {
        return try! requireID()
    }

    var userEmail: String {
        return email
    }
}

extension WMSCreateUserFormRepresentable {
    var wmsUserRow: WMSUserRow {
        return WMSUserRow(id: nil, email: userCreateFormEmail)
    }
}

extension WMSUpdateUserFormRepresentable {
    var wmsUserRow: WMSUserRow {
        return WMSUserRow(id: userUpdateFormId, email: userUpdateFormEmail)
    }
}

extension Int {
    var wmsUserRow: WMSUserRow {
        return WMSUserRow(id: self, email: "")
    }
}
