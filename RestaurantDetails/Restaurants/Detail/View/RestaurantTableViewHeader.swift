//
//  RestaurantTableViewHeader.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 25.12.21.
//

import UIKit

class RestaurantTableViewHeader: UIView {

    private(set) var coverImageView: UIImageView!

    private var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        // setup image view
        coverImageView = setupImageView()
        addSubview(coverImageView)

        // setup photos stack view
        stackView = setupPhotosStackView()
        addSubview(stackView)

        // add image views in a stack view
        let horizontalImageViews = setupHorizontalImageViews()
        horizontalImageViews.forEach { stackView.addArrangedSubview($0) }

        // setup constraints
        let imageViewConstraints = setupImageViewConstraints(coverImageView,
                                                             superView: self)
        addConstraints(imageViewConstraints)

        let stackViewConstraints = setupStackViewConstraints(stackView,
                                                             superView: self,
                                                             topView: coverImageView)
        addConstraints(stackViewConstraints)
    }

    // MARK: Public

    func setImageUrls(_ urls: [String]) {
        // display only the first 3 photos
        for (i, urlString) in urls.enumerated() {
            if let url = URL(string: urlString) {
                (stackView.arrangedSubviews[i] as? UIImageView)?.sd_setImage(with: url,
                                                                             placeholderImage: UIImage(named: "restaurant-item-placeholder"))
            }

            // we have 3 image views in the stack view, so we want
            // to stop the loop once we know that 3 images have been loaded
            if i == 2 {
                break
            }
        }
    }

    // MARK: Private

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func setupPhotosStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    /// setup 3 image views
    /// - Returns: An array with 3 image views
    private func setupHorizontalImageViews() -> [UIImageView] {
        var imageViews: [UIImageView] = []
        for _ in 0 ..< 3 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "restaurant-item-placeholder")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
            imageViews.append(imageView)
        }
        return imageViews
    }

    private func setupImageViewConstraints(_ imageView: UIImageView,
                                           superView: UIView) -> [NSLayoutConstraint] {
        return [imageView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                imageView.topAnchor.constraint(equalTo: superView.topAnchor),
                imageView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150)]
    }

    private func setupStackViewConstraints(_ stackView: UIStackView,
                                           superView: UIView,
                                           topView coverImageView: UIImageView) -> [NSLayoutConstraint] {
        return [stackView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                stackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 5),
                stackView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
