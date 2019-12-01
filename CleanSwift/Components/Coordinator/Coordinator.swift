//
//  Coordinator.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {

    private var rootNavController: UINavigationController!

    static let instance = Coordinator()

@discardableResult
private init() {
    
        rootNavController = UIStoryboard.root
            .instantiateViewController(withIdentifier: "RootNavController") as! RootNavController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = rootNavController
        appDelegate.window?.makeKeyAndVisible()
    
        detectSuitableVC()
    
    }
    
    func detectSuitableVC(){
        
        addVConNavigationStack(vcType: .FirstScreenController, animated: true, clearStack: true)
    }
    
    func getVC<T>(type: T.Type, controllerType: ControllerType) -> T {
        
        return controllerType.getStoryboard()
            .instantiateViewController(withIdentifier: controllerType.rawValue) as! T
    }
    
    func addVConNavigationStack(vcType: ControllerType, animated: Bool, clearStack: Bool = false){
        
        let type = ControllerType.vcClassType(vcType)
        
        let vc = getVC(type: type.self, controllerType: vcType)
        
        
        if clearStack{
            
            rootNavController.setViewControllers([vc], animated: true)
            
        }else{
            rootNavController.pushViewController(vc, animated: animated)
        }
        
    }
    
}
