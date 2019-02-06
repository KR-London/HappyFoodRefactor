//
//  AppStoryboards.swift
//  HappyFoods
//
//  Created by Kate Roberts on 18/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//
/// https://medium.com/@gurdeep060289/clean-code-for-multiple-storyboards-c64eb679dbf6

///

///Now one can instantiate ViewController as below

/// let loginScene = LoginVC.instantiate(fromAppStoryboard: .Prelogin)

import Foundation
import UIKit
enum AppStoryboard : String {
    
    case OnboardingStoryboard, Main
    
    var instance : UIStoryboard{
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController?
    {
        return instance.instantiateInitialViewController()
    }
    
}

var storyboardID : String {
    return "<Storyboard Identifier>"
}


extension UIViewController{
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(appStoryboard : AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
