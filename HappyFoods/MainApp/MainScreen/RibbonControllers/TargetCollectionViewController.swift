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
                    ///delete from core data
                    if let dataAppDelegatde = UIApplication.shared.delegate as? AppDelegate{
                        let mngdCntxt = dataAppDelegatde.persistentContainer.viewContext
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TriedFood")
                        let predicate = NSPredicate(format: "imageFileName = %@", triedFoodArray[indexOfThisFood].imageFileName ?? "")
                        fetchRequest.predicate = predicate
                            do{
                                let result = try mngdCntxt.fetch(fetchRequest)
                                if result.count > 0 {
                                        mngdCntxt.delete(result.first as! NSManagedObject)
                                }
                                else{
                                    print("that's strange - you tried to delete a picture which didnt exist ")
                                }
                            }
                                catch{  }
//                                if result.count > 0{
//                                    for object in result {
//                                    mngdCntxt.delete(object as! NSManagedObject)
//                                }
                           // }
                        //}catch{  }
                    }
                    triedFoodArray.remove(at: indexOfThisFood)
                    //self.collectionView.reloadData()
                  
                    saveItems()
                     // self.targetCollectionView.reloadInputViews()
//                    self.targetCollectionView.reloadSections([(hitIndex?.section)!])
                    self.targetCollectionView.reloadSections([0,1,2,3])
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
        
        let triedCellHeight = min(RIBBON_DEFAULT_HEIGHT/2.31, SCREEN_WIDTH/3.41)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
       
        
       layout.sectionInset = UIEdgeInsets(top: triedCellHeight/10, left: triedCellHeight/10, bottom: triedCellHeight/10, right: triedCellHeight/10)
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
        return max(4, (triedFoodArray.count+1)/2)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! triedCollectionViewCell
        
        // cell.foodImage.image = UIImage(named: "tick.png")
        cell.tickImage.isHidden = true
        cell.removeBtnClick.isHidden = true
        
        cell.layer.borderWidth = 1.0
       // cell.layer.borderColor = UIColor.white as! CGColor
        
       if triedFoodArray != nil
        {
            if 2*indexPath.section + indexPath.row  < triedFoodArray.count
            {

                let tickedImage = UIImage(named: triedFoodArray[2*indexPath.section + indexPath.row].imageFileName ?? "chaos.jpg")

               cell.foodImage.image = tickedImage

                cell.tickImage.isHidden = false

//                //"tick.jpg"
              if longPressedEnabled   {
                    cell.startAnimate()
                    cell.tickImage.isHidden = true
                }
                else{
                    longPressedEnabled = false
                }
            }
            else
            {
                cell.foodImage.image = nil
                longPressedEnabled = false
      }
        }
        else
        {
            // cell.stopAnimate()
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
            //            guard let selectedIndexPath = imgcollection.indexPathForItem(at: gesture.location(in: imgcollection)) else {
            //                return
            //            }
        //            imgcollection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            print(".changed")
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            break
        //            imgcollection.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
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

    
}
