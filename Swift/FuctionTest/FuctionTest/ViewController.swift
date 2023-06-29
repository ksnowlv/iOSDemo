//
//  ViewController.swift
//  FuctionTest
//
//  Created by lvwei on 2023/6/27.
//

import UIKit

class ViewController: UIViewController {
    
    let ARRAYLEN = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapTest()
        filterTest()
        reduceTest()
        flatMapTest()
        compactMapTest()
        sortTest()
    }
    
    func mapTest() {
        let words = ["apple", "orange", "banana"]
        let capitalizedWords = words.map {
            $0.capitalized
        }
        
        print("---file:\(#file),#function:\(#function) capitalizedWords:\(capitalizedWords)")
    }
    
    func filterTest() {
        var numbers = Array<Int>()
        
        for i in 0..<ARRAYLEN {
            numbers.append(i)
        }
        
        let res1 = numbers.filter { (n) in
            return n % 2 == 0
        }
        
        print("---file:\(#file),#function:\(#function) filterTest res1:\(res1)")
        
        let res2 = numbers.filter {
            $0 % 2 != 0
        }
     
        print("---file:\(#file),#function:\(#function) filterTest res2:\(res2)")
    }
    
    func reduceTest() {
        
        var numbers = Array<Int>()
        
        for i in 0..<ARRAYLEN {
            numbers.append(i)
        }
        
        let res = numbers.reduce(0) { x, y in
            x + y
        }
        
        print("---file:\(#file),#function:\(#function) reduceTest res:\(res)")
    }
    
    func flatMapTest() {
        let numbers = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12], [13, 14, 15], [16, 17, 18],[19, 20],[21],[22, 23, 24, 25, 26]]
        
        
        let res = numbers.flatMap { $0
        }
        
        print("---file:\(#file),#function:\(#function) reduceTest res:\(res)")
    }
    
    func compactMapTest() {
        let possibleNumbers = ["1", "2", "three", "///4///", "5"]
        
//        let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
//        // [1, 2, nil, nil, 5]
        
        let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
        // [1, 2, 5]
        print("---file:\(#file),#function:\(#function) compactMapTest res:\(compactMapped)")
    }
    
    func sortTest() {
        let nums = [3, 29, 8, 13, 18, 1, 22, 31, 0, 60]
        
        let res = nums.sorted { n1, n2 in
            n1 < n2
        }
        print("---file:\(#file),#function:\(#function) sortTest res:\(res)")
        
        let res1 = nums.sorted { n1, n2 in
            n1 > n2
        }
        print("---file:\(#file),#function:\(#function) sortTest res1:\(res1)")
        
        let res2 = nums.sorted {
            $0 > $1
        }
        print("---file:\(#file),#function:\(#function) sortTest res2:\(res2)")
    }
    
    

}

