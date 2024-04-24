//
//  SceneDelegate.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 16/04/24.
//

import UIKit

/// The delegate object of the scene, responsible for managing the life cycle events of a scene.
///
/// The `SceneDelegate` class conforms to the `UIWindowSceneDelegate` protocol and handles various events related to the scene's life cycle.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    /// The shared instance of `NavigationManager` used for navigation purposes.
    private let navigationManager = NavigationManager.shared
        
    /// The shared instance of `AuthManager` used for authentication purposes.
    private let authManager = AuthManager.shared

    /// The shared instance of  `ThemeManager` used to determine the app's theme
    private let themeManger = ThemeManger.shared
        
    /// The window associated with the scene.
    var window: UIWindow?

    /// Informs the delegate that the scene is about to connect to the specified session.
    ///
    /// - Parameters:
    ///   - scene: The scene object being connected to a session.
    ///   - session: The session object to which the scene is connecting.
    ///   - connectionOptions: The options that specify the reason for connecting the scene to the session.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        UINavigationBar.appearance().tintColor = .systemRed

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = determineRootViewController()
        window?.makeKeyAndVisible()

        initializeApp()
    }
    
    /// Determines the appropriate root view controller based on the user's authentication status.
    ///
    /// - Returns: The root view controller of the application
    private func determineRootViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        print("isAuthenticated: \(authManager.isAuthenticated())")
        if authManager.isAuthenticated() {
            return storyboard.instantiateViewController(withIdentifier: AppPages.MyTabBarController)
        } else {
            return storyboard.instantiateViewController(withIdentifier: AppPages.Login)
        }
    }

    /// Initializes the application settings.
    private func initializeApp(){
        // System theme
        let systemTheme = themeManger.getSystemTheme()
        let styleString = themeManger.getThemeAsString(by: systemTheme!)
        print("System default theme is: \(String(describing: styleString))")
        
        // App Settings Theme
        let appTheme = themeManger.getAppTheme()
        if appTheme != .unspecified { ThemeManger.shared.applyTheme(color: appTheme) }
        let appThemeAsString = themeManger.getThemeAsString(by: appTheme)
        print("App theme is: \(String(describing: appThemeAsString))")
    }
    
    /// Notifies the delegate that the scene was disconnected from the system.
    ///
    /// - Parameter scene: The scene object that was disconnected.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    /// Notifies the delegate that the scene has become active.
    ///
    /// - Parameter scene: The scene object that became active.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    /// Notifies the delegate that the scene will resign active status.
    ///
    /// - Parameter scene: The scene object that will resign active status.
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    /// Notifies the delegate that the scene is about to enter the foreground.
    ///
    /// - Parameter scene: The scene object that will enter the foreground.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    /// Notifies the delegate that the scene has entered the background.
    ///
    /// - Parameter scene: The scene object that has entered the background.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
