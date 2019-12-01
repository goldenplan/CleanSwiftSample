//
//  DemoView.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import UIKit
import CoreData

typealias InnerDemoViewData = (objectId: NSManagedObjectID, title: String, description: String)

class InnerDemoView: UIView {

    @IBOutlet var contentView: UIView!
    
    fileprivate var currentObjectId: NSManagedObjectID? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("InnerDemoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupOrClear()
        
    }
    
    func setupOrClear(){
        
        currentObjectId = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
        
    }
    
    fileprivate func show(animated: Bool = true){
        UIView.animate(withDuration: animated ? 0.3 : 0) { [weak self] in
            self?.contentView.alpha = 1
        }
    }
    
    fileprivate func hide(animated: Bool = true, with completion: ((Bool) -> ())? = nil){
        
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            
            [weak self] in
            
            self?.contentView.alpha = 0
            
        }, completion: completion)
        
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            
            [weak self] in
            
            self?.contentView.alpha = 0
            
        }
    }
    
    func update(with data: InnerDemoViewData){
        
        hide(animated: currentObjectId != nil, with: { [weak self] _ in
            
            guard let strongSelf = self else { return }
            
            strongSelf.currentObjectId = data.objectId
            strongSelf.titleLabel.text = data.title
            strongSelf.descriptionLabel.text = data.description
            strongSelf.show()
        })
        
        
    }
    
}
