//
//  TodoService.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 24/04/24.
//

import Foundation

/// A service for managing todo items.
///
/// This class provides methods for performing CRUD operations on todo items through network requests.
class TodoService {
    
    /// The configuration manager used for accessing API base URL.
    private let configManager = ConfigManager.shared
    
    /// The network manager used for performing HTTP requests.
    private let networkManager = NetworkManager.shared
    
    /// The base URL for todo service requests.
    private var baseUrl = ""
    
    /// The JSON decoder used for decoding JSON responses.
    let decoder = JSONDecoder()
    
    /// The shared instance of the TodoService.
    static let shared = TodoService()
    
    /// Initializes a new instance of the TodoService.
    ///
    /// This private initializer is called to create a new instance of the TodoService and initializes its properties.
    private init() {
        baseUrl = configManager.getApiBaseUrl()
    }
    
    /// Retrieves all todo items for this user.
    ///
    /// This method retrieves all todo items from the server.
    ///
    /// - Returns: An array of todo items.
    func getTodos() async throws -> [TodoItem] {
        let endpoint = "\(baseUrl)/todos"

        do {
            let (data, response) = try await networkManager.performHTTPRequest(
                endpoint: endpoint,
                method: HTTPMethod.GET,
                withAuth: true
            )
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                return try decoder.decode([TodoItem].self, from: data)
            }
            throw MyError.invalidData
        } catch {
            print(error)
            throw MyError.invalidData
        }
    }

    /// Retrieves a todo item by its identifier.
    ///
    /// This method retrieves a todo item from the server based on its identifier.
    ///
    /// - Parameter id: The identifier of the todo item to retrieve.
    /// - Returns: The retrieved todo item.
    func getTodo(by id: Int) async throws -> TodoItem {
        let endpoint = "\(baseUrl)/todos/\(id)"
        do {
            let (data, response) = try await networkManager.performHTTPRequest(
                endpoint: endpoint,
                method: HTTPMethod.GET,
                withAuth: true
            )
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                return try decoder.decode(TodoItem.self, from: data)
            }
            throw MyError.invalidData
        } catch {
            print(error)
            throw MyError.invalidData
        }
    }

    /// Creates a new todo item.
    ///
    /// This method creates a new todo item on the server.
    ///
    /// - Parameters:
    ///   - title: The title of the todo item.
    ///   - description: The description of the todo item.
    /// - Returns: A generic response indicating the success of the operation.
    func createTodo(title: String, description: String) async throws -> GenericResponse {
        let endpoint = "\(baseUrl)/todos"
        
        // Converti l'oggetto in formato JSON
        let requestBody = ["title": title, "description": description]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            throw MyError.invalidRequest
        }
        
        do {
            let (data, response) = try await networkManager.performHTTPRequest(
                endpoint: endpoint,
                method: HTTPMethod.POST,
                httpBody: jsonData,
                withAuth: true
            )
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                return try decoder.decode(GenericResponse.self, from: data)
            }
            throw MyError.invalidData
        }
        catch {
            print(error)
            throw MyError.invalidData
        }
    }

    /// Updates an existing todo item.
    ///
    /// This method updates an existing todo item on the server.
    ///
    /// - Parameter todoItem: The todo item to be updated.
    /// - Returns: A generic response indicating the success of the operation.
    func updateTodo(from todoItem: TodoItem) async throws -> GenericResponse {
        let endpoint = "\(baseUrl)/todos/\(todoItem.todoId)"
        
        do {
            let jsonData = try JSONEncoder().encode(todoItem)
            let (data, response) = try await networkManager.performHTTPRequest(
                endpoint: endpoint, 
                method: HTTPMethod.PUT,
                httpBody: jsonData,
                withAuth: true
            )
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                return try decoder.decode(GenericResponse.self, from: data)
            }
            throw MyError.invalidData
        }
        catch {
            print(error)
            throw MyError.invalidData
        }
    }
    
    /// Deletes a todo item by its identifier.
    ///
    /// This method deletes a todo item from the server based on its identifier.
    ///
    /// - Parameter id: The identifier of the todo item to delete.
    /// - Returns: A generic response indicating the success of the operation.
    func deleteTodo(by id: Int) async throws -> GenericResponse {
        let endpoint = "\(baseUrl)/todos/\(id)"
        
        do {
            let (data, response) = try await networkManager.performHTTPRequest(
                endpoint: endpoint,
                method: HTTPMethod.DELETE,
                withAuth: true
            )
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                return try decoder.decode(GenericResponse.self, from: data)
            }
            throw MyError.invalidData
        }
        catch {
            print(error)
            throw MyError.invalidData
        }
    }
    
    
}
