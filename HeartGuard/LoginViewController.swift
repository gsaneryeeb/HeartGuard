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
    
    
    
    // MARK: Ouelet
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    
    
    // MARK: Actions
    
    @IBAction func skipAction(_ sender: UIButton) {
        
        HealthKitManager.getTodaysHeartRates()
        
    }
    
    // MARK: Login
    @IBAction func action(_ sender: UIButton) {
        
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
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: Health Kit
    
    
    
}

