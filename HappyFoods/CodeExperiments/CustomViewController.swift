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

//// this was when I wanted to have a double height maybe ribbon

//    func setUpCollectionViewScrollingStack( ) -> UIView {
//        let yesVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "greenScreen") as? YesCollectionViewController)!
//        let targetVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tryingScreen") as? TargetCollectionViewController)!
//        let maybeVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "amberScreen") as? MaybeCollectionViewController)!
//        // let noVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "redScreen") as? CustomCollectionViewController)!
//        let noVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tempScreen") as? NoCollectionViewController)!
//
//        var stackView: UIStackView!
//        var scrollView: UIScrollView!
//
//        yesVC.delegate = self
//        targetVC.delegate = self
//        maybeVC.delegate = self
//        //  tempVC.delegate = self
//        noVC.delegate = self
//
//
//
//        communicationChannelGreen = yesVC
//        communicationChannelTrying = targetVC
//        communicationChannelAmber = maybeVC
//        communicationChannelRed = noVC
//
//        targetVC.delegateTick = self
//        tickChannel = targetVC
//
//
//        self.addChildViewControllerCustom(childViewController: yesVC)
//        self.addChildViewControllerCustom(childViewController: targetVC)
//        self.addChildViewControllerCustom(childViewController: maybeVC)
//        self.addChildViewControllerCustom(childViewController: noVC)
//
//        yesVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5 ).isActive = true
//        targetVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5).isActive = true
//        maybeVC.view.heightAnchor.constraint(equalToConstant: 2*CONTENT_HEIGHT/5).isActive = true
//        noVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5).isActive = true
//
//        stackView = UIStackView(arrangedSubviews: [yesVC.view, targetVC.view, maybeVC.view, noVC.view])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.spacing = 0
//
//
//        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CONTENT_HEIGHT)
//        scrollView.addSubview(stackView)
//
//        scrollView.addSubview(stackView)
//        NSLayoutConstraint.activate([
//            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            stackView.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT),
//            ])
//
//        return scrollView
//    }
//func setUpCollectionViewNoScrollingStack( ) -> UIView {
//    let yesVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "greenScreen") as? YesCollectionViewController)!
//    let targetVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tryingScreen") as? TargetCollectionViewController)!
//    let maybeVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "amberScreen") as? MaybeCollectionViewController)!
//    // let noVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "redScreen") as? CustomCollectionViewController)!
//    
//    let nooVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tempScreen") as? NoCollectionViewController)!
//    
//    
//    yesVC.delegate = self
//    targetVC.delegate = self
//    maybeVC.delegate = self
//    //  tempVC.delegate = self
//    nooVC.delegate = self
//    
//    communicationChannelGreen = yesVC
//    // communicationChannelTarget = targetVC
//    communicationChannelAmber = maybeVC
//    communicationChannelRed = nooVC
//    
//    
//    
//    self.addChildViewControllerCustom(childViewController: yesVC)
//    self.addChildViewControllerCustom(childViewController: targetVC)
//    self.addChildViewControllerCustom(childViewController: maybeVC)
//    self.addChildViewControllerCustom(childViewController: nooVC)
//    
//    yesVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5 ).isActive = true
//    targetVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5).isActive = true
//    maybeVC.view.heightAnchor.constraint(equalToConstant: 2*CONTENT_HEIGHT/5).isActive = true
//    nooVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5).isActive = true
//    
//    
//    return self.view
//}
