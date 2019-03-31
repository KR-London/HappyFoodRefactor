import Foundation
import CoreData


//A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements

protocol CommunicationChannel : class {

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
                
                let tickCount  = tickChannel?.giveTick(image_file_name: imageFileName) ?? 0
                if tickCount == 8 { performSegue(withIdentifier: "celebration", sender: self)}
            break
            
            case (.maybe, .no):
                communicationChannelRed?.insertIntoTargetRibbon(draggedFoodFileName: imageFileName, destinationIndexPath: destinationIndexPath)
                communicationChannelAmber?.removeFromSourceRibbon(imageFileName: imageFileName, sourceIndexPath: triedFood.sourceIndexPath, sourceRibbon: .maybe)
                
                 let tickCount  = tickChannel?.giveTick(image_file_name: imageFileName) ?? 0
                if tickCount == 8 { performSegue(withIdentifier: "celebration", sender: self)}
                
            break
            
            case ( .no, .yes) :
                communicationChannelGreen?.insertIntoTargetRibbon(draggedFoodFileName: imageFileName, destinationIndexPath: destinationIndexPath)
                communicationChannelRed?.removeFromSourceRibbon(imageFileName: imageFileName, sourceIndexPath: triedFood.sourceIndexPath, sourceRibbon: .no)
                
                let tickCount  = tickChannel?.giveTick(image_file_name: imageFileName) ?? 0
                if tickCount == 8 { performSegue(withIdentifier: "celebration", sender: self)}
            
            break
            
            case ( .no, .maybe) :
            
                communicationChannelAmber?.insertIntoTargetRibbon(draggedFoodFileName: imageFileName, destinationIndexPath: destinationIndexPath)
            
                communicationChannelRed?.removeFromSourceRibbon(imageFileName: imageFileName, sourceIndexPath: triedFood.sourceIndexPath, sourceRibbon: .no)
                
                let tickCount  = tickChannel?.giveTick(image_file_name: imageFileName) ?? 0 
                if tickCount == 8 { performSegue(withIdentifier: "celebration", sender: self)}
            
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
        
        self.yesCollectionView.endInteractiveMovement()
        
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
        self.yesCollectionView.insertItems(at: [destinationIndexPath])
        return
    }
    
    func removeFromSourceRibbon(imageFileName: String, sourceIndexPath: IndexPath, sourceRibbon: Ribbon) {
        /// this deletes the item from the ribbon.
        self.yesCollectionView.performBatchUpdates({
            foodArray.remove(at: sourceIndexPath.row)
            self.yesCollectionView.deleteItems(at: [sourceIndexPath])            
        })
        
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
        self.maybeCollectionView.endInteractiveMovement()
        
        // I need to pull the record out of the database
        let request : NSFetchRequest<Food> = Food.fetchRequest()
        do{
            let foodArrayFull = try context.fetch(request)
            let draggedFood = foodArrayFull.filter{$0.image_file_name == draggedFoodFileName}.filter{$0.image_file_name != "tick.png"}.first!
            draggedFood.rating = 2
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
        self.maybeCollectionView.performBatchUpdates({
            foodArray.remove(at: sourceIndexPath.row)
            self.maybeCollectionView.deleteItems(at: [sourceIndexPath])
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
        
        self.noCollectionView.endInteractiveMovement()
        
        // I need to pull the record out of the database
        let request : NSFetchRequest<Food> = Food.fetchRequest()
        do{
            let foodArrayFull = try context.fetch(request)
            let draggedFood = foodArrayFull.filter{$0.image_file_name == draggedFoodFileName}.filter{$0.image_file_name != "tick.png"}.first!
            draggedFood.rating = 3
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
        self.noCollectionView.performBatchUpdates({
            foodArray.remove(at: sourceIndexPath.row)
            self.noCollectionView.deleteItems(at: [sourceIndexPath])
        })
        
        return
    }
}


