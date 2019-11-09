//
//  BaseViewController.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/09.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rateDidUpdated), name: .rateDidUpdate, object: nil)
    }

    @objc func rateDidUpdated() {
        // override
    }
}
