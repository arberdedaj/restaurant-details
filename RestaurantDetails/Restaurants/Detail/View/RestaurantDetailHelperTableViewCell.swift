//
//  RestaurantDetailHelperTableViewCell.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 25.12.21.
//

import UIKit

/// A TableView Cell which can show a loading view (while data is being loaded for that section),
/// and an error view if there was an error while loading the data.
class RestaurantDetailHelperTableViewCell: UITableViewCell {
    
    var onRetryButtonTapped: (() -> Void)?
    
    var isSeparatorHidden: Bool = true {
        didSet {
            separatorView.isHidden = isSeparatorHidden
        }
    }
    
    private var loadingActivityIndicator: UIActivityIndicatorView?
    private var errorMessageLabel: UILabel?
    private var retryButton: UIButton?
    private var separatorView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        separatorView = UIView()
        separatorView.isHidden = isSeparatorHidden
        separatorView.backgroundColor = UIColor(red: 102/255,
                                                green: 102/255,
                                                blue: 102/255,
                                                alpha: 1)
        addSubview(separatorView)
        
        setupConstraints()
    }
    
    // MARK: - Public
    
    func showLoadingView() {
        dismissErrorView()
        if loadingActivityIndicator == nil {
            loadingActivityIndicator = UIActivityIndicatorView(style: .medium)
            loadingActivityIndicator?.hidesWhenStopped = true
            loadingActivityIndicator?.startAnimating()
            addSubview(loadingActivityIndicator!)

            loadingActivityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            loadingActivityIndicator?.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
            loadingActivityIndicator?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            loadingActivityIndicator?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        } else {
            loadingActivityIndicator?.startAnimating()
        }
    }
    
    func dismissLoadingView() {
        loadingActivityIndicator?.stopAnimating()
        loadingActivityIndicator?.removeFromSuperview()
        loadingActivityIndicator = nil
    }
    
    func showError(errorMessage: String) {
        dismissLoadingView()
        if errorMessageLabel == nil && retryButton == nil {
            errorMessageLabel = UILabel()
            errorMessageLabel?.numberOfLines = 2
            errorMessageLabel?.text = errorMessage
            errorMessageLabel?.font =  UIFont(name: "AvenirNext-Regular", size: 15)
            addSubview(errorMessageLabel!)
            
            retryButton = UIButton(type: .system)
            retryButton?.tintColor = .black
            retryButton?.setTitle("Retry", for: .normal)
            retryButton?.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
            addSubview(retryButton!)

            errorMessageLabel?.translatesAutoresizingMaskIntoConstraints = false
            errorMessageLabel?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            errorMessageLabel?.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
            errorMessageLabel?.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16).isActive = true

            retryButton?.translatesAutoresizingMaskIntoConstraints = false
            retryButton?.leadingAnchor.constraint(equalTo: errorMessageLabel!.leadingAnchor).isActive = true
            retryButton?.topAnchor.constraint(equalTo: errorMessageLabel!.bottomAnchor, constant: 16).isActive = true
            retryButton?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        }
    }
    
    func dismissErrorView() {
        errorMessageLabel?.removeFromSuperview()
        errorMessageLabel = nil
        retryButton?.removeFromSuperview()
        retryButton = nil
    }
    
    // MARK: - Private
    
    @objc private func retryButtonTapped() {
        onRetryButtonTapped?()
    }
    
    private func setupConstraints() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
