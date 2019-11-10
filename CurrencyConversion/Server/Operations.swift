//
//  Operations.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/10.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import Foundation

class refreshCurrencyRateOperation: Operation {
    override func main() {
        APIManager.shared.requestCurrenctRate { (result) in
            print("background refresh result: \(result)")
        }
    }
}
