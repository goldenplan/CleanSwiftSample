//
//  PillsData.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation

struct PillsData: Decodable {
    var id          : Int64
    var name        : String
    var img         : String
    var desription  : String
    var dose        : String
}
