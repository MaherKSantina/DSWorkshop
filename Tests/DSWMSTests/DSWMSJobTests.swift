import XCTest
@testable import DSWMS
import DSAuth
import FluentMySQL

struct JobForm: WMSCreateJobFormRepresentable, WMSUpdateJobFormRepresentable {
    var jobCreateFormName: String {
        return name
    }

    var jobUpdateFormId: Int {
        return id!
    }

    var jobUpdateFormName: String {
        return name
    }

    var id: Int?
    var name: String
}

final class DSWMSJobTests: WMSTestCase {

    var sut: DSWMS!

    override func setUp() {
        super.setUp()
        sut = DSWMS()
    }

    func testGetAllJobs_ShouldGetCorrectly() throws {
        let _ = try WMSJobRow(id: nil, name: "job1").save(on: conn).wait()
        let _ = try WMSJobRow(id: nil, name: "job2").save(on: conn).wait()
        let jobs = try WMSJob.getAll(on: conn).wait()
        XCTAssertEqual(jobs[0].name, "job1")
        XCTAssertEqual(jobs[1].name, "job2")
    }

    func testGetJobById_ShouldGetCorrectly() throws {
        let _ = try WMSJobRow(id: nil, name: "job1").save(on: conn).wait()
        let job2 = try WMSJobRow(id: nil, name: "job2").save(on: conn).wait()
        let job = try WMSJob.get(id: try job2.requireID(), on: conn).wait()
        XCTAssertEqual(job.name, "job2")
    }

    func testGetJobByFilter_ShouldGetCorrectly() throws {
        let _ = try WMSJobRow(id: nil, name: "job1").save(on: conn).wait()
        let job2 = try WMSJobRow(id: nil, name: "job2").save(on: conn).wait()
        let jobs = try WMSJob.getAll(queryString: "1", on: conn).wait()
        XCTAssertEqual(jobs.count, 1)
    }

    func testGetJobByFilter_2_ShouldGetCorrectly() throws {
        let _ = try WMSJobRow(id: nil, name: "job1").save(on: conn).wait()
        let job2 = try WMSJobRow(id: nil, name: "job2").save(on: conn).wait()
        let jobs = try WMSJob.getAll(queryString: "1", on: conn).wait()
        XCTAssertEqual(jobs.count, 1)
    }

    func testCreateJob_ShouldCreateCorrectly() throws {
        let form = WMSJob.Post(name: "job1")
        let _ = try form.create(on: conn).wait()
        let jobs = try WMSJob.getAll(on: conn).wait()
        XCTAssertEqual(jobs[0].name, "job1")
    }

    func testUpdateJob_ShouldCreateCorrectly() throws {
        let form = WMSJobRow(id: nil, name: "job1")
        let newJob = try form.create(on: conn).wait()
        let update = WMSJob(id: try! newJob.requireID(), name: "jobnew1")
        let _ = try update.update(on: conn).wait()
        let jobs = try WMSJob.getAll(on: conn).wait()
        XCTAssertEqual(jobs[0].name, "jobnew1")
    }

    func testDeleteJob_ShouldDeleteCorrectly() throws {
        let form = WMSJobRow(id: nil, name: "job1")
        let newJob = try form.create(on: conn).wait()
        let delete = WMSJob(id: try! newJob.requireID(), name: "")
        _ = try delete.delete(on: conn).wait()
        let jobs = try WMSJob.getAll(on: conn).wait()
        XCTAssertEqual(jobs.count, 0)
    }
}
