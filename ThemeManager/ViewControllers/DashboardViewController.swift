//
//  DashboardViewController.swift
//  ThemeManager
//
//  Created by Mangaraju, Venkata Maruthu Sesha Sai [GCB-OT NE] on 7/28/18.
//  Copyright © 2018 Sai. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var specificLabel: UILabel!
    @IBOutlet weak var specificButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ThemeManager.applyScreenSpecificStyles(self)
        
    }
}

