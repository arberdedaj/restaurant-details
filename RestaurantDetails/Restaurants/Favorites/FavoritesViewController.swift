//
//  FavoritesViewController.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 24.12.21.
//

import UIKit

class FavoritesViewController: UIViewController, FavoritesViewDelegate {

    var favorites: [Restaurant]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"

        let fileStorage = FileStorage()
        let favoritesPersistence = FavoritesPersistence(storage: fileStorage)
        let favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistence)
        favoritesManager.loadFavorites { [weak self] favorites in
            self?.favorites = favorites

            if let favorites = favorites, !favorites.isEmpty {
                // remove no data view if needed
                (view as? FavoritesView)?.removeNoDataView()
                // show favorites list
                (view as? FavoritesView)?.reloadData()
            } else {
                (view as? FavoritesView)?.showNoDataView()
            }
        }
    }

    override func loadView() {
        view = FavoritesView()
        (view as? FavoritesView)?.delegate = self
    }

    // MARK: FavoritesViewDelegate

    func getNumberOfRows() -> Int {
        return favorites?.count ?? 0
    }
    
    func getImageUrlStringForItem(at index: Int) -> String? {
        guard let favorites = favorites, favorites.count - 1 >= index else {
            return nil
        }

        return favorites[index].imageUrl
    }
    
    func getTitleForItem(at index: Int) -> String? {
        guard let favorites = favorites, favorites.count - 1 >= index else {
            return nil
        }

        return favorites[index].name
    }
    
    func getDescriptionForItem(at index: Int) -> String? {
        guard let favorites = favorites, favorites.count - 1 >= index else {
            return nil
        }

        return getFormattedRestaurantAddress(favorites[index])
    }
    
    func isItemFavorite(at index: Int) -> Bool {
        false
    }

    func onItemViewSelected(at index: Int) {
        // TODO: navigate to detail screen
    }

    // MARK: Helpers

    private func getFormattedRestaurantAddress(_ restaurant: Restaurant) -> String? {
        guard let displayAddress = restaurant.location?.displayAddress,
              displayAddress.count >= 2 else {
                  return nil
        }

        return "\(displayAddress[0]), \(displayAddress[1])"
    }
}
