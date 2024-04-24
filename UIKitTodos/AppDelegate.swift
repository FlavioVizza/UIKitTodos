//
//  AppDelegate.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 16/04/24.
//

import UIKit

/// The delegate object of the application, responsible for managing the application's life cycle events.
///
/// The `AppDelegate` class conforms to the `UIApplicationDelegate` protocol and handles various events related to the application's life cycle.
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Notifies the delegate that the launch process has begun and the app is almost ready to run.
    ///
    /// - Parameters:
    ///   - application: The singleton application instance.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any).
    /// - Returns: `true` if the app launch was successful, otherwise `false`.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    /// Returns the configuration for the new scene when connecting to a session.
    ///
    /// - Parameters:
    ///   - application: The singleton application instance.
    ///   - connectingSceneSession: The new scene session being created.
    ///   - options: The options for creating the scene.
    /// - Returns: A `UISceneConfiguration` object representing the configuration of the new scene.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    /// Notifies the delegate that the user discards a scene session.
    ///
    /// - Parameter sceneSessions: The set of scene sessions that were discarded.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
