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

private let reuseIdentifier = "yesCell"

@IBDesignable
class YesCollectionViewController: UICollectionViewController{
    
    weak var delegate: CommunicationChannel?

    @IBOutlet var yesCollectionView: UICollectionView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionViewLayout.invalidateLayout()
 
   
        loadItems()
        foodArray = foodArray.filter{ $0.rating == 1 }
        
        yesCollectionView.dragDelegate = self
        yesCollectionView.dropDelegate = self
        yesCollectionView.dragInteractionEnabled = true
        
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

extension YesCollectionViewController : UICollectionViewDelegateFlowLayout{
//MARK: - UICollectionViewDelegateFlowLayout

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
{
    return CGSize(width: CELL_HEIGHT, height: CELL_HEIGHT)
}
}

extension YesCollectionViewController : UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.foodArray[indexPath.row].image_file_name
        let itemProvider = NSItemProvider(object: item! as String as NSItemProviderWriting)

        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
       // foodsTriedThisWeek = [( self.foodArray[indexPath.row].image_file_name ?? "no idea", indexPath, "fromGreenRibbon")] + ( foodsTriedThisWeek ?? [])
        
        delegate?.removeFromSourceRibbon(imageFileName: item ?? "", sourceIndexPath: indexPath, sourceRibbon: .yes)
        return [dragItem]
    }
}

extension YesCollectionViewController: UICollectionViewDropDelegate{
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
             
                switch coordinator.proposal.operation
                {
                    case .move:
                        /// i would need to add more here to make the re-ordering persist
                        let sourceIndexPath = coordinator.items.first!.sourceIndexPath
                        let draggedFood = foodArray![(sourceIndexPath?.row)!]
                    
                        //self.boxCollectionView.moveItem(at: sourceIndexPath!, to: destinationIndexPath)
                        yesCollectionView.performBatchUpdates({
                            /// swap the datasource
                            foodArray.remove(at: (sourceIndexPath?.row)!)
                            foodArray.insert(draggedFood, at: destinationIndexPath.row)
                            //swap the view
                            self.yesCollectionView.deleteItems(at: [sourceIndexPath!])
                            self.yesCollectionView.insertItems(at: [destinationIndexPath])
                        })
                        // try!context.save()
                        
                    break
                    
                    case .copy:
                        delegate?.triage(imageFileName: snack, destinationIndexPath: destinationIndexPath, destinationViewController: .yes)
                        
                    break
                    
                    default: return
                }
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
