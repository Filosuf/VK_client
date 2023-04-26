//
//  ContactsTests.swift
//  ClientVkTests
//
//  Created by Filosuf on 26.04.2023.
//

import XCTest
@testable import ClientVk

class ContactsTests: XCTestCase {

    var presenter: ContactsViewPresenter?

    override func setUpWithError() throws {
        let friendsService = FriendsService()
        let contactService = ContactsService()
        let tokenStorage = TokenStoragePlug()
        let controllersFactory = ViewControllersFactory(tokenStorage: tokenStorage)
        let coordinator = ContactsFlowCoordinator(navCon: UINavigationController(), controllersFactory: controllersFactory)
        presenter = ContactsViewPresenter(coordinator: coordinator,
                                          friendsService: friendsService,
                                          contactsService: contactService,
                                          tokenStorage: tokenStorage)
    }

    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = ContactsViewPresenterSpy()
        let viewController = ContactsViewController(presenter: presenter)

        //when
        viewController.beginAppearanceTransition(true, animated: false)

        //then
        XCTAssertTrue(presenter.viewWillAppearCalled) //behaviour verification
    }

    func testPresenterCallsUpdateView() {
        //given
        let viewController = ContactsViewControllerSpy()
        presenter?.view = viewController

        //when
        presenter?.contacts = []

        //then
        XCTAssertTrue(viewController.viewUpdated) //behaviour verification
    }

}

final class ContactsViewPresenterSpy: ContactsViewPresenterProtocol {
    // MARK: - Properties
    var friends: [Profile] = []
    var contacts: [Contact] = []

    var viewWillAppearCalled = false

    //MARK: - Methods
    func viewWillAppear() {
        viewWillAppearCalled = true
    }

    func fetchContact(index: IndexPath) -> Contact? { return nil }

    func didSelectRow(index: IndexPath) { }
}

final class ContactsViewControllerSpy: UIViewController, ContactsViewControllerProtocol {
    // MARK: - Properties
    var viewUpdated = false

    //MARK: - Methods
    func updateView() {
        viewUpdated = true
    }
}
