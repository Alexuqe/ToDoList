//
//  DetailViewTests.swift
//  ToDoList
//
//  Created by Sasha on 23.02.25.
//

import XCTest
@testable import ToDoList

class DetailViewControllerTests: XCTestCase {
    var sut: DetailViewController!
    var mockPresenter: MockDetailPresenter!

    override func setUp() {
        super.setUp()
        sut = DetailViewController()
        mockPresenter = MockDetailPresenter()
        sut.presenter = mockPresenter
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        super.tearDown()
    }

    func testViewDidLoad_CallsPresenterViewDidLoad() {
        // Act
        sut.viewDidLoad()

        // Assert
        XCTAssertTrue(mockPresenter.viewDidLoadCalled, "viewDidLoad should call presenter's viewDidLoad")
    }

    func testDisplayTaskTitle_SetsTitleOnView() {
        // Arrange
        let title = "Test Title"

        // Act
        sut.displayTaskTitle(title: title)

        // Assert
        XCTAssertEqual(sut.titleTask.text, title, "displayTaskTitle should set the title on the view")
    }
}

class MockDetailPresenter: DetailViewPresenterProtocol {
    var viewDidLoadCalled = false

    var view: DetailViewControllerProtocol?
    var interactor: DetailViewInteractorProtocol?
    var router: DetailViewRouterProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func saveButtonTapped(title: String, details: String) {}
    func textFieldDidChange(title: String?, details: String?) {}
    func configure(with task: TasksList) {}
    func dismiss() {}
}
