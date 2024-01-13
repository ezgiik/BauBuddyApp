//
//  TaskCellTableViewCell.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import UIKit
import SwiftHEXColors

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var colorCodeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    
        }
    func configure(with task: Task) {
                taskLabel.text = task.task
                titleLabel.text = task.title
                descriptionLabel.text = task.description
                colorCodeLabel.text = task.colorCode
                descriptionLabel.numberOfLines = 0
                
                if let hexColor = task.colorCode {
                    cellView.backgroundColor = UIColor(hexString: hexColor)
                }
            }
    }
        


