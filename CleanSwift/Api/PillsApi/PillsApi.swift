//
//  PillsApi.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation
import Alamofire

class PillsApi {
    
    static let shared = PillsApi()
    
    func getList(completion:@escaping (Result<[PillsData]>)->Void){
        
        let route = PillsRoute.getList
        //PillsRoute.testUrl
        Alamofire.request(route).responseJSON { (response) in
            
//            print("Запрос пошел \(String(describing: response.request))")
//            print("Ответ пришел \(String(describing: response.result.value))")
            
            guard response.result.isSuccess
            else {
                    completion(Result.failure(
                        ApiError.ServerNotAvailable))
                    return
            }
            
            guard
                let answer = try? JSONDecoder().decode(
                    ApiResponse<[PillsData]>.self,
                    from: response.data!),
                answer.status == StatusCode.Ok.rawValue
            else {
                    completion(Result.failure(
                        ApiError.WrongAnswer))
                    return
            }
            
            completion(Result.success(answer.pills))
            
        }
        
    }

}
