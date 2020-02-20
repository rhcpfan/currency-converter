//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 20/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    // MARK: - Instance Properties -

    let tabBarControllerDelegate = MainTabBarControllerDelegate()

    // MARK: - Application Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = tabBarControllerDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set the navigation item title as the current VC title
        self.navigationItem.title = self.selectedViewController?.title
    }
}

class MainTabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Update the navigation item title
        tabBarController.navigationItem.title = viewController.title
    }
}
