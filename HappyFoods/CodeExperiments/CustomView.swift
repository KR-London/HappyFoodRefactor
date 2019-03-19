//
//  CustomView.swift
//  HappyFoods
//
//  Created by Kate Roberts on 08/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


//    private func addChildViewControllerCustom(childViewController: UICollectionViewController){
//        addChild(childViewController)
//        view.addSubview(childViewController.view)
//        childViewController.view.frame = view.bounds
//        childViewController.didMove(toParent: self)
//    }
