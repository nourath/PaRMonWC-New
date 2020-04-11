//
//  PaRMonWC
//
//  Created by Reem Alfaris on 4/8/20.
//  Copyright © 2020 Noura. All rights reserved.
//

import HealthKit
import AAInfographics
import UIKit
import Charts

// steps chart start from here

class BarChartController: UIViewController{
    
    @IBOutlet weak var barChart: BarChartView!
    var stepsDic: [Date: Double] = [:]
    var sortedArr: [(Date, Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let l = barChart.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false

        let rightAxis = barChart.rightAxis
        rightAxis.axisMinimum = 0

        let leftAxis = barChart.leftAxis
        leftAxis.axisMinimum = 0

        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = -0.5
        xAxis.granularity = 1
        xAxis.valueFormatter = self
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
        HealthKitAssistant.shared.retrieveStepCount(startDate: startDate, endDate: endDate) { (steps, startDate, endDate) in
            self.stepsDic[endDate] = steps
            DispatchQueue.main.async {
                self.barChartUpdate()
            }
        }
    }
    
    func barChartUpdate () {
        sortedArr = stepsDic.sorted(by: { (firstItem, secondItem) -> Bool in
            return firstItem.key < secondItem.key
        })
        
        var count = 0.0
        var entries: [BarChartDataEntry] = []
        
        for (_, value) in sortedArr{
            let entry = BarChartDataEntry(x: count, y: value)
            entries.append(entry)
            count += 1
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "7 days recently")
        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        //  barChart.chartDescription?.text = "Number of steps in day"
        // Color
        dataSet.colors = ChartColorTemplates.liberty()

        // Refresh chart with new data
        barChart.notifyDataSetChanged()
    }
}

extension BarChartController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        let date = sortedArr[Int(value)].0
        let result = dateFormatter.string(from: date)
        return result
    }
}

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd"
    return dateFormatter
}()


// heart rate chart starts from here

struct bmpNode {
    var date: Date
    var high: Double = -1
    var low: Double = -1
    var average: Double = -1
    
    var datas: [HKQuantitySample] = []
    
    init(_ datas: [HKQuantitySample]) {
        self.datas = datas
        self.date = datas.last!.startDate
        datas.forEach {
            if low < 0 || low > $0.heartRate {
                low = $0.heartRate
            }
            if high < 0 || high < $0.heartRate {
                high = $0.heartRate
            }
        }
        average = datas.reduce(0, { x, y in
            x + y.heartRate
        }) / Double(datas.count)
    }
}

extension HKQuantitySample {
    open var heartRate: Double {
        return self.quantity.doubleValue(for: HKUnit(from: "count/min"))
    }
}

extension Date {
  
    public var chnDay: String {
        let fmt: DateFormatter = DateFormatter()
        fmt.dateFormat = "MMM dd"
        return fmt.string(from: self)
    }
}
extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 1
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}

class HeartViewController: UIViewController {
    typealias timeBmp = Dictionary<Int, [HKQuantitySample]>
    let health = HKHealthStore()
    let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    var heartRateQuery:HKSampleQuery?
  
   var datas: timeBmp = {
        var datas: timeBmp = [:]
    for  day in 0 ... 31 {
            datas[day] = [] }
        
       return datas
    }()
    var bmpNodes = [bmpNode]()

   override func viewDidLoad() {
        super.viewDidLoad()
        self.getTodaysHeartRates()
    }
    
    func makeP() {
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height/1.2
        let aaChartView = AAChartView()
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        
        self.view.addSubview(aaChartView)
        
        let chartModel = AAChartModel()
            .chartType(.areaspline)//Chart type
            .title("Week heartbeat curve")//Chart main title
            .inverted(false)//Whether to flip the graph
          //  .yAxisTitle("Times/minute")// Y Axis title
            .legendEnabled(true)//Whether to enable the legend of the chart (clickable dot at the bottom of the chart)
           // .tooltipValueSuffix("Times/minute")//Floating prompt box unit suffix
            .categories(self.bmpNodes.compactMap({ $0.date.chnDay }))
            .colorsTheme(["#E8F2FC","#4686F6","#06caf4","#7dffc0"])//Theme color array
           
            .series([
                
                AASeriesElement()
                    .type(.areasplinerange) .name("highest")
                    .data(self.bmpNodes.compactMap({ [$0.low, $0.high] }).filter({ $0.first! > .zero }))
                    .toDic()!,
               
                AASeriesElement() .type(.spline) .name("average")
                    .data(self.bmpNodes.compactMap({ Int($0.average) }).filter({ $0 > .zero }))
                    .toDic()!,])
     
        
        aaChartView.aa_drawChartWithChartModel(chartModel)
    }
    
    
    /*Method to get todays heart rate - this only reads data from health kit. */
    func getTodaysHeartRates() {
       
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        //descriptor
        let sortDescriptors = [
            NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        heartRateQuery = HKSampleQuery.init(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            if let error = error {
                print("error \(error.localizedDescription)")
            } else {
                guard let results = results else { return }
                self.printHeartRateInfo(results)
            }
        })
        health.execute(heartRateQuery!)
        
    }
    
    /*used only for testing, prints heart rate info */
    private func printHeartRateInfo(_ results:[HKSample]) {
        for currData in results {
            guard let currData:HKQuantitySample = currData as? HKQuantitySample else { return }
            
            let date = currData.startDate
            let day = Calendar.current.component(.day, from: date)
            self.datas[day]?.append(currData)
            
            print("Heart Rate: \(currData.quantity.doubleValue(for: heartRateUnit))")
            print("quantityType: \(currData.quantityType)")
            print("Start Date: \(currData.startDate)")
            print("End Date: \(currData.endDate)")
            print("Metadata: \(String(describing: currData.metadata))")
            print("UUID: \(currData.uuid)")
            print("Source: \(currData.sourceRevision)")
            print("Device: \(String(describing: currData.device))")
            print("---------------------------------\n")
        }
        let times = self.datas.sorted(by: { $0.key < $1.key })
        
        for nodes in times {
            let split = nodes.value.sorted(by: { $0.startDate < $1.startDate }).split()
            if split.left.count > 0 {
                bmpNodes.append(bmpNode.init(split.left))
            }
            if split.right.count > 0 {
                bmpNodes.append(bmpNode.init(split.right))
                
            }
        }
        DispatchQueue.main.async {
            if self.bmpNodes.count < 48 {
                for _ in self.bmpNodes.count ..< 48 {
                    var node = self.bmpNodes.first!
                    node.high = -1
                    node.low = -1
                    node.average = -1
                    self.bmpNodes.append(node)
                }
            }
            self.makeP()
          
        }
    }
}

