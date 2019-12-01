//
//  FerstScreenController.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import UIKit

class FirstScreenController: UIViewController {

    let mainContext = CoreDataStack.sharedInstance.mainContext
    
    @IBOutlet weak var openButton: UIButton!
    @IBAction func openButtonPressed(_ sender: UIButton) {
        
        Coordinator.instance.addVConNavigationStack(vcType: .DemoViewController, animated: true)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupButton()
        setupNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeNotification()
    }
    
    func setupNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupButton), name: .NSManagedObjectContextDidSave, object: nil)
        
    }
    
    func removeNotification(){
        NotificationCenter.default.removeObserver(self)
    }

    @objc func setupButton(){
        
        openButton.isEnabled = PillsItem.fetchPills(in: mainContext).count > 0
        
    }
    
}
