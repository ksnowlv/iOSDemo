//
//  ThreadMutexTest.swift
//  MultiThreadTest
//
//  Created by lvwei on 2023/6/20.
//

import Foundation

class ThreadMutexTest {
    
    var pthreadMutex = pthread_mutex_t()
    var array: [Int] = []
    
    init() {
        pthread_mutex_init(&pthreadMutex, nil)
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
        pthread_mutex_lock(&pthreadMutex)
        defer { pthread_mutex_unlock(&pthreadMutex) }
        array.append(item)
    }

    func removeItem(_ item: Int) {
        pthread_mutex_lock(&pthreadMutex)
        defer { pthread_mutex_unlock(&pthreadMutex) }
        if let index = array.firstIndex(of: item) {
            array.remove(at: index)
        }
    }
}

