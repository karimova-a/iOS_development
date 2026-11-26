//
//  HeroListViewController.swift
//  HeroApp
//
//  List screen. Data path:
//  viewDidLoad -> HeroService.fetchHeroes (background thread, URLSession)
//  -> DispatchQueue.main.async -> heroes = ... -> tableView.reloadData()
//  -> numberOfRowsInSection / cellForRowAt -> HeroCell.configure(with:)
//

import UIKit

class HeroListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var heroes: [Hero] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heroes"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 72

        loadHeroes()
    }

    private func loadHeroes() {
        activityIndicator.startAnimating()

        HeroService.fetchHeroes { [weak self] result in
            // This handler runs on a background thread.
            // UIKit may only be used on the main thread, so hop there first.
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()

                switch result {
                case .success(let heroes):
                    self.heroes = heroes
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showError(error)
                }
            }
        }
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Could not load heroes",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadHeroes()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    // The storyboard segue "showDetail" ends here. We only pass the hero object;
    // the detail screen does not download the hero data again.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail",
              let detail = segue.destination as? HeroDetailViewController else { return }

        var tappedPath: IndexPath?
        if let cell = sender as? UITableViewCell {
            tappedPath = tableView.indexPath(for: cell)
        }
        if tappedPath == nil {
            tappedPath = tableView.indexPathForSelectedRow
        }
        guard let indexPath = tappedPath, indexPath.row < heroes.count else { return }

        detail.hero = heroes[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension HeroListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as? HeroCell else {
            return UITableViewCell()
        }
        cell.configure(with: heroes[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HeroListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
