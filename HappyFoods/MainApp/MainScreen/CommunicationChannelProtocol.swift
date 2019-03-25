import Foundation
import CoreData


//A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements

protocol CommunicationChannel : class {
    // func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
    // func sayHello()
    
    // var draggedFood: Pokemon { get set }
    // here i decide if I add to foods tried this week
    func triage(imageFileName: String, destinationIndexPath: IndexPath, destinationViewController: Ribbon)
    
    // the drop delegate will handle most of this?
    func insertIntoTargetRibbon(draggedFoodFileName: String, destinationIndexPath: IndexPath)
    
    // this is the hard working one
    func removeFromSourceRibbon(imageFileName: String, sourceIndexPath: IndexPath, sourceRibbon: Ribbon)
}

extension MainViewController:CommunicationChannel{
    
    func triage(imageFileName: String, destinationIndexPath: IndexPath, destinationViewController: Ribbon) {
        /// sanity check that we agree what's in transit!
        if triedFood.draggedFoodFileName != imageFileName
        {
            return
        }
        
        let sourceSink = (triedFood.sourceViewController, destinationViewController)
        
        switch sourceSink
        {
      
            case ( .yes, .maybe) :
            
                communicationChannelAmber?.insertIntoTargetRibbon(draggedFoodFileName: imageFileName, destinationIndexPath: destinationIndexPath)
            
                communicationChannelGreen?.removeFromSourceRibbon(imageFileName: imageFileName, sourceIndexPath: triedFood.sourceIndexPath, sourceRibbon: .yes)
            
            break
            
            case (.yes, .no):
                communicationChannelRed?.insertIntoTargetRibbon(draggedFoodFileName: imageFileName, destinationIndexPath: destinationIndexPath)
            
                communicationChannelGreen?.removeFromSourceRibbon(imageFileName: imageFileName, sourceIndexPath: triedFood.sourceIndexPath, sourceRibbon: .yes)
            break
            
            case ( .maybe, .yes) :
            
                communicationChannelGreen?.insertIntoTargetRibbon(draggedFoodFileName: imageFileName, destinationIndexPath: destinationIndexPath)
            
                communicationChannelAmber?.removeFromSourceRibbon(imageFileName: imageFileName, sourceIndexPath: triedFood.sourceIndexPath, sourceRibbon: .maybe)
            
            break
            
            case (.maybe, .no):
                communicationChannelRed?.insertIntoTargetRibbon(draggedFoodFileName: imageFileName, destinationIndexPath: destinationIndexPath)
            
                communicationChannelAmber?.removeFromSourceRibbon(imageFileName: imageFileName, sourceIndexPath: triedFood.sourceIndexPath, sourceRibbon: .maybe)
            break
            
            case ( .no, .yes) :
            
            communicationChannelGreen?.insertIntoTargetRibbon(draggedFoodFileName: imageFileName, destinationIndexPath: destinationIndexPath)
            
            communicationChannelRed?.removeFromSourceRibbon(imageFileName: imageFileName, sourceIndexPath: triedFood.sourceIndexPath, sourceRibbon: .no)
            
            break
            
            case ( .no, .maybe) :
            
                communicationChannelAmber?.insertIntoTargetRibbon(draggedFoodFileName: imageFileName, destinationIndexPath: destinationIndexPath)
            
                communicationChannelRed?.removeFromSourceRibbon(imageFileName: imageFileName, sourceIndexPath: triedFood.sourceIndexPath, sourceRibbon: .no)
            
            break
            
        default: return
        }
        
        
        return
    }
    
    func insertIntoTargetRibbon(draggedFoodFileName: String, destinationIndexPath: IndexPath) {
        /// this one does nothing
        return
    }
    
    func removeFromSourceRibbon(imageFileName: String, sourceIndexPath: IndexPath, sourceRibbon: Ribbon) {
        /// this one has to update the tried food object to keep track of what I'm dragging and where it came from
        triedFood.draggedFoodFileName = imageFileName
        triedFood.sourceIndexPath = sourceIndexPath
        triedFood.sourceViewController = sourceRibbon
        print( triedFood.draggedFoodFileName.description)
        return
    }
}

extension YesCollectionViewController: CommunicationChannel{
    func triage(imageFileName: String, destinationIndexPath: IndexPath, destinationViewController: Ribbon) {
        /// does nothing
        return
    }
    
    func insertIntoTargetRibbon(draggedFoodFileName: String, destinationIndexPath: IndexPath) {
        /// I will put the drop delegate code in here.
        /// I could do it direct in the drop delegate code, but I prefer to deal with it here to reduce the chance of the item being dropped without being removed from the source
        let request : NSFetchRequest<Food> = Food.fetchRequest()
        do{
            let foodArrayFull = try context.fetch(request)
            let draggedFood = foodArrayFull.filter{$0.image_file_name == draggedFoodFileName}.filter{$0.image_file_name != "tick.png"}.first!
            draggedFood.rating = 0
            foodArray.insert(draggedFood, at: destinationIndexPath.row)
        }
        catch{
            print("Error fetching data \(error)")
        }
        
        try!context.save()
        self.yesCollectionView.insertItems(at: [destinationIndexPath])
        return
    }
    
    func removeFromSourceRibbon(imageFileName: String, sourceIndexPath: IndexPath, sourceRibbon: Ribbon) {
        /// this deletes the item from the ribbon.
        self.yesCollectionView.performBatchUpdates({
            foodArray.remove(at: sourceIndexPath.row)
            self.yesCollectionView.deleteItems(at: [sourceIndexPath])
            // self.boxCollectionView.collectionViewLayout.invalidateLayout()
            // self.boxCollectionView.collectionViewLayout.prepare()
            
        })
        
        return
    }
    
    
}

extension TargetCollectionViewController: CommunicationChannel{
    func triage(imageFileName: String, destinationIndexPath: IndexPath, destinationViewController: Ribbon) {
        return
    }
    
    func insertIntoTargetRibbon(draggedFoodFileName: String, destinationIndexPath: IndexPath) {
        return
    }
    
    func removeFromSourceRibbon(imageFileName: String, sourceIndexPath: IndexPath, sourceRibbon: Ribbon) {
        return
    }
    
    
}

extension MaybeCollectionViewController: CommunicationChannel{
    func triage(imageFileName: String, destinationIndexPath: IndexPath, destinationViewController: Ribbon) {
        /// does nothing
        return
    }
    
    func insertIntoTargetRibbon(draggedFoodFileName: String, destinationIndexPath: IndexPath) {
        /// I will put the drop delegate code in here.
        /// I could do it direct in the drop delegate code, but I prefer to deal with it here to reduce the chance of the item being dropped without being removed from the source
        // I need to pull the record out of the database
        let request : NSFetchRequest<Food> = Food.fetchRequest()
        do{
            let foodArrayFull = try context.fetch(request)
            let draggedFood = foodArrayFull.filter{$0.image_file_name == draggedFoodFileName}.filter{$0.image_file_name != "tick.png"}.first!
            draggedFood.rating = 1
            foodArray.insert(draggedFood, at: destinationIndexPath.row)
        }
        catch{
            print("Error fetching data \(error)")
        }
        
        try!context.save()
        self.maybeCollectionView.insertItems(at: [destinationIndexPath])
        return
    }
    
    func removeFromSourceRibbon(imageFileName: String, sourceIndexPath: IndexPath, sourceRibbon: Ribbon) {
        /// this deletes the item from the ribbon.
        /// where do I update food Array...?
        self.maybeCollectionView.performBatchUpdates({
            foodArray.remove(at: sourceIndexPath.row)
            self.maybeCollectionView.deleteItems(at: [sourceIndexPath])
            // self.teamCollectionView.collectionViewLayout.invalidateLayout()
        })
        
        return
    }
}

extension NoCollectionViewController: CommunicationChannel{
    func triage(imageFileName: String, destinationIndexPath: IndexPath, destinationViewController: Ribbon) {
        /// does nothing
        return
    }
    
    func insertIntoTargetRibbon(draggedFoodFileName: String, destinationIndexPath: IndexPath) {
        /// I will put the drop delegate code in here.
        /// I could do it direct in the drop delegate code, but I prefer to deal with it here to reduce the chance of the item being dropped without being removed from the source
        // I need to pull the record out of the database
        let request : NSFetchRequest<Food> = Food.fetchRequest()
        do{
            let foodArrayFull = try context.fetch(request)
            let draggedFood = foodArrayFull.filter{$0.image_file_name == draggedFoodFileName}.filter{$0.image_file_name != "tick.png"}.first!
            draggedFood.rating = 1
            foodArray.insert(draggedFood, at: destinationIndexPath.row)
        }
        catch{
            print("Error fetching data \(error)")
        }
        
        try!context.save()
        self.noCollectionView.insertItems(at: [destinationIndexPath])
        return
    }
    
    func removeFromSourceRibbon(imageFileName: String, sourceIndexPath: IndexPath, sourceRibbon: Ribbon) {
        /// this deletes the item from the ribbon.
        /// where do I update food Array...?
        self.noCollectionView.performBatchUpdates({
            foodArray.remove(at: sourceIndexPath.row)
            self.noCollectionView.deleteItems(at: [sourceIndexPath])
            // self.teamCollectionView.collectionViewLayout.invalidateLayout()
        })
        
        return
    }
}


