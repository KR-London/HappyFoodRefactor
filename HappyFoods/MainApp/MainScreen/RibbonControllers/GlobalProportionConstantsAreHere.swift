//
//  GlobalProportionConstantsAreHere.swift
//  HappyFoods
//
//  Created by Kate Roberts on 18/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import Foundation
import UIKit

let CONTENT_HEIGHT = 1.1*UIScreen.main.bounds.height

/// I'm making the assumption that the ribbons are in ratio 1:1:2:1 .
/// If I want to change this - I would do it in main view controller = and things might go wonky if I don't reflect it here

let CELL_HEIGHT = Double(0.7*CONTENT_HEIGHT/5)
let CELL_WIDTH = Double(CELL_HEIGHT)
let CELL_SPACING = Double(0.15*CONTENT_HEIGHT/5)

var celebrationTiggered = false


