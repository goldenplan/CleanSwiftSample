//
//  ControllerType.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation
import UIKit

enum ControllerType: String {
    case DemoViewController     = "DemoViewController"
    case RootNavController      = "RootNavController"
    case FirstScreenController  = "FirstScreenController"
    
    
    func getStoryboard() -> UIStoryboard{
            
            switch self {
            case .DemoViewController:
                return UIStoryboard(name: self.rawValue, bundle: nil)
            case .RootNavController:
                return UIStoryboard(name: self.rawValue, bundle: nil)
            case .FirstScreenController:
                return UIStoryboard(name: self.rawValue, bundle: nil)
            }
            
        }
        
        static func vcClassType(_ byType: ControllerType) -> UIViewController.Type{
            return Converter.getvcClassType(byType)
        }
        
    }

    fileprivate struct Converter{
        
        static func getvcClassType(_ byType: ControllerType) -> UIViewController.Type{
            
            switch byType {
            case .RootNavController:
                return RootNavController.self
            case .DemoViewController:
                return DemoViewController.self
            case .FirstScreenController:
                return FirstScreenController.self
            
            }
            
        }
        
}
