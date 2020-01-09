import XCTest
@testable import DSWMS
import DSAuth
import FluentMySQL

final class DSWMSUserTests: WMSTestCase {

    var sut: DSWMS!

    override func setUp() {
        super.setUp()
        sut = DSWMS()
    }

    func testGetAllUsers_ShouldGetCorrectly() throws {
        let _ = try WMSUserRow(id: nil, email: "u1@gmail.com").save(on: conn).wait()
        let _ = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let users = try WMSUser.getAll(on: conn).wait()
        XCTAssertEqual(users[0].email, "u1@gmail.com")
        XCTAssertEqual(users[1].email, "u2@gmail.com")
    }

    func testGetUserById_ShouldGetCorrectly() throws {
        let _ = try WMSUserRow(id: nil, email: "u1@gmail.com").save(on: conn).wait()
        let user2 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let user = try WMSUser.get(id: try user2.requireID(), on: conn).wait()
        XCTAssertEqual(user.email, "u2@gmail.com")
    }

    func testGetUserByFilter_ShouldGetCorrectly() throws {
        let _ = try WMSUserRow(id: nil, email: "u1@gmail.com").save(on: conn).wait()
        let user2 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let users = try WMSUser.getAll(queryString: "u1", on: conn).wait()
        XCTAssertEqual(users.count, 1)
    }

    func testGetUserByFilter_2_ShouldGetCorrectly() throws {
        let _ = try WMSUserRow(id: nil, email: "u1@gmail.com").save(on: conn).wait()
        let user2 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let users = try WMSUser.getAll(queryString: "u1", on: conn).wait()
        XCTAssertEqual(users.count, 1)
    }

    func testCreateUser_ShouldCreateCorrectly() throws {
        let form: WMSUser.Post = .init(email: "u@e.com")
        _ = try form.create(on: conn).wait()
        let users = try WMSUser.getAll(on: conn).wait()
        XCTAssertEqual(users[0].email, "u@e.com")
    }

    func testUpdateUser_ShouldCreateCorrectly() throws {
        let form = WMSUser.Post(email: "u@e.com")
        let newUser = try form.create(on: conn).wait()
        let update = WMSUser.Put(id: newUser.id, email: "newu@e.com")
        let _ = try update.update(on: conn).wait()
        let users = try WMSUser.getAll(on: conn).wait()
        XCTAssertEqual(users[0].email, "newu@e.com")
    }

    func testDeleteUser_ShouldDeleteCorrectly() throws {
        let form = WMSUser.Post(email: "u@e.com")
        let newUser = try form.create(on: conn).wait()
        let delete = WMSUser.Delete(id: newUser.id)
        let _ = try delete.delete(on: conn).wait()
        let users = try WMSUser.getAll(on: conn).wait()
        XCTAssertEqual(users.count, 0)
    }
}
