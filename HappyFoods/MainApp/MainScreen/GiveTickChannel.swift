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
        
       tickChannel?.giveTick(image_file_name: image_file_name)
        
        //// shall i use this place to trigger the segue to the celebration screen, when the tried foods are filled up..?
        
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
            let sectionIndex = Int((triedFoodArray.count - 1)/2)
            if triedFoodArray.count > 8
            {
                //self.targetCollectionView.numberOfSections
                self.targetCollectionView.reloadData()
                self.targetCollectionView.reloadInputViews()
                self.targetCollectionView.numberOfSections.advanced(by: 1)
            }
            //self.targetCollectionView.reloadSections([sectionIndex])
        })
        
        saveItems()
        
        return triedFoodArray?.count ?? 0
        
 }
    
    
}
