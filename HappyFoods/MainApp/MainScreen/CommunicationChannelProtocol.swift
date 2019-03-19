//
//  CommunicationChannelProtocol.swift
//  HappyFoods
//
//  Created by Kate Roberts on 19/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import Foundation

//A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements
var foodsTriedThisWeek = [(String?, IndexPath, String)]()

protocol CommunicationChannel : class {
    func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
}

extension MainViewController: CommunicationChannel{
    
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
        print("Main")
    }
    
}
