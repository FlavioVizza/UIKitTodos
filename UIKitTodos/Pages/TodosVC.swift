//
//  TodosVC.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 16/04/24.
//

import UIKit

/// View controller for Todo List page.
class TodosVC: UIViewControllerWithSpinner {

    private let navCtrl = NavigationManager.shared
    private let todoService = TodoService.shared
    
    /// Array to store todo items.
    private var todos: [TodoItem] = []
    
    /// Refresh control for updating todo list.
    private var refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyTableView: UIView!

    /// Removes the observer for  changes in the todo list when the view controller is deallocated.
    deinit {
        NotificationCenter.default.removeObserver(self, name: AppNotification.TodosListChanged, object: nil)
    }
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        
        loadTodos()
        changeTodosListObserver()
    }
    
    /// Configures the navigation bar.
    private func configureNavBar() {
        view.backgroundColor = .systemBackground
        title = "Todos"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTodoItem)
        )
    }
    
    /// Configures the table view.
    private func configureTableView() {
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        tableView.removeExcessCells()

        // Add refreshControl to TableView
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadTodos), for: .valueChanged)
               
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier )
    }
    
    /// Adds observer for changes in the todo list.
    private func changeTodosListObserver(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadTodos),
            name: AppNotification.TodosListChanged,
            object: nil
        )
    }
    
    /// Handles the add new todo item action.
    @objc private func addNewTodoItem(){
        goToDetail(todoItem: nil)
    }
    
    /// Navigates to the todo detail view controller.
    private func goToDetail(todoItem: TodoItem?){
        navCtrl.pushViewController(
            fromStoryboard: "Main",
            viewControllerIdentifier: AppPages.TodoDetail,
            viewControllerType: TodoDetailVC.self,
            configure: { todoDetailVC in todoDetailVC.todoItem = todoItem },
            navigationController: navigationController
        )
    }
    
    /// Fetches todo items from the server.
    @objc private func loadTodos(){
        Task {
            showLoadingView()
            do {
                let todosResponse: [TodoItem] = try await todoService.getTodos()
                updateUI(with: todosResponse)

            } catch {
                print(error)
                showErrorAlert(message: MyError.genericMessage.rawValue)
            }
            dismissLoadingView()
        }
    }
    
    /// Updates the UI with the fetched todo items.
    private func updateUI(with todos: [TodoItem]) {
        DispatchQueue.main.async {
            self.todos = todos
            
            if self.todos.isEmpty {
                self.tableView.isHidden = true
            }
            else {
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
            
            if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
        }
    }
    
    /// Shows an error alert with the given message.
    private func showErrorAlert(message: String) {
        let ac = UIAlertController(title: "error".translate(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".translate(), style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true)
    }

}

/// Extension to provide UITableView support for TodosVC.
///
/// This extension implements UITableViewDataSource and UITableViewDelegate
/// protocols to manage the table view in the TodosVC.
extension TodosVC: UITableViewDataSource, UITableViewDelegate {
    
    /// Returns the number of rows in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    /// Configures and returns a table view cell for the specified row index.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        cell.set(todo: todos[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    /// Handles the selection of a todo item from the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoItem = todos[indexPath.row]
        goToDetail(todoItem: todoItem)
    }
    
}
