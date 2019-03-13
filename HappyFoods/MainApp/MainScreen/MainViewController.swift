//
//  MainViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 13/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    lazy var yesVC: YesCollectionViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "greenScreen") as! YesCollectionViewController

        self.addChildViewControllerCustom(childViewController: viewController)
        return viewController
    }()

    lazy var targetVC: TargetCollectionViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "tryingScreen") as! TargetCollectionViewController

        self.addChildViewControllerCustom(childViewController: viewController)
        return viewController
    }()

    lazy var maybeVC: MaybeCollectionViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "amberScreen") as! MaybeCollectionViewController

        self.addChildViewControllerCustom(childViewController: viewController)
        return viewController
    }()

    lazy var noVC: NoCollectionViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "redScreen") as! NoCollectionViewController

        self.addChildViewControllerCustom(childViewController: viewController)
        return viewController
    }()

//    lazy var stackView: UIStackView = {
//            let sv = UIStackView(arrangedSubviews: [yesVC.view, targetVC.view, maybeVC.view, noVC.view])
//            sv.translatesAutoresizingMaskIntoConstraints = false
//            sv.axis = .vertical
//            sv.spacing = 0
//            sv.distribution = .fillEqually
//            return sv
//        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
//        yesVC.view.isHidden = false
//        targetVC.view.isHidden = false
//        maybeVC.view.isHidden = false
//        noVC.view.isHidden = false
        
            var stackView: UIStackView!
            stackView = UIStackView(arrangedSubviews: [yesVC.view, targetVC.view, maybeVC.view, noVC.view])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 0
            stackView.distribution = .fillEqually
        
        
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1.2*UIScreen.main.bounds.height)
        scrollView.addSubview(stackView)
    
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.2),
            // childVC.topAnchor.constraint(equalTo: scrollView.to2pAnchor),
            //  childVC.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            // childVC.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        
        view.addSubview(scrollView)
    }
    private func intitialiseRibbons(){
        var yesVC: YesCollectionViewController = {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            var viewController = storyboard.instantiateViewController(withIdentifier: "greenScreen") as! YesCollectionViewController
            
            self.addChildViewControllerCustom(childViewController: viewController)
            return viewController
        }()
        
        var targetVC: TargetCollectionViewController = {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            var viewController = storyboard.instantiateViewController(withIdentifier: "tryingScreen") as! TargetCollectionViewController
            
            self.addChildViewControllerCustom(childViewController: viewController)
            return viewController
        }()
        
        var maybeVC: MaybeCollectionViewController = {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            var viewController = storyboard.instantiateViewController(withIdentifier: "amberScreen") as! MaybeCollectionViewController
            
            self.addChildViewControllerCustom(childViewController: viewController)
            return viewController
        }()
        
        var noVC: NoCollectionViewController = {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            var viewController = storyboard.instantiateViewController(withIdentifier: "redScreen") as! NoCollectionViewController
            
            self.addChildViewControllerCustom(childViewController: viewController)
            return viewController
        }()
        
       var stackView: UIStackView = {
            let sv = UIStackView(arrangedSubviews: [yesVC.view, targetVC.view, maybeVC.view, noVC.view])
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .vertical
            sv.spacing = 0
            sv.distribution = .fillEqually
            return sv
        }()
    }

    private func addChildViewControllerCustom(childViewController: UICollectionViewController)
    {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
     //   childViewController.view.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        //childViewController.view.heightAnchor.constraint(equalToConstant: 100)
        childViewController.didMove(toParent: self)
    }
}
