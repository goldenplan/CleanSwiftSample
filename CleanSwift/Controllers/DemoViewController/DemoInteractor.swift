//
//  Interactor.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation

protocol DemoBusinessLogic {
    func makeRequest(request: Demo.Model.Request.RequestType)
}

class DemoInteractor: DemoBusinessLogic{

    let mainContext = CoreDataStack.sharedInstance.mainContext
    
    var service = PillsService()
    var presenter: DemoPresentationLogic?
    
    func makeRequest(request: Demo.Model.Request.RequestType) {
        
        switch request {
        case .updatePillsInBase:
            
            service.updatePills(context: mainContext)
            
        case .selectPillsInControl(let dataFromControl):
            
            guard dataFromControl != nil else {return}
            
            let pagerInfo = PagerControlInfo(
                currentIndex: dataFromControl!.index,
                count: dataFromControl!.count)
            
            presenter?.presentData(response: .presentPagerControlInfo(info: pagerInfo))
            
            presenter?.presentData(response: .presentSelectedItem(objectId: dataFromControl!.objectId))
            break
        }
    }
    
}
