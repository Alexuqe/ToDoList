//
//  
//
//
//
//

protocol DetailViewControllerProtocol: AnyObject {
    var presenter: DetailViewPresenterProtocol? { get set }

    func displayTaskTitle(title: String)
    func displayTaskDetail(detail: String)
    func displayDate(date: String)
    func enableSaveButton(_ enabled: Bool)
}
