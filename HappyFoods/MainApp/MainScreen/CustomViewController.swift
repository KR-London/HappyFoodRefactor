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
    @IBOutlet var stackView: UIStackView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(sender: )) )
        self.view.addGestureRecognizer(pinch)
        
        /// I like it in a scroll view so that I'm not wasting valuable screen space on the negative! I hide the 'no' ribbon.
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "chaos.jpg")!)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1.2*view.bounds.height)
   

        
        stackView.addSubview(containerYes)
        stackView.addSubview(containerTarget)
        stackView.addSubview(containerMaybe)
        stackView.addSubview(containerNo)
        
    
        scrollView.addSubview(stackView)
        
        self.view.addSubview(scrollView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        

    }
    

    
    @objc func handlePinchGesture(sender: UIPinchGestureRecognizer) -> Void {
        print("That pinches!")
        if sender.state == .ended
        {
            performSegue(withIdentifier: "goToCamera", sender: self)
        }
    }
    }

