//
//  ThemeableViewController.swift
//  ThemeManager
//
//  Created by Mangaraju, Venkata Maruthu Sesha Sai [GCB-OT NE] on 7/28/18.
//  Copyright © 2018 Sai. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(applyStyles), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.applyStyles()
    }
    
    @objc func applyStyles(){
        ThemeManager.applyScreenSpecificStyles(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
