//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import UIKit
import Combine
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var signupText: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var passwordVisible = false
   
    private var viewModel = LoginViewModel(authManager: AuthenticationManager.shared,newtworkService: NetworkService.shared,localDatabase: LocalDataSource.shared )
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden=true
       bindViewModel()
    setupPasswordField(passwordTextField)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signupTextTapped))
                signupText.isUserInteractionEnabled = true
                signupText.addGestureRecognizer(tapGesture)
    }
    private func bindViewModel() {
            viewModel.$isLoading
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isLoading in
                    if isLoading {
                        self?.activityIndicator.isHidden = false
                        self?.activityIndicator.startAnimating()
                    } else {
                        self?.activityIndicator.isHidden = true
                        self?.activityIndicator.stopAnimating()
                    }
                }
                .store(in: &cancellables)
        viewModel.$successful
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSuccessful in
                if isSuccessful {
                    let storyboard2 = UIStoryboard(name: "Israa", bundle: nil)
                    let homeViewController =
                            storyboard2.instantiateViewController(identifier: "HomeViewController") as! UINavigationController
                    homeViewController.modalPresentationStyle = .fullScreen
                    homeViewController.modalTransitionStyle = .flipHorizontal
                    self?.present(homeViewController, animated: true)
                    self?.navigationController?.viewControllers = []
                } 
            }
            .store(in: &cancellables)
            viewModel.$errorMessage
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] errorMessage in
                    self?.showAlert(message: errorMessage)
                }
                .store(in: &cancellables)
        }
    
    @IBAction func login(_ sender: Any) {
        guard isValidEmail(emailTextField.text ?? "") else {
                    showAlert(message: "Please enter a valid email address.")
                    return
                }
        guard isValidPassword(passwordTextField.text ?? "") else {
                    showAlert(message: "Password must be at least 8 characters long.")
                    return
                }
        let customer = CustomerCredentials(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        viewModel.login(customer: customer)
        
    }
    
    
    private func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
        
    private func isValidPassword(_ password: String) -> Bool {
            return password.count >= 8
        }
    
    private func showAlert(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    @objc func signupTextTapped() {
           if let signupVC = storyboard?.instantiateViewController(withIdentifier: "signupVC") as? SignupViewController {
               navigationController?.pushViewController(signupVC, animated: true)
           }
       }
    private func setupPasswordField(_ textField: UITextField) {
            textField.isSecureTextEntry = true
            let button = UIButton(type: .custom)
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "eye")
            config.baseForegroundColor = .systemGray
            config.imagePadding = 8
            button.configuration = config
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            textField.rightView = button
            textField.rightViewMode = .always
        }

        @objc private func togglePasswordVisibility(_ sender: UIButton) {
            passwordVisible.toggle()
            passwordTextField.isSecureTextEntry = !passwordVisible
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: passwordVisible ? "eye.slash" : "eye")
            config.baseForegroundColor = passwordVisible ? UIColor.systemBlue.withAlphaComponent(0.7) : .systemGray
            config.imagePadding = 8
            sender.configuration = config
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
}
