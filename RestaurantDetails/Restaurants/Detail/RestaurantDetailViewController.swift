//
//  RestaurantDetailViewController.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 24.12.21.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    private let restaurant: Restaurant

    private var favoritesManager: FavoritesManager!

    required init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = restaurant.name

        // setup Favorites manager
        let favoritesPersistence = FavoritesPersistence(storage: FileStorage())
        favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistence)

        // get is restaurant favorite
        let isFavorite = favoritesManager.isFavorite(restaurant: restaurant)

        // setup favorite bar button item
        let favoriteBarButtonItem = setupFavoriteBarButtonItem(isFavorite: isFavorite)
        navigationItem.rightBarButtonItem = favoriteBarButtonItem

        // setup restaurant cover picture
        if let imageUrlString = restaurant.imageUrl,
           let imageUrl = URL(string: imageUrlString) {
            (view as? RestaurantDetailView)?.getHeaderImageView().sd_setImage(with: imageUrl,
                                                                              placeholderImage: UIImage(named: "restaurant-item-placeholder"))
        }
    }

    override func loadView() {
        view = RestaurantDetailView()
    }

    private func setupFavoriteBarButtonItem(isFavorite: Bool) -> UIBarButtonItem {
        let image = isFavorite ? UIImage(named: "favorites-toolbar-icon") : UIImage(named: "favorites-empty-star")
        let barButtonItem = UIBarButtonItem(image: image,
                                            style: .plain,
                                            target: self,
                                            action: #selector(favoriteButtonTapped))
        return barButtonItem
    }

    @objc private func favoriteButtonTapped() {
        // check if restaurant is currently favorite
        let isFavorite = favoritesManager.isFavorite(restaurant: restaurant)

        if isFavorite {
            // if it is favorite, remove it from favorites
            favoritesManager.removeFavorite(restaurant: restaurant) { result in
                if result {
                    // update favorite bar button item if the favorite was removed successfully
                    navigationItem.rightBarButtonItem = setupFavoriteBarButtonItem(isFavorite: false)
                }
            }
        } else {
            // if it is not favorite, add it in favorites
            favoritesManager.addFavorite(restaurant: restaurant) { result in
                if result {
                    // update favorite bar button item if the favorite was added successfully
                    navigationItem.rightBarButtonItem = setupFavoriteBarButtonItem(isFavorite: true)
                }
            }
        }
    }

    private func fetchRestaurantDetails() {
        // TODO: implement
    }

    private func fetchReviews() {
        // TODO: implement
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
