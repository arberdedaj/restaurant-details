//
//  RestaurantsViewController.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 20.12.21.
//

import UIKit

class RestaurantsViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = searchBar
    }

    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: implement
    }
    
}

