//
//  CurrencyRateEntity.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/09.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import CoreData

extension CurrencyRateEntity {
    typealias type = (rate: Double, timestamp: Double, abbr: String, currencyName: String, selected: Bool)
    convenience init(_ data: CurrencyRateEntity.type, context: NSManagedObjectContext) {
        self.init(context: context)
        self.rate = data.rate
        self.timestamp = data.timestamp
        self.abbr = data.abbr
        self.currencyName = data.currencyName
        self.selected = data.selected
    }
}
