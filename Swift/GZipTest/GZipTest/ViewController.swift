//
//  ViewController.swift
//  GZipTest
//
//  Created by lvwei on 2023/6/5.
//

import UIKit
//import Compression
import zlib




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let string = "Hello"
        let helloData =  string.data(using: .utf8)
        

        
//        let compressData = gzipCompress(helloData!)
//        let unCompressData = gzipDecompress(compressData!)
//        let resString = String(data: unCompressData! as Data, encoding: .utf8)
//        print("resString:\(resString)")
        
        let compressData2 =   (helloData! as NSData).gzipCompressData() as! Data
        let uncompressData2 =  (compressData2 as NSData).gzipDataUncompress() as! Data// compressData1?.gzipUncompress()
        let resString2 =  String(data: uncompressData2, encoding: String.Encoding.utf8)
        print("resString2:\(resString2)")
        
        
        testDataCompression()
        testDataCompression1()
        test1()
    }
    
    
    func testDataCompression()  {
        let helloworld = "Hello"
        let data = helloworld.data(using: .utf8)

        // 压缩数据
        var uncompressedSize = uLong(data?.count ?? 0)
        var compressedSize = compressBound(uLong(data!.count))
        var compressedData = Data(count: Int(compressedSize))
        
        compressedData.withUnsafeMutableBytes { compressedBytes in
            data!.withUnsafeBytes { uncompressedBytes in
                compress(compressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), &compressedSize, uncompressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), uncompressedSize)
            }
        }
        compressedData.count = Int(compressedSize)
        print("压缩后的数据：\(compressedData)")
        
        var uncompressedData = Data(count: Int(uncompressedSize))
        let actualSize = uncompressedData.withUnsafeMutableBytes { uncompressedBytes in
            compressedData.withUnsafeBytes { compressedBytes in
                return uncompress(uncompressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), &uncompressedSize, compressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), uLong(compressedData.count))
            }
        }
        if actualSize != Z_OK {
            print("解压缩数据失败")
        } else {
            let uncompressedString = String(data: uncompressedData, encoding: .utf8)!
            print("解压缩后的数据：\(uncompressedString)")
        }
    }
    
    
    func testCompress2() {

        // 压缩数据
        let data = "hello".data(using: .utf8)!

        // 压缩数据
        let sourceData = data.withUnsafeBytes {
            //return $0.baseAddress!.assumingMemoryBound(to: Bytef.self)
            //return $0.baseAddress!.assumingMemoryBound(to: Bytef.self)
            return $0.assumingMemoryBound(to: Bytef.self).baseAddress!
        }
        let sourceLen = uLong(data.count)
        var compressDataLen = compressBound(sourceLen)
        var compressData = Data(count: Int(compressDataLen))
        let compressDataPtr = compressData.withUnsafeMutableBytes {
            return $0.baseAddress!.assumingMemoryBound(to: Bytef.self)
        }

        let compressRes = compress2(compressDataPtr,
                                    &compressDataLen,
                                    sourceData,
                                    sourceLen,
                                    Int32(Z_DEFAULT_COMPRESSION))

        if compressRes != Z_OK {
            print("压缩数据失败：\(compressRes)")
        } else {
            compressData.count = Int(compressDataLen)
            print("压缩后的数据：\(compressData)")
        }
        
        // 解压数据
        var uncompressDataLen = data.count
        var uncompressData = Data(count: uncompressDataLen)
        let uncompressDataPtr = uncompressData.withUnsafeMutableBytes {
            return $0.baseAddress?.assumingMemoryBound(to: Bytef.self)
        }
        let compressDataPtr1 = compressData.withUnsafeBytes {
            return $0.baseAddress?.assumingMemoryBound(to: Bytef.self)
        }

        var compressDataLen1 = compressDataLen

        let uncompressRes = uncompress2(uncompressDataPtr,
                                        &uncompressDataLen,
                                        compressDataPtr1,
                                        &compressDataLen1)

        if uncompressRes != Z_OK {
            print("解压数据失败：\(uncompressRes)")
        } else {
            uncompressData.count = Int(uncompressDataLen)
            print("解压后的数据：\(uncompressData)")
        }
            
    }
    
    func test1() {
        let helloworld = "Hello"
        let data = helloworld.data(using: .utf8)

        // 压缩数据
        var uncompressedSize = uLong(data?.count ?? 0)
        var compressedSize = compressBound(uLong(data!.count))
        var compressedData = Data(count: Int(compressedSize))
        
        let sourceDataPtr = data?.withUnsafeBytes({
            return $0.baseAddress?.assumingMemoryBound(to: Bytef.self)
        })
        
        let compressedDataPtr = compressedData.withUnsafeMutableBytes ({ compressedDataPtr in
            return compressedDataPtr.baseAddress?.assumingMemoryBound(to: Bytef.self)
        })
        
        var res =  compress2(compressedDataPtr,
                      &compressedSize,
                      sourceDataPtr, uncompressedSize, Int32(Z_DEFAULT_COMPRESSION))
            
            print("compressedSize:\(compressedSize)")
        
        if res == Z_OK {
            compressedData.count = Int(compressedSize)
            print("test1 压缩后的数据：\(compressedData)")
        } else {
            print("压缩失败：\(res)")
        }
            
        
        
        
//        var res = compressedData.withUnsafeMutableBytes { compressedBytes in
//            data!.withUnsafeBytes { uncompressedBytes in
//                compress2(compressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), &compressedSize, uncompressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), uncompressedSize, Int32(Z_DEFAULT_COMPRESSION))
//            }
//        }
        
    
        
        
        var uncompressedData = Data(count: Int(uncompressedSize))
        res = uncompressedData.withUnsafeMutableBytes { uncompressedBytes in
            compressedData.withUnsafeBytes { compressedBytes in
                
                var compressedDataLen = uLong(compressedData.count)
                
                return uncompress2(uncompressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), &uncompressedSize, compressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), &compressedDataLen)
            }
        }
        if res != Z_OK {
            print("解压缩数据失败")
        } else {
            let uncompressedString = String(data: uncompressedData, encoding: .utf8)!
            print("test1 解压缩后的数据：\(uncompressedString)")
        }
        
    }
    
    func testDataCompression1()  {
        let helloworld = "Hello"
        let data = helloworld.data(using: .utf8)

        // 压缩数据
        var uncompressedSize = uLong(data?.count ?? 0)
        var compressedSize = compressBound(uLong(data!.count))
        var compressedData = Data(count: Int(compressedSize))
        
        var res = compressedData.withUnsafeMutableBytes { compressedBytes in
            data!.withUnsafeBytes { uncompressedBytes in
                compress2(compressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), &compressedSize, uncompressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), uncompressedSize, Int32(Z_DEFAULT_COMPRESSION))
            }
        }
        
        if res == Z_OK {
            compressedData.count = Int(compressedSize)
            print("testDataCompression1 压缩后的数据：\(compressedData)")
        } else {
            print("压缩失败：\(res)")
        }
        
        
        var uncompressedData = Data(count: Int(uncompressedSize))
        res = uncompressedData.withUnsafeMutableBytes { uncompressedBytes in
            compressedData.withUnsafeBytes { compressedBytes in
                
                var compressedDataLen = uLong(compressedData.count)
                
                return uncompress2(uncompressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), &uncompressedSize, compressedBytes.baseAddress!.assumingMemoryBound(to: Bytef.self), &compressedDataLen)
            }
        }
        if res != Z_OK {
            print("解压缩数据失败")
        } else {
            let uncompressedString = String(data: uncompressedData, encoding: .utf8)!
            print("testDataCompression1 解压缩后的数据：\(uncompressedString)")
        }
    }
}



