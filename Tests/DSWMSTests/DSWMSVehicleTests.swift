import XCTest
@testable import DSWMS
import DSAuth
import FluentMySQL

struct VehicleForm: WMSCreateVehicleFormRepresentable, WMSUpdateVehicleFormRepresentable {
    var vehicleCreateFormName: String {
        return name
    }

    var vehicleCreateFormUserId: Int {
        return userID
    }

    var vehicleUpdateFormId: Int {
        return id!
    }

    var vehicleUpdateFormName: String {
        return name
    }

    var vehicleUpdateFormUserId: Int {
        return userID
    }

    var id: Int?
    var name: String
    var userID: Int
}

final class DSWMSVehicleTests: WMSTestCase {

    var sut: DSWMS!

    override func setUp() {
        super.setUp()
        sut = DSWMS()
    }

    func testGetAllVehicles_ShouldGetCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let _ = try WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID()).save(on: conn).wait()
        let vehicles = try sut.getAllVehicles(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v1")
    }

    func testGetAllVehicles2_ShouldGetCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let _ = try WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID()).save(on: conn).wait()
        let vehicles = try sut.getAllVehicles2(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v1")
        XCTAssertEqual(vehicles[0].user.email, "u2@gmail.com")
    }

    func testGetVehicleById_ShouldGetCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let _ = try WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID()).save(on: conn).wait()
        let v2 = try WMSVehicleRow(id: nil, name: "v2", userID: try! user1.requireID()).save(on: conn).wait()
        let vehicle = try sut.getVehicle(id: try v2.requireID(), on: conn).wait()
        XCTAssertEqual(vehicle.name, "v2")
        XCTAssertEqual(vehicle.userID, 1)
    }

    func testGetVehicle2ById_ShouldGetCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let _ = try WMSVehicleRow(id: nil, name: "v1", userID: try! user1.requireID()).save(on: conn).wait()
        let v2 = try WMSVehicleRow(id: nil, name: "v2", userID: try! user1.requireID()).save(on: conn).wait()
        let vehicle = try sut.getVehicle2(id: try v2.requireID(), on: conn).wait()
        XCTAssertEqual(vehicle.name, "v2")
        XCTAssertEqual(vehicle.user.email, "u2@gmail.com")
    }

    func testCreateVehicle_ShouldCreateCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let form = VehicleForm(id: nil, name: "v1", userID: try! user1.requireID())
        let _ = try sut.createVehicle(vehicle: form, on: conn).wait()
        let vehicles = try sut.getAllVehicles(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v1")
        XCTAssertEqual(vehicles[0].userID, 1)
    }

    func testCreateVehicle2_ShouldCreateCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let form = VehicleForm(id: nil, name: "v1", userID: try! user1.requireID())
        let _ = try sut.createVehicle2(vehicle: form, on: conn).wait()
        let vehicles = try sut.getAllVehicles2(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v1")
        XCTAssertEqual(vehicles[0].user.email, "u2@gmail.com")
    }

    func testUpdateVehicle_ShouldCreateCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let form = VehicleForm(id: nil, name: "v1", userID: try! user1.requireID())
        let newVehicle = try sut.createVehicle(vehicle: form, on: conn).wait()
        let update = VehicleForm(id: newVehicle.id, name: "v2", userID: try! user1.requireID())
        let _ = try sut.updateVehicle(vehicle: update, on: conn).wait()
        let vehicles = try sut.getAllVehicles(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v2")
        XCTAssertEqual(vehicles[0].userID, 1)
    }

    func testUpdateVehicle2_ShouldCreateCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let form = VehicleForm(id: nil, name: "v1", userID: try! user1.requireID())
        let newVehicle = try sut.createVehicle(vehicle: form, on: conn).wait()
        let update = VehicleForm(id: newVehicle.id, name: "v2", userID: try! user1.requireID())
        let _ = try sut.updateVehicle2(vehicle: update, on: conn).wait()
        let vehicles = try sut.getAllVehicles2(on: conn).wait()
        XCTAssertEqual(vehicles[0].name, "v2")
        XCTAssertEqual(vehicles[0].user.email, "u2@gmail.com")
    }

    func testDeleteVehicle_ShouldDeleteCorrectly() throws {
        let user1 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let form = VehicleForm(id: nil, name: "v1", userID: try! user1.requireID())
        let newVehicle = try sut.createVehicle(vehicle: form, on: conn).wait()
        let _ = try sut.deleteVehicle(id: newVehicle.id, on: conn).wait()
        let vehicles = try sut.getAllVehicles(on: conn).wait()
        XCTAssertEqual(vehicles.count, 0)
    }
}
