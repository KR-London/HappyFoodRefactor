//
//  OnboardingViewController2.swift
//  HappyFoods
//
//  Created by Kate Roberts on 18/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class OnboardingViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "OnboardingStoryboard", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tutorial3") 
            self.present(newViewController, animated: true, completion: nil)
        }
    }
}
