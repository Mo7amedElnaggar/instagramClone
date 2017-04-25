//
//  feedCell.swift
//  FireBase instagram Clone
//
//  Created by Mohamed El Naggar on 4/25/17.
//  Copyright © 2017 Mohamed El Naggar. All rights reserved.
//

import UIKit
import SDWebImage

class feedCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var userText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setPhoto()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAttributes(post: (String , String , String)) {
        userNameLabel.text = post.0
        userPhoto.sd_setImage(with: URL(string: post.1))
        userText.text = post.2
    }
    
    private func setPhoto() {
        self.userPhoto.layer.borderColor = UIColor.purple.cgColor
        
        self.userPhoto.layer.cornerRadius = 4.0
        
        self.userPhoto.layer.borderWidth = 2.0
        
        
        self.userText.layer.borderWidth = 1.0
        self.userText.layer.borderColor = UIColor.blue.cgColor
        
    }

}
