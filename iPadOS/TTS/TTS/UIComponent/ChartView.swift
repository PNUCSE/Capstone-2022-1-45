//
//  LineChartView.swift
//  TTS
//
//  Created by 안현주 on 2022/09/11.
//

import Foundation
import Charts

class ChartView: LineChartView {
    
    let chartLabelSize = CGFloat(15)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfig() {
        self.noDataText = "데이터가 없습니다."
        self.noDataFont = .systemFont(ofSize: 20)
        self.noDataTextColor = .darkGray
        self.doubleTapToZoomEnabled = false
        self.legend.enabled = false

        self.xAxis.labelPosition = .bottom    // X축 레이블 위치 조정
        self.xAxis.labelFont = .boldSystemFont(ofSize: chartLabelSize)
        self.xAxis.labelTextColor = .gray
        self.xAxis.drawGridLinesEnabled = false
//        self.xAxis.axisLineColor = .black
        self.rightAxis.enabled = false        // 오른쪽 축 제거
        
        let yAxis = self.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: chartLabelSize)
        yAxis.labelTextColor = .gray
        yAxis.setLabelCount(8, force: false)
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.labelXOffset = -5
    }
}
