//
//  DetailCells.swift
//  HeroApp
//
//  The two cell types of the detail table.
//

import UIKit

// A powerstat: name, number and a coloured progress bar.
class StatCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!

    private var targetProgress: Float = 0
    private var animationID = 0

    func configure(name: String, value: Int?) {
        nameLabel.text = name
        animationID += 1
        progressView.setProgress(0, animated: false)

        if let value = value {
            valueLabel.text = "\(value)"
            targetProgress = Float(min(max(value, 0), 100)) / 100
            progressView.progressTintColor = StatCell.color(for: value)
        } else {
            valueLabel.text = Display.unknown
            targetProgress = 0
            progressView.progressTintColor = .systemGray
        }
    }

    /// Fills the bar after a small delay, so the bars appear one by one.
    func animateBar(delay: TimeInterval) {
        animationID += 1
        let id = animationID
        progressView.setProgress(0, animated: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self, self.animationID == id else { return }
            self.progressView.setProgress(self.targetProgress, animated: true)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        animationID += 1
        progressView.setProgress(0, animated: false)
    }

    // Low = red, middle = orange, high = green.
    private static func color(for value: Int) -> UIColor {
        if value >= 65 { return .systemGreen }
        if value >= 30 { return .systemOrange }
        return .systemRed
    }
}

// A text row: grey title on the left, value on the right.
class InfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }
}
