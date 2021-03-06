//
//  CongratulationView.swift
//  HappyFoods
//
//  Created by Kate Roberts on 08/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class CongratulationView: UIView {

    weak var imageView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    lazy var backgroundView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "Chaos_ Chaos_2.png")?.resizeImageNoMargins(targetSize: UIScreen.main.bounds.size )
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
