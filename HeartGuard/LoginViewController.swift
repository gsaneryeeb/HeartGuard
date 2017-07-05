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
    var keyboardOnScreen = false
    
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
    @IBOutlet weak var messageLabel: UILabel!
    
    
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
                        HGUser.sharedInstance.email = self.emailText.text!
                        HGUser.sharedInstance.userUID = user?.uid
                        
                        self.present(controller, animated: true, completion: nil)
                        
                    }else{
                        if let myError = error?.localizedDescription{
                            
                            print("Login error:\(myError)")
                            
                            self.messageLabel.text = myError
                            
                        }else{
                            // user or password error
                            print(" Other Errors")
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
                            
                            print("sign up error:\(myError)")
                            self.messageLabel.text = myError
                            
                        }else{
                            print(" Other Errors")
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
        
        actionButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view, typically from a nib.
        // self.requestAuthorization()
        // self.getTodaysHeartRates()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - LoginViewController: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate{
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
            
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField){
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(emailText)
        resignIfFirstResponder(passwordText)
    }

}


