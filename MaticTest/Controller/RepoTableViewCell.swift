//
//  RepoTableViewCell.swift
//  MaticTest
//
//  Created by Apple on 8/25/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import UIKit
import Kingfisher

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ownerImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(_ repo: Repo ){
        
        self.nameLabel.text = repo.name
        self.ownerNameLabel.text = repo.owner?.login
        self.starCountLabel.text = "\(repo.stargazers_count ?? 0)"
        self.descriptionTextView.text = repo.description
        self.ownerImageView.kf.setImage(with: URL(string: repo.owner?.avatar_url ?? ""))
        self.ownerImageView.layer.cornerRadius = self.ownerImageView.frame.width/2
        
    }
}
