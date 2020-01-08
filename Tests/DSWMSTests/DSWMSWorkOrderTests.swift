import XCTest
@testable import DSWMS
import DSAuth
import FluentMySQL

final class DSWMSWorkOrderTests: WMSTestCase {

    var sut: DSWMS!

    var job1: WMSJobRow!
    var job2: WMSJobRow!

    var vehicle1: WMSVehicleRow!
    var vehicle2: WMSVehicleRow!
    var vehicle3: WMSVehicleRow!

    var user1: WMSUserRow!
    var user2: WMSUserRow!

    override func setUp() {
        super.setUp()
        sut = DSWMS()

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
        let all = try sut.getAllWorkOrders(on: conn).wait()
        XCTAssertEqual(all.count, 1)
    }

    func testGetWorkOrderById_ShouldGetCorrectly() throws {
        let _ = try WMSWorkOrderRow(id: nil, jobID: job1.id!, vehicleID: vehicle1.id!, notes: "asd", date: Date()).save(on: conn).wait()
        let _ = try WMSWorkOrderRow(id: nil, jobID: job2.id!, vehicleID: vehicle3.id!, notes: "note2", date: Date()).save(on: conn).wait()
        let one = try sut.getWorkOrder(id: 2, on: conn).wait()
        XCTAssertEqual(one.jobID, 2)
        XCTAssertEqual(one.vehicleID, 3)
        XCTAssertEqual(one.notes, "note2")
    }

    func testCreateWorkOrder_ShouldCreateCorrectly() throws {
        let row = WMSWorkOrderRow(id: nil, jobID: 2, vehicleID: 1, notes: "notes1", date: Date())
        let _ = try sut.createWorkOrder(workOrder: row, on: conn).wait()
        let workOrders = try sut.getAllWorkOrders(on: conn).wait()
        XCTAssertEqual(workOrders[0].jobID, 2)
        XCTAssertEqual(workOrders[0].vehicleID, 1)
        XCTAssertEqual(workOrders[0].notes, "notes1")
    }

    func testUpdateUser_ShouldCreateCorrectly() throws {
        let row = try WMSWorkOrderRow(id: nil, jobID: 2, vehicleID: 1, notes: "notes1", date: Date()).save(on: conn).wait()
        let _ = try sut.createWorkOrder(workOrder: row, on: conn).wait()
        let update = WMSWorkOrderRow(id: 1, jobID: 1, vehicleID: 2, notes: "notes1", date: Date())
        let _ = try sut.updateWorkOrder(workOrder: update, on: conn).wait()
        let workOrders = try sut.getAllWorkOrders(on: conn).wait()
        XCTAssertEqual(workOrders[0].jobID, 1)
        XCTAssertEqual(workOrders[0].vehicleID, 2)
        XCTAssertEqual(workOrders[0].notes, "notes1")
    }

    func testDeleteUser_ShouldDeleteCorrectly() throws {
        let row = try WMSWorkOrderRow(id: nil, jobID: 2, vehicleID: 1, notes: "notes1", date: Date()).save(on: conn).wait()
        let _ = try sut.deleteWorkOrder(id: row.id!, on: conn).wait()
        let users = try sut.getAllWorkOrders(on: conn).wait()
        XCTAssertEqual(users.count, 0)
    }
}
