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
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    var lastLift: Float = 100
    var todaysLift: Float = 105
    var nextLift: Float = 112
    var increment: Float = 5
    var exercise: String = "Bench"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseDatabase()
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
        
        
        benchData.setValue("Bench", forKey: "name")
        benchData.setValue(100, forKey: "score")
        benchData.setValue(5, forKey: "increment")
        
        heaveData.setValue("Heave", forKey: "name")
        heaveData.setValue(40, forKey: "score")
        heaveData.setValue(2.5, forKey: "increment")
        
        pressData.setValue("Press", forKey: "name")
        pressData.setValue(68, forKey: "score")
        pressData.setValue(2.5, forKey: "increment")
        
        squatData.setValue("Squat", forKey: "name")
        squatData.setValue(60, forKey: "score")
        squatData.setValue(10, forKey: "increment")
        
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
        
        
        newData.setValue(exercise, forKey: "name")
        newData.setValue(todaysLift, forKey: "score")
        newData.setValue(increment, forKey: "increment")
        
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
        requestData()
        
    }
    
    
    func populateFields() {
        
        todaysLiftLabel.text = "\(todaysLift)"
        lastLiftLabel.text = "\(lastLift)"
        nextLiftLabel.text = "\(nextLift)"
        exerciseLabel.text = exercise.uppercased()
        incrementsLabel.text = "\(increment)"
        
    }
    
    
    func requestData() {
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: exercise)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "name") == nil {
                    initialiseDatabase()
                } else {
            
               // exercise = data.value(forKey: "name") as! String
                increment = data.value(forKey: "increment") as! Float
                lastLift = data.value(forKey: "score") as! Float
                }
            }
        } catch {
            print("failed")
        }
        
        todaysLift = lastLift + increment
        nextLift = todaysLift + increment
        
        populateFields()
    }
    
    
    @IBAction func doneButtonWasPressed(_ sender: Any) {
        todaysLift = (todaysLiftLabel.text! as NSString).floatValue
        increment = (incrementsLabel.text! as NSString).floatValue
        saveData()
        view.endEditing(true)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: Any) {
        if exercise == "Bench" {
            exercise = "Press"
            previousButton.setTitle("Bench", for: UIControlState.normal)
            nextButton.setTitle("Squat", for: UIControlState.normal)
            
        } else if exercise == "Press" {
            exercise = "Squat"
            nextButton.setTitle("Heave", for: UIControlState.normal)
            previousButton.setTitle("Press", for: UIControlState.normal)
        
        } else if exercise == "Squat"{
            exercise = "Heave"
            nextButton.setTitle("Bench", for: UIControlState.normal)
            previousButton.setTitle("Squat", for: UIControlState.normal)
        } else if exercise == "Heave"{
            exercise = "Bench"
            nextButton.setTitle("Press", for: UIControlState.normal)
            previousButton.setTitle("Heave", for: UIControlState.normal)
        }
        requestData()
    }
    
   
    
    
    @IBAction func PreviousButtonPressed(_ sender: Any) {
        if exercise == "Bench" {
            exercise = "Heave"
            nextButton.setTitle("Bench", for: UIControlState.normal)
            previousButton.setTitle("Squat", for: UIControlState.normal)
            
        } else if exercise == "Heave" {
            exercise = "Squat"
            nextButton.setTitle("Heave", for: UIControlState.normal)
            previousButton.setTitle("Press", for: UIControlState.normal)
            
        } else if exercise == "Press" {
            exercise = "Bench"
            nextButton.setTitle("Press", for: UIControlState.normal)
            previousButton.setTitle("Heave", for: UIControlState.normal)
        } else if exercise == "Squat" {
            exercise = "Press"
            nextButton.setTitle("Squat", for: UIControlState.normal)
            previousButton.setTitle("Bench", for: UIControlState.normal)
        }
       requestData()
    }
    
    
}

