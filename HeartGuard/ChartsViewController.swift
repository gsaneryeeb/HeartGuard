//
//  ChartsViewController.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-7-8.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase

class ChartsViewController:UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var ref:FIRDatabaseReference?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getChartData()
        
    }
    
    func getChartData() ->Void {
        
        ref = FIRDatabase.database().reference()
        
        var heartRateForChart:Dictionary<Double,Double> = [:]
        
        
        ref?.child(HGUser.sharedInstance.userUID!).queryOrdered(byChild: "heartRate").observe(.value, with: { (snapshot) -> Void in
            
            if snapshot.exists(){
                if let allData = snapshot.value as?[String:AnyObject] {
                    
                    for(_,dataByDay) in allData{
                        
                        let heartRates = dataByDay as? [String: AnyObject]
                        
                        for (_ ,heartData) in heartRates!{
                            
                            let tempHeart = heartData["heartRate"] as! Double
                            let tempFeeling = Double(heartData["feeling"] as! String)!
                            
                            heartRateForChart[tempHeart] = tempFeeling
                            
                        } // end for heardata
                        
                    }//end for
                    
                }// end allData
            }// end snapshot
            
            self.setChart(heartRateForChart)
            
        }) // end query
        
    }
    
    
    func setChart(_ dataForChart: Dictionary<Double,Double>) {
        
        lineChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        
        let sortedData = dataForChart.sorted(by: {$0.0 < $1.0})
        
        for (xPoint, yPoint) in sortedData {
            
            let dataEntry = ChartDataEntry(x: xPoint, y: yPoint)
            
            dataEntries.append(dataEntry)
    
        }
        
        // LienChart
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Pain Index ")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        lineChartView.data = lineChartData
        
        lineChartView.descriptionText = ""
        
        lineChartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        lineChartDataSet.setCircleColor(UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1))
        lineChartDataSet.circleHoleColor = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        lineChartDataSet.circleRadius = 4.0
    
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        let dangerousLine = ChartLimitLine(limit: 8.0, label: "Dangerous")
        
        lineChartView.rightAxis.addLimitLine(dangerousLine)
    
        
    }
    
}
