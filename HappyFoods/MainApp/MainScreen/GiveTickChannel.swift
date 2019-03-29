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
    
    
    func giveTick(image_file_name: String)
}

extension MainViewController : GiveTickChannel {
    func giveTick(image_file_name: String) {
        
       tickChannel?.giveTick(image_file_name: image_file_name)
        
        
        return
    }
}

extension TargetCollectionViewController : GiveTickChannel {
    func giveTick(image_file_name: String) {
        
        let newlyTriedFood = NSEntityDescription.insertNewObject(forEntityName: "TriedFood", into: context) as! TriedFood
        newlyTriedFood.imageFileName = image_file_name
        newlyTriedFood.dateTried = Date()
        saveItems()
        self.view.reloadInputViews()
 }
    
    
}
