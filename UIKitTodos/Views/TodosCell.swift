//
//  TodosCell.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 17/04/24.
//

import UIKit

class TodosCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    static let identifier = "TodosCell"
    static func nib() -> UINib { return  UINib(nibName: "TodosCell", bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(todo: TodoItem){
        print(todo)
        title.text = todo.title
    }
    
}
