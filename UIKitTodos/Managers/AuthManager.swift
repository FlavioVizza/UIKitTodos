//
//  AuthManager.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 16/04/24.
//

import UIKit

/// A manager for handling user authentication.
///
/// This class provides methods for managing user authentication, including token handling, logout, and authentication status verification.
class AuthManager {

    /// The shared instance of the AuthManager.
    static let shared = AuthManager()
    
    /// The storage manager used for storing and retrieving authentication tokens.
    private let storageManager = StorageManager.shared
    
    /// The configuration manager used for accessing API base URL.
    private let configManager = ConfigManager.shared
    
    /// The base URL for API requests.
    private var baseUrl = ""
    
    /// The access token for authentication.
    ///
    /// This private property holds the access token retrieved during authentication.
    private(set) var accessToken: String?
    
    /// The refresh token for authentication.
    ///
    /// This private property holds the refresh token retrieved during authentication.
    private(set) var refreshToken: String?
    
    /// The JSON decoder used for decoding token responses.
    private let decoder = JSONDecoder()

    /// Initializes a new instance of the AuthManager.
    ///
    /// This private initializer is called to create a new instance of the AuthManager and initializes its properties.
    private init(){
        baseUrl = configManager.getApiBaseUrl()
        accessToken = storageManager.secureRetrieve(key: StorageKeys.ACCESS_TOKEN.rawValue)
        refreshToken = storageManager.secureRetrieve(key: StorageKeys.REFRESH_TOKEN.rawValue)
        
        print("AuthManager init, accessToken \(String(describing: accessToken?.debugDescription)) refreshToken \(String(describing: refreshToken?.debugDescription))")
    }
    
    /// Handles token response from authentication.
    ///
    /// This method updates the access token and refresh token with the provided token response and saves them securely.
    ///
    /// - Parameter tokenResponse: The token response containing access and refresh tokens.
    func tokenHandler(tokenResponse: TokenResponse){
        accessToken = tokenResponse.accessToken
        refreshToken = tokenResponse.refreshToken
        storageManager.secureSave(key: StorageKeys.ACCESS_TOKEN.rawValue, value: accessToken ?? "")
        storageManager.secureSave(key: StorageKeys.REFRESH_TOKEN.rawValue, value: refreshToken ?? "")
    }
    
    /// Logs out the user.
    ///
    /// This method clears the access token, refresh token, and removes them securely from storage.
    func logout() {
        accessToken = nil
        refreshToken = nil
        storageManager.secureDelete(key: StorageKeys.ACCESS_TOKEN.rawValue)
        storageManager.secureDelete(key: StorageKeys.REFRESH_TOKEN.rawValue)
    }
    
    /// Checks if the user is authenticated.
    ///
    /// - Returns: `true` if the user is authenticated, `false` otherwise.
    func isAuthenticated() -> Bool {
        return accessToken != nil && accessToken != ""
    }
}

