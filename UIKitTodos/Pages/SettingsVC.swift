//
//  SettingsVC.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 16/04/24.
//

import UIKit

class SettingsVC: UIViewController {

    private let authManager = AuthManager.shared
    private let navManager = NavigationManager.shared
    private let themeManager = ThemeManger.shared
    
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var themeLbl: UILabel!
    @IBOutlet weak var langLbl: UILabel!
    
    // MARK: - Lifecycle Methods

    /// Removes the observer for language changes when the view controller is deallocated.
    deinit {
        NotificationCenter.default.removeObserver(self, name: AppNotification.RefreshLanguage, object: nil)
    }
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        configureThemeSwitch()
        configureLabels()
        changeLanguageObserver()
    }
    
    // MARK: - Configurations
    
    /// Observes the language change and updates the labels accordingly.
    private func changeLanguageObserver(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(configureLabels),
            name: AppNotification.RefreshLanguage,
            object: nil
        )
    }
    
    /// Configures the localized labels.
    @objc private func configureLabels() {
        title = "settings".translate()
        themeLbl.text = "theme".translate()
        langLbl.text = "select lang".translate()
    }
    
    /// Configures the theme switch based on the current app theme.
    private func configureThemeSwitch(){
        themeSwitch.isOn = themeManager.getAppTheme() == .dark ||
            (
                themeManager.getAppTheme() == .unspecified &&
                themeManager.getSystemTheme() == .dark
            )
    }
    
    // MARK: - Actions

    /// Handles the event when the theme switch is tapped.
    @IBAction private func themeBtnTapped(_ sender: Any) {
        let userInterfaceStyle: UIUserInterfaceStyle = themeSwitch.isOn ? .dark : .light
        ThemeManger.shared.setAppTheme(color: userInterfaceStyle)
    }
    
    /// Handles the event when the language button is tapped.
    @IBAction private func langBtnTapped(_ sender: Any) {
        navManager.presentModalViewController(
            fromStoryboard: "Main",
            viewControllerIdentifier: AppPages.Languages,
            viewControllerType: LanguagesVC.self,
            presentationStyle: .automatic,
            presentingViewController: self
        )
    }
    
    /// Handles the event when the logout button is tapped.
    @IBAction private func logoutBtnTapped(_ sender: Any) {
        let ac = UIAlertController(title: "logout".translate(), message: "logout message".translate(), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "cancel".translate(), style: .cancel))
        ac.addAction(UIAlertAction(title: "ok".translate(), style: .default) { [unowned self] _ in
            authManager.logout()
            navManager.setRoot(viewControllerIdentifier: AppPages.Login)
        })
        present(ac, animated: true)
    }
    
}
