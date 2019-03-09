//
//  OnboardingView1.swift
//  HappyFoods
//
//  Created by Kate Roberts on 05/02/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class OnboardingView1: UIView {
    
    weak var imageView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    lazy var backgroundView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "Onboarding1Background.png")?.resizeImageNoMargins(targetSize: UIScreen.main.bounds.size )
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
    }
}
