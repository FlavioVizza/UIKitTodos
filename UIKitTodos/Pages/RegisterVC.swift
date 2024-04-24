//
//  RegisterVC.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 16/04/24.
//

import UIKit

/// View controller for user registration.
class RegisterVC: UIViewControllerWithSpinner {
    private let authService = AuthService.shared

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /// Removes the observer for language changes when the view controller is deallocated.
    deinit {
        NotificationCenter.default.removeObserver(self, name: AppNotification.RefreshLanguage, object: nil)
    }
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureLabels()
        configureForm()
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
        usernameTF.placeholder = "username".translate()
        emailTF.placeholder = "email".translate()
        passwordTF.placeholder = "password".translate()
        confirmPasswordTF.placeholder = "confirm password".translate()
        registerBtn.setTitle("register".translate(), for: .normal)
    }
    
    /// Configures the navigation bar with a close button.
    private func configureNavBar(){
        if let topItem = navigationBar.topItem {
            topItem.rightBarButtonItem = UIBarButtonItem(
                title: "cancel".translate(),
                style: .plain,
                target: self,
                action: #selector(closeBtnTapped)
            )
        }
    }
    
    /// Configures the form's initial state.
    private func configureForm(){
        registerBtn.isEnabled = false
        passwordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true

        usernameTF.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        confirmPasswordTF.addTarget(self, action: #selector(validateFields), for: .editingChanged)
    }
    
    /// Validates the input fields and enables the register button if conditions are met.
    @objc private func validateFields() {
        // Verifica campi di testo contengono testo
        guard let email = emailTF.text, !email.isEmpty,
              let username = usernameTF.text, !username.isEmpty,
              let password = passwordTF.text, !password.isEmpty, password.count >= 8,
              let confirmPassword = confirmPasswordTF.text, confirmPassword == password
        else {
            registerBtn.isEnabled = false
            return
        }
        
        // Se entrambi i campi contengono testo, abilita il pulsante di login
        registerBtn.isEnabled = true
    }
    
    /// Handles the close button tap event.
    @objc func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    /// Handles the register button tap event.
    @IBAction private func registerBtnTapped(_ sender: Any) {
        guard registerBtn.isEnabled else { return }
        
        let email = emailTF.text!
        let username = usernameTF.text!
        let password = passwordTF.text!
        
        Task {
            showLoadingView()
            do {
                let result = try await authService.register(username: username, email: email, password: password)
                if (!result.success) { throw MyError.invalidRequest }
                showSuccessAlert()
            }
            catch { showErrorAlert() }
            dismissLoadingView()
        }
    }
    
    /// Shows a success alert upon successful registration.
    private func showSuccessAlert(){
        let ac = UIAlertController(
            title: "registration".translate(),
            message: "registration ok".translate(),
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "ok".translate(), style: .default) { [unowned self] _ in
            dismiss(animated: true)
        })
        present(ac, animated: true)
    }
    
    /// Shows an error alert upon registration failure.
    private func showErrorAlert() {
        let title = "error".translate()
        let message = "registration ko".translate()
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: title, style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true)
    }
    
}
