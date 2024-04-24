//
//  ThemeManager.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 20/04/24.
//
import UIKit

/// A manager for handling application themes.
///
/// This class provides methods for getting and setting the application theme, including both system and custom themes.
class ThemeManger {
    
    /// The shared instance of the ThemeManager.
    static let shared = ThemeManger()
    
    /// The storage manager used for storing and retrieving theme settings.
    private let storageManager = StorageManager.shared
    
    /// Initializes a new instance of the ThemeManager.
    ///
    /// This private initializer is called to create a new instance of the ThemeManager.
    private init() { }
    
    /// Retrieves the system theme of the application.
    ///
    /// - Returns: The system theme of the application, or `.unspecified` if not available.
    func getSystemTheme() -> UIUserInterfaceStyle? {
        // Get a reference to the main window of the active scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .unspecified }
        guard let window = windowScene.windows.first else { return .unspecified }
        
        // Example of retrieving the system theme
        let currentTraitCollection = window.rootViewController?.traitCollection
        return currentTraitCollection?.userInterfaceStyle
    }
    
    /// Retrieves the application theme.
    ///
    /// - Returns: The application theme.
    func getAppTheme() -> UIUserInterfaceStyle {
        let savedString =  storageManager.retrieve(key: .APP_THEME)
        return getUserInterfaceStyle(from: savedString ?? UIUserInterfaceStyle.unspecified.rawValue.description)
    }
    
    /// Sets the application theme.
    ///
    /// - Parameter color: The UIUserInterfaceStyle representing the desired theme.
    func setAppTheme(color: UIUserInterfaceStyle){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = windowScene.windows.first else { return }
        
        window.overrideUserInterfaceStyle = color
        print("salvo \(color.rawValue.description)")
        storageManager.save(key: .APP_THEME, value: color.rawValue.description)
    }
    
    /// Applies the specified theme to the application.
    ///
    /// - Parameter color: The UIUserInterfaceStyle representing the desired theme.
    func applyTheme(color: UIUserInterfaceStyle){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = windowScene.windows.first else { return }
        
        window.overrideUserInterfaceStyle = color
    }
    
    /// Converts the given UIUserInterfaceStyle to a string representation.
    ///
    /// - Parameter userInterfaceStyle: The UIUserInterfaceStyle to convert.
    /// - Returns: A string representation of the UIUserInterfaceStyle.
    func getThemeAsString(by userInterfaceStyle: UIUserInterfaceStyle) -> String {
        let styleString: String
        switch userInterfaceStyle {
            case .light: styleString = "light"
            case .dark: styleString = "dark"
            default: styleString = "unspecified"
        }
        
        return styleString
    }
    
    /// Converts the given string to a UIUserInterfaceStyle.
    ///
    /// - Parameter string: The string to convert.
    /// - Returns: The corresponding UIUserInterfaceStyle.
    func getUserInterfaceStyle(from string: String) -> UIUserInterfaceStyle {
        switch string {
            case UIUserInterfaceStyle.light.rawValue.description: return .light
            case UIUserInterfaceStyle.dark.rawValue.description: return .dark
            default: return .unspecified
        }
    }
    
}
