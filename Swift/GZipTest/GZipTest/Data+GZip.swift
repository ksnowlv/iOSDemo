//
//  Data+GZip.swift
//  GZipTest
//
//  Created by lvwei on 2023/6/5.
//

import Foundation
import zlib


/**解压缩流大小**/
private let GZIP_STREAM_SIZE: Int32 = Int32(MemoryLayout<z_stream>.size)
/**默认空数据**/
private let GZIP_NULL_DATA = Data()

/*
 解压缩缓冲区大小
 */
private let GZIP_BUF_LENGTH = 1024

/*
 解压缩缓冲区
 */
let GZipMaxBuf = UnsafeMutablePointer<Bytef>.allocate(capacity: GZIP_BUF_LENGTH)


public extension Data {
    var isGZipCompressed :Bool {
        return self.starts(with: [0x1f,0x8b])
    }
    
    func gzipCompress() -> Data {
        
        guard self.count > 0 else {
            return self
        }
        
        var stream = z_stream()
        stream.avail_in = uInt(self.count)
        stream.total_out = 0
        
        let uncompressedDataPointer = UnsafeMutablePointer<Bytef>(mutating: (self as NSData).bytes .bindMemory(to: Bytef.self, capacity: (self as NSData).count))
        
        stream.next_in = uncompressedDataPointer
        stream.avail_in = uInt(self.count)
        
        
        var status = deflateInit2_(&stream,Z_DEFAULT_COMPRESSION, Z_DEFLATED, MAX_WBITS + 16, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY, ZLIB_VERSION, GZIP_STREAM_SIZE)
        
        if  status != Z_OK {
            return  GZIP_NULL_DATA
        }
        
        var compressedData = Data()
        
        while stream.avail_out == 0 {
            
            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            stream.next_out = GZipMaxBuf
            
            status = deflate(&stream, Z_FINISH)
            if status != Z_OK && status != Z_STREAM_END {
                return GZIP_NULL_DATA
            } else {
                let dataLength = GZIP_BUF_LENGTH - Int(stream.avail_out)
                
                if dataLength > 0 {
                    compressedData.append(GZipMaxBuf, count: dataLength)
                }
            }            }
        
        guard deflateEnd(&stream) == Z_OK else {
            return GZIP_NULL_DATA
        }
        
        
        return compressedData
    }
    
    func gzipUncompress() ->Data {
        guard self.count > 0  else {
            return GZIP_NULL_DATA
        }
        
        guard self.isGZipCompressed else {
            return self
        }
        
        var  stream = z_stream()
        
//        self.withUnsafeBytes { (bytes:UnsafePointer<Bytef>) in
//
//            stream.next_in =  UnsafeMutablePointer<Bytef>(mutating: bytes)
//        }
        self.withUnsafeBytes {
            stream.next_in = UnsafeMutablePointer<Bytef>(mutating: $0.baseAddress?.assumingMemoryBound(to: Bytef.self))
            stream.avail_in = uInt(self.count)
        }
        
        stream.avail_in = uInt(self.count)
        stream.total_out = 0
        
        
        var status: Int32 = inflateInit2_(&stream, MAX_WBITS + 16, ZLIB_VERSION,GZIP_STREAM_SIZE)
        
        guard status == Z_OK else {
            return GZIP_NULL_DATA
        }
        
        var decompressed = Data(capacity: self.count * 2)
        while stream.avail_out == 0 {
            
            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            decompressed.count += GZIP_BUF_LENGTH
            
            decompressed.withUnsafeMutableBytes { //(bytes:UnsafeMutablePointer<Bytef>)in
                stream.next_out = $0.advanced(by: Int(stream.total_out))
            }
            
            status = inflate(&stream, Z_SYNC_FLUSH)
            
            if status != Z_OK && status != Z_STREAM_END {
                break
            }
        }
        
        if inflateEnd(&stream) != Z_OK {
            return GZIP_NULL_DATA
        }
        
        decompressed.count = Int(stream.total_out)
        return decompressed
    }
    
}
