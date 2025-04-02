//
//  TestChart.swift
//  bureau-ios-device-bb
//
//  Created by apple on 28/03/25.
//

import UIKit
import DGCharts

class BehaviouralInsightsGraph: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleIco: UIImageView!
    
    @IBOutlet weak var Line_1_Lbl: UILabel!
    @IBOutlet weak var Line_2_Lbl: UILabel!
    @IBOutlet weak var Line_3_Lbl: UILabel!
    @IBOutlet weak var Line_4_Lbl: UILabel!
    
    @IBOutlet weak var graphParentView: UIView!
    
    private var bubbleGraphView: BubbleChartView!
    private var lineGraphView: LineChartView!
    private var counter = 0.0
    var bubbleGraphdataEntries: [BubbleChartDataEntry] = []
    var lineGraphdataEntries: [ChartDataEntry] = []

    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BehaviouralInsightsGraph", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func initBubbleGraph() {
        bubbleGraphView = BubbleChartView()
        graphParentView.layoutIfNeeded()
        bubbleGraphView.frame = graphParentView.bounds
        graphParentView.addSubview(bubbleGraphView)
        
        
        bubbleGraphView.dragEnabled = false
        bubbleGraphView.drawBordersEnabled = false
        bubbleGraphView.legend.enabled = false
        bubbleGraphView.pinchZoomEnabled = false
//        bubbleGraphView.maxVisibleCount = 200
        
        
        let xAxis = bubbleGraphView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = true
        xAxis.labelFont = UIFont(name: "Lexend-Regular", size: 12) ?? .systemFont(ofSize: 12)
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = Double(screenWidth)   // Set max to screen width
        
        
        // Y-Axis based on screen height
        let leftAxis = bubbleGraphView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.labelFont = UIFont(name: "Lexend-Regular", size: 12) ?? .systemFont(ofSize: 12)
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = Double(screenHeight)   // Set max to screen height

        bubbleGraphView.rightAxis.enabled = false
        
        // Initialize empty data
        let dataSet = BubbleChartDataSet(entries: bubbleGraphdataEntries, label: "Touch Data")
        dataSet.setColor(NSUIColor(cgColor: AppConstant.ThemeColor!.cgColor), alpha: 0.5)
        dataSet.drawValuesEnabled = false
        dataSet.valueFont = .systemFont(ofSize: 10)
        
        // **Fixed bubble size**
        dataSet.normalizeSizeEnabled = false  // Disable dynamic sizing
        
        bubbleGraphView.data = BubbleChartData(dataSet: dataSet)
    }
    
    func addBubbleGraphEntry(randomDouble1: Double, randomDouble2: Double, randomDouble3: Double) {
        counter += 1.0
        
        // Add new bubble entry
        let newEntry = BubbleChartDataEntry(x: randomDouble1, y: randomDouble2, size: randomDouble3)
        bubbleGraphdataEntries.append(newEntry)
        
        // Update the dataset
        if let dataSet = bubbleGraphView.data?.dataSets.first as? BubbleChartDataSet {
            dataSet.append(newEntry)
            
            bubbleGraphView.data?.notifyDataChanged()
            bubbleGraphView.notifyDataSetChanged()
        }
    }
    
    
    func initLineGraph(){
        lineGraphView = LineChartView()
        graphParentView.layoutIfNeeded()
        lineGraphView.frame = CGRect(x: 0, y: 0, width: graphParentView.frame.size.width, height: graphParentView.frame.size.height)
        graphParentView.addSubview(lineGraphView)
        
        let xAxis = lineGraphView.xAxis
        xAxis.drawLabelsEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.drawAxisLineEnabled = true
        xAxis.centerAxisLabelsEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = Double(screenWidth)
        
        
        // Customize Y-axis (left and right)
        let leftAxis = lineGraphView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.labelFont = UIFont(name: "Lexend-Regular", size: 12)!
        leftAxis.labelTextColor = AppConstant.ThemeFontColor ?? .gray
        leftAxis.labelAlignment = .left
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = Double(screenHeight)   // Set max to screen height
//        leftAxis.inverted = true
        
        let rightAxis = lineGraphView.rightAxis
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.labelFont = UIFont(name: "Lexend-Regular", size: 12)!
        leftAxis.labelTextColor = AppConstant.ThemeFontColor ?? .gray


        
        // First data set
        let dataSet = LineChartDataSet(entries: lineGraphdataEntries, label: "Touch Data")
//        dataSet.colors = [NSUIColor(cgColor: AppConstant.ThemeColor!.cgColor)]
        dataSet.setColor(NSUIColor(cgColor: AppConstant.ThemeColor!.cgColor), alpha: 0.5)

        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 4.0
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = 1.0
        dataSet.circleColors = [AppConstant.ThemeColor!.withAlphaComponent(0.5)]

        lineGraphView.drawBordersEnabled = false
        lineGraphView.dragEnabled = false
        lineGraphView.legend.enabled = false
        
        let data = LineChartData(dataSets: [dataSet])
        lineGraphView.data = data
        lineGraphView.animate(xAxisDuration: 0.3)
        
    }
    
    func addLineGraphEntry(randomDouble1: Double, randomDouble2: Double, randomDouble3: Double) {
        let newEntry = ChartDataEntry(x: randomDouble1, y: randomDouble2)
        lineGraphdataEntries.append(newEntry)
        
        if let dataSet = lineGraphView.data?.dataSets.first as? LineChartDataSet {
            dataSet.append(newEntry)
            
            lineGraphView.data?.notifyDataChanged()
            lineGraphView.notifyDataSetChanged()
        }
        
    }
}
