//
//  RestaurantsNoDataView.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 24.12.21.
//

import UIKit

class RestaurantsNoDataView: UIView {

    required init(title: String, description: String) {
        super.init(frame: .zero)

        backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)

        let titleLabelConstraints = setupTitleLabelConstraints(titleLabel, superView: self)
        addConstraints(titleLabelConstraints)

        let descriptionLabelConstraints = setupDescriptionLabelConstraints(descriptionLabel,
                                                                           superView: self,
                                                                           topView: titleLabel)
        addConstraints(descriptionLabelConstraints)
    }

    private func setupTitleLabelConstraints(_ titleLabel: UILabel,
                                            superView: UIView) -> [NSLayoutConstraint] {
        return [titleLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 16),
                titleLabel.topAnchor.constraint(equalTo: superView.topAnchor, constant: 32),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor,
                                                     constant: -16)]
    }

    private func setupDescriptionLabelConstraints(_ descriptionLabel: UILabel,
                                                  superView: UIView,
                                                  topView titleLabel: UILabel) -> [NSLayoutConstraint] {
        return [descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor,
                                                           constant: -16),
                ]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
