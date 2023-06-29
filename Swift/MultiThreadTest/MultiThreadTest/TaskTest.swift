//
//  TaskTest.swift
//  MultiThreadTest
//
//  Created by lvwei on 2023/6/29.
//

import Foundation
import UIKit

class TaskTest {
   
    
    func add(_ a: Int, _ b: Int) async -> Int {
        
        do {
            try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
            
        } catch let error {
            print("error:\(error)")
        }
        
        return a + b
    }
    
    func taskTest() async -> Int {
        
        var task = Task {
            await self.add(1, 2)
        }
        
        var result = await task.value
        print("1+2=\(result)")
        
        task = Task.detached {
            await self.add(5, 6)
        }
        do {
            result = try await task.result.get()
            print("---file:\(#file),fuction:\(#function) 5+6:\(result)")
            
            return result
            
        } catch {
            print("---file:\(#file),fuction:\(#function) error")
            return -1
        }
    }
    
    func taskGroupTest()  {
        
        let task =  Task{
            let result =  await withTaskGroupTest()
            
            print("---file:\(#file),fuction:\(#function) result=\(result)")
        }
    }
    
    private func withTaskGroupTest() async -> Int  {
        
        let add = {(a: Int) -> Int in
            
            var sum = 0
            for i in 0..<a {
                sum += i
            }
            
            return sum
        }
        
        return  await withTaskGroup(of: Int.self, returning: Int.self) { group -> Int in
            
            for i in 0..<100 {
                group.addTask {
                    add(i)
                }
            }
            
            for i in 0..<100 {
                group.addTask {
                    add(i)
                }
            }
            
            var total = 0
            
            for await result in group {
                total += result
                print("---result:\(result)")
            }
            
            return total
        }
    }
          
}
