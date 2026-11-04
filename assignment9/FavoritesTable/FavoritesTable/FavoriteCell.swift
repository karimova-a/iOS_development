//
//  FavoriteCell.swift
//  FavoritesTable
//
//  Created by Aigerim Karimova on 03.11.2026.
//

import UIKit

class FavoriteCell: UITableViewCell {

   // override func awakeFromNib() {
   //     super.awakeFromNib()
   //     // Initialization code
   // }
   //
   // override func setSelected(_ selected: Bool, animated: Bool) {
   //     super.setSelected(selected, animated: animated)
   //
   //     // Configure the view for the selected state
   // }
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!
    
    func configure(with item: FavoriteItem) {
        posterImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        for (index, star) in starImageViews.enumerated() {
            star.image = UIImage(systemName: index < item.rating ? "star.fill" : "star")
        }
    }
}
