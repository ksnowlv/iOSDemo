//
//  ViewController.swift
//  MultiThreadTest
//
//  Created by lvwei on 2023/6/20.
//

import UIKit

class ViewController: UIViewController {
    
    let threadTest = ThreadTest()
    let gcdTest = GCDTest()
    let taskTest = TaskTest()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleThreadTestStart() {
        threadTest.start()
    }
    
    @IBAction func handleThreadTestStop() {
        threadTest.stop()
    }
    
    @IBAction func handleSerialQueueTest() {
        gcdTest.serialQueueTest()
    }
    
    @IBAction func handleConcurrentQueueTest() {
        gcdTest.concurrentQueueTest()
    }
    
    @IBAction func handleGroupTest() {
        gcdTest.groupTest()
    }
    
    @IBAction func handleTaskTest() {
        
        /// await/async-> await/Task
        Task {
            let res = await taskTest.taskTest()
        }
    }
    
    @IBAction func handleTaskGroupTest() {
        
        ///
        taskTest.taskGroupTest()
    }
    
    func testLock() {
        let lockTest = LockTest()
        lockTest.test()
        
        let threadMutexTest = ThreadMutexTest()
        threadMutexTest.test()
    }
}

