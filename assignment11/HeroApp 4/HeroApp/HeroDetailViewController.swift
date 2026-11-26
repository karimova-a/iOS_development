//
//  HeroDetailViewController.swift
//  HeroApp
//
//  Detail screen: header with picture, name and alignment badge,
//  then grouped rows (Powerstats, Appearance, Biography, Work).
//  Tapping a row copies its value and shows "Copied!".
//

import UIKit

class HeroDetailViewController: UITableViewController {

    // Set by HeroListViewController.prepare(for:sender:)
    var hero: Hero?

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alignmentLabel: UILabel!

    private enum Row {
        case stat(title: String, value: Int?)
        case info(title: String, value: String)
    }

    private struct Section {
        let title: String
        let rows: [Row]
    }

    private var sections: [Section] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 52

        guard let hero = hero else { return }
        configureHeader(with: hero)
        sections = makeSections(for: hero)
        loadPicture(for: hero)
    }

    // MARK: - Header

    private func configureHeader(with hero: Hero) {
        nameLabel.text = hero.name
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.6

        let text: String
        let color: UIColor
        let alignment = hero.biography?.alignment?.lowercased() ?? ""
        switch alignment {
        case "good":
            text = "Alignment: Good"
            color = .systemGreen
        case "bad":
            text = "Alignment: Bad"
            color = .systemRed
        case "neutral":
            text = "Alignment: Neutral"
            color = .systemOrange
        default:
            text = "Alignment: Unknown"
            color = .systemGray
        }
        alignmentLabel.text = text
        alignmentLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        alignmentLabel.textAlignment = .center
        alignmentLabel.textColor = color
        alignmentLabel.backgroundColor = color.withAlphaComponent(0.15)
        alignmentLabel.layer.cornerRadius = 14
        alignmentLabel.layer.masksToBounds = true

        // Placeholder until the real picture arrives.
        heroImageView.contentMode = .scaleAspectFit
        heroImageView.image = UIImage(systemName: "person.crop.rectangle")
        heroImageView.tintColor = .tertiaryLabel
    }

    // Only the picture is downloaded here (URLSession). The hero data was already loaded by the list.
    private func loadPicture(for hero: Hero) {
        let urlString = hero.images?.lg ?? hero.images?.md ?? hero.images?.sm

        HeroService.fetchImage(from: urlString) { [weak self] image in
            // Background thread: go back to the main thread before touching the image view.
            DispatchQueue.main.async {
                guard let self = self, let image = image else { return }
                UIView.transition(with: self.heroImageView,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve) {
                    self.heroImageView.image = image
                }
            }
        }
    }

    // MARK: - Data

    private func makeSections(for hero: Hero) -> [Section] {
        let stats = hero.powerstats
        let appearance = hero.appearance
        let biography = hero.biography
        let work = hero.work

        return [
            Section(title: "Powerstats", rows: [
                .stat(title: "Intelligence", value: stats?.intelligence),
                .stat(title: "Strength", value: stats?.strength),
                .stat(title: "Speed", value: stats?.speed),
                .stat(title: "Durability", value: stats?.durability),
                .stat(title: "Power", value: stats?.power),
                .stat(title: "Combat", value: stats?.combat)
            ]),
            Section(title: "Appearance", rows: [
                .info(title: "Race", value: Display.text(appearance?.race)),
                .info(title: "Height", value: Display.measurement(appearance?.height)),
                .info(title: "Weight", value: Display.measurement(appearance?.weight)),
                .info(title: "Eye color", value: Display.text(appearance?.eyeColor))
            ]),
            Section(title: "Biography", rows: [
                .info(title: "Full name", value: Display.text(biography?.fullName)),
                .info(title: "Publisher", value: Display.text(biography?.publisher)),
                .info(title: "Born in", value: Display.text(biography?.placeOfBirth))
            ]),
            Section(title: "Work", rows: [
                .info(title: "Occupation", value: Display.text(work?.occupation)),
                .info(title: "Base", value: Display.text(work?.base))
            ])
        ]
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .stat(let title, let value):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as? StatCell else {
                return UITableViewCell()
            }
            cell.configure(name: title, value: value)
            return cell

        case .info(let title, let value):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoCell else {
                return UITableViewCell()
            }
            cell.configure(title: title, value: value)
            return cell
        }
    }

    // MARK: - UITableViewDelegate

    // The bars fill one by one, a little later for every row.
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let statCell = cell as? StatCell {
            statCell.animateBar(delay: 0.1 + Double(indexPath.row) * 0.08)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let textToCopy: String
        switch sections[indexPath.section].rows[indexPath.row] {
        case .stat(let title, let value):
            textToCopy = "\(title): \(value.map { String($0) } ?? Display.unknown)"
        case .info(_, let value):
            textToCopy = value
        }
        UIPasteboard.general.string = textToCopy
        showToast("Copied!")
    }

    // MARK: - Toast

    private func showToast(_ message: String) {
        let host: UIView = navigationController?.view ?? view

        let label = UILabel()
        label.text = "  \(message)  "
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        host.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: host.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: host.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            label.heightAnchor.constraint(equalToConstant: 32)
        ])

        UIView.animate(withDuration: 0.2, animations: {
            label.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.9, options: [], animations: {
                label.alpha = 0
            }, completion: { _ in
                label.removeFromSuperview()
            })
        })
    }
}
