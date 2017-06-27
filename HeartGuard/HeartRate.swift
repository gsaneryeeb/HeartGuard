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
    var remark: String?
    var saveDate: String? // The date of save data to database
    // The feeling of your heart from 0 to 10
    // 😃0 No Hurt 🙂2 Hurts Little Bit ☹️4 Hurts Little More 😧6 Hurts Even More 😣8 Hurts Whole Lot 😰10 Hurts Worst
    var painRatingScale: Int?
    
    init(heartRate:Double,startDate:String,remark:String,saveDate:String,painRatingScale:Int) {
        self.heartRate = heartRate
        self.startDate = startDate
        self.remark = remark
        self.saveDate = saveDate
        self.painRatingScale = painRatingScale
        super.init()
    }
    
}
