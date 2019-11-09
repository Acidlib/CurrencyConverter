//
//  APIManager+DataModel.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/09.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import CoreData

extension APIManager {
    func loadAbbrDictionary() {
        let path = Bundle.main.path(forResource: "currency_abbr", ofType: "txt")
        if let path = path {
            var contents: String
            do {
                contents = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
            } catch {
                contents = ""
            }
            let array = contents.components(separatedBy: "\n")
            var dict: [String: String] = [:]
            _ = array.map({
                let arrContext = $0.components(separatedBy: ",")
                if arrContext.count == 2 {
                    dict[arrContext[1]] = arrContext[0]
                }
            })
            abbrDictionary = dict
        }
    }

    func loadLocalCurrencyRate() {
        let fetchRequest = NSFetchRequest<CurrencyRateEntity>(entityName: "CurrencyRateEntity")
        do {
            let fetchedArray = try context.fetch(fetchRequest)
            if fetchedArray.count == 0 {
                self.requestCurrenctRate()
            } else {
                _ = fetchedArray.map({
                    if $0.abbr != nil {
                        allCurrencyList.append(CurrencyRateEntity.type(rate: $0.rate, timestamp: $0.timestamp, abbr: $0.abbr!, currencyName: $0.currencyName!, selected: $0.selected))
                    }
                })
            }
            let groupedList = Dictionary(grouping: allCurrencyList, by: { $0.currencyName.prefix(1) })
            let keys = groupedList.keys.sorted()
            groupedAllCurrencyList = keys.map({
                Section(alphabet: String($0), countries: groupedList[$0]!)
            })
            loadSelectedArray()
        } catch let error {
            print("fetch failed:\(error), \(error.localizedDescription)")
        }
    }

    func requestCurrenctRate() {
        let callObj = CHAPICallObject(.post, "http://www.apilayer.net/api/live?access_key=\(currencylayeraAiKey)", [:])
        self.makeApiCall(callObj, { [weak self] result in
            if result.success {
                if let dict = result.data as? [String: Any],
                    let timestamp = dict["timestamp"] as? TimeInterval,
                    let result = dict["quotes"] as? [String: Double] {
                    self?.saveCurrencyRateToDatamodel(dictionary: result, timestamp: timestamp)
                } else {
                    print("Ooops, parsing api result failed")
                }
            } else {
                print("Ooops, API request failed: \(result.errorDescription ?? "unknwon error")")
            }
        })
    }

    func saveCurrencyRateToDatamodel(dictionary: [String: Double], timestamp: TimeInterval) {
        do {
            _ = try dictionary.map({ (arg0) in
                let (key, value) = arg0
                let abbr = String(key.suffix(3))
                let request = NSFetchRequest<CurrencyRateEntity>(entityName: "CurrencyRateEntity")
                request.predicate = NSPredicate(format: "abbr == %@", abbr)
                let existedData = try context.fetch(request)
                if existedData.count > 0 {
                    existedData.forEach({
                        $0.rate = value
                    })
                } else {
                    // create default selection
                    let defaultSelection = ["USD", "EUR", "JPY", "GBP"]
                    let selected = defaultSelection.contains(abbr)
                    if let cn = abbrDictionary[abbr] {
                        let entityType = CurrencyRateEntity.type(rate: value, timestamp: Double(timestamp), abbr: abbr, currencyName: cn, selected: selected)
                        _ = CurrencyRateEntity(entityType, context: context)
                        allCurrencyList.append(entityType)
                    }
                }
            })

            // temp: should be optimized (using CoreData notify rather than cached array):
            let groupedList = Dictionary(grouping: allCurrencyList, by: { $0.currencyName.prefix(1) })
            let keys = groupedList.keys.sorted()
            groupedAllCurrencyList = keys.map({
                Section(alphabet: String($0), countries: groupedList[$0]!)
            })
            loadSelectedArray()

            // finished data arrangement, notify
            NotificationCenter.default.post(name: .rateDidUpdate, object: nil)
            try context.save()
        } catch {
            print("save currency rate to model failed")
        }
    }

    func loadSelectedArray() {
        let fetchRequest = NSFetchRequest<CurrencyRateEntity>(entityName: "CurrencyRateEntity")
        fetchRequest.predicate = NSPredicate(format: "selected == %d", true)
        do {
            let fetchResult = try context.fetch(fetchRequest)
            _ = fetchResult.map({
                if $0.abbr != nil {
                    selectedCurrencyList.append(CurrencyRateEntity.type(rate: $0.rate, timestamp: $0.timestamp, abbr: $0.abbr!, currencyName: $0.currencyName!, selected: $0.selected))
                }
            })
        } catch let error {
            print("fetch failed:\(error), \(error.localizedDescription)")
        }
    }

    func didSelectCurrency(section: Int, entity: CurrencyRateEntity.type) {
        let fetchRequest = NSFetchRequest<CurrencyRateEntity>(entityName: "CurrencyRateEntity")
        fetchRequest.predicate = NSPredicate(format: "abbr == %@", entity.abbr)
        do {
            // local save
            let fetchResult = try context.fetch(fetchRequest)
            _ = fetchResult.map({
                $0.selected = ($0.selected) ? false : true
            })
            // cache data
            if entity.selected {
                if let index = selectedCurrencyList.firstIndex(where: { $0.abbr == entity.abbr }) {
                    selectedCurrencyList.remove(at: index)
                }
            } else {
                selectedCurrencyList.append(entity)
            }

            if let index = groupedAllCurrencyList[section].countries.firstIndex(where: { $0.abbr == entity.abbr }) {
                var copy = groupedAllCurrencyList[section].countries[index]
                copy.selected = !entity.selected
                groupedAllCurrencyList[section].countries.remove(at: index)
                groupedAllCurrencyList[section].countries.insert(copy, at: index)
            }
            if let index = allCurrencyList.firstIndex(where: { $0.abbr == entity.abbr }) {
                allCurrencyList[index].selected = entity.selected ? false : true
            }
        } catch {
            print("selection failed:\(error), \(error.localizedDescription)")
        }
    }
}

extension Notification.Name {
    static var rateDidUpdate: Notification.Name { return .init(rawValue: "api.rateDidUpdate") }
}
