//
//  MediaTableViewCell.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 25/05/2023.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    
    //Mark: - Outlets.
    @IBOutlet weak var artWorkImage: UIImageView!
    @IBOutlet weak var artStreamLabel: UILabel!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    
    
    //Mark: - LifeCycle Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(artworkImageTapped))
        artWorkImage.addGestureRecognizer(tapGesture)
        artWorkImage.isUserInteractionEnabled = true
     }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func artworkImageTapped() {
        artWorkImage.bounceAnimation()
    }
}
