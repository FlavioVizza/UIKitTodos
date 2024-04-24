//
//  TodosCellTableViewCell.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 17/04/24.
//

import UIKit

class TodosCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title.text = "test"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(todo: TodoItem) {
        //avatarImageView.image = Images.placeholder
        //avatarImageView.downloadImage(fromURL: favorite.avatarUrl)
        title?.text = todo.title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        title.text = "test"

    }
    
}
