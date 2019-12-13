//
//  Delegate.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Foundation
import Vapor

protocol WMSDelegate {
    func register(user: WMSRegisterFromRepresentable, on: DatabaseConnectable, container: Container) throws -> EventLoopFuture<WMSAccessRepresentable>
    func login(user: WMSLoginFormRepresentable, on: Container) throws -> Future<WMSAccessRepresentable>
    func getAllUsers(on: DatabaseConnectable) -> Future<[WMSUserRepresentable]>
    func getUser(id: Int, on: DatabaseConnectable) throws -> Future<WMSUserRepresentable>
    func createUser(user: WMSCreateUserFormRepresentable, on: DatabaseConnectable) throws -> Future<WMSUserRepresentable>
    func updateUser(user: WMSUpdateUserFormRepresentable, on: DatabaseConnectable) throws -> Future<WMSUserRepresentable>
    func deleteUser(id: Int, on: DatabaseConnectable) throws -> Future<Void>
//    func getAllVehicles(on: DatabaseConnectable) -> Future<[WMSVehicle]>
//    func getVehicle(id: Int, on: DatabaseConnectable) throws -> Future<WMSVehicle>
//    func createVehicle(vehicle: WMSCreateVehicleForm, on: DatabaseConnectable) throws -> Future<WMSVehicle>
//    func updateVehicle(vehicle: WMSUpdateVehicleForm, on: DatabaseConnectable) throws -> Future<WMSVehicle>
//    func deleteVehicle(id: Int, on: DatabaseConnectable) throws -> Future<Void>
}
