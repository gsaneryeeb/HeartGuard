//
//  ViewController.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-2-24.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit
import FirebaseAuth
import HealthKit

class LoginViewController: UIViewController,UINavigationControllerDelegate {

    
    // MARK: Properties
    
    // MARK: Health Kit Properties
    let health:HKHealthStore = HKHealthStore()
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    var heartRateQuery:HKSampleQuery?
    var heartRateResultsTable:TableViewController?
    
    
    
    // MARK: Ouelet
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    
    
    // MARK: Actions
    
    @IBAction func skipAction(_ sender: UIButton) {
    }

        
    // MARK: Login
    @IBAction func action(_ sender: UIButton) {
        
        print("------- LoginViewController: Login button action -------")
        
        if emailText.text != "" && passwordText.text != ""
        {
            if segmentControl.selectedSegmentIndex == 0{
                // Login user
                FIRAuth.auth()?.signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil {
                        // Sign in successful
                        
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "showHeartBeat") as! UINavigationController
                        
                        self.present(controller, animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "segue", sender: self)
                        //self.requestAuthorization()
                        //self.setupHeartRateTable()
                        //self.getTodaysHeartRates()
                        
                    }else{
                        if let myError = error?.localizedDescription{
                            
                            print(myError)
                        
                        }else{
                            // user or password error
                            print("Error")
                        }
                    }
                })
            }else{
                // sign up
                FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil
                    {
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "showHeartBeat") as! UINavigationController
                        
                        self.present(controller, animated: true, completion: nil)
                        
                    
                        //self.performSegue(withIdentifier: "segue", sender: self)

                    }
                    else
                    {
                        if let myError = error?.localizedDescription{
                            
                            print(myError)
                            
                        }else{
                            // user or password error
                            print("Error")
                        }
                    }
                })
            }
        }
        
        
        
        
    }
    
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        print("----------LoginViewController viewDidLoad----------")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.requestAuthorization()
        self.getTodaysHeartRates()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: Health Kit
    
    // MARK: Method to get todays heart rate = this only reads data from health kit
    func getTodaysHeartRates()
    {
        print("--------LoginViewController getTodaysHeartRates---------")
        //predicate
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year,.month,.day], from: now)
        guard let startDate:Date = calendar.date(from: components) else { return }
        let endDate:Date? = calendar.date(byAdding: .day, value: 1, to: startDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        // descriptor
        let sortDescriptors = [NSSortDescriptor(key:HKSampleSortIdentifierEndDate,ascending:false)]
        heartRateQuery = HKSampleQuery(sampleType: heartRateType,
                                       predicate: predicate,
                                       limit: 25,
                                       sortDescriptors: sortDescriptors)
        { (query:HKSampleQuery, results:[HKSample]?, error:Error?) -> Void in
            
            guard error == nil else { print("error");return}
            
            self.printHeartRateInfo(results: results)
            
            //self.updateHeartRateTableViewContent(samples: results)
            
        }
        health.execute(heartRateQuery!)
        
    }
    
    // MARK: Testing prints heart rate info
    func printHeartRateInfo(results:[HKSample]?)
    {
        //for(var iter = 0; iter < results!.count; iter++)
        
        print("result count:\(results!.count)")
        
        for iter in 0...results!.count-1
        {
            guard let currData:HKQuantitySample = results![iter] as? HKQuantitySample else { return }
            
            HeartRateRecords.sharedInstance.listOfRecords.append(currData)
            
            print("[\(iter)]")
            print("Heart Rate:\(currData.quantity.doubleValue(for: heartRateUnit))")
            print("quantityType: \(currData.quantityType)")
            print("Start Date: \(currData.startDate)")
            print("End Date:\(currData.endDate)")
            print("Metadata: \(currData.metadata)")
            print("UUID: \(currData.uuid)")
            print("Source: \(currData.sourceRevision)")
            print("Device: \(currData.device)")
            print("---------------------------------\n")
        }//eofl
    }//eom
    
    // MARK: Request Authorization
    func requestAuthorization()
    {
        // reading
        let readingTypes:Set = Set([heartRateType])
        
        // writing
        let writingTypes:Set = Set([heartRateType])
        
        // auth request
        health.requestAuthorization(toShare: writingTypes, read: readingTypes) { (success, error) -> Void in
            
            if error != nil
            {
                print("error \(error?.localizedDescription)")
            }
            else if success
            {
                
            }
        }// eo-request
    }//eom
    
    // MARK: Heart Rate Table
    func updateHeartRateTableViewContent(samples: [HKSample]?)
    {
        print("----------LoginViewController updateHeartRateTableViewContent---------")
        
        guard (samples?.count)! > 0 else {return}
        
        var vc = self.storyboard?.instantiateViewController(withIdentifier: "HeartRateDetail") as! TableViewController
        
        vc.updateTableViewContent(newContent: samples!)
        
        //heartRateResultsTable?.updateTableViewContent(newContent: samples!)
        
        
    }
    
    
    
    
}

