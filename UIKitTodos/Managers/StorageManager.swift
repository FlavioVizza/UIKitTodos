//
//  StorageManager.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 20/04/24.
//

import UIKit
import Security

/// An enumeration representing keys used for storing data in UserDefaults or keychain.
///
/// This enumeration encapsulates keys used for storing various types of data in UserDefaults or keychain.
enum StorageKeys : String {
    /// The key for storing the selected theme of the application.
    case APP_THEME = "settings.apptheme"
    
    /// The key for storing the selected language of the application.
    case SELECTED_LANG = "settings.selectedlang"
    
    /// The key for storing the access token used for authentication.
    case ACCESS_TOKEN = "auth.token.access"
    
    /// The key for storing the refresh token used for authentication.
    case REFRESH_TOKEN = "auth.token.refresh"
}

/// A manager for storing and retrieving data using UserDefaults and Keychain.
///
/// This class provides methods for securely storing and retrieving data using UserDefaults for simple data types and Keychain for sensitive data.
class StorageManager {
    
    /// The shared instance of the StorageManager.
    static let shared = StorageManager()
    
    /// The UserDefaults instance used for storing non-sensitive data.
    private let defaults = UserDefaults.standard
    
    /// The service name used for Keychain operations.
    private let keychainServiceName = Bundle.main.bundleIdentifier ?? ""
    
    /// Initializes a new instance of the StorageManager.
    ///
    /// This private initializer is called to create a new instance of the StorageManager.
    private init() { }
    
    /// Saves a value securely in Keychain.
    ///
    /// This method securely saves a value in Keychain using the provided key.
    ///
    /// - Parameters:
    ///   - key: The key under which to save the value.
    ///   - value: The value to be saved.
    func secureSave(key: String, value: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainServiceName,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            let status = SecItemAdd(query as CFDictionary, nil)
            print("\(key) \(value) \(status) \(query)")
            guard status == errSecSuccess else { return }
        }
    }
    
    /// Retrieves a value securely from Keychain.
    ///
    /// This method securely retrieves a value from Keychain using the provided key.
    ///
    /// - Parameter key: The key from which to retrieve the value.
    /// - Returns: The retrieved value, if available.
    func secureRetrieve(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainServiceName,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    /// Deletes a value from Keychain.
    ///
    /// This method securely deletes a value from Keychain using the provided key.
    ///
    /// - Parameter key: The key of the value to be deleted.
    func secureDelete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainServiceName,
            kSecAttrAccount as String: key
        ]
        
        let _ = SecItemDelete(query as CFDictionary)
    }
    
    /// Saves a value in UserDefaults.
    ///
    /// This method saves a value in UserDefaults using the provided key.
    ///
    /// - Parameters:
    ///   - key: The key under which to save the value.
    ///   - value: The value to be saved.
    func save(key: StorageKeys, value: String) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    /// Retrieves a value from UserDefaults.
    ///
    /// This method retrieves a value from UserDefaults using the provided key.
    ///
    /// - Parameter key: The key from which to retrieve the value.
    /// - Returns: The retrieved value, if available.
    func retrieve(key: StorageKeys) -> String? {
        return defaults.string(forKey: key.rawValue)
    }
    
    /// Deletes a value from UserDefaults.
    ///
    /// This method deletes a value from UserDefaults using the provided key.
    ///
    /// - Parameter key: The key of the value to be deleted.
    func delete(key: StorageKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
