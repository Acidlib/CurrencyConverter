//
//  PortalViewController.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/08.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit

class PortalViewController: UIViewController {
    
    weak var delegate: PortalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTableView()
    }

    override func didMove(toParent parent: UIViewController?) {
        
    }
    
    func loadTableView() {
        
    }
}

protocol PortalViewControllerDelegate: class {
    func didSelectCurrency(array: [String], timestamp: Date)
}
