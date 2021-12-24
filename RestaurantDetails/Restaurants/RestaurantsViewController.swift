//
//  RestaurantsViewController.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 20.12.21.
//

import UIKit
import SDWebImage

class RestaurantsViewController: UIViewController,
                                 UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout,
                                 UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    private var restaurantsRepository: RestaurantsRepositoryProtocol!

    private var restaurants: [Restaurant]?
    
    /// Defines the max limit of the search results that you want to display in the grid
    private let limit: Int = 10

    private let apiKey: String = "6jGum-laSomPXN65KHz-KuRlvDfuaOkS26CvzualGZ0o3PqS6gfQqV2Dafxa7kiV2q7CzieS8opOH8IcbDhUw3UVPTcoBc-8_UnpNqmGhW7dk9e8FtC4WiBLPizAYXYx" // FIXME: Save the Api Key in Config.xcconfig file and not push it into the repo

    private var noDataView: RestaurantsNoDataView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.tintColor = .darkGray

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag

        let apiClient = RestaurantsApiClient(apiKey: apiKey)
        let fileStorage = FileStorage()
        let restaurantsPersistence = RestaurantsPersistence(storage: fileStorage)
        restaurantsRepository = RestaurantsRepository(apiClient: apiClient,
                                                      restaurantsPersistence: restaurantsPersistence)
    }

    // MARK: UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }

        // show loading view
        showLoadingView()

        // fetch restaurants for the writen search keyword in the search bar
        fetchRestaurants(searchKeyword: text,
                         latitude: 37.786882, // pass a dummy latitude & longitude for now
                         longitude: -122.399972, // pass a dummy latitude & longitude for now
                         limit: limit) { [weak self] result in
            // remove loading view
            self?.dismissLoadingView()
            // dismiss keyboard
            self?.searchBar.resignFirstResponder()
            switch result {
            case .success(let restaurants):
                if restaurants.isEmpty {
                    // show no data view
                    self?.showNoDataView()
                } else {
                    // remove no data view if needed
                    self?.removeNoDataView()
                    // update collection view with the search results
                    self?.restaurants = restaurants
                    self?.updateView()
                }
            case .failure(let error):
                // remove no data view if needed
                self?.removeNoDataView()
                // display error
                // add 0.5 sec delay as a workaround to show the error alert
                // immediately after dismissing the loading view
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.showError(error: error)
                }
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // if search field becomes empty,
            // remove all data from the collection view
            restaurants = []
            updateView()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: Private

    private func fetchRestaurants(searchKeyword: String,
                                  latitude: Double,
                                  longitude: Double,
                                  limit: Int,
                                  completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        restaurantsRepository.fetchRestaurants(term: searchKeyword,
                                               latitude: latitude,
                                               longitude: longitude,
                                               limit: 10,
                                               completion: completion)
    }

    private func updateView() {
        collectionView.reloadData()
    }

    private func showLoadingView() {
        let alert = UIAlertController(title: nil,
                                      message: "Loading...",
                                      preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5,
                                                                     width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }

    private func dismissLoadingView() {
        dismiss(animated: true, completion: nil)
    }

    private func showError(error: Error) {
        presentSimpleAlert(message: error.localizedDescription)
    }

    private func showNoDataView() {
        guard noDataView == nil else { return }
        noDataView = setupNoDataView(title: "No results for \(searchBar.text ?? "")",
                                         description: "The term you entered did not bring any results.")
        view.addSubview(noDataView!)
        
        let noDataViewConstraints = setupNoDataViewConstraints(noDataView!, onTopOf: collectionView)
        view.addConstraints(noDataViewConstraints)
    }

    private func setupNoDataView(title: String, description: String) -> RestaurantsNoDataView {
        let noDataView = RestaurantsNoDataView(title: title, description: description)
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        return noDataView
    }

    private func setupNoDataViewConstraints(_ noDataView: RestaurantsNoDataView,
                                            onTopOf collectionView: UIView) -> [NSLayoutConstraint] {
        return [noDataView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
                noDataView.topAnchor.constraint(equalTo: collectionView.topAnchor),
                noDataView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                noDataView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)]
    }

    private func removeNoDataView() {
        noDataView?.removeFromSuperview()
        noDataView = nil
    }

    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        let actionSheet = setupSortingActionSheet()
        present(actionSheet, animated: true, completion: nil)
    }

    private func setupSortingActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(title: "Sort by restaurant name", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .gray

        let ascendingAction = UIAlertAction(title: "Ascending", style: .default) { [weak self] action in
            self?.restaurants = self?.restaurants?.sorted(by: { $0.name ?? "" < $1.name ?? "" })
            self?.updateView()
        }
        
        actionSheet.addAction(ascendingAction)

        let descendingAction = UIAlertAction(title: "Descending", style: .default) { [weak self] action in
            self?.restaurants = self?.restaurants?.sorted(by: { $0.name ?? "" > $1.name ?? "" })
            self?.updateView()
        }
        actionSheet.addAction(descendingAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCellId",
                                                      for: indexPath) as! RestaurantCollectionViewCell
        
        if let restaurant = restaurants?[indexPath.row] {
            cell.nameLabel.text = restaurant.name ?? "-"
            cell.addressLabel.text = getFormattedRestaurantAddress(restaurant) ?? "-"

            if let imageUrlString = restaurant.imageUrl,
               let imageUrl = URL(string: imageUrlString) {
                cell.imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "restaurant-item-placeholder"))
            }
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            // fallback to a square cell
            return CGSize(width: 200, height: 200)
        }

        // define number of columns in grid view
        let cellsPerRow = 2
        // take into calculation the collection view section insets
        let insets = layout.sectionInset
        // take into calculation the spacing between cell items
        let marginsAndInsets = insets.left + insets.right + layout.minimumInteritemSpacing * CGFloat(Float(cellsPerRow - 1)) + collectionView.contentInset.left + collectionView.contentInset.right
        // get the item width which ensures we have always 2 elements per row (in different screen sizes)
        let itemWidth = (collectionView.frame.width - marginsAndInsets) / CGFloat(cellsPerRow)
        return CGSize(width: itemWidth, height: 220)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    // MARK: Helpers

    private func getFormattedRestaurantAddress(_ restaurant: Restaurant) -> String? {
        guard let displayAddress = restaurant.location?.displayAddress,
              displayAddress.count >= 2 else {
                  return nil
        }

        return "\(displayAddress[0]), \(displayAddress[1])"
    }

    private func presentSimpleAlert(title: String = "RestaurantDetails",
                                    message: String,
                                    customAction: UIAlertAction? = nil,
                                    actionTitle: String = "OK",
                                    handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            handler?()
        }
        
        if let customAction = customAction {
            alertController.addAction(customAction)
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

