//
//  FavoritesTableViewCell.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 24.12.21.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    private(set) var favoriteImageView: UIImageView!
    private(set) var favoriteNameLabel: UILabel!
    private(set) var favoriteAddressLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator

        // setup subviews

        favoriteImageView = setupImageView()
        contentView.addSubview(favoriteImageView)
    
        favoriteNameLabel = setupNameLabel()
        contentView.addSubview(favoriteNameLabel)
    
        favoriteAddressLabel = setupAddressLabel()
        contentView.addSubview(favoriteAddressLabel)
    
        // setup constraints
    
        let imageViewConstraints = setupImageViewConstraints(favoriteImageView,
                                                             superView: contentView)
        contentView.addConstraints(imageViewConstraints)
    
        let nameLabelConstraints = setupNameLabelConstraints(favoriteNameLabel,
                                                             superView: contentView,
                                                             leadingView: favoriteImageView)
        contentView.addConstraints(nameLabelConstraints)
    
        let addressLabelConstraints = setupAddressLabelConstraints(favoriteAddressLabel,
                                                                   superView: contentView,
                                                                   topView: favoriteNameLabel,
                                                                   leadingView: favoriteImageView)
        contentView.addConstraints(addressLabelConstraints)
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func setupNameLabel() -> UILabel {
        let nameLabel = UILabel()
        if let customFont = UIFont(name: "AvenirNext-Medium", size: 17) {
            // dynamic font size
            nameLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
            // enable dynamic font size
            nameLabel.adjustsFontForContentSizeCategory = true
        }
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }

    private func setupAddressLabel() -> UILabel {
        let descriptionLabel = UILabel()
        if let customFont = UIFont(name: "AvenirNext-Regular", size: 16) {
            // dynamic font size
            descriptionLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
            // enable dynamic font size
            descriptionLabel.adjustsFontForContentSizeCategory = true
        }
        descriptionLabel.textColor = .darkGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }

    private func setupImageViewConstraints(_ imageView: UIImageView,
                                           superView: UIView) -> [NSLayoutConstraint] {
        return [imageView.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 16),
                imageView.topAnchor.constraint(equalTo: superView.topAnchor, constant: 16),
                imageView.bottomAnchor.constraint(lessThanOrEqualTo: superView.bottomAnchor, constant: -16),
                imageView.widthAnchor.constraint(equalToConstant: 55),
                imageView.heightAnchor.constraint(equalToConstant: 55)]
    }

    private func setupNameLabelConstraints(_ nameLabel: UILabel,
                                           superView: UIView,
                                           leadingView imageView: UIImageView) -> [NSLayoutConstraint] {
        return [nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
                nameLabel.topAnchor.constraint(equalTo: superView.topAnchor, constant: 16),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor, constant: -16)]
    }

    private func setupAddressLabelConstraints(_ addressLabel: UILabel,
                                              superView: UIView,
                                              topView nameLabel: UILabel,
                                              leadingView imageView: UIImageView) -> [NSLayoutConstraint] {
        return [addressLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
                addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor, constant: -16),
                addressLabel.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -16)]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
