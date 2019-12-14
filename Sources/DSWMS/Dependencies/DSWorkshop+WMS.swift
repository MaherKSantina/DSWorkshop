//
//  File.swift
//  
//
//  Created by Maher Santina on 12/14/19.
//

import DSWorkshop

extension VehicleRow {
    var wmsVehicle: WMSVehicle {
        return WMSVehicle(id: try! requireID(), name: name, userID: userID)
    }
}

extension WMSCreateVehicleFormRepresentable {
    var workshopVehicleRow: VehicleRow {
        return VehicleRow(id: nil, name: vehicleCreateFormName, userID: vehicleCreateFormUserId)
    }
}

extension WMSUpdateVehicleFormRepresentable {
    var workshopVehicleRow: VehicleRow {
        return VehicleRow(id: vehicleUpdateFormId, name: vehicleUpdateFormName, userID: vehicleUpdateFormUserId)
    }
}
