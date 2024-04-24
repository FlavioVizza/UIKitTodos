//
//  UIViewControllerWithSpinner.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 16/04/24.
//

import UIKit

/// A view controller with a loading spinner.
///
/// This class extends UIViewController to provide functionality for displaying and dismissing a loading spinner.
class UIViewControllerWithSpinner : UIViewController {
    
    /// The container view used to display the loading spinner.
    var containerView: UIView!
    
    /// Displays a loading spinner on the screen.
    ///
    /// This method creates a container view covering the entire screen with a semi-transparent background and a large activity indicator in the center.
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .black
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.65 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    /// Dismisses the loading spinner from the screen.
    ///
    /// This method removes the container view and stops the activity indicator animation.
    func dismissLoadingView() {
        DispatchQueue.main.async {
            guard self.containerView != nil else { return }

            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
}
