//
//  OS + Extension.swift
//  WatchConnectivityRnd
//
//  Created by Shahwat Hasnaine on 12/5/24.
//

import Foundation

import os

extension OSLog {
    static let subsystem = "com.hasnaine.WaterMyPlants"
    static let plants = OSLog(subsystem: OSLog.subsystem, category: "plants")
    static let watch = OSLog(subsystem: OSLog.subsystem, category: "phone>watch")
}
