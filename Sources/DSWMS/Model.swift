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

public protocol WMSCreateUserFormRepresentable {
    var userCreateFormEmail: String { get }
}

public protocol WMSUpdateUserFormRepresentable {
    var userUpdateFormId: Int { get }
    var userUpdateFormEmail: String { get }
}

public protocol WMSWorkOrderRepresentable {
    var workOrderId: Int { get }
    var workOrderName: String { get }
}

public protocol WMSJobRepresentable {
    var workOrderId: Int { get }
    var workOrderJame: String { get }
}

public protocol WMSVehicleRepresentable {
    var vehicleId: Int { get }
    var vehicleName: String { get }
    var vehicleUser: WMSUser { get }
}

public protocol WMSCreateVehicleFormRepresentable {
    var vehicleCreateFormName: String { get }
    var vehicleCreateFormUserId: Int { get }
}

public protocol WMSUpdateVehicleFormRepresentable {
    var vehicleUpdateFormId: Int { get }
    var vehicleUpdateFormName: String { get }
}
