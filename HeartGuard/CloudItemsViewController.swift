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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var handle: FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    var listByDate:[(saveDate:String, count:UInt)] = []
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.activityIndicator.alpha = 1.0
            self.activityIndicator.startAnimating()
        }
        
        ref = FIRDatabase.database().reference()
        
        let userUID = HGUser.sharedInstance.userUID!
        
        ref?.child(userUID).observe(.value, with: { (snapshot) -> Void in
            
            if(snapshot.value is NSNull){
            
                print("Not Found in Firebase")
                
                
            } else{

                for child in snapshot.children {
                    
                    
                    let saveDate = (child as AnyObject).key as String
                    
                    let childCount = (child as AnyObject).childrenCount as UInt
                    
                    self.listByDate.append((saveDate: saveDate, count: childCount))
                    
                }
                
                self.listByDate = self.listByDate.sorted{ $0 > $1 }
                self.cloudTableVIew.reloadData()
                
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
            }
            
            
        })
        
        
    }
    
    // MARK: - Delegate Action
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listByDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cloudViewCell", for: indexPath)
        
        cell.textLabel?.text = listByDate[indexPath.row].saveDate
        cell.detailTextLabel?.text = "\(listByDate[indexPath.row].count)"
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("----------CloudItemsViewContorller prepareForSegue----------")
        
        
        
        let cell = sender as! UITableViewCell
        
        // If the triggered segue is the "ShowDayItem"
        if segue.identifier == "ShowDayItem" {
            print("----------CloudItemsViewContorller prepare--ShowDayItem--------")
            
            // Figure out which row just tapped
            if let row = cloudTableVIew.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let saveDate = listByDate[row].saveDate
                let dayViewController = segue.destination as! DayViewController
                dayViewController.startDate = saveDate
                
                // Set next view back button title
                let backItem = UIBarButtonItem()
                backItem.title = saveDate
                navigationItem.backBarButtonItem = backItem
                
                
                
            }
        }
        
    }
    
}
