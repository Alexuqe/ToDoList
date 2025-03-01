import XCTest
@testable import ToDoList

final class DetailViewTests: XCTestCase {
    var sut: DetailViewController!
    var mockPresenter: MockDetailViewPresenter!

    override func setUp() {
        super.setUp()
        sut = DetailViewController()
        mockPresenter = MockDetailViewPresenter()
        sut.presenter = mockPresenter
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        super.tearDown()
    }

    // MARK: - Initial Setup Tests
    func testInitialSetup() {
        // Then
        XCTAssertNotNil(sut.view)
        XCTAssertEqual(sut.view.backgroundColor, .darkBackground)
        XCTAssertNotNil(sut.presenter)

        // Check UI Components
        XCTAssertNotNil(sut.titleTask)
        XCTAssertFalse(sut.navigationItem.rightBarButtonItem?.isEnabled ?? true)
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.title, "Сохранить")
    }

    // MARK: - UI Components Tests
    func testTitleTaskConfiguration() {
        // Then
        let expectedFont = UIFont.systemFont(ofSize: 30, weight: .bold)
        XCTAssertEqual(sut.titleTask.font, expectedFont)
        XCTAssertEqual(sut.titleTask.textColor, UIColor.white)
        XCTAssertEqual(sut.titleTask.accessibilityIdentifier, "titleTextField")

        let placeholder = sut.titleTask.attributedPlaceholder?.string
        XCTAssertEqual(placeholder, "Введите заголовок")
    }

    // MARK: - Navigation Setup Tests
    func testNavigationConfiguration() {
        // Then
        XCTAssertFalse(sut.navigationController?.navigationBar.prefersLargeTitles ?? true)
        XCTAssertEqual(sut.navigationController?.navigationBar.tintColor, UIColor.goldCheckmark)

        let saveButton = sut.navigationItem.rightBarButtonItem
        XCTAssertEqual(saveButton?.title, "Сохранить")
        XCTAssertEqual(saveButton?.style, .done)
    }

    // MARK: - Protocol Implementation Tests
    func testDisplayTaskTitle() {
        // Given
        let testTitle = "Test Task"

        // When
        sut.displayTaskTitle(title: testTitle)

        // Then
        XCTAssertEqual(sut.titleTask.text, testTitle)
    }

    // MARK: - User Interaction Tests
    func testTitleTaskEditing() {
        // Given
        sut.titleTask.text = "New Title"

        // When
        sut.titleTask.sendActions(for: .editingChanged)

        // Then
        XCTAssertTrue(mockPresenter.textFieldDidChangeCalled)
        XCTAssertEqual(mockPresenter.capturedTitle, "New Title")
    }

    func testEnableSaveButton() {
        // When
        sut.enableSaveButton(true)
        XCTAssertTrue(sut.navigationItem.rightBarButtonItem?.isEnabled ?? false)

        sut.enableSaveButton(false)
        XCTAssertFalse(sut.navigationItem.rightBarButtonItem?.isEnabled ?? true)
    }

    // MARK: - Touch Handling Tests
    func testTouchesBeganEndsEditing() {
        // Given
        sut.titleTask.becomeFirstResponder()
        XCTAssertTrue(sut.titleTask.isFirstResponder)

        // When
        sut.touchesBegan(Set<UITouch>(), with: nil)

        // Then
        XCTAssertFalse(sut.titleTask.isFirstResponder)
    }
}

// End of file. No additional code.
