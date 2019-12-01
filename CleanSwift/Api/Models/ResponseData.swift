//
//  ResponseData.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation

struct ApiResponse<T:Decodable>: Decodable {
    var status  : String
    var pills    : T
}
