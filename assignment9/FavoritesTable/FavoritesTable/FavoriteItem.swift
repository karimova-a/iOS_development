//
//  FavoriteItem.swift
//  FavoritesTable
//
//  Created by Aigerim Karimova on 02.11.2026.
//

import Foundation

struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int
}

extension FavoriteItem {
    static let all: [FavoriteItem] = [
        FavoriteItem(title: "Ramen", subtitle: "Country: Japan", imageName: "food1.png", rating: 1),
        FavoriteItem(title: "Tiramisù", subtitle: "Country: Italy", imageName: "food2.png", rating: 4),
        FavoriteItem(title: "Nutella crêpes", subtitle: "Country: France", imageName: "food3.png", rating: 0),
        FavoriteItem(title: "English breakfast", subtitle: "Country: England", imageName: "food4.png", rating: 3),
        FavoriteItem(title: "Pancakes with maple syrup", subtitle: "Country: Canada", imageName: "food5.png", rating: 5),
        FavoriteItem(title: "Blini", subtitle: "Country: Russia", imageName: "food6.png", rating: 0),
        FavoriteItem(title: "Tom yum", subtitle: "Country: Thailand", imageName: "food7.png", rating: 2),
        FavoriteItem(title: "Khachapuri", subtitle: "Country: Georgia", imageName: "food8.png", rating: 5),
        FavoriteItem(title: "Khinkali", subtitle: "Country: Georgia", imageName: "food9.png", rating: 3),
        FavoriteItem(title: "Pho", subtitle: "Country: Vietnam", imageName: "food10.png", rating: 4),
        FavoriteItem(title: "Cheeseburger", subtitle: "Country: USA", imageName: "food11.png", rating: 1),
        FavoriteItem(title: "Tacos", subtitle: "Country: Mexico", imageName: "food12.png", rating: 3),
        FavoriteItem(title: "Steak and fries", subtitle: "Country: France", imageName: "food13.png", rating: 4),
        FavoriteItem(title: "Baguette", subtitle: "Country: France", imageName: "food14.png", rating: 5),
        FavoriteItem(title: "Soslu döner", subtitle: "Country: Turkey", imageName: "food15.png", rating: 2),
        FavoriteItem(title: "Miso soup", subtitle: "Country: Japan", imageName: "food16.png", rating: 1),
        FavoriteItem(title: "Sushi", subtitle: "Country: Japan", imageName: "food17.png", rating: 2),
        FavoriteItem(title: "Greek salad", subtitle: "Country: Greece", imageName: "food18.png", rating: 3),
        FavoriteItem(title: "Tagliatelle al ragù alla Bolognese", subtitle: "Country: Italy", imageName: "food19.png", rating: 4),
        FavoriteItem(title: "Pizza Napoletana", subtitle: "Country: Italy", imageName: "food20.png", rating: 5)
    ]
}
