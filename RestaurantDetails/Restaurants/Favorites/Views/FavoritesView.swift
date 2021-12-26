//
//  FavoritesView.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 24.12.21.
//

import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func getNumberOfRows() -> Int
    func getImageUrlStringForItem(at index: Int) -> String?
    func getTitleForItem(at index: Int) -> String?
    func getDescriptionForItem(at index: Int) -> String?
    func isItemFavorite(at index: Int) -> Bool
    func onItemViewSelected(at index: Int)
}

class FavoritesView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: FavoritesViewDelegate?

    private var tableView: UITableView!
    private var noDataView: RestaurantsNoDataView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        tableView = setupTableView(delegate: self, dataSource: self)
        addSubview(tableView)

        let tableViewConstraints = setupTableViewConstraints(tableView, superView: self)
        addConstraints(tableViewConstraints)
    }

    // MARK: Public

    func reloadData() {
        tableView.reloadData()
    }

    func showNoDataView() {
        guard noDataView == nil else { return }
        noDataView = setupNoDataView(title: "You don't have any favorites",
                                     description: "To create a favorite, search for a restaurant" +
                                     " and you can make it a favorite by clicking on the star button" +
                                     " in the details screen.")
        addSubview(noDataView!)
        
        let noDataViewConstraints = setupNoDataViewConstraints(noDataView!,
                                                               onTopOf: tableView)
        addConstraints(noDataViewConstraints)
    }

    func removeNoDataView() {
        noDataView?.removeFromSuperview()
        noDataView = nil
    }

    // MARK: Private

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

    private func setupTableView(delegate: UITableViewDelegate,
                                dataSource: UITableViewDataSource) -> UITableView {
        let tableView = UITableView()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(FavoritesTableViewCell.self,
                           forCellReuseIdentifier: String(describing: FavoritesTableViewCell.self))
        return tableView
    }

    private func setupTableViewConstraints(_ tableView: UITableView,
                                           superView: UIView) -> [NSLayoutConstraint] {
        return [tableView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                tableView.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
                tableView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)]
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.onItemViewSelected(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.getNumberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoritesTableViewCell.self)) as! FavoritesTableViewCell

        // set name label text
        cell.favoriteNameLabel.text = delegate?.getTitleForItem(at: indexPath.row) ?? "-"
        // set address label text
        cell.favoriteAddressLabel.text = delegate?.getDescriptionForItem(at: indexPath.row) ?? "-"

        // get the image url
        if let urlString = delegate?.getImageUrlStringForItem(at: indexPath.row),
            let url = URL(string: urlString) {
            // load the image from server and set it in the image view
            cell.favoriteImageView?.sd_setImage(with: url,
                                                placeholderImage: UIImage(named: "restaurant-item-placeholder"))
        } else {
            // add a placeholder image
            cell.favoriteImageView?.image = UIImage(named: "restaurant-item-placeholder")
        }

        return cell
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
