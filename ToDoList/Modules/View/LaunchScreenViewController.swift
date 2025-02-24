
import UIKit

protocol LaunchScreenProtocols: AnyObject {
    var presenter: LaunchScreenPresenterProtocols? { get set }
    func animateLaunchScreen()
}

final class LaunchScreenViewController: UIViewController, LaunchScreenProtocols {

        //MARK: Properties
    var presenter: LaunchScreenPresenterProtocols?

        //MARK: - Private Properties
    private let launchAnimationDuration: TimeInterval = 3.1
    private let transitionDelay: TimeInterval = 3

        //MARK: - Private UI Components
    private let launchScreenImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.launchScreen
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

        //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

        //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .darkBackground
        view.addSubview(launchScreenImage)
        setupConstraints()
        animateLaunchScreen()
    }

        //MARK: - Animation Methods
    func animateLaunchScreen() {
        launchScreenImage.alpha = 0.0
        launchScreenImage.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

        animateIn { [weak self] in
            guard let self else { return }
            self.animateOut {
                self.transition()
            }
        }
    }


}

    //MARK: - Private Methods
private extension LaunchScreenViewController {

    func setupConstraints() {
        NSLayoutConstraint.activate([
            launchScreenImage.topAnchor.constraint(equalTo: view.topAnchor),
            launchScreenImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            launchScreenImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchScreenImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func animateIn(completion: @escaping () -> Void) {
        UIView.animate(withDuration: launchAnimationDuration, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1) { [weak self] in
            guard let self = self else { return }
            self.launchScreenImage.alpha = 1.0
            self.launchScreenImage.transform = CGAffineTransform.identity
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.transitionDelay) {
                completion()
            }
        }
    }

    func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.launchScreenImage.transform = CGAffineTransform(scaleX: 4, y: 4)
            self.launchScreenImage.alpha = 0.0
        } completion: { _ in
            completion()
        }
    }

        //MARK: - Transition Methods
    func transition() {
        UIView.transition(with: self.view.window ?? UIWindow(), duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.presenter?.showTaskListView()
        }, completion: nil)
    }






}
