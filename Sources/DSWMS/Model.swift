//
//  Model.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Foundation
import DSCore

public protocol WMSLoginFormRepresentable {
    var loginEmail: String { get }
    var loginPassword: String { get }
}

public protocol WMSRegisterFromRepresentable {
    var registerEmail: String { get }
    var registerPassword: String { get }
}

public protocol WMSCreateUserFormRepresentable: RowConvertible {
    var userCreateFormEmail: String { get }
}

public protocol WMSUpdateUserFormRepresentable: RowConvertible {
    var userUpdateFormId: Int { get }
    var userUpdateFormEmail: String { get }
}
