//
//  CurreuncyRateUserDefault.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/10.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import Foundation

class CurreuncyRateUserDefault {
    private static let lastRefreshedKey = "lastRefreshed"

    class func lastRefreshed() -> Date {
        if UserDefaults.standard.object(forKey: CurreuncyRateUserDefault.lastRefreshedKey) == nil {
            return Date(timeIntervalSince1970: 0)
        } else {
            return UserDefaults.standard.object(forKey: CurreuncyRateUserDefault.lastRefreshedKey) as! Date
        }
    }

    class func setLastRefresh(time: Date) {
        UserDefaults.standard.set(time, forKey: CurreuncyRateUserDefault.lastRefreshedKey)
    }
}
