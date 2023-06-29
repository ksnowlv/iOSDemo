//
//  LockTest.swift
//  MultiThreadTest
//
//  Created by lvwei on 2023/6/20.
//

import Foundation

class LockTest {
    
    var lock = NSLock()
    var array: [Int] = []
    
    init() {
       
    }
    
    
    func test() {
        
        for i in 0..<10 {
            DispatchQueue.global().async {
                self.addItem(i)
            }
        }
        
        for i in 0..<10 {
            DispatchQueue.global().async {
                self.removeItem(i)
            }
        }
    }


    func addItem(_ item: Int) {
        lock.lock()
        defer { lock.unlock() }
        array.append(item)
    }

    func removeItem(_ item: Int) {
        lock.lock()
        defer { lock.unlock() }
        if let index = array.firstIndex(of: item) {
            array.remove(at: index)
        }
    }
}
