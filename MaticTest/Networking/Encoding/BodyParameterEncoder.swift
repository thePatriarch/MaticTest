//
//  BodyParameterEncoder.swift
//  MaticTest
//
//  Created by Apple on 8/25/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import Foundation

public struct BodyParameterEncoder:ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            var paramStrings = ""
            for (key,value) in parameters {
               paramStrings += "\(key)=\(value)&"
            }
            paramStrings.removeLast()
            let jsonAsData =  paramStrings.data(using: String.Encoding.utf8)
            //data(withJSONObject: parameters)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
        }
       
    }
}
