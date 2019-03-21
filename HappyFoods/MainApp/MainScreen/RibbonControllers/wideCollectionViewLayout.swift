//
//  wideCollectionViewLayout.swift
//  HappyFoods
//
//  Created by Kate Roberts on 13/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class wideCollectionViewLayout: UICollectionViewLayout {

    
    /// used for calculating each cells' CGRect on screen.
    /// CGRect will define the origin and size of the cell

    
    // dictionary yo hold the UICollectionViewLayoutAttributes for each cell
    // layout attributes will define teh cell's size and position (x,y,z index).
    /// one of the heaview parts of the layout.
    // recommend holding it in a dictionary or data store for smooth performance
    
    var cellAttrsDictionary = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
    
    //define the size of the area the user can move around in within the collection view
    var contentSize = CGSize.zero
    
    // Used to determine if a data source update has occured.
    // Note: The data source would be responsible for updating
    // this value if an update was performed.
    var dataSourceDidUpdate = true
    
    func lastLayoutAttributes() -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary.values.map { $0 }.sorted(by: { $0.frame.maxX < $1.frame.maxX }).last
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        guard collectionView.frame != .zero else { return .zero }

        let width: CGFloat
       // let height: CGFloat = collectionView.frame.width

        if let lastLayoutAttributes = lastLayoutAttributes() {
            width = lastLayoutAttributes.frame.maxX
        } else {
            width = 0
        }

        return CGSize(width: width, height: 2*CONTENT_HEIGHT/5)
    }
    
    
    override func prepare() {
        /// I don't have headers, so I jump straight to 'else' on the credera tutorial
        //super.prepare()
        self.invalidateLayout()
    
        if !dataSourceDidUpdate
        {
            // Determine current content offsets.
            let xOffset = collectionView!.contentOffset.x
            //let yOffset = collectionView!.contentOffset.y
            
            let indexPath = NSIndexPath(item:0,section:0)
            // update y position to follow user. I don't understand this comment
            if let attrs = cellAttrsDictionary[indexPath] {
                var frame = attrs.frame
                frame.origin.x = xOffset
                attrs.frame = frame
            }
            return
        }
        // Acknowledge data source change, and disable for next time.
        dataSourceDidUpdate = false
        // cycle through every section of the data source
        guard let section0 = (collectionView?.numberOfItems(inSection: 0) ) else{ return}
        guard let section1 = (collectionView?.numberOfItems(inSection: 1) ) else{ return}
        
        let numberOfItemsToDisplay = section0 + section1
        
        /// I'm assumping that the collection view will only exist with 1 or more items...? Is this correct...?
        for item in 0...numberOfItemsToDisplay-1
        {
            var cellIndex = NSIndexPath()
            var yPos = CELL_SPACING
            /// build the UICollectionViewAttributes for the cell
            if item % 2 == 0{
                cellIndex = NSIndexPath(item:item/2,section:0)
            }
            else {
                cellIndex = NSIndexPath(item:(item-1)/2,section:1)
                yPos = yPos + CELL_HEIGHT + CELL_SPACING
            }
            
            let xPos = Double(item/2)*(CELL_WIDTH + CELL_SPACING) + CELL_SPACING
            
            let  cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
            cellAttributes.frame = CGRect(x:xPos, y:yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
            cellAttributes.zIndex = 1
            
            //save attributes
            cellAttrsDictionary[cellIndex] = cellAttributes
            
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        /// create array to hold all the elements in our current view
        var attributesInRTect = [UICollectionViewLayoutAttributes]()
        
        /// check each element to see if they should be returned
        for cellAttributes in cellAttrsDictionary.values
        {
            if rect.intersects(cellAttributes.frame)
            {
                attributesInRTect.append(cellAttributes)
                print(cellAttributes.indexPath)
            }
        }
        
        return attributesInRTect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath as NSIndexPath]!
    }
    
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
