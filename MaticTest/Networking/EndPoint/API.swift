//
//  API.swift
//  MaticTest
//
//  Created by Apple on 8/25/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    
    case production
    
}

public enum API {
    
    case repos(page:Int, q:String?, sort: String?, order: String?)
    
}

extension API: EndPointType {
    
    var environmentBaseURL : String {
        return "https://api.github.com/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        return "search/repositories"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
            
        case .repos(let page, let q, let sort, let order):
            
            var params: [String:Any] = [:]
            
            if order != nil{
                params["order"] = order!
            }
            if q != nil{
                params["q"] = q!
            }
            if sort != nil{
                params["sort"] = sort!
            }
            params["page"] = page
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: params)
        }
    }
}
