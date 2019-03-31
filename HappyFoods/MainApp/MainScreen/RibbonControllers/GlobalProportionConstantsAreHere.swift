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
let RIBBON_DEFAULT_HEIGHT = CONTENT_HEIGHT/5


 let SCREEN_WIDTH = UIScreen.main.bounds.width

/// I'm making the assumption that the ribbons are in ratio 1:1:2:1 .
/// If I want to change this - I would do it in main view controller = and things might go wonky if I don't reflect it here

let CELL_HEIGHT = Double(0.7*RIBBON_DEFAULT_HEIGHT)
let CELL_WIDTH = Double(CELL_HEIGHT)
///I'm not using this since I dropped custom layouts
let CELL_SPACING = Double(0.15*RIBBON_DEFAULT_HEIGHT)

var celebrationTiggered = false

let MAYBE_WIDE = false

