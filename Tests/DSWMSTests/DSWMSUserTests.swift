import XCTest
@testable import DSWMS
import DSAuth
import FluentMySQL

struct UserForm: WMSCreateUserFormRepresentable, WMSUpdateUserFormRepresentable {
    var userCreateFormEmail: String {
        return email
    }

    var userUpdateFormId: Int {
        return id!
    }

    var userUpdateFormEmail: String {
        return email
    }

    var id: Int?
    var email: String
}

final class DSWMSUserTests: WMSTestCase {

    var sut: DSWMS!

    override func setUp() {
        super.setUp()
        sut = DSWMS()
    }

    func testGetAllUsers_ShouldGetCorrectly() throws {
        let _ = try WMSUserRow(id: nil, email: "u1@gmail.com").save(on: conn).wait()
        let _ = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let users = try sut.getAllUsers(on: conn).wait()
        XCTAssertEqual(users[0].email, "u1@gmail.com")
        XCTAssertEqual(users[1].email, "u2@gmail.com")
    }

    func testGetUserById_ShouldGetCorrectly() throws {
        let _ = try WMSUserRow(id: nil, email: "u1@gmail.com").save(on: conn).wait()
        let user2 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let user = try sut.getUser(id: try user2.requireID(), on: conn).wait()
        XCTAssertEqual(user.email, "u2@gmail.com")
    }

    func testGetUserByFilter_ShouldGetCorrectly() throws {
        let _ = try WMSUserRow(id: nil, email: "u1@gmail.com").save(on: conn).wait()
        let user2 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let users = try sut.getUsers(queryString: "u1", on: conn).wait()
        XCTAssertEqual(users.count, 1)
    }

    func testGetUserByFilter_2_ShouldGetCorrectly() throws {
        let _ = try WMSUserRow(id: nil, email: "u1@gmail.com").save(on: conn).wait()
        let user2 = try WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn).wait()
        let users = try sut.getUsers(queryString: "u1", on: conn).wait()
        XCTAssertEqual(users.count, 1)
    }

    func testCreateUser_ShouldCreateCorrectly() throws {
        let form = UserForm(id: nil, email: "u@e.com")
        let _ = try sut.createUser(user: form, on: conn).wait()
        let users = try sut.getAllUsers(on: conn).wait()
        XCTAssertEqual(users[0].email, "u@e.com")
    }

    func testUpdateUser_ShouldCreateCorrectly() throws {
        let form = UserForm(id: nil, email: "u@e.com")
        let newUser = try sut.createUser(user: form, on: conn).wait()
        let update = UserForm(id: newUser.id, email: "newu@e.com")
        let _ = try sut.updateUser(user: update, on: conn).wait()
        let users = try sut.getAllUsers(on: conn).wait()
        XCTAssertEqual(users[0].email, "newu@e.com")
    }

    func testDeleteUser_ShouldDeleteCorrectly() throws {
        let form = UserForm(id: nil, email: "u@e.com")
        let newUser = try sut.createUser(user: form, on: conn).wait()
        let _ = try sut.deleteUser(id: newUser.id, on: conn).wait()
        let users = try sut.getAllUsers(on: conn).wait()
        XCTAssertEqual(users.count, 0)
    }
}
