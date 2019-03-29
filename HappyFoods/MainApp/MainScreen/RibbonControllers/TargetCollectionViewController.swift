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

    @IBOutlet var targetCollectionView: UICollectionView!
    
    weak var delegate: GiveTickChannel?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var triedFood: [NSManagedObject] = []
    var triedFoodArray: [TriedFood]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // let width = UIScreen.main.bounds.width
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        // change this
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        // layout.collectionView?.contentSize.height = 200
        
        collectionView!.collectionViewLayout = layout

        // Do any additional setup after loading the view.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        // cell.foodImage.image = UIImage(named: "tick.png")
        cell.tickImage.isHidden = true
        
        cell.removeBtnClick.isHidden = true
        
       if triedFoodArray != nil
        {
            if 2*indexPath.section + indexPath.row  < triedFoodArray.count
            {

                let tickedImage = UIImage(named: triedFoodArray[2*indexPath.section + indexPath.row].imageFileName ?? "chaos.jpg")

               cell.foodImage.image = tickedImage

                cell.tickImage.isHidden = false

//                //"tick.jpg"
//             / if longPressedEnabled   {
//                    cell.startAnimate()
//                    cell.tickImage.isHidden = true
//                }
//                else{
//                    longPressedEnabled = false
//                }
//            }
//            else
//            {
//                cell.foodImage.image = nil
//                longPressedEnabled = false
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
    
    public func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    
}
