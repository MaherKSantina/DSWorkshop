//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Foundation
import DSCore
import FluentMySQL

struct WMSUserRow: MySQLModel, DSModel {
    var id: Int?
    var email: String

    static func routePath() throws -> String {
        return ""
    }

    static var defaultDatabase: DatabaseIdentifier<MySQLDatabase>? = .mysql

    static var entity: String = "WMSUser"
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
