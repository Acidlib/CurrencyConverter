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
    static var coreDataStoreName = "currencyHistory"
    static var coreDataModel: NSManagedObjectModel = {
        guard let modelURL = Bundle(for: APIManager.self).url(forResource: "currenyHistoryModel", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Can not init currenyHistoryModel CoreData")
        }
        return model
    }()
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext
    
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
            }
            task.resume()
        } catch {
        }
    }
}
