//
//  FavoritesViewController.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 24.12.21.
//

import UIKit

class FavoritesViewController: UIViewController, FavoritesViewDelegate {

    private var favorites: [Restaurant]? = []

    private var favoritesManager: FavoritesManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"

        let fileStorage = FileStorage()
        let favoritesPersistence = FavoritesPersistence(storage: fileStorage)
        favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistence)

        // load favorites and update view
        refreshFavoritesList(completion: nil)

        // observe favorites list updates
        NotificationCenter.default.addObserver(forName: FavoritesManager.favoritesListChangedNotification,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            // reload data
            self?.refreshFavoritesList(completion: nil)
        }
    }
    
    /// Loads the favorites from FavoritesManager and updates the view accordingly.
    /// - Parameter completion: completion handler.
    private func refreshFavoritesList(completion: (() -> Void)?) {
        // load favorites
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
            // call completion handler
            completion?()
        }
    }

    override func loadView() {
        // replace ViewController's view with FavoritesView
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
        guard let favorites = favorites, favorites.count - 1 >= index else {
            return
        }

        let favorite = favorites[index]

        // navigate to detail screen
        let favoriteDetailViewController = RestaurantDetailViewController(restaurant: favorite)
        navigationController?.pushViewController(favoriteDetailViewController, animated: true)
    }

    // MARK: Helpers

    private func getFormattedRestaurantAddress(_ restaurant: Restaurant) -> String? {
        guard let displayAddress = restaurant.location?.displayAddress,
              displayAddress.count >= 2 else {
                  return nil
        }

        return "\(displayAddress[0]), \(displayAddress[1])"
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: FavoritesManager.favoritesListChangedNotification,
                                                  object: nil)
    }
}
