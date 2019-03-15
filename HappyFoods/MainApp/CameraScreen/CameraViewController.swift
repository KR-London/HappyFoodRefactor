//
//  CameraViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 05/02/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var food: [NSManagedObject] = []
        var foodArray: [Food]!
       
        
        /// where am I using this....?
        let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
    
        /// add swipe gesture recognisers
        
        
        /// populate to core data
        
    }
}
