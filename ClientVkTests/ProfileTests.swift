//
//  ProfileTests.swift
//  ClientVkTests
//
//  Created by Filosuf on 26.04.2023.
//

@testable import ClientVk
import XCTest

final class ProfileTests: XCTestCase {

    var presenter: ProfileViewPresenter?

    override func setUpWithError() throws {
        let profileService = ProfileServicePlug()
        let tokenStorage = TokenStoragePlug()
        let controllersFactory = ViewControllersFactory(tokenStorage: tokenStorage)
        let coordinator = ProfileFlowCoordinator(navCon: UINavigationController(), controllersFactory: controllersFactory)
        presenter = ProfileViewPresenter(coordinator: coordinator, profileService: profileService, tokenStorage: tokenStorage)
    }

    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }

    func testPresenterCallsSetupView() {
        //given
        let viewController = ProfileViewControllerSpy()
        presenter?.view = viewController

        //when
        presenter?.viewDidLoad()

        //then
        XCTAssertTrue(viewController.viewIsSet) //behaviour verification
    }

}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    // MARK: - Properties
    var viewDidLoadCalled = false

    //MARK: - Methods
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func logout() { }
}

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {

    // MARK: - Properties
    var presenter: WebViewPresenterProtocol?

    var viewIsSet = false

    //MARK: - Methods
    func setupView(profile: Profile) {
        viewIsSet = true
    }
}

final class TokenStoragePlug: TokenStorageProtocol {
    func saveToken(_ token: ApiToken) { }

    func getToken() -> ApiToken? {
        ApiToken(accessToken: "", expiresIn: 8400)
    }

    func removeToken() { }
}

final class ProfileServicePlug: ProfileServiceProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<[ProfileCodable], Error>) -> Void) {
        let profile = ProfileCodable(id: 1,
                                     photoUrl: "",
                                     firstName: "",
                                     lastName: "",
                                     city: nil,
                                     mobilePhone: nil)
        return completion(.success([profile]))
    }
}
