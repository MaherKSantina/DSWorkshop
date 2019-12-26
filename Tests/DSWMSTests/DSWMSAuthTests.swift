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

final class DSWMSAuthTests: WMSTestCase {

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
        let _ = try sut.login(user: UserLogin(email: "user1@gmail.com", password: "asdfgh"), on: conn).wait()
    }

    func testLogin_UserDoesntExist_ShouldShowError() throws {
        do {
            let _ = try sut.login(user: UserLogin(email: "user1@gmail.com", password: "asdfgh"), on: conn).wait()
            XCTFail()
        }
        catch {
//            XCTAssertEqual(error, )
        }

    }

    func testRegister_NewUser_ShouldRegisterProperly() throws {
        let _ = try sut.register(user: UserLogin(email: "maher.santina90@gmail.com", password: "123456"), on: conn).wait()
        let _ = try sut.login(user: UserLogin(email: "maher.santina90@gmail.com", password: "123456"), on: conn).wait()
    }

    func testRegister_ExistingUser_NewLogin_ShouldRegisterProperly() throws {
        let org = try OrganizationRow(id: nil, name: "Org 1").save(on: conn).wait()
        let _ = try UserRow(id: nil, email: "maher.santina90@gmail.com").save(on: conn).wait()
        let newUser = UserRow.Register(email: "maher.santina90@gmail.com", password: "123123", organizationID: try org.requireID())
        let _ = try DSAuthMain.register(user: newUser, on: conn).wait()
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
        let _ = try DSAuthMain.register(user: newUser, on: conn).wait()
        }
        catch {
            let e = error as! MySQLError
            XCTAssertEqual(e.identifier, "server (1062)")
        }
    }

    func testConvertAccessDto_ShouldConvertProperly() throws {
        // TODO: Implement
    }
}
