//
//  DetailViewController.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-3-23.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetailViewController: UIViewController {

    @IBOutlet weak var heartRateValue: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var painScaleSlider: UISlider!
    @IBOutlet weak var painScaleLabel: UILabel!
    
    
    var heartRate: HeartRate!
    var ref:FIRDatabaseReference?
    var currentValue: Int = 4
    
    // MARK: - Action
    
    @IBAction func sliderMoved(slider:UISlider){
        
        currentValue = lroundf(slider.value)

        painScaleLabel.text = String(currentValue)
        
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        
        print("----------DetailViewController saveBtn----------")
        let userUID = HGUser.sharedInstance.userUID!
        let startDate = heartRate.startDate
        let date = startDate?.substring(to: (startDate?.index((startDate?.startIndex)!, offsetBy: 10))!)
        let now = Date()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createDate = formater.string(from: now)
        
        /* Database structure
           - userUID
              |- date
                  |-AutoID
                      |- startDate:
                      |- heartRate:
                      |- feeling:
                      |- createDate:
        */
        ref?.child(userUID).child(date!).childByAutoId().setValue(["startDate":heartRate.startDate,"heartRate":heartRate.heartRate,"feeling":painScaleLabel.text,"createDate":createDate])
        
    }
    // MARK: - Live Flow
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        heartRateValue.text = "\(heartRate.heartRate!)"
        dateValue.text = heartRate.startDate
        painScaleLabel.text = String(describing: heartRate.painRatingScale!)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        heartRate.painRatingScale = Int(painScaleLabel.text!)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
    }
}
