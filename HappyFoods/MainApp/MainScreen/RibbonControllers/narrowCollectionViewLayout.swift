//
//  narrowCollectionViewLayout.swift
//  HappyFoods
//
//  Created by Kate Roberts on 13/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class narrowCollectionViewLayout: UICollectionViewLayout {

    // dictionary yo hold the UICollectionViewLayoutAttributes for each cell
    // layout attributes will define the cell's size and position (x,y,z index).
    /// one of the heaview parts of the layout.recommend holding it in a dictionary or data store for smooth performance
    
    var cellAttrsDictionary = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
    //define the size of the area the user can move around in within the collection view
    var contentSize = CGSize.zero
    
    // Used to determine if a data source update has occured.
    // Note: The data source would be responsible for updating
    // this value if an update was performed.
    var dataSourceDidUpdate = true
    
    func lastLayoutAttributes() -> UICollectionViewLayoutAttributes? {
        
        /// this gives you the biggest value of X so we know how big to set the content size. 
        return cellAttrsDictionary.values.map { $0 }.sorted(by: { $0.frame.maxX < $1.frame.maxX }).last
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        guard collectionView.frame != .zero else { return .zero }
        
        let width: CGFloat
        let height: CGFloat = CONTENT_HEIGHT/5
            //collectionView.frame.width
        
        if let lastLayoutAttributes = lastLayoutAttributes() {
            width = lastLayoutAttributes.frame.maxX
        } else {
            width = 0
        }
        
        return CGSize(width: width, height: height)
    }
    
    override func prepare() {
        if (collectionView?.numberOfItems(inSection: 0))! > 0 {
            /// cycle through each item of the section
            for item in 0...(collectionView?.numberOfItems(inSection: 0))!-1{
                /// build the collection attributes
                let cellIndex = NSIndexPath(item: item, section: 0)
                let xPos = Double(item)*(CELL_WIDTH  + CELL_SPACING) + CELL_SPACING
                let yPos = CELL_SPACING
                
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
                cellAttributes.frame = CGRect(x: xPos, y:yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                cellAttributes.zIndex = 1
                
                //save
                cellAttrsDictionary[cellIndex] = cellAttributes
            }
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
            }
        }
        
        return attributesInRTect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath as NSIndexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }

}
