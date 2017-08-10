//
//  AnswerTableViewCell.swift
//  MelodySampling
//
//  Created by moon on 2017/8/10.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var answerView: UIView! {
        didSet {
            answerView.layer.cornerRadius = 10
            answerView.layer.masksToBounds = true
            answerView.layer.borderColor = UIColor.playPageBackground.cgColor
            answerView.layer.borderWidth = 2
            answerView.backgroundColor = UIColor.white
        }
    }

    @IBOutlet weak var answerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.contentView.backgroundColor = UIColor.playPageBackground

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
