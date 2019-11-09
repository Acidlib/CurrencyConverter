//
//  CurrencyListEntity.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/09.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import CoreData

extension SelectedCurrencyListEntity {
    convenience init(_ currencyNameAbbr: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.currencyNameAbbr = currencyNameAbbr
    }
}
