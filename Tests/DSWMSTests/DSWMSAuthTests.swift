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
