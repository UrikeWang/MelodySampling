//
//  HistoryTableViewCell.swift
//  MelodySampling
//
//  Created by moon on 2017/8/15.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionImageView: UIImageView! {
        didSet {
            collectionImageView.layer.shadowColor = UIColor.mldBlack50.cgColor
            collectionImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
            collectionImageView.layer.shadowRadius = 4
        }
    }
    
    @IBOutlet weak var trackNameLabel: UILabel! {
        didSet {
            trackNameLabel.addTextSpacing(to: -0.4)
        }
    }
    
    @IBOutlet weak var artistNameLabel: UILabel! {
        didSet {
            artistNameLabel.addTextSpacing(to: -0.4)
        }
    }
    
    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            createProfilePageHistoryCellBackground(target: cellBackgroundView)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
