//
//  RestaurantInfoTableViewCell.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 25.12.21.
//

import UIKit

class RestaurantInfoTableViewCell: UITableViewCell {

    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }

    var address: String? {
        didSet {
            addressLabel.text = address
        }
    }

    var rating: String? {
        didSet {
            ratingLabel.text = rating
        }
    }

    private var nameLabel: UILabel!
    private var addressLabel: UILabel!
    private var ratingLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        // setup subviews
        nameLabel = setupNameLabel()
        contentView.addSubview(nameLabel)
    
        addressLabel = setupAddressLabel()
        contentView.addSubview(addressLabel)

        let ratingContainerView = setupRatingContainerView()
        contentView.addSubview(ratingContainerView)

        ratingLabel = setupRatingLabel()
        ratingContainerView.addSubview(ratingLabel)

        // setup constraints
        let nameLabelConstraints = setupNameLabelConstraints(nameLabel,
                                                             superView: contentView,
                                                             trailingView: ratingContainerView)
        contentView.addConstraints(nameLabelConstraints)
    
        let addressLabelConstraints = setupAddressLabelConstraints(addressLabel,
                                                                   superView: contentView,
                                                                   topView: nameLabel,
                                                                   trailingView: ratingContainerView)
        contentView.addConstraints(addressLabelConstraints)
    
        let ratingContainerViewConstraints = setupRatingContainerViewConstraints(ratingContainerView,
                                                                                 superView: contentView)
        contentView.addConstraints(ratingContainerViewConstraints)

        let ratingLabelConstraints = setupRatingLabelConstraints(ratingLabel,
                                                                 superView: ratingContainerView)
        ratingContainerView.addConstraints(ratingLabelConstraints)
    }

    private func setupNameLabel() -> UILabel {
        let nameLabel = UILabel()
        if let customFont = UIFont(name: "AvenirNext-Medium", size: 20) {
            // dynamic font size
            nameLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
            // enable dynamic font size
            nameLabel.adjustsFontForContentSizeCategory = true
        }
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }

    private func setupAddressLabel() -> UILabel {
        let descriptionLabel = UILabel()
        if let customFont = UIFont(name: "AvenirNext-Regular", size: 17) {
            // dynamic font size
            descriptionLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
            // enable dynamic font size
            descriptionLabel.adjustsFontForContentSizeCategory = true
        }
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }

    private func setupRatingLabel() -> UILabel {
        let ratingLabel = UILabel()
        ratingLabel.font = UIFont(name: "AvenirNext-Medium", size: 17)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        return ratingLabel
    }

    private func setupRatingContainerView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 99/255,
                                                green: 215/255,
                                                blue: 169/255,
                                                alpha: 1)
        containerView.layer.cornerRadius = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }

    private func setupNameLabelConstraints(_ nameLabel: UILabel,
                                           superView: UIView,
                                           trailingView ratingView: UIView) -> [NSLayoutConstraint] {
        return [nameLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 16),
                nameLabel.topAnchor.constraint(equalTo: superView.topAnchor, constant: 16),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor, constant: -16),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingView.leadingAnchor, constant: -16)]
    }

    private func setupAddressLabelConstraints(_ addressLabel: UILabel,
                                              superView: UIView,
                                              topView nameLabel: UILabel,
                                              trailingView ratingView: UIView) -> [NSLayoutConstraint] {
        return [addressLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 16),
                addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor, constant: -16),
                addressLabel.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -16),
                addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingView.leadingAnchor, constant: -16)]
    }

    private func setupRatingContainerViewConstraints(_ ratingContainerView: UIView,
                                                     superView: UIView) -> [NSLayoutConstraint] {
        return [ratingContainerView.topAnchor.constraint(equalTo: superView.topAnchor, constant: 16),
                ratingContainerView.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -16),
                ratingContainerView.widthAnchor.constraint(equalToConstant: 35),
                ratingContainerView.heightAnchor.constraint(equalToConstant: 35)]
    }

    private func setupRatingLabelConstraints(_ ratingLabel: UILabel,
                                             superView: UIView) -> [NSLayoutConstraint] {
        return [ratingLabel.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
                ratingLabel.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
                ratingLabel.widthAnchor.constraint(lessThanOrEqualTo: superView.widthAnchor)]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
