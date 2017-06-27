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
    
    
    func addItem(newHeartRate: HeartRate){
        
        allRates.append(newHeartRate)
    }
    
    func removeHeartRate(heartRate: HeartRate){
        if let index = allRates.index(of: heartRate) {
            allRates.remove(at: index)
        }
        
    }
    
    func removeAll(){
        
        allRates.removeAll()
    
    }
    
    func moveHeartRateAtIndex(fromIndex: Int, toIndex: Int){
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being moved so you can reinsert it. 
        let movedItem = allRates[fromIndex]
        
        // Remove item from array
        allRates.remove(at: fromIndex)
        
        // Insert item in array at new location
    }
    
}
