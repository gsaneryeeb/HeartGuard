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
    
    
    // MARK: Ouelet
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Login
    @IBAction func action(_ sender: UIButton) {
        
        print("------- LoginViewController: Login button action -------")
        
        userDidTapView(self)
        
        // Set Activity Indicator
        DispatchQueue.main.async {
            self.activityIndicator.alpha = 1.0
            self.activityIndicator.startAnimating()
        }
        
        
        if emailText.text != "" && passwordText.text != ""
        {
            setUIEnable(false)
            
            if segmentControl.selectedSegmentIndex == 0{
                // Login user
                FIRAuth.auth()?.signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil {
                        // Sign in successful

                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "showHeartBeat") as! UITabBarController
                        HGUser.sharedInstance.email = self.emailText.text!
                        HGUser.sharedInstance.userUID = user?.uid
                        
                        self.present(controller, animated: true, completion: nil)
                        
                        self.setUIEnable(true)
                        
                    }else{
                        
                        self.setUIEnable(true)
                        
                        if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!){
                            
                            switch errorCode{
                            
                            case .errorCodeOperationNotAllowed:
                                self.showErrorAlert("The email and password accounts are not enabled. Please contact support.")
                            case .errorCodeUserDisabled:
                                self.showErrorAlert("Your account has been disabled. Please contact support.")
                            case .errorCodeInvalidEmail, .errorCodeWrongPassword:
                                self.showErrorAlert("Please enter a vaild email or a wrong password")
                            case .errorCodeNetworkError:
                                self.showErrorAlert("Network error. Please try again.")
                            case .errorCodeUserNotFound:
                                self.showErrorAlert("The user doesn't exist. Please sign up!")
                            default:
                                self.showErrorAlert("Unknown error occurred.(\((error?.localizedDescription)!))")
                            }
                            
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                    }
                    
                })
            }else{
                // sign up
                FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil
                    {
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "showHeartBeat") as! UITabBarController
                        
                        HGUser.sharedInstance.email = self.emailText.text!
                        HGUser.sharedInstance.userUID = user?.uid
                        
        
                        self.present(controller, animated: true, completion: nil)
                        
                        self.setUIEnable(true)
                        
                        DispatchQueue.main.async {
                            self.activityIndicator.isHidden = true
                        }
                        
                    }
                    else
                    {
                        self.setUIEnable(true)
                        
                        if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!){
                            
                            switch errorCode{
                                
                            case .errorCodeEmailAlreadyInUse:
                                self.showErrorAlert("The email is already in use with another account.")
                            case .errorCodeOperationNotAllowed:
                                self.showErrorAlert("Your account has been disabled. Please contact support.")
                            case .errorCodeInvalidEmail, .errorCodeInvalidSender,.errorCodeInvalidRecipientEmail:
                                self.showErrorAlert("Please enter a vaild email.")
                            case .errorCodeNetworkError:
                                self.showErrorAlert("Network error. Please try again.")
                            case .errorCodeWeakPassword:
                                self.showErrorAlert("Your password is too weak.")
                            default:
                                self.showErrorAlert("Unknown error occurred.(\((error?.localizedDescription)!))")
                            }
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                    }
                    
                })
            }
        }else{
            
            self.showErrorAlert("Username or Password Empty.")
            
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
            }
            
        }

        
    }
    
    // MARK: Functions
    func showErrorAlert(_ error : String){
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        print("----------LoginViewController viewDidLoad----------")
        
        super.viewDidLoad()
        
        actionButton.layer.cornerRadius = 5
        
        activityIndicator.alpha = 0.0
        // Request HealthKit Authorization
        requestAuthorization()
    }
    
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
    
    
}

// MARK: - LoginViewController (Configure UI)
private extension LoginViewController{
    
    func setUIEnable(_ enabled: Bool){
        emailText.isEnabled = enabled
        passwordText.isEnabled = enabled
        actionButton.isEnabled = enabled
        messageLabel.text = ""
        messageLabel.isEnabled = enabled
        
    }
    
    func displayError(_ errorString: String?){
        if let errorString = errorString{
            messageLabel.text = errorString
        }
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
        view.frame.origin.y = keyboardHeight(notification) * (-1)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue // of CGRect
        if passwordText.isFirstResponder{
            return keyboardSize.cgRectValue.height
        }else{
            return 0
        }
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

// MARK: - LoginViewController (Notification)

private extension LoginViewController{
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotification(){
        NotificationCenter.default.removeObserver(self)
    }
}




