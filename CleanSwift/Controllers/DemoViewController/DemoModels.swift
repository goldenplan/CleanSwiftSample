//
//  Models.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation
import CoreData

enum Demo {
   
  enum Model {
    struct Request {
      enum RequestType {
        case updatePillsInBase
        case selectPillsInControl(selectedItem: DataFromControl?)
      }
    }
    struct Response {
      enum ResponseType {
        case presentSelectedItem(objectId: NSManagedObjectID)
        case presentClearData
        case presentPagerControlInfo(info: PagerControlInfo)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case showClearInnerView
        case showDataInInnerView(data: InnerDemoViewData)
        case showControlInfo(info: PagerControlInfo)
      }
    }
  }
}
