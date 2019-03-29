//
//  MainViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 13/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
        let triedFood = TriedFoodsObject()

        //// this is what I use to co-ordinate my VCs
        weak var communicationChannelGreen: CommunicationChannel?
        weak var communicationChannelAmber: CommunicationChannel?
        weak var communicationChannelRed: CommunicationChannel?
    
        weak var tickChannel: GiveTickChannel?
    
    /// temporary hack. I wanted to use a separate channel - but it doesn't seem to transmit
        weak var communicationChannelTrying: CommunicationChannel?

    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var food: [NSManagedObject] = []
        var foodArray: [Food]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datafilepath = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first?.appendingPathComponent("Items.plist")

        
        print(datafilepath)
        
        let scrollingStackOfCollectionViews = setUpCollectionViewScrollingStack_noWideLayout()
        view.addSubview(scrollingStackOfCollectionViews)

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(sender: )) )
        self.view.addGestureRecognizer(pinch)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
 func setUpCollectionViewScrollingStack_noWideLayout( ) -> UIView {
        
        let yesVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "greenScreen") as? YesCollectionViewController)!
        let targetVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tryingScreen") as? TargetCollectionViewController)!
        let maybeVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tempMaybe") as? MaybeCollectionViewController)!
        let noVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "redScreen") as? NoCollectionViewController)!
        
        var stackView: UIStackView!
        var scrollView: UIScrollView!
        
        yesVC.delegate = self
        maybeVC.delegate = self
        noVC.delegate = self
    
        communicationChannelGreen = yesVC
        communicationChannelAmber = maybeVC
        communicationChannelRed = noVC
    
        targetVC.delegate = self
        tickChannel = targetVC
        
        self.addChildViewControllerCustom(childViewController: yesVC)
        self.addChildViewControllerCustom(childViewController: targetVC)
        self.addChildViewControllerCustom(childViewController: maybeVC)
        self.addChildViewControllerCustom(childViewController: noVC)
        
        yesVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/4 ).isActive = true
        targetVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/4).isActive = true
        maybeVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/4).isActive = true
        noVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/4).isActive = true
        
        stackView = UIStackView(arrangedSubviews: [yesVC.view, targetVC.view, maybeVC.view, noVC.view])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CONTENT_HEIGHT*(5/4))
        scrollView.addSubview(stackView)
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT),
            ])
        
        return scrollView
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
