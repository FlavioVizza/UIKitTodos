//
//  UITableView+Ext.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 23/04/24.
//

import UIKit

/// An extension to provide convenience methods for UITableView.
///
/// This extension adds additional functionality to UITableView to simplify common tasks.
extension UITableView {
    /// Reloads the table view data on the main thread.
    ///
    /// This method reloads the table view data asynchronously on the main thread to ensure UI updates are performed safely.
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    /// Removes excess cells from the table view.
    ///
    /// This method removes excess cells by setting the table footer view to an empty UIView, effectively hiding any empty cells below the content.
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
