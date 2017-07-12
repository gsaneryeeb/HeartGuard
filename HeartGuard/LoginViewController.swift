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
    
    // MARK: Login
    @IBAction func action(_ sender: UIButton) {
        
        print("------- LoginViewController: Login button action -------")
        
        userDidTapView(self)
        
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
                })
            }
        }else{
            
            self.showErrorAlert("Username or Password Empty.")
        }

        
    }
    
    // MARK: Functions
    func showErrorAlert(_ error : String){
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        print("----------LoginViewController viewDidLoad----------")
        
        super.viewDidLoad()
        
        actionButton.layer.cornerRadius = 5
        
        //Set Notification
//        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
//        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
//        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
//        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageLabel.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

// MARK: - LoginViewController (Notification)

private extension LoginViewController{
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotification(){
        NotificationCenter.default.removeObserver(self)
    }
}




