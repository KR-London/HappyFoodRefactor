//
//  SwipeScreenView.swift
//  HappyFoods
//
//  Created by Kate Roberts on 07/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class SwipeScreenView: UIView {

    weak var imageView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    lazy var backgroundView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "swipeScreenBackground.JPG")?.resizeImageNoMargins(targetSize: UIScreen.main.bounds.size )
        return contentView
    }()
    
    lazy var instructionView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "Thingy.png")
        return contentView
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /// place in the background image, centred.
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ]
        )
     
        addSubview(instructionView)
       instructionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(
                    [
                        instructionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        instructionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                        instructionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
                        instructionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor)
                    ]
                )
    }

}
