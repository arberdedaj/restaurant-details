//
//  RestaurantDetailView.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 25.12.21.
//

import UIKit

protocol RestaurantDetailViewDelegate: AnyObject {
    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int) -> Int
    func getTitleForHeader(in section: Int) -> String?
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

class RestaurantDetailView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: RestaurantDetailViewDelegate?

    private var tableView: UITableView!
    private var tableViewHeader: RestaurantTableViewHeader!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        // setup tableview
        tableView = setupTableView(delegate: self, dataSource: self)
        addSubview(tableView)

        // setup tableview header
        tableViewHeader = setupTableViewHeader()
        tableView.tableHeaderView = tableViewHeader

        // setup constraints
        let tableViewConstraints = setupTableViewConstraints(tableView, superView: self)
        addConstraints(tableViewConstraints)
    }

    // MARK: Public

    func reloadData() {
        tableView.reloadData()
    }

    func getHeaderImageView() -> UIImageView {
        return tableViewHeader.coverImageView
    }

    func setImageUrls(_ urls: [String]) {
        tableViewHeader.setImageUrls(urls)
    }

    // MARK: Private

    private func setupTableView(delegate: UITableViewDelegate,
                                dataSource: UITableViewDataSource) -> UITableView {
        let tableView = UITableView()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(RestaurantInfoTableViewCell.self,
                           forCellReuseIdentifier: String(describing: RestaurantInfoTableViewCell.self))
        tableView.register(ReviewTableViewCell.self,
                           forCellReuseIdentifier: String(describing: ReviewTableViewCell.self))
        tableView.register(RestaurantDetailHelperTableViewCell.self,
                           forCellReuseIdentifier: String(describing: RestaurantDetailHelperTableViewCell.self))
        return tableView
    }

    private func setupTableViewHeader() -> RestaurantTableViewHeader {
        return RestaurantTableViewHeader(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: tableView.frame.width,
                                                       height: 320))
    }

    private func setupTableViewConstraints(_ tableView: UITableView,
                                           superView: UIView) -> [NSLayoutConstraint] {
        return [tableView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                tableView.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
                tableView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)]
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return delegate?.getTitleForHeader(in: section)
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.getNumberOfSections() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.getNumberOfRows(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return delegate?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
