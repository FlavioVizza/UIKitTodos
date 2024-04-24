//
//  AppStateManger.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 19/04/24.
//

import UIKit

/// A manager for handling application state changes.
///
/// This class provides methods for managing changes in application state, such as updating the language and notifying observers about changes in the todos list.
class AppStateManger {
    
    /// The shared instance of the AppStateManager.
    static let shared = AppStateManger()
    
    /// The storage manager used for storing and retrieving application state.
    private let storageManager = StorageManager.shared
    
    /// Initializes a new instance of the AppStateManager.
    ///
    /// This private initializer is called to create a new instance of the AppStateManager.
    private init() {

    }
    
    /// Notifies observers about changes in the todos list.
    func todosListChanged(){
        NotificationCenter.default.post(
            name: AppNotification.TodosListChanged,
            object: nil,
            userInfo: nil
        )
    }
    
    /// Changes the language of the application.
    ///
    /// This method saves the selected language code in UserDefaults and notifies observers about the language change.
    ///
    /// - Parameter langCode: The language code to set as the selected language.
    func changeLanguage(langCode: String){
        storageManager.save(key: StorageKeys.SELECTED_LANG, value: langCode)
        NotificationCenter.default.post(
            name: AppNotification.RefreshLanguage,
            object: nil
        )
    }
    
}

