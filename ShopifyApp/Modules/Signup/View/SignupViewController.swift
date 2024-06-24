//
//  SignupViewController.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import UIKit
import Combine
class SignupViewController: UIViewController {

    
    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet weak var firstNameTextField: UITextField!
        
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var customer:CustomerData?
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: SignupScreenViewModel = SignupScreenViewModel(authManager: AuthenticationManager.shared,networkService: NetworkService.shared)
   private var passwordVisible = false
   private var confirmPasswordVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden=true
        setupPasswordField(passwordTextField)
        setupConfirmPasswordField(confirmPasswordTextField)
        bindViewModel()
        // Do any additional setup after loading the view.
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
        viewModel.$isSuccessful
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSuccessful in
                if isSuccessful {
                    self?.showAlertWithAction()
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
        viewModel.bindSuccessToViewController = {
            [weak self] createdCustomer in
            self?.customer?.id = createdCustomer.id
            self?.viewModel.signup(customer: (self?.customer)!)
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        
        guard isValidUsername(firstNameTextField.text ?? "") else {
                  showAlert(message: "First name must be at least 3 characters long.")
                  return
              }
        guard isValidUsername(lastNameTextField.text ?? "") else {
                  showAlert(message: "Last name must be at least 3 characters long.")
                  return
              }
        guard isValidEmail(emailTextField.text ?? "") else {
                    showAlert(message: "Please enter a valid email address.")
                    return
                }
        guard isValidPhone(phoneTextField.text ?? "") else {
                   showAlert(message: "Phone number must be 11 digits long and start with 012, 011, 010, or 015.")
                   return
               }
        guard isValidPassword(passwordTextField.text ?? "") else {
                    showAlert(message: "Password must be at least 8 characters long.")
                    return
                }
        guard passwordTextField.text == confirmPasswordTextField.text else {
                    showAlert(message: "Passwords do not match.")
                    return
                }
         customer = CustomerData(id:nil,userId: "", firstName:firstNameTextField.text ?? "",lastName: lastNameTextField.text ?? "" ,phone:phoneTextField.text ?? "",email: emailTextField.text ?? "", password:passwordTextField.text ?? ""  )
        viewModel.createShopifyCustomer(customer: customer!)
    }
    
    
    private func isValidUsername(_ username: String) -> Bool {
           return username.count >= 3
       }

    
    private func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    
    private func isValidPhone(_ phone: String) -> Bool {
          let phoneRegex = "^(012|011|010|015)[0-9]{8}$"
          let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
          return phonePredicate.evaluate(with: phone)
      }
    private func isValidPassword(_ password: String) -> Bool {
            return password.count >= 8
        }
    
    
    private func showAlert(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    func showAlertWithAction() {
          let alert = UIAlertController(title: "Verification", message: "We have sent you a verification email!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                  self?.navigationController?.popViewController(animated: true)
          }
          alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
    private func setupConfirmPasswordField(_ textField: UITextField) {
            textField.isSecureTextEntry = true
            let button = UIButton(type: .custom)
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "eye")
            config.baseForegroundColor = .systemGray
            config.imagePadding = 8
            button.configuration = config
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.addTarget(self, action: #selector(toggleConfirmPasswordVisibility(_:)), for: .touchUpInside)
            textField.rightView = button
            textField.rightViewMode = .always
        }

        @objc private func toggleConfirmPasswordVisibility(_ sender: UIButton) {
            confirmPasswordVisible.toggle()
            confirmPasswordTextField.isSecureTextEntry = !confirmPasswordVisible
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: confirmPasswordVisible ? "eye.slash" : "eye")
            config.baseForegroundColor = confirmPasswordVisible ? UIColor.systemBlue.withAlphaComponent(0.7) : .systemGray
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
