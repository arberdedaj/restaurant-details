//
//  RestaurantTableViewHeader.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 25.12.21.
//

import UIKit

class RestaurantTableViewHeader: UIView {

    private(set) var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        // setup image view
        imageView = setupImageView()
        addSubview(imageView)

        // setup constraints
        let imageViewConstraints = setupImageViewConstraints(imageView,
                                                             superView: self)
        addConstraints(imageViewConstraints)
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func setupImageViewConstraints(_ imageView: UIImageView,
                                           superView: UIView) -> [NSLayoutConstraint] {
        return [imageView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                imageView.topAnchor.constraint(equalTo: superView.topAnchor),
                imageView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
