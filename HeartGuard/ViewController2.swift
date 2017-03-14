//
//  ViewController2.swift
//  
//
//  Created by JasonZ on 2017-3-14.
//
//

import UIKit
import FirebaseAuth

class ViewController2: UIViewController {

    @IBAction func logout(_ sender: UIButton)
    {
    
        print("Sign out")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "segue2", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FIRAuth.auth()?.currentUser?.email)
        
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
