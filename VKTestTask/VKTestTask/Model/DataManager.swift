//
//  DataManager.swift
//  VKTestTask
//
//  Created by Yulia Popova on 26/3/2022.
//

import Foundation

struct DataManager {
    static let shared = DataManager()

    func getData(completion: @escaping ([MeasurementModel]) -> Void) {
            
        var data : [MeasurementModel] = []
        
        for _ in 1...20 {
            let measure = MeasurementModel(measurement: Double.random(in: 0..<1000), time: Date())
            data.append(measure)
        }

        completion(data)
    }
}
