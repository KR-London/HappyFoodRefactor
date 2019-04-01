//
//  OnboardingView3.swift
//  HappyFoods
//
//  Created by Kate Roberts on 07/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class OnboardingView3: UIView {
    
    weak var imageView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    lazy var backgroundView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "Onboarding3Background.JPG")?.resizeImageNoMargins(targetSize: UIScreen.main.bounds.size )
        return contentView
    }()
    
    lazy var textView: UILabel = {
        let contentView = UILabel()
        contentView.text = " Don’t see what you want? Pinch out to add more foods using camera or camera roll. Aim for 8 tries a week.  "
        contentView.textAlignment = .center
        contentView.numberOfLines = 8
        return contentView
    }()

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /// place in the background image, centred.
//        addSubview(backgroundView)
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate(
//            [
//                backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//            ]
//        )
//        
//        addSubview(textView)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate(
//            [
//                textView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                textView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//                textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//                 textView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//            ]
//        )
    }
}
