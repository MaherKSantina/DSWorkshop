//
//  Delegate.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Foundation
import Vapor

protocol WMSDelegate {
    func register(user: WMSRegisterFromRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSAccess>
    func login(user: WMSLoginFormRepresentable, on: DatabaseConnectable) throws -> Future<WMSAccess>
    func getAllUsers(on: DatabaseConnectable) -> Future<[WMSUser]>
    func getUsers(queryString: String, on: DatabaseConnectable) -> Future<[WMSUser]>
    func getUser(id: Int, on: DatabaseConnectable) throws -> Future<WMSUser>
    func createUser(user: WMSCreateUserFormRepresentable, on: DatabaseConnectable) throws -> Future<WMSUser>
    func updateUser(user: WMSUpdateUserFormRepresentable, on: DatabaseConnectable) throws -> Future<WMSUser>
    func deleteUser(id: Int, on: DatabaseConnectable) throws -> Future<Void>
    func getAllVehicles(on: DatabaseConnectable) -> Future<[WMSVehicle]>
    func getVehicle(id: Int, on: DatabaseConnectable) throws -> Future<WMSVehicle>
    func createVehicle(user: WMSCreateVehicleFormRepresentable, on: DatabaseConnectable) throws -> Future<WMSVehicle>
    func updateVehicle(user: WMSUpdateVehicleFormRepresentable, on: DatabaseConnectable) throws -> Future<WMSVehicle>
    func deleteVehicle(id: Int, on: DatabaseConnectable) throws -> Future<Void>
//    func createVehicle(vehicle: WMSCreateVehicleForm, on: DatabaseConnectable) throws -> Future<WMSVehicle>
//    func updateVehicle(vehicle: WMSUpdateVehicleForm, on: DatabaseConnectable) throws -> Future<WMSVehicle>
//    func deleteVehicle(id: Int, on: DatabaseConnectable) throws -> Future<Void>
}
