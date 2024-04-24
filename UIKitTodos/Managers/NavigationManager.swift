//
//  NavigationManager.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 17/04/24.
//

import UIKit

/// A manager for handling navigation within the application.
///
/// This class provides methods for setting root view controllers, presenting modal view controllers,
/// and pushing view controllers onto navigation stacks.
class NavigationManager {
    
    /// The shared instance of the NavigationManager.
    static let shared = NavigationManager()

    /// Initializes a new instance of the NavigationManager.
    ///
    /// This private initializer is called to create a new instance of the NavigationManager.
    private init() {}

    /// Sets the root view controller of the window.
    ///
    /// - Parameters:
    ///   - viewControllerIdentifier: The identifier of the view controller to set as the root.
    func setRoot(viewControllerIdentifier: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let window = windowScene.windows.first else { return }
            
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }

    /// Presents a modal view controller.
    ///
    /// - Parameters:
    ///   - storyboardName: The name of the storyboard containing the view controller.
    ///   - viewControllerIdentifier: The identifier of the view controller to present.
    ///   - viewControllerType: The type of the view controller to present.
    ///   - presentationStyle: The presentation style for the modal view controller.
    ///   - presentingViewController: The view controller from which to present the modal view controller.
    ///   - completion: A closure to be executed after the presentation finishes.
    func presentModalViewController<T: UIViewController>(
        fromStoryboard storyboardName: String,
        viewControllerIdentifier: String,
        viewControllerType: T.Type,
        presentationStyle: UIModalPresentationStyle,
        presentingViewController: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let modalViewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? T else { return }
        
        modalViewController.modalPresentationStyle = presentationStyle
        presentingViewController.present(modalViewController, animated: true, completion: completion)
    }

    /// Pushes a view controller onto a navigation stack.
    ///
    /// - Parameters:
    ///   - storyboardName: The name of the storyboard containing the view controller.
    ///   - viewControllerIdentifier: The identifier of the view controller to push.
    ///   - viewControllerType: The type of the view controller to push.
    ///   - configure: A closure to configure the view controller before pushing it.
    ///   - navigationController: The navigation controller onto which to push the view controller.
    func pushViewController<T: UIViewController>(
        fromStoryboard storyboardName: String,
        viewControllerIdentifier: String,
        viewControllerType: T.Type,
        configure: ((T) -> Void)? = nil,
        navigationController: UINavigationController?
    ) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? T else { return }

        configure?(viewController)

        navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Pops a view controller from a navigation stack.
    ///
    /// - Parameter navigationController: The navigation controller from which to pop the view controller.
    func popViewController(
        navigationController: UINavigationController?
    ) {
        navigationController?.popViewController(animated: true)
    }
    
}
