//
//  ViewController.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 16/04/24.
//

import UIKit

/// View controller for user login.
class LoginVC: UIViewControllerWithSpinner {
    private let authService = AuthService.shared
    private let navManager = NavigationManager.shared

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    /// Removes the observer for language changes when the view controller is deallocated.
    deinit {
        NotificationCenter.default.removeObserver(self, name: AppNotification.RefreshLanguage, object: nil)
    }
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()

        configureForm()
        configureLabels()
        changeLanguageObserver()
    }
    
    /// Observes the language change notification.
    private func changeLanguageObserver(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(configureLabels),
            name: AppNotification.RefreshLanguage,
            object: nil
        )
    }
    
    /// Configures the localized text for UI elements.
    @objc private func configureLabels(){
        emailTF.placeholder = "email".translate()
        passwordTF.placeholder = "password".translate()
        loginBtn.setTitle("login".translate(), for: .normal)
        questionLbl.text = "don't have an account?".translate()
        registerBtn.setTitle("register".translate(), for: .normal)
    }
    
    /// Configures the login form UI elements.
    private func configureForm(){
        loginBtn.isEnabled = false
        passwordTF.isSecureTextEntry = true
        
        emailTF.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(validateFields), for: .editingChanged)
    }
    
    /// Validates the input fields and enables/disables the login button accordingly.
    @objc private func validateFields() {
        guard let email = emailTF.text, !email.isEmpty, let password = passwordTF.text, !password.isEmpty else {
            loginBtn.isEnabled = false
            return
        }
        
        loginBtn.isEnabled = true
    }
    
    /// Handles the login button tap event.
    @IBAction private func loginBtnTapped(_ sender: Any){
        guard let email = emailTF.text, let password = passwordTF.text else { return }
        guard loginBtn.isEnabled else { return }
    
        print("login email:\(email) password: \(password)")
              
        Task {
            showLoadingView()
            do {
                let _ = try await authService.login(email: email, password: password)                
                navManager.setRoot(viewControllerIdentifier: AppPages.MyTabBarController)
            } catch { showErrorAlert() }
            dismissLoadingView()
        }
    }
    
    /// Handles the register button tap event.
    @IBAction private func registerBtnTapped(_ sender: Any) {
        navManager.presentModalViewController(
            fromStoryboard: "Main",
            viewControllerIdentifier: AppPages.Register,
            viewControllerType: RegisterVC.self,
            presentationStyle: .fullScreen,
            presentingViewController: self
        )
    }
    
    /// Displays an error alert.
    private func showErrorAlert() {
        let title = "login failed".translate()
        let message = "There was an error".translate()
        let okButton = "ok".translate()
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButton, style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true)
    }
}

