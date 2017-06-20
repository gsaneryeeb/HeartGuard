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
                        
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "showHeartBeat") as! UITabBarController
                        
                        self.present(controller, animated: true, completion: nil)
                        
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
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "showHeartBeat") as! UITabBarController
                        
                        self.present(controller, animated: true, completion: nil)
                        
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
        // self.requestAuthorization()
        // self.getTodaysHeartRates()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: Health Kit
}

