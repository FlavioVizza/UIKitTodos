//
//  TodoItem.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 17/04/24.
//

import Foundation

/// A structure representing a todo item.
///
/// This structure encapsulates information about a todo item, including its title, description, completion status, and creation date.
public struct TodoItem: Codable {
    
    /// The unique identifier of the todo item.
    public let todoId: Int
    
    /// The title of the todo item.
    public let title: String
    
    /// The description of the todo item.
    public let description: String
    
    /// A Boolean value indicating whether the todo item is completed.
    public let completed: Bool
    
    /// The creation date of the todo item.
    public let createAt: String
}
