//
//  Presenter.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation

protocol DemoPresentationLogic {
    func presentData(response: Demo.Model.Response.ResponseType)
}

class DemoPresenter: DemoPresentationLogic {
    
    let mainContext = CoreDataStack.sharedInstance.mainContext
    
    weak var viewController: DemoDisplayLogic?
    
    func presentData(response: Demo.Model.Response.ResponseType) {
    
        switch response {
        case .presentClearData:

            viewController?.displayData(viewModel: .showClearInnerView)
            break
            
        case .presentPagerControlInfo(info: let info):
            
            viewController?.displayData(viewModel: .showControlInfo(info: info))
            break
            
        case .presentSelectedItem(objectId: let objectId):
            
            if let object = try? mainContext.existingObject(with: objectId) as? PillsItem {
                viewController?.displayData(viewModel: .showDataInInnerView(data: object.getInnerDemoData()))
            }
            else {
                print("Can't find object")
                viewController?.displayData(viewModel: .showClearInnerView)
            }
            
            break
      }
    }
    
    
}
