//
//  String+Ext.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 23/04/24.
//

import UIKit

/// An extension to provide localization support for strings.
///
/// This extension allows translating strings to the selected language using NSLocalizedString.
extension String {
    /// Translates the string to the selected language.
    ///
    /// This method translates the string to the selected language based on the language stored in the app's storage.
    /// If the translation is not found for the selected language, it falls back to the default language.
    ///
    /// - Returns: The translated string.
    func translate() -> String {
        // Retrieve the selected language from storage or use the default language if not found.
        let LocalizeDefaultLanguage = StorageManager.shared.retrieve(key: StorageKeys.SELECTED_LANG) ?? "en"
        
        // Load the appropriate localization bundle based on the selected language.
        if let path = Bundle.main.path(forResource: LocalizeDefaultLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            // Translate the string using NSLocalizedString.
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        
        return ""
    }
}
