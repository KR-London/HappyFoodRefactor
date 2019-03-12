//
//  MainView.swift
//  HappyFoods
//
//  Created by Kate Roberts on 12/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class MainView: UIView {


    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView(){
        backgroundColor = UIColor.cyan
    }
}
