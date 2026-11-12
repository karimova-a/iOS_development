//
//  ViewController.swift
//  FavoritesNavigator
//
//  Created by Aigerim Karimova on 11.11.2026.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let items = FavoriteData.items
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let item = items[indexPath.row]
        cell.titleLabel.text = item.title
        cell.thumbImageView.image = UIImage(named: item.imageName)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let detail = segue.destination as? DetailViewController, 
           let indexPath = tableView.indexPathForSelectedRow {
            detail.item = items[indexPath.row]
        }
    }
    

}

