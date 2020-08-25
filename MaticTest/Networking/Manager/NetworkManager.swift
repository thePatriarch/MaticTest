//
//  NetworkManager.swift
//  MaticTest
//
//  Created by Apple on 8/25/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import Foundation

struct RequestBaseResult : Decodable {
    
    var total_count: Int?
    var incomplete_results: Bool?
    var items: [Repo]?
}

struct NetworkManager{
    enum NetworkResponse:String {
        case success
        case authenticationError = "You need to be authenticated first."
        case badRequest = "Bad request"
        case outdated = "The url you requested is outdated."
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "We could not decode the response."
    }

    enum Result<String>{
        case success
        case failure(String)
    }
    
    let router = Router<API>()
    
    func getProducts(page: Int,q:String,sort: String,order: String, completion: @escaping (_ product: [Repo]?,_ error: String?)->()){
        router.request(.repos(page: page, q: q, sort: sort, order: order)) { data, response, error in

               if error != nil {
                   completion(nil, error!.localizedDescription)
               }

               if let response = response as? HTTPURLResponse {
                   print(response.statusCode)
                   let result = self.handleNetworkResponse(response)
                   switch result {
                   case .success:
                       guard let responseData = data else {
                           completion(nil, NetworkResponse.noData.rawValue)
                           return
                       }
                       do {
                           print(responseData)
                           let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                           print(jsonData)
                           let apiResponse = try JSONDecoder().decode(RequestBaseResult.self, from: responseData)
                           completion(apiResponse.items,nil)
                       }catch {
                           print(error)
                           completion(nil, NetworkResponse.unableToDecode.rawValue)
                       }
                   case .failure(let networkFailureError):
                       completion(nil, networkFailureError)
                   }
               }
           }
       }
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
