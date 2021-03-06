//
//  SwipeRateViewController.swift
//  HappyFoods
//
//  Created by Kate Roberts on 18/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData

class SwipeRateViewController: UIViewController {
    
    let foodImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        return theImageView
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    let datafilepath = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    //MARK: My local variables for my code
    var currentlyPicturedFood: Food!
    var currentlyPicturedFoodIndex = Int()
    var unratedFood: [Food]!

    override func viewDidLoad() {
    
        super.viewDidLoad()
        view.addSubview(foodImage)
        someImageViewConstraints()
        preloadData()
        loadItems()
        unratedFood = foodArray.filter{$0.rating == 0}
        if unratedFood.count == 0
        {
            transitionToRibbonsStoryboard()
        }
        else
        {
            currentlyPicturedFoodIndex = Int(arc4random_uniform(UInt32(unratedFood.count - 1)))
            currentlyPicturedFood = unratedFood[currentlyPicturedFoodIndex]
            let image = UIImage(named: currentlyPicturedFood.image_file_name!)
            let maskingImage = UIImage(named: "MASK.png")
           foodImage.image = maskImage(image: image!, mask: maskingImage!).resizeImage(targetSize: foodImage.image?.size ?? CGSize(width: 100, height: 100))
            
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
//            let storyBoard: UIStoryboard = UIStoryboard(name: "OnboardingStoryboard", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tutorial3")
//            self.present(newViewController, animated: true, completion: nil)
//        }
    }
    
    // do not forget the `.isActive = true` after every constraint
    func someImageViewConstraints() {
        foodImage.widthAnchor.constraint(equalToConstant: 180).isActive = true
        foodImage.heightAnchor.constraint(equalToConstant: 180).isActive = true
        foodImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        foodImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 28).isActive = true
    }
    
    func loadItems(){
        let request : NSFetchRequest<Food> = Food.fetchRequest()
        do{
            try
                foodArray = context.fetch(request)
        }
        catch
        {
            print("Error fetching data \(error)")
        }
    }

    func saveItems(){
        do{ try context.save() }
        catch{
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")

        }
    }
    
    func updatePicture(){
        saveItems()
        //        ///future self, please add some code to handle the case where there are no unrated foods/ to allow for previously rated foods to be presented.
        /// filter food array so you're only seeing unrated ones
        unratedFood = unratedFood.filter{$0 != currentlyPicturedFood}
        
        /// this is the fade out of the frame prompting you what the directions are
        //        if instructions.alpha > 0
        //        {
        //            instructions.alpha = instructions.alpha - 0.1
        //        }
        //

        
    
        
        
        if unratedFood.count == 0 {
            
            transitionToRibbonsStoryboard()
            return
            
        }
        if unratedFood.count > 1
        { /// load a picuture of a random one of these
            //currentlyPicturedFoodIndex = Int(arc4random_uniform(UInt32(unratedFood.count - 1)))
            
            //  debugging
            //currentlyPicturedFoodIndex = counter
            // currentlyPicturedFood = unratedFood[currentlyPicturedFoodIndex]
            currentlyPicturedFood = unratedFood.last
            //  counter = counter + 1
        }
        else
        {
            currentlyPicturedFood = unratedFood[0]
        }
        // foodImage.image = UIImage(named: currentlyPicturedFood.image_file_name!)
        
        let image = UIImage(named: currentlyPicturedFood.image_file_name!)
            //?.resizeImageNoMargins(targetSize: CGSize(width: 180, height: 180))
        let maskingImage = UIImage(named: "MASK.png")
        foodImage.image = maskImage(image: image!, mask: maskingImage!)
    }

    func preloadData () {
        // Retrieve data from the source file
        if let contentsOfURL = Bundle.main.url(forResource: "FoodData", withExtension: "csv") {
            // if let contentsOfURL = Bundle.main.url(forResource: "dummyData", withExtension: "txt") {

            // Remove all the menu items before preloading
            removeData()
            if let items = parseCSV(contentsOfURL: contentsOfURL as NSURL, encoding: String.Encoding.utf8) {
                // Preload the menu items
                if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                    for item in items {
                        let menuItem = NSEntityDescription.insertNewObject(forEntityName: "Food", into: managedObjectContext) as! Food
                        menuItem.image_file_name = item.image_file_name
                        menuItem.name = item.name
                        menuItem.rating = Int16(item.rating)

                        //                        if managedObjectContext.save() != true {
                        //                            print("insert error: \(error!.localizedDescription)")
                        //                        }
                    }
                }
            }
        }
        loadItems()

        unratedFood = foodArray.filter{$0.rating == 0}
        currentlyPicturedFoodIndex = Int(arc4random_uniform(UInt32(unratedFood.count - 1)))
        currentlyPicturedFood = unratedFood[currentlyPicturedFoodIndex]
        foodImage.image = UIImage(named: currentlyPicturedFood.image_file_name!)
    
        /// define swipe directions
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
    
    }

    func removeData () {
        // Remove the existing items
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext  {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
            var menuItems: [Food]

            do
            {
                menuItems = try managedObjectContext.fetch(fetchRequest) as! [Food]
            }
            catch
            {
                print("Failed to retrieve record")
                return
            }

            for menuItem in menuItems
            {
                managedObjectContext.delete(menuItem)
            }
        }
    }
    func parseCSV(contentsOfURL: NSURL, encoding: String.Encoding) -> [(image_file_name: String, name: String, rating: Int)]?
    {
        /// load CSV function
        let delimiter = ","
        var items:[(image_file_name: String, name: String, rating: Int)]?

        let optContent = try? String(contentsOf: contentsOfURL as URL)
        guard let content = optContent
            else
        {
            print("That didn't work!")
            return items
        }

        items = []

        let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines)

        for line in lines{
            var values:[String] = []
            if line != ""
            {
                if line.range( of: "\"" ) != nil
                {
                    var textToScan: String = line
                    var value:NSString?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while textScanner.string != ""
                    {
                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpTo("\"", into: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpTo(delimiter, into: &value)
                        }

                        // Store the value into the values array
                        values.append(value! as String)
                    }

                    // Retrieve the unscanned remainder of the string
                    if textScanner.scanLocation < textScanner.string.count {
                        textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                    } else {
                        textToScan = ""
                    }
                    textScanner = Scanner(string: textToScan)
                }
                else  {
                    values = line.components(separatedBy: delimiter)
                }

                ///image_file_name: String, name: String, rating: Int
                // Put the values into the tuple and add it to the items array
                let item = (image_file_name: values[0], name: values[1], rating: Int(values[2]) ?? 0 )
                items?.append(item )
            }
        }
        return items
    }

@objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
    if gesture.direction == UISwipeGestureRecognizer.Direction.right {
        
        foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 2
        updatePicture()
        
    }
    else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
        foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 2
        updatePicture()
    }
    else if gesture.direction == UISwipeGestureRecognizer.Direction.up {
        foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 1
        updatePicture()
    }
    else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
        foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 3
        updatePicture()
        //self.storyboard
        
        
        
        
        //onButtonTapped()
        // performSegue(withIdentifier: goToData, sender: self)
    }
}

func transitionToRibbonsStoryboard(){
    
    // performSegue(withIdentifier: "GoToMotivation", sender: self)
    
    DispatchQueue.main.asyncAfter(deadline: .now() ){
        self.performSegue(withIdentifier: "goToMotivation", sender: self)
    }
    
    //        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
    //
    //        guard let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "tellMeMotivation") as? MotivationViewController
    //            else
    //        {
    //            print("Couldn't find view controller")
    //            return
    //        }
    //
    //        navigationController?.pushViewController(destinationVC, animated: true)
}
    
    func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.cgImage
        let maskReference = mask.cgImage
        
        let imageMask = CGImage(maskWidth: maskReference!.width,
                                height: maskReference!.height,
                                bitsPerComponent: maskReference!.bitsPerComponent,
                                bitsPerPixel: maskReference!.bitsPerPixel,
                                bytesPerRow: maskReference!.bytesPerRow,
                                provider: maskReference!.dataProvider!, decode: nil, shouldInterpolate: true)
        
        let maskedReference = imageReference!.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage:maskedReference!)
        
        return maskedImage
    }


}
