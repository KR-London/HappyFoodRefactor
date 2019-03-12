//
//  CustomViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 18/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    //MARK: Properties
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerYes: UIView!
    @IBOutlet var containerTarget: UIView!
    @IBOutlet var containerMaybe: UIView!
    @IBOutlet var containerNo: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = true
 
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGesture) )
        self.view.addGestureRecognizer(tap)
        
        /// I like it in a scroll view so that I'm not wasting valuable screen space on the negative! I hide the 'no' ribbon.
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "chaos.jpg")!)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1.2*view.bounds.height)
   

        
       // stackView.addSubview(containerYes)
       // stackView.addSubview(containerTarget)
       // stackView.addSubview(containerMaybe)
       // stackView.addSubview(containerNo)
    
        
        scrollView.addSubview(containerYes)
        scrollView.addSubview(containerTarget)
        scrollView.addSubview(containerMaybe)
        scrollView.addSubview(containerNo)
        self.view.addSubview(scrollView)
        
        
        
        
        // constrain the scroll view to 8-pts on each side
       // scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
      //  scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
       // scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
      //  scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20.0).isActive = true

    }
    
   
    @objc func handleGesture() -> Void {
        print("I hear you")
            //onButtonTapped()
            // performSegue(withIdentifier: goToData, sender: self)
        }
    }

