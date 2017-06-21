//
//  DetailViewController.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-3-23.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var heartRateValue: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var remarkValue: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!

    var heartRate: HeartRate!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        heartRateValue.text = "\(heartRate.heartRate!)"
        dateValue.text = heartRate.startDate
        remarkValue.text = heartRate.remark
        dateCreatedLabel.text = "2017-06-21 16:30"
        
    }
}
