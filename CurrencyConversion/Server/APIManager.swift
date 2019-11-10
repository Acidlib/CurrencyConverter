//
//  APIManager.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/08.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit
import CoreData

let currencylayeraAiKey = "cc89cb9f60d8c11f89a042dd302cf584"

class APIManager: APIManagerProtocol {
    static let shared = APIManager()
    static var coreDataStoreName = "CurrencyDataModel"
    static var coreDataModel: NSManagedObjectModel = {
        guard let modelURL = Bundle(for: APIManager.self).url(forResource: "CurrencyDataModel", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Can not init currenyHistoryModel CoreData")
        }
        return model
    }()

    private let container: NSPersistentContainer
    var context: NSManagedObjectContext
    var allCurrencyList: [CurrencyRateEntity.type] = []

    var selectedCurrencyList: [CurrencyRateEntity.type] = []
    var groupedAllCurrencyList: [Section] = []

    init() {
        container = NSPersistentContainer(name: APIManager.coreDataStoreName, managedObjectModel: APIManager.coreDataModel)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        context = container.newBackgroundContext()
    }

    func makeApiCall(_ input: CHAPICallObject, _ completion: @escaping (CHApiResult) -> Void) {
        do {
            let jsonObj = try JSONSerialization.data(withJSONObject: input.body as Any, options: [])
            var request = URLRequest(url: URL(string: input.urlString)!)
            request.httpMethod = input.request
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.uploadTask(with: request, from: jsonObj) { data, _, error in
                if error != nil || data == nil {
                    completion(.init(success: false, errorDescription: error.debugDescription, data: nil))
                } else if let data = data, let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    completion(.init(success: true, errorCode: nil, errorDescription: nil, data: dict))
                }
            }
            task.resume()
        } catch let error {
            completion(.init(success: false, errorDescription: error.localizedDescription))
        }
    }
}

struct Section {
    let alphabet: String
    var countries: [CurrencyRateEntity.type]
}
