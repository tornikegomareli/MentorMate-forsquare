//
//  FourSquareApiClient.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 11.11.21.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum FoursquareClientError: Error {
    case connectionError(Error)
    case responseParseError(Error)
    case apiError(FoursquareAPIError)
}

public struct FoursquareAPIError: Error {
    public let errorType: String
    public let errorDetail: String
    
    init(json: Any) {
        guard let dictionary = json as? [String : Any] else {
            fatalError("Invalid json: \(json).")
        }
        
        guard let meta = dictionary["meta"] as? [String : Any] else {
            fatalError("meta section not found: \(json).")
        }
        
        guard let errorType = meta["errorType"] as? String else {
            fatalError("errorType not found: \(json).")
        }
        
        guard let errorDetail = meta["errorDetail"] as? String else {
            fatalError("errorDetail not found: \(json).")
        }
        
        self.errorType = errorType
        self.errorDetail = errorDetail
    }
}

public class FoursquareAPIClient {
    
    private let kAPIBaseURLString = "https://api.foursquare.com/v2/"
    
    private var session: URLSession
    private let accessToken: String?
    private let clientId: String?
    private let clientSecret: String?
    private let version: String
    
    public init(accessToken: String, version: String = "20160813") {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        self.session = URLSession(configuration: configuration,
                                  delegate: nil,
                                  delegateQueue: OperationQueue.main)
        self.accessToken = accessToken
        self.clientId = nil
        self.clientSecret = nil
        self.version = version
    }
    
    public init(clientId: String, clientSecret: String, version: String = "20171010") {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        self.session = URLSession(configuration: configuration,
                                  delegate: nil,
                                  delegateQueue: OperationQueue.main)
        self.accessToken = nil
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.version = version
    }
    
    public func request(path: String,
                        method: HTTPMethod = .get,
                        parameter: [String: String],
                        completion: @escaping (Result<Data, FoursquareClientError>) -> Void) {
        // Add necessary parameters
        var parameter = parameter
        if let accessToken = self.accessToken {
            parameter["oauth_token"] = accessToken
        } else if let clientId = self.clientId, let clientSecret = self.clientSecret {
            parameter["client_id"] = clientId
            parameter["client_secret"] = clientSecret
        }
        parameter["v"] = self.version
        
        let request: NSMutableURLRequest
        
        if method == .post {
            let urlString = kAPIBaseURLString + path
            guard let url = URL(string: urlString as String) else {
                print("Invalid URL: ", urlString)
                return
            }
            request = NSMutableURLRequest(url: url)
            request.httpMethod = method.rawValue
            request.httpBody = buildQueryString(fromDictionary: parameter).data(using: String.Encoding.utf8)
        } else {
            let urlString = kAPIBaseURLString + path + "?" + buildQueryString(fromDictionary: parameter)
            guard let url = URL(string: urlString as String) else {
                print("Invalid URL: ", urlString)
                return
            }
            request = NSMutableURLRequest(url: url)
            request.httpMethod = method.rawValue
        }
        
        let task = self.session.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            switch (data, response, error) {
                case (_, _, let error?):
                    completion(.failure(.connectionError(error)))
                case (let data?, let response?, _):
                    if case (200..<300)? = (response as? HTTPURLResponse)?.statusCode {
                        completion(.success(data))
                    } else {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            completion(.failure(.apiError(FoursquareAPIError(json: json))))
                        } catch {
                            completion(.failure(.responseParseError(error)))
                        }
                    }
                default:
                    fatalError("invalid response combination \(data.debugDescription), \(response.debugDescription), \(error.debugDescription).")
            }
        })
        
        task.resume()
    }
    
    private func buildQueryString(fromDictionary parameters: [String: String]) -> String {
        var urlVars = [String]()
        for (key, val) in parameters {
            if let val = val.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                urlVars += [key + "=" + "\(val)"]
            }
        }
        return urlVars.joined(separator: "&")
    }
}
