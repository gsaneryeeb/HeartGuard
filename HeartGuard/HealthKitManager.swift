//
//  HealthKitManager.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-3-17.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager: NSObject {

    // MARK: Health Kit
    static let health:HKHealthStore = HKHealthStore()
    static let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    static let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    static var heartRateQuery:HKSampleQuery?
    
    // MARK: Method to get todays heart rate = this only reads data from health kit
    static func getTodaysHeartRates()
    {
        
        //predicate
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year,.month,.day], from: now)
        guard let startDate:Date = calendar.date(from: components) else { return }
        let endDate:Date? = calendar.date(byAdding: .day, value: 1, to: startDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        // descriptor
        let sortDescriptors = [NSSortDescriptor(key:HKSampleSortIdentifierEndDate,ascending:false)]
        heartRateQuery = HKSampleQuery(sampleType: heartRateType,
                                       predicate: predicate,
                                       limit: 25,
                                       sortDescriptors: sortDescriptors)
        { (query:HKSampleQuery, results:[HKSample]?, error:Error?) -> Void in
            
            guard error == nil else { print("error");return}
            
            self.printHeartRateInfo(results: results)
            
            //self.updateHistoryTableViewContent(results)
            
        }
        health.execute(heartRateQuery!)
        
    }
    
    // MARK: Testing prints heart rate info
    static func printHeartRateInfo(results:[HKSample]?)
    {
        //for(var iter = 0; iter < results!.count; iter++)
        for iter in 0...results!.count-1
        {
            guard let currData:HKQuantitySample = results![iter] as? HKQuantitySample else { return }
            
            print("[\(iter)]")
            print("Heart Rate:\(currData.quantity.doubleValue(for: heartRateUnit))")
            print("quantityType: \(currData.quantityType)")
            print("Start Date: \(currData.startDate)")
            print("End Date:\(currData.endDate)")
            print("Metadata: \(currData.metadata)")
            print("UUID: \(currData.uuid)")
            print("Source: \(currData.sourceRevision)")
            print("Device: \(currData.device)")
            print("---------------------------------\n")
        }//eofl
    }//eom
    
    // MARK: Request Authorization
    static func requestAuthorization()
    {
        // reading
        let readingTypes:Set = Set([heartRateType])
        
        // writing
        let writingTypes:Set = Set([heartRateType])
        
        // auth request
        health.requestAuthorization(toShare: writingTypes, read: readingTypes) { (success, error) -> Void in
            
            if error != nil
            {
                print("error \(error?.localizedDescription)")
            }
            else if success
            {
                
            }
        }// eo-request
    }//eom
    
}
