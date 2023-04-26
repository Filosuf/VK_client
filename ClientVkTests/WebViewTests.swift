//
//  WebViewTests.swift
//  ClientVkTests
//
//  Created by Filosuf on 25.04.2023.
//

@testable import ClientVk
import XCTest

final class WebViewTests: XCTestCase {

    var presenter: WebViewPresenter?

    override func setUpWithError() throws {
        let authHelper = AuthHelper()
        let tokenStorage = TokenStorage()
        let controllersFactory = ViewControllersFactory(tokenStorage: tokenStorage)
        let coordinator = AuthFlowCoordinator(navCon: UINavigationController(), controllersFactory: controllersFactory)
        presenter = WebViewPresenter(coordinator: coordinator, helper: authHelper, tokenStorage: tokenStorage)
    }

    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = WebViewPresenterSpy()
        let viewController = WebViewController(presenter: presenter)
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }

    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewControllerSpy()
        presenter?.view = viewController

        //when
        presenter?.viewDidLoad()

        //then
        XCTAssertTrue(viewController.loadCalled) //behaviour verification
    }

    func testProgressVisibleWhenLessThenOne() {
        //given
        let progress: Float = 0.6
        guard let presenter = presenter else {
            return
        }

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressHiddenWhenOne() {
        //given
        let progress: Float = 1
        guard let presenter = presenter else {
            return
        }

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertTrue(shouldHideProgress)
    }

        func testAuthHelperAuthURL() {
            //given
            let configuration = AuthConfiguration.standard
            let authHelper = AuthHelper(configuration: configuration)

            //when
            let request = authHelper.authRequest()
            let urlString = request.url!.absoluteString

            //then
            XCTAssertTrue(urlString.contains(configuration.authURLString))
        }

        func testDecodingTokenFromURL() {
            //given
            let testCode = "123456789"
            let testTime = 86400
            let configuration = AuthConfiguration.standard
            let authHelper = AuthHelper(configuration: configuration)
            let url = URL(string: "https://oauth.vk.com/blank.html#access_token=\(testCode)&expires_in=\(testTime)&user_id=15528973")!
            //when
            let token = authHelper.code(from: url)

            //then
            XCTAssertTrue(testCode == token?.accessToken && testTime == token?.expiresIn)
        }
    }

    final class WebViewPresenterSpy: WebViewPresenterProtocol {

        var viewDidLoadCalled = false
        var view: WebViewControllerProtocol?

        func viewDidLoad() {
            viewDidLoadCalled = true
        }

        func decodingToken(with url: URL) -> Bool {
            return true
        }

        func didUpdateProgressValue(_ newValue: Double) {

        }
    }

    final class WebViewControllerSpy: UIViewController, WebViewControllerProtocol {
        // MARK: - Properties
        var presenter: WebViewPresenterProtocol?

        var loadCalled = false

        //MARK: - Methods
        func load(request: URLRequest) {
            loadCalled = true
        }

        func setProgressValue(_ newValue: Float) { }

        func setProgressHidden(_ isHidden: Bool) { }
    }
