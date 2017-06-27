//
//  CloudItemsViewController.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-6-24.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CloudItemsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    
    
    @IBOutlet weak var cloudTableVIew: UITableView!
    
    
    var handle: FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    var listByDate = [String:UInt]()
    
    var postKey = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        let userUID = HGUser.sharedInstance.userUID!
        
        ref?.child(userUID).observe(.value, with: { (snapshot) -> Void in
            
            if(snapshot.value is NSNull){
            
                print("Not Found in Firebase")
            
            } else{
                print("1st Children count \(snapshot.childrenCount)")
                for child in snapshot.children {
                    
                    
                    let saveDate = (child as AnyObject).key as String
                    let childCount = (child as AnyObject).childrenCount as UInt
                    print("1st Children count \(childCount)")
                    
                    self.listByDate = [saveDate:childCounnt]
                    
                    self.cloudTableVIew.reloadData()
                    
                    
                }
            }
        
            
        })
    }
    
    // MARK: - Delegate Action
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listByDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cloudViewCell")
        cell.textLabel?.text = listByDate.keys
        cell.detailTextLabel?.text = listByDate.
        return cell
        
    }
    
}
