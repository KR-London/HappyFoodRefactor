//
//  TriedFoodObject.swift
//  collectionViewDragAndDrop
//
//  Created by Kate Roberts on 25/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import Foundation

class TriedFoodsObject{
    
    var foodsTriedThisWeek: [(String?, IndexPath, Ribbon)]!
    var draggedFoodFileName: String
    var sourceIndexPath: IndexPath
    var sourceViewController: Ribbon
   // var draggedFood: Pokemon
    
    /// in my real code i want this linked with core data
    init(){
        foodsTriedThisWeek = nil
        draggedFoodFileName = ""
        sourceIndexPath = IndexPath(item: 0,section: 0)
        sourceViewController = .undefined
       // draggedFoodName = ""
        
    }
}
