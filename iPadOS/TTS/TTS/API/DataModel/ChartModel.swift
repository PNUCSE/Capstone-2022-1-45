//
//  DailyChartModel.swift
//  TTS
//
//  Created by 안현주 on 2022/09/11.
//

import Foundation

struct ChartModel: Decodable {
    let count: Int
    let xData: [String]
    let yData: [Double]
    let average: Double
}

extension ChartModel {
    static let sampleData: String =
    """
        {
            "count": 12,
            "xData": ["09/01", "09/02", "09/03", "09/04", "09/05", "09/06", "09/07", "09/08", "09/09", "09/10", "09/11", "09/12"],
            "yData": [38234, 17473, 58349, 95732, 17472, 12947, 103741, 45000, 18372, 67389, 28473, 52847],
            "average": 40000
        }
    """
}
