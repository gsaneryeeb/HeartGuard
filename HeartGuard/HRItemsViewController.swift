//
//  HRItemsViewController.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-6-1.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit
import HealthKit

class HRItemsViewController: UITableViewController {

    // MARK: Health Kit
    let health:HKHealthStore = HKHealthStore()
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    var heartRateQuery:HKSampleQuery?
    
    // MARK: properties
    var heartRateStore = HeartRateStore()
    
    override func viewDidLoad() {
        
        print("----------HRItemsViewController viewDidLoad----------")
    
        super.viewDidLoad()
    
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        // Dynamic Cell Heights
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
        getTodaysHeartRates()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    // // MARK: - Table View Protocol Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heartRateStore.allRates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a recyvled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeartBeatTableCell", for: indexPath) as! HeartRateCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = heartRateStore.allRates[indexPath.row]
        
        // Configure the cell with the Item
        cell.heartRateLabel?.text = "\(item.heartRate!)"
        cell.recordTimeLabel?.text = item.startDate
        cell.remarkLabel?.text = item.remark
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        print("----------HRItemsViewContorlle tableView commit----------")
        
        // If the table view is asking to commit a delete command
        if editingStyle == .delete {
            let heartRate = heartRateStore.allRates[indexPath.row]
            // Remove the item from the store
            heartRateStore.removeHeartRate(heartRate: heartRate)
            
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        heartRateStore.moveHeartRateAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    // MARK: - Action
    @IBAction func addNewItem(sender: AnyObject){
        // Create a new item and add it to the store
        let newItem = heartRateStore.createItem()
        
        // Figure out where that item is in the array
        if let index = heartRateStore.allRates.index(of: newItem){
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
            
        }
        
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "ShowItem" segue
        if segue.identifier == "ShowItem" {
            
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // Get the item associated with this row and pass it along
                let item = heartRateStore.allRates[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.heartRate = item
            }
        }
    }
    
    // MARK: - Function
    
    // MARK: Method to get todays heart rate = this only reads data from health kit
    func getTodaysHeartRates(){
        print("----------HRItemsViewController getTodaysHeartRates----------")
        
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
            
            if(results!.count>0){
                
    
                performUIUpdatesOnMain {
                    
                    self.heartRateStore.removeAll()
                    
                    for iter in 0...results!.count-1
                    {
                        guard let currData:HKQuantitySample = results![iter] as? HKQuantitySample else { return }
                        
//                        print("[\(iter)]")
//                        print("Heart Rate:\(currData.quantity.doubleValue(for: self.heartRateUnit))")
//                        print("quantityType: \(currData.quantityType)")
//                        print("Start Date: \(currData.startDate)")
//                        print("End Date:\(currData.endDate)")
//                        print("Metadata: \(currData.metadata)")
//                        print("UUID: \(currData.uuid)")
//                        print("Source: \(currData.sourceRevision)")
//                        print("Device: \(currData.device)")
//                        print("---------------------------------\n")
//                        
                        //Heart Rate
                        let heartRate  = currData.quantity.doubleValue(for: self.heartRateUnit)
                        
                        // Start Date
                        let currDate:Date = currData.startDate
                        let dateFormatter:DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date:String = dateFormatter.string(from: currDate)
                        
                        let remark = date
                        
                        // Start Time
                        dateFormatter.dateFormat = "HH:mm:ss"
                        let time:String = dateFormatter.string(from: currDate)
                        
                        let startDate = time
                        
                        let heartRateItem = HeartRate(heartRate: heartRate, startDate: startDate, remark: remark)
                        
                        self.heartRateStore.addItem(newHeartRate: heartRateItem)
                    }//eofl
                    
                    self.tableView.reloadData() // reload Table View data
                }//performUIUpdatesOnMain
            }else{
                print("There are no data in results!")
            }
        }
        health.execute(heartRateQuery!)

    }
    
    // MARK: Request Authorization
    func requestAuthorization()
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
