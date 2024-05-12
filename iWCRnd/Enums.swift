//
//  Enums.swift
//  iWCRndWatch Watch App
//
//  Created by Shahwat Hasnaine on 13/5/24.
//

import SwiftUI
import Foundation

struct modelData {
    var msg1: String
    var msg2: String
    var date: Date
    
    init(msg1: String, msg2: String) {
        self.msg1 = msg1
        self.msg2 = msg2
        self.date = Date()
    }
    
    static func toDict(data: modelData) -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["msg1"] = data.msg1
        dict["msg2"] = data.msg2
        dict["date"] = data.date
        
        return dict
    }
    
    static func fromDict(dict: [String: Any]) -> modelData? {
        guard let msg1 = dict["msg1"] as? String,
              let msg2 = dict["msg2"] as? String,
              let date = dict["date"] as? Date else {
            return nil
        }
        
        return modelData(msg1: msg1, msg2: msg2)
    }
}
