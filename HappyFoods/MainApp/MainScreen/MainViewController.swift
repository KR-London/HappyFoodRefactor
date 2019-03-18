//
//  MainViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 13/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let yesVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "greenScreen") as? YesCollectionViewController)!
        let targetVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tryingScreen") as? TargetCollectionViewController)!
        let maybeVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "amberScreen") as? MaybeCollectionViewController)!
        let noVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "redScreen") as? NoCollectionViewController)!
      
        self.addChildViewControllerCustom(childViewController: yesVC)
        self.addChildViewControllerCustom(childViewController: targetVC)
        self.addChildViewControllerCustom(childViewController: maybeVC)
        self.addChildViewControllerCustom(childViewController: noVC)
        
        var stackView: UIStackView!
        
//        yesVC.view.invalidateIntrinsicContentSize()
//        targetVC.view.invalidateIntrinsicContentSize()
//        maybeVC1.view.invalidateIntrinsicContentSize()
//        noVC.view.invalidateIntrinsicContentSize()
        
        yesVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5 ).isActive = true
        targetVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5).isActive = true
        maybeVC.view.heightAnchor.constraint(equalToConstant: 2*CONTENT_HEIGHT/5).isActive = true
        noVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5).isActive = true
        
     
        
        stackView = UIStackView(arrangedSubviews: [yesVC.view, targetVC.view, maybeVC.view, noVC.view])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0

        
        
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CONTENT_HEIGHT)
        scrollView.addSubview(stackView)
    
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT),
            ])
        view.addSubview(scrollView)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(sender: )) )
        self.view.addGestureRecognizer(pinch)
    }

    private func addChildViewControllerCustom(childViewController: UICollectionViewController){
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.didMove(toParent: self)
    }

    @objc func handlePinchGesture(sender: UIPinchGestureRecognizer) -> Void {
        print("That pinches!")
        if sender.state == .ended
        {
            performSegue(withIdentifier: "goToCamera", sender: self)
        }
    }
}
