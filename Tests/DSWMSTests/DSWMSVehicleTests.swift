import XCTest
@testable import DSWMS
import DSAuth
import FluentMySQL

final class DSWMSVehicleTests: WMSTestCase {

    func testGetAllVehicles_ShouldGetCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let _ = try WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID()).save(on: conn).wait()
        let vehicles = try WMSVehicle.getAll(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v1")
    }

    func testGetAllVehicles2_ShouldGetCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let _ = try WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID()).save(on: conn).wait()
        let vehicles = try WMSVehicle2.getAll(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v1")
        XCTAssertEqual(vehicles[0].user.email, "u2@gmail.com")
    }

    func testGetVehicleById_ShouldGetCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let _ = try WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID()).save(on: conn).wait()
        let v2 = try WMSVehicleRow(id: nil, name: "v2", userID: try! user1.requireID()).save(on: conn).wait()
        let vehicle = try WMSVehicle.get(id: try v2.requireID(), on: conn).wait()
        XCTAssertEqual(vehicle.name, "v2")
        XCTAssertEqual(vehicle.userID, 1)
    }

    func testGetVehicle2ById_ShouldGetCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let _ = try WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID()).save(on: conn).wait()
        let v2 = try WMSVehicleRow(id: nil, name: "v2", userID: try! user1.requireID()).save(on: conn).wait()
        let vehicle = try WMSVehicle2.get(id: try v2.requireID(), on: conn).wait()
        XCTAssertEqual(vehicle.name, "v2")
        XCTAssertEqual(vehicle.user.email, "u2@gmail.com")
    }

    func testCreateVehicle_ShouldCreateCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let form = WMSVehicle.Post(name: "v1", userID: try! user1.requireID())
        let _ = try form.create(on: conn).wait()
        let vehicles = try WMSVehicle.getAll(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v1")
        XCTAssertEqual(vehicles[0].userID, 1)
    }

//    func testCreateVehicle2_ShouldCreateCorrectly() throws {
//        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
//        let form = VehicleForm(id: nil, name: "v1", userID: try! user1.requireID())
//        let _ = try sut.createVehicle2(vehicle: form, on: conn).wait()
//        let vehicles = try sut.getAllVehicles2(on: conn).wait()
//        XCTAssertEqual(vehicles[0].name, "v1")
//        XCTAssertEqual(vehicles[0].user.email, "u2@gmail.com")
//    }

    func testUpdateVehicle_ShouldCreateCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let form = WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID())
        let newVehicle = try form.create(on: conn).wait()
        let update = WMSVehicle(id: try newVehicle.requireID(), name: "v2", userID: try! user1.requireID())
        let _ = try update.update(on: conn).wait()
        let vehicles = try WMSVehicle.getAll(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v2")
        XCTAssertEqual(vehicles[0].userID, 1)
    }

//    func testUpdateVehicle2_ShouldCreateCorrectly() throws {
//        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
//        let form = WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID())
//        let newVehicle = try form.create(on: conn).wait()
//        let update = VehicleForm(id: newVehicle.id, name: "v2", userID: try! user1.requireID())
//        let _ = try sut.updateVehicle2(vehicle: update, on: conn).wait()
//        let vehicles = try sut.getAllVehicles2(on: conn).wait()
//        XCTAssertEqual(vehicles[0].name, "v2")
//        XCTAssertEqual(vehicles[0].user.email, "u2@gmail.com")
//    }

    func testDeleteVehicle_ShouldDeleteCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let form = WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID())
        let newVehicle = try form.create(on: conn).wait()
        let delete = WMSVehicle(id: try! newVehicle.requireID(), name: "", userID: 0)
        let _ = try delete.delete(on: conn).wait()
        let vehicles = try WMSVehicle.getAll(on: conn).wait()
        XCTAssertEqual(vehicles.count, 0)
    }
}
