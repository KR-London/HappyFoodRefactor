//
//  TargetCollectionViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 09/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "targetCell"

class TargetCollectionViewController: UICollectionViewController{
    
    /// these variables help me to delete cells
    var longPressGesture = UILongPressGestureRecognizer()
    var isAnimate: Bool! = true
    var longPressedEnabled = false

    @IBOutlet var targetCollectionView: UICollectionView!
    
    @IBAction func RmvButtonClick(_ sender: UIButton) {
                let hitPoint = sender.convert(CGPoint.zero, to: self.collectionView)
                let hitIndex = self.collectionView.indexPathForItem(at: hitPoint)
                let indexOfThisFood = 2*(hitIndex?.section)! + (hitIndex?.row)!
                if indexOfThisFood < triedFoodArray.count
                {
//                    ///delete from core data
////                    if let dataAppDelegatde = UIApplication.shared.delegate as? AppDelegate{
////                        let mngdCntxt = dataAppDelegatde.persistentContainer.viewContext
////                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TriedFood")
////                        let predicate = NSPredicate(format: "imageFileName = %@", triedFoodArray[indexOfThisFood].imageFileName ?? "")
////                        fetchRequest.predicate = predicate
////                            do{
////                                let result = try mngdCntxt.fetch(fetchRequest)
////                                if result.count > 0 {
////                                        mngdCntxt.delete(result.first as! NSManagedObject)
////                                }
////                                else{
////                                    print("that's strange - you tried to delete a picture which didnt exist ")
////                                }
////                            }
////                                catch{  }
//////                                if result.count > 0{
//////                                    for object in result {
//////                                    mngdCntxt.delete(object as! NSManagedObject)
//////                                }
////                           // }
////                        //}catch{  }
////                    }
                    self.targetCollectionView.performBatchUpdates({
                        
                        triedFoodArray.remove(at: indexOfThisFood)
                        saveItems()

                        if self.targetCollectionView.numberOfSections > max((triedFoodArray.count + 1)/2, 4 )
                        {
                            self.targetCollectionView.deleteSections([self.targetCollectionView.numberOfSections - 1 ])
                        }
                    
                      
                        
                    })
                    
                    for x in 0 ... self.targetCollectionView.numberOfSections - 1
                    {
                        self.targetCollectionView.reloadSections([x])
                    }
                    
                    self.reloadInputViews()
                    

                }
     }
    
    var delegate: GiveTickChannel?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var triedFood: [NSManagedObject] = []
    var triedFoodArray: [TriedFood]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        //adding longpress gesture over UICollectionView
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        self.view.addGestureRecognizer(longPressGesture)
        
        // move this to custom tried cell
        let triedCellHeight = min(RIBBON_DEFAULT_HEIGHT/2.31, SCREEN_WIDTH/3.41)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let inset = (SCREEN_WIDTH/4 - triedCellHeight)/2
        
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        
        // change this
        layout.itemSize = CGSize(width: triedCellHeight, height: triedCellHeight)
//layout.minimumInteritemSpacing = triedCellHeight/10
        //layout.minimumLineSpacing = triedCellHeight/10
        layout.scrollDirection = .horizontal
      
        // layout.collectionView?.contentSize.height = 200
        
        collectionView!.collectionViewLayout = layout

        // Do any additional setup after loading the view.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return max(4, ((triedFoodArray?.count ?? 0)+1)/2 )
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! triedCollectionViewCell
        
        cell.tickImage.isHidden = true
        cell.removeBtnClick.isHidden = true
        
        if indexPath.section >= 4
        {
            cell.layer.borderWidth = 0
        }
        
       if triedFoodArray != nil{
            if 2*indexPath.section + indexPath.row  < triedFoodArray.count{

                let tickedImage = UIImage(named: triedFoodArray[2*indexPath.section + indexPath.row].imageFileName ?? "chaos.jpg")

                cell.foodImage.image = tickedImage
                cell.tickImage.isHidden = false

                if longPressedEnabled   {
                    cell.startAnimate()
                    cell.tickImage.isHidden = true
                }
                else{
                    longPressedEnabled = false
                    cell.stopAnimate()

                }
            }
            else{
                cell.foodImage.image = nil
                longPressedEnabled = false
            }
        }
        else{
            cell.stopAnimate()
        }
                // Configure the cell
    
        return cell
    }

    func saveItems(){
        do{ try
            context.save() }
        catch{
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            
        }
    }

    /// MARK: Setup
    func loadItems(){
        let request : NSFetchRequest<TriedFood> = TriedFood.fetchRequest()
        do{
            try
                triedFoodArray = context.fetch(request)
        }
        catch
        {
            print("Error fetching data \(error)")
        }
        
        /// check if this list needs archiving
        if triedFoodArray.count > 0
        {
            for x in 0 ... triedFoodArray.count - 1
            {
                if triedFoodArray[x].dateTried ?? Date() < Date().addingTimeInterval(-604800)
                {
                    archiveTriedFood()
                    return
                }
            }
        }
    }
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        print("Long tap detected")
        switch(gesture.state) {
        case .began:
            print(".began")
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView))
                else { return }
            self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            break
        case .changed:
            print(".changed")
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            break
        case .ended:
            print(".ended")
            self.collectionView.endInteractiveMovement()
            //           // doneBtn.isHidden = false
            longPressedEnabled = !longPressedEnabled
            self.collectionView.reloadData()
            break
            
        default:
            self.collectionView.cancelInteractiveMovement()
            break
            
        }
    }
    
    
    public func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    /// MARK: Archive Functions
    
    func archiveTriedFood(){
        
        
        /// take the earliest tried food date
        
        /// make a database entry linking that date with the count of tried foods that week and the current ratio of yes/no/maybe

        //// open historical tried food.
        
        /// for every member of tried foods
        for food_to_archive in triedFoodArray{
            
            if food_to_archive.imageFileName != nil {
                saveArchive(imageFileName: food_to_archive.imageFileName!)
            }
        }
    
        triedFoodArray = [TriedFood]()
        
        /// search for it in historical tried food
        
        /// if it exists,
            ///increment the counter by 1
            /// delete that record from tried food core data
        
        // if counter is == 10 add this food to the 'do not sneak back, i really don't like this' list.
        //else
            /// create a record with that food & 1
        
        
        
        /// reset tried food as nil
        
    }
    
    
    /// take the earliest tried food date
    
    func saveArchive(imageFileName: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "HistoricalTriedFood",
                                       in: managedContext)!
        
        let food_to_archive = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        food_to_archive.setValue(imageFileName, forKeyPath: "imageFileName")
        
        // 4
        do {
            try managedContext.save()
            //larder.append(food_to_archive)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
}
