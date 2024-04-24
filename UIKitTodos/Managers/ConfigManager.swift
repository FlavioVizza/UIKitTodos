//
//  ConfigManager.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 23/04/24.
//

import Foundation

/// A manager for application configuration settings.
///
/// This class manages application configuration settings, such as supported languages and API base URL.
class ConfigManager {
    /// The shared instance of the ConfigManager.
    static let shared = ConfigManager()
    
    /// An array of supported languages.
    ///
    /// This array contains the language codes of supported languages.
    let languages = [ "en", "it" ]
    
    /// The base URL for the API.
    ///
    /// This private property holds the base URL used for API requests. It defaults to a local development server URL and can be overridden by a value stored in the Info.plist file.
    private var baseUrl = "http://localhost:3000/api"
    
    /// Initializes a new instance of the ConfigManager.
    ///
    /// This private initializer is called to create a new instance of the ConfigManager and initialize its properties.
    private init() {
        initBaseUrl()
    }
    
    /// Initializes the base URL from the Info.plist file.
    ///
    /// This private method attempts to read the API base URL from the Info.plist file and sets it as the baseUrl property.
    private func initBaseUrl(){
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let infoDict = NSDictionary(contentsOfFile: path) as? [String: Any],
            let baseURL = infoDict["ApiBaseUrl"] as? String {
            baseUrl = baseURL
            print("API Base URL: \(baseURL)")
        }
    }
    
    /// Retrieves the API base URL.
    ///
    /// - Returns: The base URL for API requests.
    func getApiBaseUrl() -> String{
        return baseUrl
    }

}
