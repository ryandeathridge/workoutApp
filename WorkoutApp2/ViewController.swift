//
//  ViewController.swift
//  WorkoutApp2
//
//  Created by Ryan Deathridge on 5/7/18.
//  Copyright © 2018 RYAN DEATHRIDGE. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var todaysLiftLabel: UITextField!
    @IBOutlet weak var lastLiftLabel: UILabel!
    @IBOutlet weak var nextLiftLabel: UILabel!
    @IBOutlet weak var incrementsLabel: UITextField!
    @IBOutlet weak var lastLiftDateLabel: UILabel!
    @IBOutlet weak var decimelLabel: UILabel!
    @IBOutlet weak var lastDecimelLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextDecimelLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var lastLift: Float = 100
    var todaysLift: Float = 105
    var nextLift: Float = 112
    var increment: Float = 5
    var exercise: String = "Bench"
    var todaysDecimels: Float = 0.0
    var lastDecimels: Float = 0.0
    var nextDecimels: Float = 0.0
    
    let today = NSDate()
    var lastLiftDate = NSDate()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
      //  initialiseDatabase()
          requestData()
    }

    
    func initialiseDatabase() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity1 = NSEntityDescription.entity(forEntityName: "Bench", in: context)
        let entity2 = NSEntityDescription.entity(forEntityName: "Heave", in: context)
        let entity3 = NSEntityDescription.entity(forEntityName: "Press", in: context)
        let entity4 = NSEntityDescription.entity(forEntityName: "Squat", in: context)
        let benchData = NSManagedObject(entity: entity1!, insertInto: context)
        let heaveData = NSManagedObject(entity: entity2!, insertInto: context)
        let pressData = NSManagedObject(entity: entity3!, insertInto: context)
        let squatData = NSManagedObject(entity: entity4!, insertInto: context)
        
        
        benchData.setValue(0, forKey: "score")
        benchData.setValue(5, forKey: "increment")
        benchData.setValue(today, forKey: "date")
        
        heaveData.setValue(0, forKey: "score")
        heaveData.setValue(2.5, forKey: "increment")
        heaveData.setValue(today, forKey: "date")
        
        pressData.setValue(0, forKey: "score")
        pressData.setValue(2.5, forKey: "increment")
        pressData.setValue(today, forKey: "date")
        
        squatData.setValue(0, forKey: "score")
        squatData.setValue(10, forKey: "increment")
        squatData.setValue(today, forKey: "date")
        
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
    }
    
   
    func saveData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
  
        let entity = NSEntityDescription.entity(forEntityName: exercise, in: context)
        let newData = NSManagedObject(entity: entity!, insertInto: context)
        
        
       
        newData.setValue(todaysLift, forKey: "score")
        newData.setValue(increment, forKey: "increment")
        newData.setValue(today, forKey: "date")
        
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
        requestData()
    }
    
    
    
    
    func populateFields() {
        
        let daysAgo = lastLiftDate.timeIntervalSinceNow / 86400
        let formattedDaysAgo = Int(daysAgo.rounded() * -1)
       
        print("\(daysAgo) days ago")
        
       
        let Todaynumber: NSNumber = NSNumber(value: todaysLift.truncatingRemainder(dividingBy: 1))
        let lastDecimels: NSNumber = NSNumber(value: lastLift.truncatingRemainder(dividingBy: 1))
        let nextDecimels: NSNumber = NSNumber(value: nextLift.truncatingRemainder(dividingBy: 1))
        
        let numbersToWords = NumberFormatter()
        numbersToWords.maximumFractionDigits = 1
        numbersToWords.numberStyle = .spellOut
       
        
        
        let decimalValue = numbersToWords.string(from: Todaynumber)
        let nextDecimelsString = numbersToWords.string(from: nextDecimels)
        let lastDecimelsString = numbersToWords.string(from: lastDecimels)
        
        todaysLiftLabel.text = "\(Int(todaysLift))"
        lastLiftLabel.text = "\(Int(lastLift))"
        nextLiftLabel.text = "\(Int(nextLift))"
        exerciseLabel.text = exercise.uppercased()
        incrementsLabel.text = "\(increment)"
        
        // Add decimels to the labels
        if decimalValue == "zero" { decimelLabel.text = "kg" } else { decimelLabel.text = decimalValue?.replacingOccurrences(of: "zero ", with: "") }
        if lastDecimelsString == "zero" {lastDecimelLabel.text = "kg"} else {lastDecimelLabel.text = lastDecimelsString?.replacingOccurrences(of: "zero ", with: "")}
        if nextDecimelsString == "zero" {nextDecimelLabel.text = "kg"} else {nextDecimelLabel.text = nextDecimelsString?.replacingOccurrences(of: "zero ", with: "")}
        
        if formattedDaysAgo == 0 {
            lastLiftDateLabel.text = ("Today")
                } else if formattedDaysAgo == 1 {
                    lastLiftDateLabel.text = ("Yesterday")
                } else {
                    lastLiftDateLabel.text = "\(formattedDaysAgo) days ago"
                }
            }
    
    
    func requestData() {
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: exercise)
        fetchRequest.returnsObjectsAsFaults = false
        // fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "score") == nil { initialiseDatabase() }
              
                    
                increment = data.value(forKey: "increment") as! Float
                lastLift = data.value(forKey: "score") as! Float
                lastLiftDate = data.value(forKey: "date") as! NSDate
                   print("\(String(describing: data.value(forKey: "score")))")
                    print(lastLiftDate)
                    print(today)
                   
               
                
            }
        } catch {
            print("failed")
        }
        
        todaysLift = lastLift + increment
        nextLift = todaysLift + increment
        
       
        
        populateFields()
    }
    
    
    @IBAction func doneButtonWasPressed(_ sender: Any) {
        todaysDecimels = todaysLift.truncatingRemainder(dividingBy: 1)
        todaysLift = (todaysLiftLabel.text! as NSString).floatValue + todaysDecimels
        increment = (incrementsLabel.text! as NSString).floatValue
        
        saveData()
        view.endEditing(true)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: Any) {
        if exercise == "Bench" {
            exercise = "Press"
            previousButton.setTitle("Bench", for: UIControlState.normal)
            nextButton.setTitle("Squat", for: UIControlState.normal)
            pageControl.currentPage = 2
            
        } else if exercise == "Press" {
            exercise = "Squat"
            nextButton.setTitle("Heave", for: UIControlState.normal)
            previousButton.setTitle("Press", for: UIControlState.normal)
            pageControl.currentPage = 3
        
        } else if exercise == "Squat"{
            exercise = "Heave"
            nextButton.setTitle("Bench", for: UIControlState.normal)
            previousButton.setTitle("Squat", for: UIControlState.normal)
            pageControl.currentPage = 0
            
        } else if exercise == "Heave"{
            exercise = "Bench"
            nextButton.setTitle("Press", for: UIControlState.normal)
            previousButton.setTitle("Heave", for: UIControlState.normal)
            pageControl.currentPage = 1
        }
        requestData()
    }
    
   
    
    
    @IBAction func PreviousButtonPressed(_ sender: Any) {
        if exercise == "Bench" {
            exercise = "Heave"
            nextButton.setTitle("Bench", for: UIControlState.normal)
            previousButton.setTitle("Squat", for: UIControlState.normal)
            pageControl.currentPage = 0
            
        } else if exercise == "Heave" {
            exercise = "Squat"
            nextButton.setTitle("Heave", for: UIControlState.normal)
            previousButton.setTitle("Press", for: UIControlState.normal)
            pageControl.currentPage = 3
            
        } else if exercise == "Press" {
            exercise = "Bench"
            nextButton.setTitle("Press", for: UIControlState.normal)
            previousButton.setTitle("Heave", for: UIControlState.normal)
            pageControl.currentPage = 1
            
        } else if exercise == "Squat" {
            exercise = "Press"
            nextButton.setTitle("Squat", for: UIControlState.normal)
            previousButton.setTitle("Bench", for: UIControlState.normal)
            pageControl.currentPage = 2
            
        }
       requestData()
    }
    
    @IBAction func SwipeRight(_ gestureRecogniser : UISwipeGestureRecognizer) {
        if gestureRecogniser.state == .ended {
           PreviousButtonPressed(gestureRecogniser)
           
        }
    }
    @IBAction func SwipeLeft(_ gestureRecogniser : UISwipeGestureRecognizer) {
        if gestureRecogniser.state == .ended {
            nextButtonWasPressed(gestureRecogniser)
        }
    }

}

