//
//  HeartRateRecords.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-5-13.
//  Copyright © 2017 saneryee. All rights reserved.
//

import Foundation
import HealthKit

class HeartRateRecords {
    
    // MARK: Shared Instance
    
    static let sharedInstance : HeartRateRecords = {
        let instance = HeartRateRecords(array: [])
        return instance
    }()
    
    // MARK:  Local Variable
    
    var listOfRecords : [HKSample]
    
    // MARK: Init
    
    init( array : [HKSample]) {
        listOfRecords = array
    }
}
