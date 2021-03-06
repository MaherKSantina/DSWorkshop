import XCTest
@testable import DSWMS
import DSAuth
import FluentMySQL

final class DSWMSWorkOrderTests: WMSTestCase {

    var job1: WMSJobRow!
    var job2: WMSJobRow!

    var vehicle1: WMSVehicleRow!
    var vehicle2: WMSVehicleRow!
    var vehicle3: WMSVehicleRow!

    var user1: WMSUserRow!
    var user2: WMSUserRow!

    override func setUp() {
        super.setUp()

        user1 = try! WMSUserRow(id: nil, email: "user1@gmail.com").save(on: conn).wait()
        user2 = try! WMSUserRow(id: nil, email: "user2@gmail.com").save(on: conn).wait()

        job1 = try! WMSJobRow(id: nil, name: "Job1").save(on: conn).wait()
        job2 = try! WMSJobRow(id: nil, name: "Job2").save(on: conn).wait()

        vehicle1 = try! WMSVehicleRow(id: nil, name: "Vehicle 1", userID: user1.id!).save(on: conn).wait()
        vehicle2 = try! WMSVehicleRow(id: nil, name: "Vehicle 2", userID: user2.id!).save(on: conn).wait()
        vehicle3 = try! WMSVehicleRow(id: nil, name: "Vehicle 3", userID: user2.id!).save(on: conn).wait()
    }

    func testGetAllWorkOrders_ShouldGetCorrectly() throws {
        let _ = try WMSWorkOrderRow(id: nil, jobID: job1.id!, vehicleID: vehicle1.id!, notes: "asd", date: Date()).save(on: conn).wait()
        let all = try WMSWorkOrder.getAll(on: conn).wait()
        XCTAssertEqual(all.count, 1)
    }

    func testGetWorkOrderById_ShouldGetCorrectly() throws {
        let _ = try WMSWorkOrderRow(id: nil, jobID: job1.id!, vehicleID: vehicle1.id!, notes: "asd", date: Date()).save(on: conn).wait()
        let _ = try WMSWorkOrderRow(id: nil, jobID: job2.id!, vehicleID: vehicle3.id!, notes: "note2", date: Date()).save(on: conn).wait()
        let one = try WMSWorkOrder.get(id: 2, on: conn).wait()
        XCTAssertEqual(one.jobID, 2)
        XCTAssertEqual(one.vehicleID, 3)
        XCTAssertEqual(one.notes, "note2")
    }

    func testCreateWorkOrder_ShouldCreateCorrectly() throws {
        let row = WMSWorkOrder.Post(id: nil, jobID: 2, vehicleID: 1, notes: "notes1", date: Date())
        let _ = try row.create(on: conn).wait()
        let workOrders = try WMSWorkOrderRow.getAll(on: conn).wait()
        XCTAssertEqual(workOrders[0].jobID, 2)
        XCTAssertEqual(workOrders[0].vehicleID, 1)
        XCTAssertEqual(workOrders[0].notes, "notes1")
    }

    func testUpdateUser_ShouldCreateCorrectly() throws {
        let row = try WMSWorkOrderRow(id: nil, jobID: 2, vehicleID: 1, notes: "notes1", date: Date()).save(on: conn).wait()
        let update = WMSWorkOrder(id: try! row.requireID(), jobID: 1, vehicleID: 2, notes: "notes1", date: Date())
        let _ = try update.update(on: conn).wait()
        let workOrders = try WMSWorkOrderRow.getAll(on: conn).wait()
        XCTAssertEqual(workOrders[0].jobID, 1)
        XCTAssertEqual(workOrders[0].vehicleID, 2)
        XCTAssertEqual(workOrders[0].notes, "notes1")
    }

    func testDeleteUser_ShouldDeleteCorrectly() throws {
        let row = try WMSWorkOrderRow(id: nil, jobID: 2, vehicleID: 1, notes: "notes1", date: Date()).save(on: conn).wait()
        let delete = WMSWorkOrderRow(id: try! row.requireID())
        let _ = try delete.delete(on: conn).wait()
        let users = try WMSWorkOrder.getAll(on: conn).wait()
        XCTAssertEqual(users.count, 0)
    }

    func test_GetAll2_ShouldGetProperly() throws {
        _ = try WMSWorkOrderRow(id: nil, jobID: 2, vehicleID: 1, notes: "Note", date: Date()).save(on: conn).wait()
        guard let viewItem = try WMSWorkOrder2.getAll(on: conn).wait().first else { XCTFail(); return }
        XCTAssertEqual(viewItem.id, 1)
        XCTAssertEqual(viewItem.vehicle.name, "Vehicle 1")
        XCTAssertEqual(viewItem.job.name, "Job2")
    }

    func test_GetAll3_ShouldGetProperly() throws {
        _ = try WMSUserRow(id: nil, email: "email").save(on: conn).wait()
        _ = try WMSVehicleRow(id: nil, name: "V1", userID: 1).save(on: conn).wait()
        _ = try WMSJobRow(id: nil, name: "Job1").save(on: conn).wait()
        _ = try WMSWorkOrderRow(id: nil, jobID: 1, vehicleID: 1, notes: "Note", date: Date()).save(on: conn).wait()
        guard let viewItem = try WMSWorkOrder3.getAll(on: conn).wait().first else { XCTFail(); return }
        XCTAssertEqual(viewItem.id, 1)
        XCTAssertEqual(viewItem.vehicle.name, "Vehicle 1")
        XCTAssertEqual(viewItem.job.name, "Job1")
        XCTAssertEqual(viewItem.vehicle.user.email, "user1@gmail.com")
    }
}
