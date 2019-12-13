//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Foundation

public struct WMSAuthUser {
    public var id: Int
    public var email: String
}

public struct WMSUser {
    public var id: Int
    public var email: String

    init(userRow: WMSUserRow) {
        self.id = try! userRow.requireID()
        self.email = userRow.email
    }
}

public struct WMSAccess {
    public var token: String
}
