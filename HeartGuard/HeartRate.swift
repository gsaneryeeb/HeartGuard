//
//  HeartRate.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-6-1.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit

class HeartRate: NSObject {
    
    var heartRate: Int
    var startDate: String?

    init(heartRate:Int,startDate:String) {
        self.heartRate = heartRate
        self.startDate = startDate
        
        super.init()
    }
    
    
    
    convenience init(random:Bool = false){
        if random {
         
            let randomHeartRate = Int(arc4random_uniform(100))
            
            
            let day = arc4random_uniform(UInt32(100))+1
            let hour = arc4random_uniform(23)
            let minute = arc4random_uniform(59)
            
            let today = Date(timeIntervalSinceNow: 0)
            let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            var offsetComponents = DateComponents()
            offsetComponents.day = Int(day - 1)
            offsetComponents.hour = Int(hour)
            offsetComponents.minute = Int(minute)
            
            let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
            
        
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let randomStartDate = dateFormatter.string(from: randomDate!)
            self.init(heartRate:randomHeartRate,
                      startDate:randomStartDate)
        }
        else{
            self.init(heartRate: 100,startDate:"2017-06-01")
        }
    }
    
    
}
