
import Foundation
import CommonCrypto

extension Data {
    
    public var md5: String {
        var context = CC_MD5_CTX()
        CC_MD5_Init(&context)

        if self.count > 0 {
            self.withUnsafeBytes {
                _ = CC_MD5_Update(&context, $0.baseAddress, numericCast(self.count))
            }
        } else {
            return ""
        }
        // Compute the MD5 digest:
        var digest: [UInt8] = Array(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = CC_MD5_Final(&digest, &context)

        let hexDigest = digest.map { String(format: "%02hhx", $0) }.joined()
        return hexDigest
    }
    
}


extension String {
    
    //用法
    //let md5 =  "Some thing".md5
    //如果需要小写，将"%02X"改成"%02x"
    public var md5: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
    
}

extension URL {
    
    public var md5: String {

        let bufferSize = 1024 * 1024

        do {
            // Open file for reading:
            let file = try FileHandle(forReadingFrom: self)
            defer {
                file.closeFile()
            }

            // Create and initialize MD5 context:
            var context = CC_MD5_CTX()
            CC_MD5_Init(&context)

            // Read up to `bufferSize` bytes, until EOF is reached, and update MD5 context:
            while autoreleasepool(invoking: {
                let data = file.readData(ofLength: bufferSize)
                if data.count > 0 {
                    data.withUnsafeBytes {
                        _ = CC_MD5_Update(&context, $0.baseAddress, numericCast(data.count))
                    }
                    return true // Continue
                } else {
                    return false // End of file
                }
            }) { }

            // Compute the MD5 digest:
            var digest: [UInt8] = Array(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            _ = CC_MD5_Final(&digest, &context)

            let hexDigest = digest.map { String(format: "%02hhx", $0) }.joined()
            return hexDigest
            
    //        return Data(digest)

        } catch {
            print("Cannot open file:", error.localizedDescription)
            return ""
        }
    }
    
}

