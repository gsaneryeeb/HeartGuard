//
//  HeartRate.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-6-1.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit

class HeartRate: NSObject {
    
    var heartRate: Double?
    var startDate: String?
    var remark:String?

    init(heartRate:Double,startDate:String,remark:String) {
        self.heartRate = heartRate
        self.startDate = startDate
        self.remark = remark
        super.init()
    }
    
}
