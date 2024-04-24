//
//  Constants.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 17/04/24.
//

import UIKit

/// An enumeration representing custom error types.
///
/// This enumeration encapsulates various error scenarios that may occur during application execution.
public enum MyError: String, Error {
    /// Indicates that the provided URL is not valid.
    case invalidURL = "The URL is not valid"
    
    /// Indicates that the request cannot be completed due to invalid parameters or URL.
    case invalidRequest = "Unable to complete your request. Please check your request params and URL."
    
    /// Indicates an invalid response received from the server.
    case invalidResponse = "Invalid response from the server. Please try again."
    
    /// Indicates that the data received from the server was invalid.
    case invalidData = "The data received from the server was invalid. Please try again."
    
    /// Indicates that the access token is not valid or has expired.
    case noAuthToken = "Access token is not valid or expired"
    
    /// Indicates that the refresh token is not valid or has expired.
    case noRefreshToken = "Refresh token is not valid or expired"
    
    /// Indicates a generic error message when retrieving data.
    case genericMessage = "There was an error retrieving data. Please try again."
}

/// An enumeration representing custom notification names.
///
/// This enumeration encapsulates notification names used within the application.
public enum AppNotification {
    /// Notification name for refreshing language settings.
    static let RefreshLanguage = Notification.Name("RefreshLanguage")
    
    /// Notification name for requesting root navigation.
    static let RequestRootNavigation = Notification.Name("RequestRootNavigation")
    
    /// Notification name indicating changes in the todos list.
    static let TodosListChanged = Notification.Name("TodosListChanged")
}

/// An enumeration representing identifiers for various app pages.
///
/// This enumeration encapsulates identifiers for view controllers within the application.
public enum AppPages {
    /// Identifier for the login view controller.
    static let Login = "LoginVC"
    
    /// Identifier for the main tab bar controller.
    static let MyTabBarController = "MyTabBarController"
    
    /// Identifier for the todos view controller.
    static let Todos = "TodosVC"
    
    /// Identifier for the todo detail view controller.
    static let TodoDetail = "TodoDetailVC"
    
    /// Identifier for the settings view controller.
    static let Settings = "SettingsVC"
    
    /// Identifier for the register view controller.
    static let Register = "RegisterVC"
    
    /// Identifier for the languages view controller.
    static let Languages = "LanguagesVC"
}


/// Enum representing HTTP methods.
enum HTTPMethod {
    /// HTTP GET method.
    static let GET = "GET"
    
    /// HTTP POST method.
    static let POST = "POST"
    
    /// HTTP PUT method.
    static let PUT = "PUT"
    
    /// HTTP DELETE method.
    static let DELETE = "DELETE"
}
