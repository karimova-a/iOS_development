//
//  ViewController.swift
//  FavoritesTable
//
//  Created by Aigerim Karimova on 02.11.2026.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    private let items = FavoriteItem.all

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MY FAVORITES"
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.configure(with: items[indexPath.row])
        return cell
    }

}

