

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    var presenter: DetailViewPresenterProtocol? { get set }

    func displayTaskTitle(title: String)
    func displayTaskDetail(detail: String)
    func displayDate(date: String)
    func enableSaveButton(_ enabled: Bool)
}

final class DetailViewController: UIViewController {

    //MARK: Properties
    var presenter: DetailViewPresenterProtocol?
    var tasks: TasksList?

    private let labelStyle = LabelStyles.shared

    //MARK: - UI Components
    lazy var titleTask: UITextField = {
        let view = UITextField()
        view.font = .systemFont(ofSize: 30, weight: .bold)
        view.textColor = .white
        view.attributedPlaceholder = NSAttributedString(
            string: "Введите заголовок",
            attributes: [.foregroundColor: UIColor.systemGray2])
        view.addTarget(self, action: #selector(titleDidChange), for: .editingChanged)
        view.accessibilityIdentifier = "titleTextField"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var dateLabel: UILabel = labelStyle.dateLabelStyle()

    private lazy var detailTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textAlignment = .left
        view.textColor = .white
        view.backgroundColor = .clear
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "detailTextView"
        return view
    }()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .darkBackground
        presenter?.viewDidLoad()
    }

    //MARK: - Override Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    //MARK: - Actions
    @objc private func titleDidChange() {
        presenter?.textFieldDidChange(title: titleTask.text, details: detailTextView.text)
    }

    @objc private func saveButtonTapped() {
        guard let title = titleTask.text, let details = detailTextView.text else { return }
        presenter?.saveButtonTapped(title: title, details: details)
        navigationController?.popViewController(animated: true)
    }

}

//MARK: - DetailViewControllerProtocol
extension DetailViewController: DetailViewControllerProtocol {

    func displayTaskTitle(title: String) {
        titleTask.text = title
    }
    
    func displayTaskDetail(detail: String) {
        detailTextView.text = detail
    }
    
    func displayDate(date: String) {
        dateLabel.text = date
    }
    
    func enableSaveButton(_ enabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
}

//MARK: - Setup UI
extension DetailViewController {

    func setupUI() {
        setupNavigationController()
        addSubviews(titleTask, dateLabel, detailTextView)
        setupConstraints()
    }

    //MARK: Setup Navigation Controller
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .goldCheckmark

        let saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped))

        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    //MARK: Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTask.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTask.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleTask.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: titleTask.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleTask.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            detailTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            detailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailTextView.trailingAnchor.constraint(equalTo: titleTask.trailingAnchor),
            detailTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    //MARK: UI Helpers
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }

}

//MARK: - UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter?.textFieldDidChange(title: titleTask.text, details: textView.text)
    }
}
