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

class MaybeCollectionViewController: UICollectionViewController, CommunicationChannel {
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
        print("Maybe")
    }
 
    
    @IBOutlet var maybeCollectionView: UICollectionView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        foodArray = foodArray.filter{ $0.rating == 2}
        
        maybeCollectionView.dragDelegate = self
        maybeCollectionView.dropDelegate = self
        maybeCollectionView.dragInteractionEnabled = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return foodArray.count/2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell

        /// edit this to allow for double depth rows
        let cellContentsIndex = indexPath.row
        if cellContentsIndex <= foodArray.count
        {
            let plate = foodArray[cellContentsIndex]
            cell.displayContent(image: plate.image_file_name ?? "chaos.jpg")
        }
        // Configure the cell
    
        return cell
    }

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
}

extension MaybeCollectionViewController : UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.foodArray[indexPath.row].image_file_name
        let itemProvider = NSItemProvider(object: item! as String as NSItemProviderWriting)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
}

extension MaybeCollectionViewController: UICollectionViewDropDelegate{
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath{
            /// if I reciognise the index path the user is aiming for - stick it there
            destinationIndexPath = indexPath
        }
        else{
            /// if I'm lost - stick in on the end
            if collectionView.numberOfItems(inSection: 0) > collectionView.numberOfItems(inSection: 1)
            {
                destinationIndexPath = IndexPath(row: collectionView.numberOfItems(inSection: 1), section: 1)
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

