//
//  CommunicationChannelProtocol.swift
//  HappyFoods
//
//  Created by Kate Roberts on 19/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import Foundation

//A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements
//var foodsTriedThisWeek = [(String?, IndexPath, String)]()

protocol CommunicationChannel : class {
    func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
    func sayHello()
}

var foodsTriedThisWeek: [(String?, IndexPath, String)]!

extension MainViewController: CommunicationChannel{
    
//    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
//        print("Main")
//    }
//
    func sayHello(){
        print("Yes")
    }
    
    func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
    {
        
        let sourceSink = (from: foodsTriedThisWeek[0].2, to: sourceViewController)
        
        switch sourceSink
        {
        case ("fromGreenRibbon", "droppingIntoGreen"):
            communicationChannelGreen?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
        case ("fromGreenRibbon", "droppingIntoTarget"):
            communicationChannelGreen?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
        case ("fromGreenRibbon", "droppingIntoMaybe"):
            communicationChannelGreen?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
        case ("fromGreenRibbon", "droppingIntoRed"):
            communicationChannelGreen?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
            
        case ( "fromTargetRibbon", "droppingIntoTarget"):
            communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            break
        case ("fromTargetRibbon", "droppingIntoGreen"):
            communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            break
        case ("fromTargetRibbon", "droppingIntoMaybe"):
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
        case ("fromTargetRibbon", "droppingIntoRed"):
            //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            break
            

        case ("fromMaybeRibbon", "droppingIntoGreen"): communicationChannelAmber?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
        //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
        doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            break
        case ("fromMaybeRibbon", "droppingIntoTarget"):
            communicationChannelAmber?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
     
        case ("fromMaybeRibbon", "droppingIntoRed"):
            communicationChannelAmber?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            break
            
            
        case ("fromRedRibbon", "droppingIntoRed"):
            communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            //doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            // communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
        case ("fromRedRibbon", "droppingIntoGreen"):
            communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            // communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            // foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
        case ("fromRedRibbon", "droppingIntoTarget"):
            communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
        case ("fromRedRibbon", "droppingIntoMaybe"):
            //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
    
            
        default: return
        }
        
        
        if foodsTriedThisWeek != nil && celebrationTiggered == false
        {
            if foodsTriedThisWeek.count >= 6
            {
                performSegue(withIdentifier: "celebrationScreen", sender: self)
                celebrationTiggered = true
            }
        }
        
        //        if sourceSink.from == "fromTopMaybeRibbon"
        //        {
        //            communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
        //        }
        //        if sourceSink.from == "fromBottomMaybeRibbon"
        //        {
        //            communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
        //        }
        
        
        //     communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
    }
    
    
    
}

extension YesCollectionViewController: CommunicationChannel{
    
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
 
        foodArray.remove(at: foodsTriedThisWeek[0].1.row)
        foodArray = foodArray.filter{ $0.rating == 1 }
        self.collectionView!.reloadData()
        self.collectionView!.numberOfItems(inSection: 0)
    }
    
    func sayHello(){
         print("Yes")
    }
    
}


extension NoCollectionViewController: CommunicationChannel{
    
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
 
        foodArray.remove(at: foodsTriedThisWeek[0].1.row)
        foodArray = foodArray.filter{ $0.rating == 3 }
        //self.reloadInputViews()
        self.collectionView!.reloadData()
        //self.collectionViewLayout.invalidateLayout()
        self.collectionView!.numberOfItems(inSection: 0)
    }
    
    func sayHello(){
        print("No")
    }
    
}

extension CustomCollectionViewController: CommunicationChannel{
    
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
        // print("No")
        
        foodArray.remove(at: foodsTriedThisWeek[0].1.row)
        foodArray = foodArray.filter{ $0.rating == 1 }

        self.collectionView!.reloadData()
        self.collectionViewLayout.invalidateLayout()
        self.collectionView!.numberOfItems(inSection: 0)
    }
    
    func sayHello(){
        print("No")
    }
    
}


extension TargetCollectionViewController: CommunicationChannel{
    
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
        print("Target ")
    }
    
    func sayHello(){
        print("Target")
    }
    
}

//extension MaybeCollectionViewController: CommunicationChannel{
//
//    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
//        print("Maybe")
//    }
//
//    func sayHello(){
//        print("Maybe")
//    }
//
//}

