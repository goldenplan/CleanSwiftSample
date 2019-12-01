//
//  DemoCollectonViewDelegate.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum DemoControlActionType {
    case selectItem(data: DataFromControl)
    case updateItem(data: DataFromControl)
    case noData
}

typealias DataFromControl = (index: Int, count: Int, objectId: NSManagedObjectID)
typealias SelectorAction = (DemoControlActionType) -> ()

protocol DemoCollectonViewControlProtocol {
    func showNext()
    func setupLayoutIfNeed()
}

class DemoCollectonViewControl: NSObject{
    
    fileprivate var isLayoutUpdated = false
    
    fileprivate var collectionView: UICollectionView!
    
    fileprivate var action: SelectorAction!
    
    fileprivate var selectedIndex : Int? = nil{
        didSet{
            
            guard selectedIndex != nil else {
                action(.noData)
                return
            }

            sendAction(with: selectedIndex!)
            
        }
    }
    
    fileprivate var pageSize: CGSize {
            let layout = self.collectionView.collectionViewLayout as! CenteredFlowLayout
            var pageSize = layout.itemSize
            pageSize.width += layout.minimumLineSpacing
            return pageSize
        }
    
    fileprivate var fetchRC: NSFetchedResultsController<PillsItem>!
    
    fileprivate let mainContext = CoreDataStack.sharedInstance.mainContext
    
    init(collectionView: UICollectionView, action: @escaping SelectorAction) {
        super.init()
        
        self.collectionView = collectionView
        self.action = action
        
        setupCollectionView()
        
        setupFRC()
    }
    
    fileprivate func setupCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: DemoCell.cellId, bundle: nil), forCellWithReuseIdentifier: DemoCell.cellId)
        
    }
        
    fileprivate func setupFRC(){
        
        let fetchRequest = PillsItem.getFetchRequst(in: mainContext)
        
        fetchRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchRC.delegate = self
        
        do {
            
            try fetchRC.performFetch()
            
            if fetchRC.fetchedObjects!.count > 0{
                selectedIndex = 0
            }
            
        } catch {
            print(error)
        }
        
    }
    
    fileprivate func detectIndex(_ scrollView: UIScrollView){
        let pageSide = self.pageSize.width
        let offset = scrollView.contentOffset.x
        let index = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        if index != selectedIndex {
            selectedIndex = index
        }
    }
    
    fileprivate func sendAction(with index: Int){
        
        let data = DataFromControl(index: index, count: fetchRC.fetchedObjects!.count, objectId: fetchRC.object(at: IndexPath(row: index, section: 0)).objectID)
        action(.selectItem(data: data))
        
    }
    
    fileprivate func configureCell(cell: DemoCell, with pillsItem: PillsItem){

        cell.imageLink = pillsItem.img
        
    }
    
}

extension DemoCollectonViewControl: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        selectedIndex = indexPath.row
    }
    
}

extension DemoCollectonViewControl: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchRC.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DemoCell.cellId, for: indexPath) as! DemoCell
        
        let pillsItem = fetchRC.object(at: indexPath)
        
        configureCell(cell: cell, with: pillsItem)
        
        return cell
    }
    
}

extension DemoCollectonViewControl: UIScrollViewDelegate{
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        detectIndex(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        detectIndex(scrollView)
    }
    
}

extension DemoCollectonViewControl: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if controller.fetchedObjects == nil || controller.fetchedObjects?.count == 0{
            selectedIndex = nil
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
            
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            
            collectionView.deleteItems(at: [indexPath!])
            break
        case .move:
            
            if let indexPath = indexPath {
                collectionView.deleteItems(at: [indexPath])
            }
            if let newIndexPath = newIndexPath {
                collectionView.insertItems(at: [newIndexPath])
            }
            
            break
        case .update:
            print("update")
            if let indexPath = indexPath {
                
                if indexPath.row == selectedIndex{
                    sendAction(with: selectedIndex!)
                }
                
                let pillsItem = fetchRC.object(at: indexPath)
                guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCell else { break }
                configureCell(cell: cell, with: pillsItem)
            }
            break
        @unknown default:break
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        
    }
    
}

extension DemoCollectonViewControl: DemoCollectonViewControlProtocol{
    
    func setupLayoutIfNeed() {
        
        guard !isLayoutUpdated else { return }
        
        let layout = self.collectionView.collectionViewLayout as! CenteredFlowLayout
        layout.itemSize = CGSize(
            width: collectionView.bounds.width / 6 * 4,
            height: collectionView.bounds.height)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        
        isLayoutUpdated = true
    
    }
    
    func showNext(){
        
        guard selectedIndex != nil else { return }
        
        if fetchRC.fetchedObjects!.count - 1 == selectedIndex{
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        }else{
            collectionView.scrollToItem(at: IndexPath(row: selectedIndex! + 1, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
    
}
