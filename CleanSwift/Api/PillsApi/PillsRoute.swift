//
//  PillsRoute.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation
import Alamofire

enum PillsRoute: URLRequestConvertible {
    
    static let apiUrl = Settings.Constants.siteURL + "test_task"
    static let testUrl = "https://drive.google.com/uc?authuser=0&id=1HFd96q0htEC6XeFygxVNfpARSijPK40p&export=download"
    
    case getList

    var header: [String:String]{
        switch self {
        case .getList:
            return [:]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getList:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getList:
            return PillsRoute.apiUrl
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getList:
            return [:]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: URL(string: path)!)
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
    
}
