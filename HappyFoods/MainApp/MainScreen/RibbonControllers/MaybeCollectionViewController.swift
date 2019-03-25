//
//  MaybeCollectionViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 09/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

private let reuseIdentifier = "maybeCell"

class MaybeCollectionViewController: UICollectionViewController {
 
     weak var delegate: CommunicationChannel?
    
    @IBOutlet var maybeCollectionView: UICollectionView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        collectionView.isPrefetchingEnabled = false
        foodArray = foodArray.filter{ $0.rating == 2}
        self.collectionViewLayout.invalidateLayout()
        //var foodsTriedThisWeek: [(String, IndexPath)]!
        
        maybeCollectionView.dragDelegate = self
        maybeCollectionView.dropDelegate = self
        maybeCollectionView.dragInteractionEnabled = true
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if MAYBE_WIDE == true
        {
            return 2
        }
        else
        {
            return 1
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if MAYBE_WIDE == true
        {
        return foodArray.count/2
        }
        else
        {
            return foodArray.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        var cellContentsIndex = 0

        if MAYBE_WIDE == true
        {
           cellContentsIndex = 2*indexPath.row + indexPath.section
        }
        else
        {
            cellContentsIndex = indexPath.row
        }

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
        foodsTriedThisWeek = [( self.foodArray[indexPath.row].image_file_name ?? "no idea", indexPath, "fromAmber")] + ( foodsTriedThisWeek ?? [])
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

extension MaybeCollectionViewController : UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.foodArray[indexPath.row].image_file_name
        let itemProvider = NSItemProvider(object: item! as String as NSItemProviderWriting)
        //self.collectionView.collectionViewLayout.invalidateLayout()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        foodsTriedThisWeek = [(foodArray[indexPath.row].name, indexPath, "fromMaybeRibbon")]
            ///put this back in a minute
           /// + foodsTriedThisWeek
        print("I just tried \(foodsTriedThisWeek)")

        return [dragItem]
    }
}

extension MaybeCollectionViewController: UICollectionViewDropDelegate{
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath{
            /// if I reciognise the index path the user is aiming for - stick it there
           // destinationIndexPath = indexPath
            destinationIndexPath = indexPath
                //IndexPath(row:0, section: 0)
        }
        else{
            /// if I'm lost - stick in on the end
            if MAYBE_WIDE == true
            {

                if collectionView.numberOfItems(inSection: 0) > collectionView.numberOfItems(inSection: 1)
                {
                    destinationIndexPath = IndexPath(row: collectionView.numberOfItems(inSection: 1), section: 1)
                }
                else
                {
                    destinationIndexPath = IndexPath(row: collectionView.numberOfItems(inSection: 0), section: 0)
                }
            }
            else
            {
                destinationIndexPath = IndexPath(row: collectionView.numberOfItems(inSection: 0), section: 0)
            }
        }
        
        for item in coordinator.items{
            if let snack = item.dragItem.localObject as? String{
                if snack == "" {return}
                
                /// placeholder to add call to delegate to let them know what's going on
                delegate?.updateSourceCellWithASmiley(sourceIndexPath: IndexPath.init(item: 0, section: 0), sourceViewController: "droppingIntoMaybe")
                
                /// insert data into food array if its come from elsewhere
                var draggedFood: Food
                let request : NSFetchRequest<Food> = Food.fetchRequest()
                do{
                    let foodArrayFull = try context.fetch(request)
                    draggedFood = foodArrayFull.filter{$0.image_file_name == snack}.filter{$0.image_file_name != "tick.png"}.first!
                    draggedFood.rating = 2
                    foodArray.insert(draggedFood, at: destinationIndexPath.row)
                }
                catch{
                    print("Error fetching data \(error)")
                }
                
                DispatchQueue.main.async {
                    self.collectionViewLayout.invalidateLayout()
                    self.maybeCollectionView.insertItems(at: [destinationIndexPath])
                 
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

