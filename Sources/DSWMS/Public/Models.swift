//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Vapor
import DSCore

public struct WMSAuthUser: Content {
    public var id: Int
    public var email: String
}

public struct WMSAccess: Content {
    public var token: String
}
