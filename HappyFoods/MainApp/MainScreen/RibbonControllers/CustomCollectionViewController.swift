//
//  YesCollectionViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 09/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

private let reuseIdentifier = "noCell"

@IBDesignable
class CustomCollectionViewController: UICollectionViewController{
    
    weak var delegate: CommunicationChannel?
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewLayout.invalidateLayout()
        
        print(self.restorationIdentifier ?? "I don't know.")
        
        loadItems()
        foodArray = foodArray.filter{ $0.rating == 3 }
        myCollectionView.dragDelegate = self
        myCollectionView.dropDelegate = self
        myCollectionView.dragInteractionEnabled = true
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        let cellContentsIndex = indexPath.row
        if cellContentsIndex <= foodArray.count
        {
            let plate = foodArray[cellContentsIndex]
            cell.displayContent(image: plate.image_file_name ?? "chaos.jpg")
        }
        
        return cell
    }
    
    /// MARK: Drag and drop helper functions
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem]{
        let sampledFood = foodArray[indexPath.section]
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all){
            completion in
            let data = sampledFood.name?.data(using: .utf8)
            completion(data, nil)
            return nil
        }
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
       // foodsTriedThisWeek = [( self.foodArray[indexPath.row].image_file_name ?? "no idea", indexPath, "fromGreen")] + ( foodsTriedThisWeek ?? [])
        dragItem.localObject = sampledFood
        return [dragItem]
    }
    
    /// MARK: Setup
    func loadItems(){
        let request : NSFetchRequest<Food> = Food.fetchRequest()
        do{
            try
                foodArray = context.fetch(request)
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

extension CustomCollectionViewController : UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.foodArray[indexPath.row].image_file_name
        let itemProvider = NSItemProvider(object: item! as String as NSItemProviderWriting)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
       // foodsTriedThisWeek = [( self.foodArray[indexPath.row].image_file_name ?? "no idea", indexPath, "fromGreenRibbon")] + ( foodsTriedThisWeek ?? [])
        
        return [dragItem]
    }
}

extension CustomCollectionViewController: UICollectionViewDropDelegate{
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath{
            /// if I reciognise the index path the user is aiming for - stick it there
            destinationIndexPath = indexPath
        }
        else{
            /// if I'm lost - stick in on the end
            destinationIndexPath = IndexPath(row: collectionView.numberOfItems(inSection: 0), section: 0)
        }
        
        for item in coordinator.items{
            if let snack = item.dragItem.localObject as? String{
                if snack == "" {return}
                
            
                /// insert data into food array if its come from elsewhere
                var draggedFood: Food
                let request : NSFetchRequest<Food> = Food.fetchRequest()
                do{
                    let foodArrayFull = try context.fetch(request)
                    draggedFood = foodArrayFull.filter{$0.image_file_name == snack}.filter{$0.image_file_name != "tick.png"}.first!
                    draggedFood.rating = 1
                    foodArray.insert(draggedFood, at: destinationIndexPath.row)
                }
                catch{
                    print("Error fetching data \(error)")
                }
                
                DispatchQueue.main.async {
                    self.myCollectionView.insertItems(at: [destinationIndexPath])
                }
                
                /// right now it's not deleting the dragged item - but i think that's handled by the delegate so I will leave it. Database seems to be correct.
                
            }
        }
    }
    
    func  collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        //// three scenarios to deal with: drop object comiong from this VC, drop object coming from other VC, or its all gone a bit mad and you are trying to drag more than one object at once
        if collectionView.hasActiveDrag{
            if session.items.count > 1 {
                return UICollectionViewDropProposal(operation: .cancel)
            }
            else{
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        }
        else{
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        
    }
    
    
}
