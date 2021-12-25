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

    func getHeaderImageView() -> UIImageView {
        return tableViewHeader.imageView
    }

    private func setupTableView(delegate: UITableViewDelegate,
                                dataSource: UITableViewDataSource) -> UITableView {
        let tableView = UITableView()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        return tableView
    }

    private func setupTableViewHeader() -> RestaurantTableViewHeader {
        return RestaurantTableViewHeader(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: tableView.frame.width,
                                                       height: 250))
    }

    private func setupTableViewConstraints(_ tableView: UITableView,
                                           superView: UIView) -> [NSLayoutConstraint] {
        return [tableView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                tableView.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
                tableView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)]
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.getNumberOfSections() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.getNumberOfRows(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
