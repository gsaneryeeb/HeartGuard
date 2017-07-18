//
//  DayViewController.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-3-23.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DayViewController: UITableViewController {

    var startDate: String?
    
    var ref: FIRDatabaseReference?
    
    
    var itemInCloudStore:[HeartRate] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        ref = FIRDatabase.database().reference()
        
        print("startDate:\(startDate!)")
        
        ref?.child(HGUser.sharedInstance.userUID!).child(startDate!).observe(.value, with: {(snapshot) -> Void in
            
            if snapshot.exists(){
                for child in ((snapshot.value as AnyObject).allValues)!{
    
                    let itemInCloud  = HeartRate(heartRate: 0, startDate: "", remark: "", saveDate: "", painRatingScale: 0)
                    
                    if let dayDate = child as? [String:AnyObject]{
                        
                        itemInCloud.heartRate = dayDate["heartRate"] as! Double
                        itemInCloud.painRatingScale = Int(dayDate["feeling"] as! String)!
                        itemInCloud.startDate = dayDate["startDate"] as? String
                        itemInCloud.saveDate = dayDate["createDate"] as? String
                        self.itemInCloudStore.append(itemInCloud)
                        self.tableView.reloadData()
                    }
                }
            }
        }) // eof firebase
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    // MARK: - Table View Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemInCloudStore.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a recyeled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayItemCell", for: indexPath) as! CloudDayCell
        
        let item = self.itemInCloudStore[indexPath.row]
        
        cell.painScaleLabel?.text = "\(item.painRatingScale!)"
        cell.heartRateLabel?.text = "\(Int(item.heartRate!))"
        cell.painPatingImageView.image = item.getPainImageFromPainRating(painRating: item.painRatingScale!)
        cell.createDateLabel?.text = item.startDate!
        
        return cell
    }
    
}
