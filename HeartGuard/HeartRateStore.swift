//
//  HeartRateStore.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-6-1.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit

class HeartRateStore {
    
    var allRates = [HeartRate]()
    
    func createItem() -> HeartRate {
        let newHeartRate = HeartRate(random: true, startDate: <#Date#>)
        
        allRates.append(newHeartRate)
        
        return newHeartRate
    }
}
