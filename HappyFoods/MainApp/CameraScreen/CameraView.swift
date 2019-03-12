//
//  CameraView.swift
//  HappyFoods
//
//  Created by Kate Roberts on 08/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class CameraView: UIView {
  
    weak var imageView: UIView!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    lazy var backgroundView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "swipeScreenBackground.JPG")?.resizeImageNoMargins(targetSize: UIScreen.main.bounds.size )
        return contentView
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /// place in the background image, centred.
        addSubview(backgroundView)
        self.sendSubviewToBack(backgroundView)
        
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ]
        )
    }
}
