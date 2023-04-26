//
//  ContactDetailsTests.swift
//  ClientVkTests
//
//  Created by Filosuf on 26.04.2023.
//

import XCTest
@testable import ClientVk

class ContactDetailsTests: XCTestCase {

    var presenter: ContactDetailsViewPresenter?

    override func setUpWithError() throws {
        let contactService = ContactsService()
        let tokenStorage = TokenStoragePlug()
        let controllersFactory = ViewControllersFactory(tokenStorage: tokenStorage)
        let coordinator = ContactsFlowCoordinator(navCon: UINavigationController(), controllersFactory: controllersFactory)
        presenter = ContactDetailsViewPresenter(coordinator: coordinator, contactService: contactService, friend: nil, contact: nil)
    }

    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = ContactDetailsViewPresenterSpy()
        let viewController = ContactDetailsViewController(presenter: presenter)

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }

    func testPresenterCallsSetupView() {
        //given
        let viewController = ContactDetailsViewControllerSpy()
        presenter?.view = viewController

        //when
        presenter?.viewDidLoad()

        //then
        XCTAssertTrue(viewController.viewIsSet) //behaviour verification
    }

}

final class ContactDetailsViewPresenterSpy: ContactDetailsViewPresenterProtocol {
    // MARK: - Properties
    var viewDidLoadCalled = false

    //MARK: - Methods
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func updatePhoto() { }

    func didSelectContact(_ contact: Contact) { }
}

final class ContactDetailsViewControllerSpy: UIViewController, ContactDetailsViewControllerProtocol {

    // MARK: - Properties
    var presenter: WebViewPresenterProtocol?

    var viewIsSet = false

    //MARK: - Methods
    func setupView(iPhone: Contact?, vkontakte: Profile?) {
        viewIsSet = true
    }
}


