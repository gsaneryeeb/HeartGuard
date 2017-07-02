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
    
    
    // MARK: Get Image of PainRating from its value(0-10)
    func getPainImageFromPainRating(painRating: Int) -> UIImage {
    
        
        var painRatingScale: UIImage?
        
        switch Int(painRating) {
            
        case 0..<2:
            // No Hurt
            painRatingScale = #imageLiteral(resourceName: "painScale0")
        case 2..<4:
            // Hurts Little Bit
            painRatingScale = #imageLiteral(resourceName: "painScale2")
        case 4..<6:
            // Hurts Little More
            painRatingScale = #imageLiteral(resourceName: "painScale4")
        case 6..<8:
            // Hurts Even More
            painRatingScale = #imageLiteral(resourceName: "painScale6")
        case 8..<10:
            // Hutrs Whole Lot
            painRatingScale = #imageLiteral(resourceName: "painScale8")
        default:
            // Hurts very very
            painRatingScale = #imageLiteral(resourceName: "painScale10")
        }

        return painRatingScale!
    }
    
}
