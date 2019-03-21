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

        //// this is what I use to co-ordinate my VCs
        weak var communicationChannelGreen: CommunicationChannel?
        weak var communicationChannelTarget: CommunicationChannel?
        weak var communicationChannelAmber: CommunicationChannel?
        weak var communicationChannelRed: CommunicationChannel?
    
    
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var food: [NSManagedObject] = []
        var foodArray: [Food]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
        
        
        let scrollingStackOfCollectionViews = setUpCollectionViewScrollingStack()
        view.addSubview(scrollingStackOfCollectionViews)

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(sender: )) )
        self.view.addGestureRecognizer(pinch)
        
        communicationChannelGreen?.sayHello()
        
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    func setUpCollectionViewScrollingStack( ) -> UIView {
        let yesVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "greenScreen") as? YesCollectionViewController)!
        let targetVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tryingScreen") as? TargetCollectionViewController)!
        let maybeVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "amberScreen") as? MaybeCollectionViewController)!
        let noVC = (UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "redScreen") as? NoCollectionViewController)!
        var stackView: UIStackView!
        var scrollView: UIScrollView!
        
        yesVC.delegate = self
        targetVC.delegate = self
        maybeVC.delegate = self
        noVC.delegate = self
        
        communicationChannelGreen = yesVC
        communicationChannelTarget = targetVC
        communicationChannelAmber = maybeVC
        communicationChannelRed = noVC
        
       
        self.addChildViewControllerCustom(childViewController: yesVC)
        self.addChildViewControllerCustom(childViewController: targetVC)
        self.addChildViewControllerCustom(childViewController: maybeVC)
        self.addChildViewControllerCustom(childViewController: noVC)
        
        yesVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5 ).isActive = true
        targetVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5).isActive = true
        maybeVC.view.heightAnchor.constraint(equalToConstant: 2*CONTENT_HEIGHT/5).isActive = true
        noVC.view.heightAnchor.constraint(equalToConstant: CONTENT_HEIGHT/5).isActive = true
        
        
        stackView = UIStackView(arrangedSubviews: [yesVC.view, targetVC.view, maybeVC.view, noVC.view])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CONTENT_HEIGHT)
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
    
    func doesThisGetATick(sourceIndexPath: IndexPath, from: String, to: String)
    {
        var unique = [Int]()
        /// check for uniqueness
        for i in 0 ... foodsTriedThisWeek.count-1
        {
            if i > 0
            {
                if foodsTriedThisWeek[0].0 == foodsTriedThisWeek[i].0
                {
                    // foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    // return
                    unique = [i] + unique            }
            }
        }
        
        if unique.count > 0
        {
            for i in 0 ... unique.count - 1
            {
                foodsTriedThisWeek.remove(at: unique[i])
            }
            
            /// this is the bug. A failed drop gives an extra 'food tried this week' - but can end up with no tick allocated at this stage.
//            if visibleTicks == foodsTriedThisWeek.count
//            {
//                return
//            }
        }
        
        /// if it is unique, then give the use a smiley!
        communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: to)
        
        /// and save down to coreData
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let newFood = NSEntityDescription.insertNewObject(forEntityName: "TriedFood", into: managedObjectContext) as! TriedFood
            
            newFood.nameOfTriedFood = foodsTriedThisWeek[0].0
            newFood.dateTried = nil
        }
    }

}
