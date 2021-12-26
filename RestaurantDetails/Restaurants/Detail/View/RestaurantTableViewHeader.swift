//
//  RestaurantTableViewHeader.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 25.12.21.
//

import UIKit

protocol RestaurantTableViewHeaderDelegate: AnyObject {
    func tableViewHeader(_ tableViewHeader: RestaurantTableViewHeader,
                         tappedImageViewWithImage image: UIImage)
    func tableViewHeader(_ tableViewHeader: RestaurantTableViewHeader,
                         tappedImageViewWithUrl url: String)
}

class ImageViewTapGesture: UITapGestureRecognizer {
    var imageView: UIImageView?
}

class RestaurantTableViewHeader: UIView {

    weak var delegate: RestaurantTableViewHeaderDelegate?

    private(set) var coverImageView: UIImageView!

    private var stackView: UIStackView!

    private var imageUrls: [String]?

    override init(frame: CGRect) {
        super.init(frame: frame)

        // setup image view
        coverImageView = setupImageView()
        addSubview(coverImageView)

        // add tap gesture
        let tapGesture = ImageViewTapGesture(target: self,
                                             action: #selector(imageViewTapped(sender:)))
        tapGesture.imageView = coverImageView
        coverImageView.addGestureRecognizer(tapGesture)

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
        // set image urls
        imageUrls = urls
        // display only the first 3 photos
        for (i, urlString) in urls.enumerated() {
            if let url = URL(string: urlString) {
                let imageView = stackView.arrangedSubviews[i] as? UIImageView
                imageView?.isUserInteractionEnabled = true
                imageView?.sd_setImage(with: url,
                                       placeholderImage: UIImage(named: "restaurant-item-placeholder"))
                // add tap gesture
                let tapGesture = ImageViewTapGesture(target: self,
                                                     action: #selector(imageViewTapped(sender:)))
                tapGesture.imageView = imageView
                imageView?.addGestureRecognizer(tapGesture)
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
        imageView.isUserInteractionEnabled = true
        imageView.tag = 4
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
        for i in 0 ..< 3 {
            let imageView = UIImageView()
            imageView.tag = i
            imageView.image = UIImage(named: "restaurant-item-placeholder")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = false
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
            imageViews.append(imageView)
        }
        return imageViews
    }

    @objc private func imageViewTapped(sender: ImageViewTapGesture) {
        guard let imageView = sender.imageView, let image = imageView.image else {
            return
        }

        if imageView.tag == 4 {
            // the cover image view was tapped
            delegate?.tableViewHeader(self, tappedImageViewWithImage: image)
        } else if imageView.tag < 4 && imageView.tag >= 0 {
            // one of the three image views loaded with urls was tapped
            guard let imageUrls = imageUrls, tag < imageUrls.count - 1 else {
                // if tag is greater than urls length, return
                return
            }

            let url = imageUrls[imageView.tag]
            // pass the url of the image view which was tapped
            delegate?.tableViewHeader(self, tappedImageViewWithUrl: url)
        }
    }

    // MARK: Constraints

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
