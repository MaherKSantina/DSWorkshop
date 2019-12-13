//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Vapor

public struct WMSAuthUser: Content {
    public var id: Int
    public var email: String
}

public struct WMSUser: Content {
    public var id: Int
    public var email: String

    init(userRow: WMSUserRow) {
        self.id = try! userRow.requireID()
        self.email = userRow.email
    }
}

public struct WMSAccess: Content {
    public var token: String
}
