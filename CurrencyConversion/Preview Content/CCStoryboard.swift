//
//  CCStoryboard.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/08.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit

class CCStoryboard: NSObject {

    class func mainStoryboard() -> (UIStoryboard) {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    class func viewController(identifier: String) -> (UIViewController) {
        return self.mainStoryboard().instantiateViewController(withIdentifier: identifier) as UIViewController
    }
}
