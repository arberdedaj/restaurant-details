//
//  RestaurantsViewController.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 20.12.21.
//

import UIKit

class RestaurantsViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = searchBar
    }
}

