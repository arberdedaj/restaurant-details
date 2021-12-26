//
//  ReviewTableViewCell.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 25.12.21.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    var name: String? {
        didSet {
            nameLabel.text = name
            userInitialLabel.text = name?.first?.uppercased()
        }
    }

    var reviewText: String? {
        didSet {
            reviewTextLabel.text = reviewText
        }
    }

    private var userInitialLabel: UILabel!
    private var nameLabel: UILabel!
    private var reviewTextLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        selectionStyle = .none

        // setup subviews
        let initialContainerView = setupUserInitialContainerView()
        contentView.addSubview(initialContainerView)
    
        userInitialLabel = setupUserInitialLabel()
        initialContainerView.addSubview(userInitialLabel)

        nameLabel = setupUserNameLabel()
        contentView.addSubview(nameLabel)

        reviewTextLabel = setupReviewTextLabel()
        contentView.addSubview(reviewTextLabel)

        // setup constraints
        let nameLabelConstraints = setupUserNameLabelConstraints(nameLabel,
                                                                 superView: contentView,
                                                                 leadingView: initialContainerView)
        contentView.addConstraints(nameLabelConstraints)
    
        let reviewLabelConstraints = setupReviewTextLabelConstraints(reviewTextLabel,
                                                                     superView: contentView,
                                                                     topView: initialContainerView)
        contentView.addConstraints(reviewLabelConstraints)

        let initialContainerViewConstraints = setupUserInitialContainerViewConstraints(initialContainerView,
                                                                                       superView: contentView)
        contentView.addConstraints(initialContainerViewConstraints)

        let initialLabelConstraints = setupInitialLabelConstraints(userInitialLabel,
                                                                   superView: initialContainerView)
        initialContainerView.addConstraints(initialLabelConstraints)
    }

    private func setupUserInitialLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func setupUserInitialContainerView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 234/255,
                                                green: 176/255,
                                                blue: 110/255,
                                                alpha: 1)
        containerView.layer.cornerRadius = 15
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }

    private func setupUserNameLabel() -> UILabel {
        let label = UILabel()
        if let customFont = UIFont(name: "AvenirNext-Medium", size: 15) {
            // dynamic font size
            label.font = UIFontMetrics.default.scaledFont(for: customFont)
            // enable dynamic font size
            label.adjustsFontForContentSizeCategory = true
        }
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func setupReviewTextLabel() -> UILabel {
        let label = UILabel()
        if let customFont = UIFont(name: "AvenirNext-Regular", size: 15) {
            // dynamic font size
            label.font = UIFontMetrics.default.scaledFont(for: customFont)
            // enable dynamic font size
            label.adjustsFontForContentSizeCategory = true
        }
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func setupUserInitialContainerViewConstraints(_ containerView: UIView,
                                                          superView: UIView) -> [NSLayoutConstraint] {
        return [containerView.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 16),
                containerView.topAnchor.constraint(equalTo: superView.topAnchor, constant: 16),
                containerView.widthAnchor.constraint(equalToConstant: 30),
                containerView.heightAnchor.constraint(equalToConstant: 30)]
    }

    private func setupInitialLabelConstraints(_ initialLabel: UILabel,
                                              superView: UIView) -> [NSLayoutConstraint] {
        return [initialLabel.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
                initialLabel.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
                initialLabel.widthAnchor.constraint(lessThanOrEqualTo: superView.widthAnchor)]
    }

    private func setupUserNameLabelConstraints(_ nameLabel: UILabel,
                                               superView: UIView,
                                               leadingView userInitialView: UIView) -> [NSLayoutConstraint] {
        return [nameLabel.leadingAnchor.constraint(equalTo: userInitialView.trailingAnchor, constant: 16),
                nameLabel.topAnchor.constraint(equalTo: superView.topAnchor, constant: 16),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor, constant: -16)]
    }

    private func setupReviewTextLabelConstraints(_ reviewTextLabel: UILabel,
                                                 superView: UIView,
                                                 topView userInitialView: UIView) -> [NSLayoutConstraint] {
        return [reviewTextLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 16),
                reviewTextLabel.topAnchor.constraint(equalTo: userInitialView.bottomAnchor, constant: 8),
                reviewTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor, constant: -16),
                reviewTextLabel.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -16)]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
