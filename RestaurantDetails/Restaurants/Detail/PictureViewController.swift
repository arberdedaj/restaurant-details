//
//  PictureViewController.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 26.12.21.
//

import UIKit

/// A ViewController to display an image view in full size.
class PictureViewController: UIViewController {

    private var imageView: UIImageView!

    private var image: UIImage?
    private var imageUrl: String?

    convenience init(image: UIImage) {
        self.init(nibName: nil, bundle: nil)
        self.image = image
    }

    convenience init(imageUrl: String) {
        self.init(nibName: nil, bundle: nil)
        self.imageUrl = imageUrl
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // setup dismiss bar button item
        let dismissButton = setupDismissBarButtonItem()
        navigationItem.rightBarButtonItem = dismissButton

        // setup image view
        imageView = setupImageView()
        view.addSubview(imageView)

        // setup constraints
        let imageViewConstraints = setupImageViewConstraints(imageView,
                                                             superView: view)
        view.addConstraints(imageViewConstraints)

        if let image = image {
            // if we have an image object, display that one
            imageView.image = image
        } else if let imageUrl = imageUrl {
            // if the ViewController was initialized with an image url, load that url and display it in the image view
            if let url = URL(string: imageUrl) {
                imageView.sd_setImage(with: url,
                                      placeholderImage: UIImage(named: "restaurant-item-placeholder"))
            }
        }
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func setupDismissBarButtonItem() -> UIBarButtonItem {
        let dismissButton = UIBarButtonItem(title: "Dismiss",
                                            style: .plain,
                                            target: self,
                                            action: #selector(dismissButtonTapped))
        dismissButton.tintColor = .black
        return dismissButton
    }

    @objc private func dismissButtonTapped() {
        // dismiss self
        dismiss(animated: true, completion: nil)
    }

    private func setupImageViewConstraints(_ imageView: UIImageView,
                                           superView: UIView) -> [NSLayoutConstraint] {
        return [imageView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                imageView.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
                imageView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                imageView.bottomAnchor.constraint(lessThanOrEqualTo: superView.safeAreaLayoutGuide.bottomAnchor)]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
