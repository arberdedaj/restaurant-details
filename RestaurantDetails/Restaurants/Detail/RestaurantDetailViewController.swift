//
//  RestaurantDetailViewController.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 24.12.21.
//

import UIKit

enum ReviewsSectionState {
    case loading
    case success(reviews: [RestaurantReview])
    case error(message: String?)
}

class RestaurantDetailViewController: UIViewController,
                                      RestaurantDetailViewDelegate {

    private let restaurant: Restaurant
    private let restaurantsRepository: RestaurantsRepositoryProtocol

    private var favoritesManager: FavoritesManager!

    private var reviewsSectionState: ReviewsSectionState = .loading

    required init(restaurant: Restaurant,
                  restaurantsRepository: RestaurantsRepositoryProtocol) {
        self.restaurant = restaurant
        self.restaurantsRepository = restaurantsRepository
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

        // fetch restaurant details and reviews
        reloadData()
    }

    override func loadView() {
        // replace ViewController's view with RestaurantDetailView
        view = RestaurantDetailView()
        (view as? RestaurantDetailView)?.delegate = self
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
    
    /// Fetches restaurant details and reviews and updates the view accordingly
    private func reloadData() {
        fetchRestaurantDetails()
        fetchReviews()
    }

    private func fetchRestaurantDetails() {
        restaurantsRepository.fetchRestaurantDetails(id: restaurant.id!) { [weak self] result in
            switch result {
            case .success(let restaurantDetails):
                // pass image urls to the view
                (self?.view as? RestaurantDetailView)?.setImageUrls(restaurantDetails.photos ?? [])
                // update view
                (self?.view as? RestaurantDetailView)?.reloadData()
            case .failure:
                // noop
                // the image views have placeholder images so we choose
                // not to display an error to the user
                break
            }
        }
    }

    private func fetchReviews() {
        restaurantsRepository.fetchRestaurantReviews(id: restaurant.id!) { [weak self] result in
            switch result {
            case .success(let reviews):
                // update reviews section state
                self?.reviewsSectionState = .success(reviews: reviews)
                // update view
                (self?.view as? RestaurantDetailView)?.reloadData()
            case.failure(let error):
                // update reviews section state
                self?.reviewsSectionState = .error(message: error.localizedDescription)
                // update view
                (self?.view as? RestaurantDetailView)?.reloadData()
            }
        }
    }

    // MARK: RestaurantDetailViewDelegate

    func getNumberOfSections() -> Int {
        // there should be two sections in total.
        // The first one displays infos about the restaurant(name, address and rating)
        // The second section displays reviews
        return 2
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        if section == 0 {
            // return 1 row for the first section
            return 1
        } else {
            // check reviews section state to setup the number of rows accordingly
            switch reviewsSectionState {
            case .loading, .error:
                return 1
            case .success(let reviews):
                return reviews.count
            }
        }
    }

    func getTitleForHeader(in section: Int) -> String? {
        if section == 1 {
            // add a section title for the reviews section
            return "Reviews"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // main info section
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantInfoTableViewCell.self)) as! RestaurantInfoTableViewCell
            cell.name = restaurant.name ?? "-"
            cell.address = RestaurantUtils.getFormattedRestaurantAddress(restaurant) ?? "-"
            cell.rating = "\(restaurant.rating ?? 0.0)"
            return cell
        } else if indexPath.section == 1 {
            // reviews section
            switch reviewsSectionState {
            case .loading:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailHelperTableViewCell.self), for: indexPath) as! RestaurantDetailHelperTableViewCell
                // show loading view
                cell.showLoadingView()
                return cell
            case .success(let reviews):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewTableViewCell.self)) as! ReviewTableViewCell
                let review = reviews[indexPath.row]

                // set name label text
                cell.name = review.user?.name ?? "-"
                // set review text
                cell.reviewText = review.text ?? "-"

                return cell
            case .error(let message):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailHelperTableViewCell.self), for: indexPath) as! RestaurantDetailHelperTableViewCell
                // show error message
                cell.showError(errorMessage: "Failed to load reviews: \(message ?? "")")
                cell.onRetryButtonTapped = { [weak self] in
                    // retry fetching reviews on retry button tapped
                    self?.reviewsSectionState = .loading
                    (self?.view as? RestaurantDetailView)?.reloadData()
                    // fetch restaurant details and reviews with this way
                    self?.reloadData()
                }
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
