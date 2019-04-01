//
//  GiveTickChannel.swift
//  HappyFoods
//
//  Created by Kate Roberts on 28/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import Foundation
import CoreData
import MobileCoreServices

protocol GiveTickChannel : class {
    
    
    func giveTick(image_file_name: String) -> Int
    
    func segueToCelebrationScreen()
}

extension MainViewController : GiveTickChannel {
    func segueToCelebrationScreen() {
        return
    }
    
    func giveTick(image_file_name: String) -> Int {
        return 0
    }
}

extension TargetCollectionViewController : GiveTickChannel {
    func segueToCelebrationScreen() {
        return
    }
    
    func giveTick(image_file_name: String) -> Int {
        
            let newlyTriedFood = NSEntityDescription.insertNewObject(forEntityName: "TriedFood", into: context) as! TriedFood
            newlyTriedFood.imageFileName = image_file_name
            newlyTriedFood.dateTried = Date()
        
            targetCollectionView.performBatchUpdates({
                triedFoodArray.append(newlyTriedFood)
                saveItems()
                let sectionIndex = Int((triedFoodArray.count - 1)/2)
                if triedFoodArray.count > 2*targetCollectionView.numberOfSections{
                    //self.targetCollectionView.numberOfSections
                    //  self.targetCollectionView.reloadData()
                    // self.targetCollectionView.reloadInputViews()
                    // self.targetCollectionView.numberOfSections.advanced(by: 1)
                    let newIndexPath = IndexPath(row: triedFoodArray.count - 2*sectionIndex - 1 , section: sectionIndex)
                    self.targetCollectionView.insertSections([sectionIndex])
                    self.targetCollectionView.insertItems(at: [newIndexPath])
                }
                else{
                        for x in 0 ... self.targetCollectionView.numberOfSections - 1{
                            self.targetCollectionView.reloadSections([x])
                        }
                }
            })

        return triedFoodArray?.count ?? 0
        
 }
    
    
}
