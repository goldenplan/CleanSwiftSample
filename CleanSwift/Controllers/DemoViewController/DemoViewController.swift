//
//  ViewController.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

typealias PagerControlInfo = (currentIndex: Int, count: Int)

protocol DemoDisplayLogic: class {
    func displayData(viewModel: Demo.Model.ViewModel.ViewModelData)
}

class DemoViewController: UIViewController {
    
    fileprivate var interactor: DemoBusinessLogic?
    fileprivate var router: (NSObjectProtocol & DemoRoutingLogic)?
    
    fileprivate var collectionViewControl: DemoCollectonViewControlProtocol!
    
    fileprivate var didSetupConstraints = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var inneDemoView: InnerDemoView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        collectionViewControl.showNext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        setupCollectionViewControl()
        
        addNavBarItem()
        
        setupViewAndColorize()
        
        view.setNeedsUpdateConstraints()
        
    }
    
    override func updateViewConstraints() {
        setupConstraintsIfNeed()
        super.updateViewConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewControl.setupLayoutIfNeed()
    }
    
    private func setup() {
      let viewController        = self
      let interactor            = DemoInteractor()
      let presenter             = DemoPresenter()
      let router                = DemoRouter()
      viewController.interactor = interactor
      viewController.router     = router
      interactor.presenter      = presenter
      presenter.viewController  = viewController
      router.viewController     = viewController
    }
    
    fileprivate func setupConstraintsIfNeed(){
        
        if (!didSetupConstraints) {
        
            nextButton.snp.makeConstraints { (make) -> Void in
                make.trailing.equalTo(self.view).inset(50)
                make.bottom.equalTo(self.view).inset(50)
            }
            
            inneDemoView.snp.makeConstraints { (make) -> Void in
                make.leading.trailing.equalTo(self.view).inset(16)
                make.height.equalTo(200)
                make.bottom.equalTo(self.nextButton).offset(-50)
            }
            
            pageIndicator.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.inneDemoView.snp.top)
            }
            
            collectionView.snp.makeConstraints { (make) -> Void in
                
                make.leading.trailing.equalTo(0)
                make.top.equalTo(self.view).inset(88)
                make.bottom.equalTo(pageIndicator.snp.top)
                
            }
                
            didSetupConstraints = true
            
        }
        
    }
    
    fileprivate func setupCollectionViewControl(){
        
        collectionViewControl = DemoCollectonViewControl(
            collectionView: collectionView, action: {
                
                [weak self] action in
                
                guard let strongSelf = self else { return }
                
                switch action{
                case .selectItem(data: let selectedItem):
                    
                    strongSelf.interactor?.makeRequest(request: .selectPillsInControl(selectedItem: selectedItem))
                    break
                case .updateItem(data: let selectedItem):
                    
                    strongSelf.interactor?.makeRequest(request: .selectPillsInControl(selectedItem: selectedItem))
                    break
                case .noData:
                    
                    break
                }
                
                
        })
        
    }
    
    fileprivate func setupViewAndColorize(){
        
        collectionView.backgroundView = nil
        collectionView.backgroundColor = .clear
        
        inneDemoView.backgroundColor = .clear
        
        nextButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true
        
    }
    
    fileprivate func addNavBarItem(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonPressed))
        
    }

    @objc fileprivate func refreshButtonPressed() {
        
        interactor?.makeRequest(request: .updatePillsInBase)
    }
    
}

extension DemoViewController: DemoDisplayLogic{
    
    func displayData(viewModel: Demo.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .showClearInnerView:
            
            inneDemoView.setupOrClear()
            break
        case .showControlInfo(info: let controlInfo):
            
            pageIndicator.currentPage = controlInfo.currentIndex
            pageIndicator.numberOfPages = controlInfo.count
            break
        case .showDataInInnerView(data: let data):
            
            inneDemoView.update(with: data)
            break
        }
        
    }
    
}
