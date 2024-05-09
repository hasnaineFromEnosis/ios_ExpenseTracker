//
//  Counter.swift
//  iWComm
//
//  Created by Shahwat Hasnaine on 10/5/24.
//

import Foundation

class Counter: ObservableObject {
    var count: Int = 0
    
    func decreament() {
        count -= 1
    }
    
    func increament() {
        count += 1
    }
    
}
