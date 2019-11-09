//
//  APIManagerProtocol.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/08.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit

protocol APIManagerProtocol: class {
    func makeApiCall(_ input: CHAPICallObject, _ completion: @escaping (_ :CHApiResult) -> Void)
}

struct CHAPICallObject {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put =  "PUT"
        case delete = "DELETE"
    }

    var request: String
    var body: NSDictionary?
    var query: [AnyHashable: Any]?
    var urlString: String

    init(_ method: Method, _ urlString: String, _ body: NSDictionary? = nil) {
        self.request = method.rawValue
        self.urlString = urlString
        self.body = body
    }

    init(_ method: Method, _ urlString: String, queryParameters: [AnyHashable: Any]) {
        self.request = method.rawValue
        self.urlString = urlString
        self.query = queryParameters
    }
}

public struct CHApiResult {
    var success: Bool
    var errorCode: Int?
    var errorDescription: String?
    var data: Any?

    init(success: Bool, errorCode: Int? = nil, errorDescription: String? = nil, data: Any? = nil) {
        self.success = success
        self.errorDescription = errorDescription
        self.data = data
    }
}
