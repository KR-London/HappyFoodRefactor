//
//  MainView.swift
//  HappyFoods
//
//  Created by Kate Roberts on 12/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class MainView: UIView {

//    @IBOutlet var yesContainer: UIView!
//    @IBOutlet var targetContainer: UIView!
//    @IBOutlet var maybeContainer: UIView!
//    @IBOutlet var noContainer: UIView!
    
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        sv.distribution = .fillEqually
        return sv
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)

        //addSubview(stackView)
    }
    
    lazy var backgroundView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "peas.jpg")?.resizeImageNoMargins(targetSize: UIScreen.main.bounds.size )
        return contentView
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        stackView.addSubview(yesContainer)
//        stackView.addSubview(targetContainer)
//        stackView.addSubview(maybeContainer)
//        stackView.addSubview(noContainer)
        
  
//
//        stackView.addSubview(yesContainer)
//        stackView.addSubview(targetContainer)
//        stackView.addSubview(maybeContainer)
//        stackView.addSubview(noContainer)
//        
    //  addSubview(stackView)
        /// place in the background image, centred.
//        addSubview(backgroundView)
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate(
//            [
//                backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//            ]
//        )
    }
}
