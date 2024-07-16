//
//  BureauLineGraphView.swift
//  bureau-ios-device-bb
//
//  Created by User on 09/07/24.
//

import UIKit
import Charts

class BureauLineGraphView: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleIco: UIImageView!

    @IBOutlet weak var Line_1_Lbl: UILabel!
    @IBOutlet weak var Line_2_Lbl: UILabel!
    @IBOutlet weak var Line_3_Lbl: UILabel!
    @IBOutlet weak var Line_4_Lbl: UILabel!
    
    @IBOutlet weak var graphParentView: UIView!
    
    var graphView: LineChartView!
    var counter = 0.0
    var dataEntries1: [ChartDataEntry] = []
    var dataEntries2: [ChartDataEntry] = []
    var dataEntries3: [ChartDataEntry] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        initGraph()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BureauLineGraphView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    private func initGraph(){
        graphView = LineChartView()
        graphParentView.layoutIfNeeded()
        graphView.frame = CGRect(x: 0, y: 0, width: graphParentView.frame.size.width, height: graphParentView.frame.size.height)
        graphParentView.addSubview(graphView)
        
        let xAxis = graphView.xAxis
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.centerAxisLabelsEnabled = true

        
        // Customize Y-axis (left and right)
        let leftAxis = graphView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.labelFont = UIFont(name: "Lexend-Regular", size: 12)!
        leftAxis.labelTextColor = AppConstant.ThemeFontColor ?? .gray
        leftAxis.labelAlignment = .left
        leftAxis.setLabelCount(5, force: true)

        let rightAxis = graphView.rightAxis
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false
        
        // First data set
        let dataSet1 = LineChartDataSet(entries: dataEntries1, label: "Random Values 1")
        dataSet1.colors = [NSUIColor(cgColor: AppConstant.OrangeTitleColor!.cgColor)]
        dataSet1.drawCirclesEnabled = false
        dataSet1.drawValuesEnabled = false
        dataSet1.lineWidth = 2.0
        
        // Second data set
        let dataSet2 = LineChartDataSet(entries: dataEntries2)
        dataSet2.colors = [NSUIColor(cgColor: AppConstant.GreenTitleColor!.cgColor)]
        dataSet2.drawCirclesEnabled = false
        dataSet2.drawValuesEnabled = false
        dataSet2.lineWidth = 2.0
        
        let dataSet3 = LineChartDataSet(entries: dataEntries1)
        dataSet3.colors = [NSUIColor(cgColor: AppConstant.ThemeColor!.cgColor)]
        dataSet3.drawValuesEnabled = false
        dataSet3.drawCirclesEnabled = false
        dataSet3.lineWidth = 2.0
        
        graphView.drawBordersEnabled = false
        graphView.dragEnabled = false
        graphView.legend.enabled = false
        
        let data = LineChartData(dataSets: [dataSet1, dataSet2, dataSet3])
        graphView.data = data
        
    }
    
    func addEntry(randomDouble1: Double, randomDouble2: Double, randomDouble3: Double) {
        counter += 1.0
        
        let newEntry1 = ChartDataEntry(x: counter, y: randomDouble1)
        let newEntry2 = ChartDataEntry(x: counter, y: randomDouble2)
        let newEntry3 = ChartDataEntry(x: counter, y: randomDouble3)
        
        dataEntries1.append(newEntry1)
        dataEntries2.append(newEntry2)
        dataEntries3.append(newEntry3)
        
        if let dataSet1 = graphView.data?.dataSets[0] as? LineChartDataSet,
           let dataSet2 = graphView.data?.dataSets[1] as? LineChartDataSet,
           let dataSet3 = graphView.data?.dataSets[2] as? LineChartDataSet{
            dataSet1.append(newEntry1)
            dataSet2.append(newEntry2)
            dataSet3.append(newEntry3)
            graphView.data?.notifyDataChanged()
            graphView.notifyDataSetChanged()
            adjustXAxisRange()
        }
    }
    
    func adjustXAxisRange() {
        let xAxis = graphView.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = counter > 10 ? counter : 10
        graphView.notifyDataSetChanged()
    }    
    
}
