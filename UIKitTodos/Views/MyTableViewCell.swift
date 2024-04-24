//
//  MyTableViewCell.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 17/04/24.
//

import UIKit

/// A custom table view cell used to display todo items.
///
/// This cell displays information about a todo item, including its title and completion status.
class MyTableViewCell: UITableViewCell {
    
    /// The reuse identifier for the table view cell.
    static let identifier = "MyTableViewCell"
    
    /// Returns a UINib object initialized to the nib file with a specified name and bundle.
    ///
    /// - Returns: A UINib object for the table view cell.
    static func nib() -> UINib { return UINib(nibName: "MyTableViewCell", bundle: nil)}
    
    /// The label displaying the title of the todo item.
    @IBOutlet weak var titleLbl: UILabel!
    
    /// The image view displaying the completion status of the todo item.
    @IBOutlet weak var iconIV: UIImageView!

    /// Performs any additional setup after loading the view.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// Notifies the cell that it has been selected.
    ///
    /// - Parameters:
    ///   - selected: A Boolean value indicating whether the cell is selected.
    ///   - animated: A Boolean value indicating whether the selection change should be animated.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Sets the appearance of the table view cell based on the provided todo item.
    ///
    /// - Parameter todo: The todo item to be displayed.
    func set(todo: TodoItem) {
        if todo.completed {
            iconIV.image = UIImage(systemName: "checkmark.circle")
            iconIV.tintColor = .systemGreen
        }
        else {
            iconIV.image = UIImage(systemName: "circle")
            iconIV.tintColor = .systemRed
        }
        titleLbl.text = todo.title
    }
    
}
