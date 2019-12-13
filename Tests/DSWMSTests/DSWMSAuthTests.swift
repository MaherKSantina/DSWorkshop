import XCTest
@testable import DSWMS
import DSAuth
import FluentMySQL

struct UserLogin: WMSLoginFormRepresentable, WMSRegisterFromRepresentable {

    var email: String
    var password: String

    var loginEmail: String {
        return email
    }

    var loginPassword: String {
        return password
    }

    var registerEmail: String {
        return email
    }

    var registerPassword: String {
        return password
    }
}

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

final class DSWMSTests: WMSTestCase {

    var sut: DSWMS!

    override func setUp() {
        super.setUp()
        sut = DSWMS()
    }

    func addLogin(login: UserLogin = UserLogin(email: "user1@gmail.com", password: "asdfgh")) throws {
        let user1 = try UserRow(id: nil, email: login.email).save(on: conn).wait()
        let _ = try LoginRow(id: nil, userID: try user1.requireID(), password: login.password, organizationID: nil, roleID: RoleRowValue.Admin.index!).save(on: conn).wait()
    }

    func testLogin_ExistingUser_ShouldLoginProperly() throws {
        try addLogin()
        let _ = try sut.login(user: UserLogin(email: "user1@gmail.com", password: "asdfgh"), on: app).wait()
    }

    func testLogin_UserDoesntExist_ShouldShowError() throws {
        do {
            let _ = try sut.login(user: UserLogin(email: "user1@gmail.com", password: "asdfgh"), on: app).wait()
            XCTFail()
        }
        catch {
//            XCTAssertEqual(error, )
        }

    }

    func testRegister_NewUser_ShouldRegisterProperly() throws {
        let _ = try sut.register(user: UserLogin(email: "maher.santina90@gmail.com", password: "123456"), on: conn, container: app).wait()
        let _ = try sut.login(user: UserLogin(email: "maher.santina90@gmail.com", password: "123456"), on: app).wait()
    }

    func testRegister_ExistingUser_NewLogin_ShouldRegisterProperly() throws {
        let org = try OrganizationRow(id: nil, name: "Org 1").save(on: conn).wait()
        let _ = try UserRow(id: nil, email: "maher.santina90@gmail.com").save(on: conn).wait()
        let newUser = UserRow.Register(email: "maher.santina90@gmail.com", password: "123123", organizationID: try org.requireID())
        let _ = try DSAuthMain.register(user: newUser, on: conn, container: app).wait()
        let users = try UserRow.query(on: conn).all().wait()
        XCTAssertEqual(users.count, 1)
        let logins = try LoginRow.query(on: conn).all().wait()
        XCTAssertEqual(logins.count, 1)
    }

    func testRegister_ExistingUser_ExistingLogin_ShouldShowError() throws {
        do {
        let org = try OrganizationRow(id: nil, name: "Org 1").save(on: conn).wait()
        let user = try UserRow(id: nil, email: "maher.santina90@gmail.com").save(on: conn).wait()
        let _ = try LoginRow(id: nil, userID: try user.requireID(), password: "123123", organizationID: try org.requireID(), roleID: 1).save(on: conn).wait()

        let newUser = UserRow.Register(email: "maher.santina90@gmail.com", password: "123123", organizationID: try org.requireID())
        let _ = try DSAuthMain.register(user: newUser, on: conn, container: app).wait()
        }
        catch {
            let e = error as! MySQLError
            XCTAssertEqual(e.identifier, "server (1062)")
        }
    }

    func testConvertAccessDto_ShouldConvertProperly() throws {
        // TODO: Implement
    }

    func testGetAllUsers_ShouldGetCorrectly() throws {
        let _ = WMSUserRow(id: nil, email: "u1@gmail.com").save(on: conn)
        let _ = WMSUserRow(id: nil, email: "u2@gmail.com").save(on: conn)
        let users = try sut.getAllUsers(on: conn).wait()
        XCTAssertEqual(users[0].userEmail, "u1@gmail.com")
        XCTAssertEqual(users[1].userEmail, "u2@gmail.com")
    }

    func testCreateUser_ShouldCreateCorrectly() throws {
        let form = UserForm(id: nil, email: "u@e.com")
        let _ = try sut.createUser(user: form, on: conn).wait()
        let users = try sut.getAllUsers(on: conn).wait()
        XCTAssertEqual(users[0].userEmail, "u@e.com")
    }

    func testUpdateUser_ShouldCreateCorrectly() throws {
        let form = UserForm(id: nil, email: "u@e.com")
        let newUser = try sut.createUser(user: form, on: conn).wait()
        let update = UserForm(id: newUser.userId, email: "newu@e.com")
        let _ = try sut.updateUser(user: update, on: conn).wait()
        let users = try sut.getAllUsers(on: conn).wait()
        XCTAssertEqual(users[0].userEmail, "newu@e.com")
    }

    func testDeleteUser_ShouldDeleteCorrectly() throws {
        let form = UserForm(id: nil, email: "u@e.com")
        let newUser = try sut.createUser(user: form, on: conn).wait()
        let _ = try sut.deleteUser(id: newUser.userId, on: conn)
        let users = try sut.getAllUsers(on: conn).wait()
        XCTAssertEqual(users.count, 0)
    }
}
