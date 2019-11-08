//
//  PortalViewController.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/08.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit

class PortalViewController: UIViewController {
    
    var collectionView: UICollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCollectionView()
        self.view.backgroundColor = UIColor.green
    }

    override func didMove(toParent parent: UIViewController?) {
        
    }
    
    func loadCollectionView() {
        
    }
}

protocol PortalViewControllerDelegate: class {
}
