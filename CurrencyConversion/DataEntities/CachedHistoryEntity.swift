//
//  CachedHistoryEntity.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/09.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import CoreData

extension CachedHistoryEntity {
    typealias CurrencyListEntityType = (rate: Double, timestamp: Date, currencyName: String)

    convenience init(_ data: CurrencyListEntityType, context: NSManagedObjectContext) {
        self.init(context: context)
        self.rate = data.rate
        self.timestamp = data.timestamp
        self.currencyName = data.currencyName
    }
}

