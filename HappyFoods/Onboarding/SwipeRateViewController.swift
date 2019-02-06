//
//  SwipeRateViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 18/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class SwipeRateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "OnboardingStoryboard", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tutorial3")
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
