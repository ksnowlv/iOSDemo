//
//  ThreadTest.swift
//  MultiThreadTest
//
//  Created by lvwei on 2023/6/27.
//

import Foundation

class MyThread: Thread {
    
    override func main() {
        
        print("---file:\(#file),fuction:\(#function) thread start")
        
        while !self.isCancelled {
            print("---file:\(#file),fuction:\(#function) thread running!")
        }
        print("---file:\(#file),fuction:\(#function) thread finish!")
    }
}

class ThreadTest {
    var myThread: MyThread?
    
    func start() {
        
        if myThread != nil,myThread!.isExecuting {
            myThread!.cancel()
        }
        
        myThread = MyThread(block: {
            
            Thread.sleep(forTimeInterval: 10)
            print("---Thread show---")
        })
    
        
        myThread?.start()
    }
    
    func stop() {
        if myThread != nil,myThread!.isExecuting {
            myThread!.cancel()
        }
    }
    
    deinit {
        self.stop()
    }
}
