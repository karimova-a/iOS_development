//
//  HeroCell.swift
//  HeroApp
//
//  One row of the list: a rounded card with a gender icon and the hero name.
//

import UIKit

class HeroCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = true
        nameLabel.adjustsFontForContentSizeCategory = true
    }

    /// Sets EVERY visible value, so a reused cell can never show data of another hero.
    func configure(with hero: Hero) {
        nameLabel.text = hero.name

        switch hero.gender {
        case .male:
            genderImageView.image = UIImage(systemName: "figure.stand")
            genderImageView.tintColor = .systemBlue
        case .female:
            genderImageView.image = UIImage(systemName: "figure.stand.dress")
            genderImageView.tintColor = .systemPink
        case .unknown:
            genderImageView.image = UIImage(systemName: "person.fill.questionmark")
            genderImageView.tintColor = .systemGray
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        genderImageView.image = nil
        genderImageView.tintColor = .systemGray
        cardView.transform = .identity
    }

    /// The card shrinks a little while the row is pressed.
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let scale: CGFloat = highlighted ? 0.96 : 1.0
        let changes = {
            self.cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        if animated {
            UIView.animate(withDuration: 0.15,
                           delay: 0,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: changes)
        } else {
            changes()
        }
    }
}
