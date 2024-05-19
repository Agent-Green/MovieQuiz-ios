import UIKit

final class MovieQuizViewController: UIViewController {
    
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
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        
        indexLabel.text = step.questionNumber
        imageUI.image = step.image
        questionLabel.text = step.question
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageUI.layer.masksToBounds = true
        imageUI.layer.borderWidth = 8
        imageUI.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    
    func showLoadingIndicator(){
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String){
        
        hideLoadingIndicator()
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: {[weak self] in
                guard let self = self else {return}
                
                self.presenter.restartGame()
                
            })
        presenter.alertPresenter?.showAlert(model: alertModel)
        
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
}

