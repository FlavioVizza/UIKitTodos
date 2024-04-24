//
//  LanguagesVC.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 22/04/24.
//

import UIKit

/// A view controller to manage language selection.
class LanguagesVC: UIViewController {

    private let appStateManger = AppStateManger.shared
    private let configManager = ConfigManager.shared
    
    @IBOutlet weak var tableView: UITableView!
    private var languages : [String] = []
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        languages = configManager.languages
        configureTableView()
    }

    /// Configures the table view.
    private func configureTableView() {
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        tableView.removeExcessCells()
    }
}

/// Extension to provide UITableView support for LanguagesVC.
///
/// This extension implements UITableViewDataSource and UITableViewDelegate
/// protocols to manage the table view in the LanguagesVC.
extension LanguagesVC: UITableViewDataSource, UITableViewDelegate {
    
    /// Returns the number of rows in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    /// Configures and returns a table view cell for the specified row index.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row].translate()
        return cell
    }
    
    /// Handles the selection of an item from the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appStateManger.changeLanguage(langCode: languages[indexPath.row])
        dismiss(animated: true)
    }
}
