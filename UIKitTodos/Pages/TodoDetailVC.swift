//
//  TodoDetailVC.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 18/04/24.
//

import UIKit

/// View controller for Todo Detail page.
class TodoDetailVC: UIViewControllerWithSpinner {
    
    /// Enumerates the mode of operation for the TodosVC.
    ///
    /// - `create`: Indicates that the operation is for creating a new todo item.
    /// - `update`: Indicates that the operation is for updating an existing todo item.
    private enum Mode {
        case create
        case update
    }
    
    /// Determines the current page mode
    ///
    /// By default, it is set to `.create`, indicating that the operation is for creating a new todo item.
    private var mode: Mode = .create

    /// Represents the todo item to be displayed or updated.
    ///
    /// - Note: This property is used as input to populate the fields for updating an existing todo item.
    var todoItem: TodoItem?

    private let appStateManager = AppStateManger.shared
    private let navManager = NavigationManager.shared
    private let todoService = TodoService.shared
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var doneLbl: UILabel!
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var doneSwitch: UISwitch!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    /// Removes the observers when the view controller is deallocated.
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: descriptionTV)
        NotificationCenter.default.removeObserver(self, name: AppNotification.RefreshLanguage, object: nil)
    }

    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageMode()
        configureForm()
        configureKeyboard()
        configureLabels()
        configureValidators()
        changeLanguageObserver()
    }
    
    /// Observes the language change notification.
    func changeLanguageObserver(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(configureLabels),
            name: AppNotification.RefreshLanguage,
            object: nil
        )
    }
    
    /// Configures the keyboard dismissal behavior by adding a tap gesture recognizer to the view.
    private func configureKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Dismisses the keyboard by ending the editing in the view.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Configures the localized text for UI elements.
    @objc private func configureLabels(){
        titleLbl.text = "title".translate()
        descrLbl.text = "description".translate()
        doneLbl.text = "done".translate()
        
        switch mode {
        case .create:
            confirmBtn.setTitle("create".translate(), for: .normal)
        case .update:
            confirmBtn.setTitle("update".translate(), for: .normal)
            deleteBtn.setTitle("delete".translate(), for: .normal)
        }
    }
    
    /// Configures the page mode based on input param todoItem.
    private func configurePageMode(){
        if todoItem != nil { mode = .update }
        else{ mode = .create }
    }
    
    /// Configures the todo form UI elements.
    private func configureForm(){
        switch mode {
        case .create:
            titleTF.text = nil
            descriptionTV.text = nil
            doneLbl.isHidden = true
            doneSwitch.isHidden = true
            confirmBtn.isEnabled = false
            deleteBtn.isHidden = true
            break
        case .update:
            loadTodo(id: todoItem!.todoId)
            break
        }
    }
    
    /// Configures validators based on page mode
    private func configureValidators(){
        // title
        titleTF.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        // description
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(validateFields),
            name: UITextView.textDidChangeNotification,
            object: descriptionTV
        )
        // done
        if (mode == .update){
            doneSwitch.addTarget(self, action: #selector(validateFields), for: .valueChanged)
        }
    }
    
    /// Validates the input fields and enables/disables the buttons accordingly.
    @objc private func validateFields() {
        guard let title = titleTF.text, !title.isEmpty,
              let description = descriptionTV.text, !description.isEmpty else {
            confirmBtn.isEnabled = false
            return
        }
        
        confirmBtn.isEnabled = true
    }

    /// Fetch todo item from the server.
    private func loadTodo(id: Int){
        Task{
            showLoadingView()
            do{
                todoItem = try await todoService.getTodo(by: id)
                titleTF.text = todoItem?.title
                descriptionTV.text = todoItem?.description
                doneSwitch.isOn = todoItem?.completed ?? false
            }
            catch{ showErrorAlert(message: "error retrieving".translate() ) }
            dismissLoadingView()
        }
    }

    /// Handles the action when the confirm button is tapped.
    ///
    /// Depending on the mode, either `createHandler()` or `updateHandler()` is called.
    @IBAction func confirmBtnTapped(_ sender: Any) {
        switch mode {
        case .create: createHandler()
            break
        case .update: updateHandler()
            break
        }
    }
    
    /// Handles the creation of a new todo item.
    ///
    /// - Requires: `titleTF` and `descriptionTV` must not be nil.
    /// - Note: If the creation is successful, the Todos list is updated and the user is navigated back.
    private func createHandler(){
        guard let title = titleTF.text, let descr = descriptionTV.text else { return }
        
        Task{
            showLoadingView()
            do{
                let result = try await todoService.createTodo(title: title, description: descr)
                if !result.success { throw MyError.genericMessage }

                print("Item created")
                navManager.popViewController(navigationController: navigationController)
                appStateManager.todosListChanged()
                
            }catch {  showErrorAlert(message: "error creating".translate()) }
            dismissLoadingView()
            
        }
    }
    
    /// Handles the update of an existing todo item.
    ///
    /// - Requires: `titleTF` and `descriptionTV` must not be nil.
    /// - Note: If the update is successful, the Todos list is updated and the user is navigated back.
    private func updateHandler(){
        guard let todoItem = todoItem else { return }
        guard let title = titleTF.text, let descr = descriptionTV.text else { return }

        let newTodo = TodoItem(
            todoId: todoItem.todoId,
            title: title,
            description: descr,
            completed: doneSwitch.isOn,
            createAt: todoItem.createAt
        )
        
        Task{
            showLoadingView()
            do{
                let result = try await todoService.updateTodo(from: newTodo)
                if !result.success { throw MyError.genericMessage }
                
                print("Item updated")
                navManager.popViewController(navigationController: navigationController)
                appStateManager.todosListChanged()
                
            }catch {  showErrorAlert(message: "error updating".translate()) }
            dismissLoadingView()
        }
    }
    
    /// Handles the action when the delete button is tapped.
    ///
    /// - Note: If the deletion is successful, the Todos list is updated and the user is navigated back.
    @IBAction private func deleteBtnTapped(_ sender: Any) {
        guard let todoItem else { return }
        
        Task{
            showLoadingView()
            do{
                let result = try await todoService.deleteTodo(by: todoItem.todoId)
                if !result.success { throw MyError.genericMessage }
                
                print("Item deleted")
                navManager.popViewController(navigationController: navigationController)
                appStateManager.todosListChanged()

            }catch {  showErrorAlert(message: "error deleting".translate()) }
            dismissLoadingView()
        }
    }
    
    /// Displays an error alert with the provided message.
    ///
    /// - Parameter message: The message to display in the error alert.
    private func showErrorAlert(message: String) {
        let ac = UIAlertController(title: "error".translate(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".translate(), style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true)
    }
}
