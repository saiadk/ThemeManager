//
//  ModalViewController.swift
//  ThemeManager
//
//  Created by Mangaraju, Venkata Maruthu Sesha Sai [GCB-OT NE] on 7/28/18.
//  Copyright © 2018 Sai. All rights reserved.
//

import UIKit

class ModalViewController: BaseViewController {
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var tableviewBtn: UIButton!

    
    @IBAction func closeModalWindow(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

