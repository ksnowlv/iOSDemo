//
//  NSData+GZip.swift
//  hengshenghuo
//
//  Created by ksnowlv on 2022/6/27.
//

import Foundation
import zlib

/*
 解压缩流大小
 */
private let GZIP_STREAM_SIZE = Int32(MemoryLayout<z_stream>.size)
/*
 解压缩缓冲区大小
 */
private let GZIP_BUF_LENGTH = 1024

/*
 解压缩缓冲区
 */
let GZipBuf = UnsafeMutablePointer<Bytef>.allocate(capacity: GZIP_BUF_LENGTH)

@objc public extension NSData {
    
    /// 判断数据是否为gzip流数据
    var gzipCompressed : Bool {
        
        if (length >= 2) {
            return (self as Data).starts(with: [0x1f, 0x8b])
        }
        
        return false;
    }
    
    
    /// gzip数据解压
    ///
    /// - Returns: NSData
    func gzipDataUncompress() -> NSData? {
        guard self.count > 0 else {
            return nil
        }
        
        guard self.gzipCompressed else {
            return self
        }
        
        var  stream = z_stream()
        stream.zalloc = nil
        stream.zfree = nil
        stream.opaque = nil
        stream.avail_in = uInt(self.count)
        stream.total_out = 0
        
        (self as Data).withUnsafeBytes { (bytes:UnsafeRawBufferPointer) in
            stream.next_in = UnsafeMutablePointer<Bytef>(mutating: bytes.bindMemory(to: Bytef.self).baseAddress)
        }
        
        
        var status: Int32 = inflateInit2_(&stream, MAX_WBITS + 16, ZLIB_VERSION,GZIP_STREAM_SIZE)
        
        guard status == Z_OK else {
            return nil
        }
        
        defer {
            deflateEnd(&stream)
        }
        
        let decompressed = NSMutableData(capacity: self.count * 2)
        
        while stream.avail_out == 0 {
            
            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            stream.next_out = GZipBuf
            status = inflate(&stream, Z_SYNC_FLUSH)
            
            if status != Z_OK && status != Z_STREAM_END {
                break
            }else {
                
                let dataLen :Int = GZIP_BUF_LENGTH - Int(stream.avail_out);
                
                if dataLen > 0 {
                    decompressed?.append(GZipBuf, length: dataLen)
                }
            }
        }
        
        return decompressed!
    }
    
    
    /// gzip数据压缩
    ///
    /// - Returns: Data
    func gzipCompressData() -> NSData? {
        
        guard self.count > 0 else {
            return self
        }
        
        
        let uncompressedDataPointer = UnsafeMutablePointer<Bytef>(mutating: self.bytes.bindMemory(to: Bytef.self, capacity: (self as Data).count))
        let uncompressedDataLength = uLong(self.count)
        
        var stream = z_stream()
        stream.avail_in = uInt(uncompressedDataLength)
        stream.next_in = uncompressedDataPointer
        
        var status = deflateInit2_(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, MAX_WBITS + 16, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size))
        
        guard status == Z_OK else {
            return nil
        }
        
        defer {
            deflateEnd(&stream)
        }
        
        var compressedData = Data()
        
        
        while stream.avail_out == 0 {
            
            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            stream.next_out = GZipBuf
            
            status = deflate(&stream, Z_FINISH)
            if status != Z_OK && status != Z_STREAM_END {
                return nil
            } else {
                let dataLength = GZIP_BUF_LENGTH - Int(stream.avail_out)
                
                if dataLength > 0 {
                    compressedData.append(GZipBuf, count: dataLength)
                }
            }
        }
        
        return compressedData as NSData
    }
    
    
    /// NSData转换成NSDictionary
    ///
    /// - Returns:
    func toJsonDictionary() -> NSDictionary? {
        
        let resultData = gzipCompressData()
        guard resultData != nil else {
            return nil
        }
        
        let dictionary =
        try? JSONSerialization.jsonObject(with: (resultData! as Data), options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if (JSONSerialization.isValidJSONObject(dictionary as Any)) {
            return (dictionary as? NSDictionary)
        }
        
        return nil
    }
    
    class func testGzip() {
        let string = "Hello world!"
        let helloData =  string.data(using: .utf8)
        let compressData =   (helloData as? NSData)?.gzipCompressData()
        let uncompressData =  compressData?.gzipDataUncompress() as? Data
        let resString =  String(data: uncompressData!, encoding: .utf8)
        print(resString)
        
    }
    
    
}
