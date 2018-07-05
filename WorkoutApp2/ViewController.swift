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
    
    @IBOutlet weak var todaysLiftLabel: UITextField!
    @IBOutlet weak var lastLiftLabel: UILabel!
    
    var lastLift: Float = 102
    var todaysLift: Float = 106
    var nextLift: Float = 112
    

    override func viewDidLoad() {
        super.viewDidLoad()
        saveData()
    }

   
    func saveData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
  
        let entity = NSEntityDescription.entity(forEntityName: "Bench", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue("bench", forKey: "name")
        newUser.setValue(80, forKey: "score")
        newUser.setValue(4, forKey: "increment")
        
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
        populateFields()
    }
    
    
    func populateFields() {
        //code
        todaysLiftLabel.text = "\(todaysLift)"
        requestData()
    }
    
    
    func requestData() {
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bench")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
            }
        } catch {
            print("failed")
        }
        lastLiftLabel.text = "\(lastLift)"
        
    }
    
    
    
    
    
    
    
}

