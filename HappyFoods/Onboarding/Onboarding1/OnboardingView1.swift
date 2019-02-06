//
//  OnboardingView1.swift
//  HappyFoods
//
//  Created by Kate Roberts on 05/02/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class OnboardingView1: UIView {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    lazy var backgroundView: UIImageView = {
        let contentView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        contentView.image = UIImage(named: "chaos.jpg")
        return contentView
    }()
    
    lazy var textBox: UILabel = {
        let headerTitle = UILabel(frame: CGRect(x: 0.2*UIScreen.main.bounds.width, y: 0.3*UIScreen.main.bounds.height, width: 0.6*UIScreen.main.bounds.width, height: 0.6*UIScreen.main.bounds.height))
        headerTitle.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        headerTitle.text = "Ready steady swipe"
        headerTitle.textAlignment = .center
        return headerTitle
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         setupView()
    }
    
    private func setupView(){


        addSubview(backgroundView)
        addSubview(textBox)


    }
}
