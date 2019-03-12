//
//  MainViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 12/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
   // var yesVC = YesCollectionViewController()
    
    var testing = CustomViewController2()
    
    @IBAction func tapped(_ sender: Any) {
        print("ouch")
        
    }
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// I like it in a scroll view so that I'm not wasting valuable screen space on the negative! I hide the 'no' ribbon.
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "chaos.jpg")!)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1.2*view.bounds.height)
        
       // yesVC = YesCollectionViewController.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        //testing.view.addGestureRecognizer(tapped())
        
        scrollView.addSubview(testing.view)
        
        self.view.addSubview(scrollView)
        
        // Do any additional setup after loading the view.
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
