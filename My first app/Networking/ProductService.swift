//
//  Networking.swift
//  My first app
//
//  Created by ios02 on 04.03.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import Foundation
import UIKit

protocol RequiredUrl {
    var urlForRequest: String { get set }
}

class ProductService: UIViewController, RequiredUrl {

    static let shared = ProductService()
    var urlForRequest: String = ""

    private struct Constants {
        static let apiKey = "api_key=yGwMYxjzXyrwQd0gSypxbDbV8EXK1YZ2U6hshpAI"
        static let getIDURL = "https://api.nal.usda.gov/ndb/search/"
        static let getNutrientsURL = "https://api.nal.usda.gov/ndb/reports/"
    }

    /// Get request for search and get productID.
    func getID(with query: String, completionHandler: @escaping (_ products: [ProductID]?, _ error: Error?) -> Void) {
        var arrayParameters = [String]()
        arrayParameters.append(Constants.apiKey)
        arrayParameters.append("q=\(query)")
        arrayParameters.append("ds=Standard%20Reference")
        arrayParameters.append("sort=r")
        arrayParameters.append("max=50")
        arrayParameters.append("offset=0")
        arrayParameters.append("format=JSON")

        urlForRequest = Constants.getIDURL
        let combinedParameters = arrayParameters.joined(separator: "&")
        urlForRequest.append("?\(combinedParameters)")

        guard let url = URL(string: urlForRequest) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                        let firstArray = json["list"] as? [String: Any],
                        let jsonArrays = firstArray["item"] as? [[String: Any]]
                        else { return }
                    var result = [ProductID]()
                    for json in jsonArrays {
                        guard let oneProduct = ProductID(json: json) else { return }
                        result.append(oneProduct)
                    }
                    completionHandler(result, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }

    /// Get request to find array with product's nutrients.
    func getNutrients(with productID: String, completionHandler: @escaping (_ nutrients: [ProductNutrients]?, _ error: Error?) -> Void) {

        var arrayParameters = [String]()
        arrayParameters.append(Constants.apiKey)
        arrayParameters.append("ndbno=\(productID)")
        arrayParameters.append("type=b")
        arrayParameters.append("format=JSON")

        urlForRequest = Constants.getNutrientsURL
        let combinedParameters = arrayParameters.joined(separator: "&")
        urlForRequest.append("?\(combinedParameters)")

        guard let url = URL(string: urlForRequest) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                        let firstArray = json["report"] as? [String: Any],
                        let secondArray = firstArray["food"] as? [String: Any],
                        let jsonArrays = secondArray["nutrients"] as? [[String: Any]]
                        else { return }
                    var nutrientArray = [ProductNutrients]()
                    for json in jsonArrays {
                        guard let oneProduct = ProductNutrients(json: json) else { return }
                        nutrientArray.append(oneProduct)
                    }
                   completionHandler(nutrientArray, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
}
