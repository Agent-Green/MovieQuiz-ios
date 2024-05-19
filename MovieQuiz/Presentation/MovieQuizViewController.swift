import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    
    @IBOutlet private weak var indexLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet weak var imageUI: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter : MovieQuizPresenter!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        presenter = MovieQuizPresenter(viewController: self)
        
        showLoadingIndicator()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageUI.layer.borderColor = UIColor.clear.cgColor
        imageUI.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
    }

    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()

        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)

            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }

                self.presenter.restartGame()
            }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageUI.layer.masksToBounds = true
        imageUI.layer.borderWidth = 8
        imageUI.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать ещё раз",
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
    }
}
