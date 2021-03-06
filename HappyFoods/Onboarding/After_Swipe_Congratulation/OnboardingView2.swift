//
//  OnboardingView2.swift
//  HappyFoods
//
//  Created by Kate Roberts on 07/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class OnboardingView2: UIView {
    
    weak var imageView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    lazy var backgroundView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "Onboarding2Background.png")?.resizeImageNoMargins(targetSize: UIScreen.main.bounds.size )
        return contentView
    }()
    
    lazy var textView: UILabel = {
       let contentView = UILabel()
        contentView.text = " Happy Foods is in your pocket and you are in charge. Pick foods to try from amber or red. Try it & drag it. Up for yum and down for yuck. "
        contentView.textAlignment = .center
        contentView.numberOfLines = 8
        contentView.font.withSize(16)
        return contentView
    }()

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /// place in the background image, centred.
       
//        addSubview(backgroundView)
//        
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate(
//            [
//                backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//            ]
//        )
//         addSubview(textView)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate(
//            [
//                textView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                textView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//                textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//                textView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//            ]
//        )
    }
}
