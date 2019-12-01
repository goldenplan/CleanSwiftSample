//
//  AppDelegate.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let mainContext = CoreDataStack.sharedInstance.mainContext

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("---------------------------")
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        print("---------------------------")
        
        PillsService().updatePills(context: mainContext)
        
        _ = Coordinator.instance
        
        return true
    }



}

