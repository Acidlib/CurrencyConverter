//
//  BaseViewController.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/09.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var currencyArray: [Section] = []
    var selectedArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set default selection
        if self.selectedArray.count == 0 {
            self.selectedArray = ["Euro,EUR", "United State,USD", "Japan Yen,JPY", "Great Britain Pound,GBP"]
        }
    }
    
}
