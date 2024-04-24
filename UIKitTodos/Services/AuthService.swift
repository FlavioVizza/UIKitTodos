//
//  AuthService.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 24/04/24.
//

import Foundation

/// A service for handling user authentication.
///
/// This class provides methods for user authentication such as login, refresh token, and registration.
class AuthService {
    
    /// The configuration manager used for accessing API base URL.
    private let configManager = ConfigManager.shared
    
    /// The network manager used for performing HTTP requests.
    private let networkManager = NetworkManager.shared
    
    /// The authentication manager used for managing authentication tokens.
    private let authManager = AuthManager.shared
    
    /// The base URL for authentication service requests.
    private var baseUrl = ""
    
    /// The JSON decoder used for decoding JSON responses.
    let decoder = JSONDecoder()
    
    /// The shared instance of the AuthService.
    static let shared = AuthService()
    
    /// Initializes a new instance of the AuthService.
    ///
    /// This private initializer is called to create a new instance of the AuthService and initializes its properties.
    private init() {
        baseUrl = configManager.getApiBaseUrl()
    }
    
    /// Performs user login.
    ///
    /// This method performs user login by sending a request to the login endpoint with the provided credentials.
    ///
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: The token response containing access and refresh tokens.
    func login(email: String, password: String) async throws -> TokenResponse {
        let endpoint = "\(baseUrl)/auth/login"

        // params
        let requestBody = ["email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            throw MyError.invalidRequest
        }
        
        do {
            let (data, response) = try await networkManager.performHTTPRequest(
                endpoint: endpoint,
                method: HTTPMethod.POST,
                httpBody: jsonData
            )
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw MyError.invalidResponse
            }
            let tokenResponse =  try decoder.decode(TokenResponse.self, from: data)
            print("Retrieved Token with login \(tokenResponse)")
            authManager.tokenHandler(tokenResponse: tokenResponse)
            return tokenResponse
        } catch {
            print("error while retrieving token during login")
            throw MyError.invalidData
        }
    }
    
    /// Performs token refresh.
    ///
    /// This method performs token refresh by sending a request to the refresh token endpoint with the current refresh token.
    ///
    /// - Returns: A boolean value indicating whether the token refresh was successful.
    func refreshToken() async throws -> Bool {
        let endpoint = "\(baseUrl)/auth/refresh"
        
        // params
        let requestBody = ["refreshToken": authManager.refreshToken]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return false
        }
        
        do {
            let (data, response) = try await networkManager.performHTTPRequest(
                endpoint: endpoint,
                method: HTTPMethod.POST,
                httpBody: jsonData
            )
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return false
            }
            
            let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
            print("Retrieved Token with refreshToken \(tokenResponse)")
            authManager.tokenHandler(tokenResponse: tokenResponse)
            return true
        } catch {
            print("error while retrieving token in refreshToken")
            return false
        }
    }
    
    /// Registers a new user.
    ///
    /// This method registers a new user by sending a request to the registration endpoint with the provided user details.
    ///
    /// - Parameters:
    ///   - username: The username of the new user.
    ///   - email: The email address of the new user.
    ///   - password: The password of the new user.
    /// - Returns: A generic response indicating the success of the registration operation.
    func register(username: String, email: String, password: String) async throws -> GenericResponse {
        let endpoint = "\(baseUrl)/auth/register"
        
        // params
        let requestBody = ["username": username, "email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            throw MyError.invalidRequest
        }
        
        do {
            let (data, response) = try await networkManager.performHTTPRequest(
                endpoint: endpoint,
                method: HTTPMethod.POST,
                httpBody: jsonData
            )
            guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                throw MyError.invalidResponse
            }
            return try decoder.decode(GenericResponse.self, from: data)
        } catch {
            throw MyError.invalidData
        }
    }
    
}
