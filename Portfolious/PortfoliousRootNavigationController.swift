//
//  PortfoliousRootNavigationController.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/31/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class PortfoliousRootNavigationController: UINavigationController {
    override func viewDidLoad() {
        navigationBar.barTintColor = Theme.Color.Aquamarine
        navigationBar.tintColor = Theme.Color.NavigationWhite
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Theme.Color.NavigationWhite]
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
