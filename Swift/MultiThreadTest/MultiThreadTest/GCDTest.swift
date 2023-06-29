//
//  GCDTest.swift
//  MultiThreadTest
//
//  Created by lvwei on 2023/6/27.
//

import Foundation


class GCDTest {
    let serialQueue = DispatchQueue(label: "com.ksnowlv.serial")
    let concurrentQueue = DispatchQueue(label: "com.ksnowlv.concurrent", attributes: .concurrent)
    let group = DispatchGroup()
    
    func serialQueueTest() {
        serialQueue.async {
            print("---file:\(#file),fuction:\(#function) test1")
        }
        
        serialQueue.sync {
            print("---file:\(#file),fuction:\(#function) test2")
        }
        
        let workItem = DispatchWorkItem {
            print("---file:\(#file),fuction:\(#function) test3")
        }
        
        serialQueue.async(execute: workItem)
    }
    
    func concurrentQueueTest() {
        for i in 0..<20 {
            concurrentQueue.async {
                print("---file:\(#file),fuction:\(#function) run1:\(i)")
            }
        }
        
        for i in 0..<20 {
            concurrentQueue.sync(flags: .barrier, execute: {
                print("---file:\(#file),fuction:\(#function) run2:\(i)")
            })
        }
        
        for i in 0..<20 {
            concurrentQueue.async {
                print("---file:\(#file),fuction:\(#function) run3:\(i)")
            }
        }
        
        
    }
    
    func groupTest() {
        
        let queue1 = DispatchQueue(label: "com.dispatchqueue.test")
        
        var count = 0
        
        queue1.async(group: group, execute: DispatchWorkItem(block: {
          
            for i in 0..<10 {
                count += i
            }
            
            print("---file:\(#file),fuction:\(#function) queue1 async1 count=\(count)")
        }))
        
        queue1.async(group: group, execute: DispatchWorkItem(block: {
            for i in 0..<10 {
                count += i
            }
            
            print("---file:\(#file),fuction:\(#function) queue1 async2 count=\(count)")
        }))
        
        queue1.async(group: group, execute: DispatchWorkItem(block: {
          
            for i in 0..<10 {
                count += i
            }
            
            print("---file:\(#file),fuction:\(#function) queue1 async3 count=\(count)")
        }))
        
        queue1.async(group: group, execute: DispatchWorkItem(block: {
            for i in 0..<10 {
                count += i
            }
            
            print("---file:\(#file),fuction:\(#function) queue1 async4 count=\(count)")
        }))
        
        group.notify(queue: queue1, work: DispatchWorkItem(block: {
            print("---file:\(#file),fuction:\(#function) queue1 async4 notify count=\(count)")
        }))
    }
        
}
