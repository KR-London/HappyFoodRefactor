//
//  OnboardingViewController3.swift
//  HappyFoods
//
//  Created by Kate Roberts on 18/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class OnboardingViewController3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainScreen") as! CustomViewController
            self.present(newViewController, animated: true, completion: nil)
        }
    }
}
