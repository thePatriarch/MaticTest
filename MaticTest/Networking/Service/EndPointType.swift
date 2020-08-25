//
//  EndPointType.swift
//  MaticTest
//
//  Created by Apple on 8/25/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}
