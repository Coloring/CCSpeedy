
import Foundation

public extension UIImage {
    
    func tinted(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        color.set()
        UIRectFillUsingBlendMode(rect, .sourceAtop)
        let tintImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintImage
    }
    
    
    /// APP icon
    static var icon: UIImage? {
        if let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImage {
    
    public func scaled(to size: CGSize, scale: CGFloat = 1) -> UIImage {
        let targetSize = self.parse(size: size)
        
        if self.isResizable(targetSize: targetSize) == false {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, scale)
        draw(in: CGRect(origin: .zero, size: targetSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    public func aspectScaled(toFit targetSize: CGSize, scale: CGFloat = 1) -> UIImage {
        if self.isResizable(targetSize: targetSize) == false {
            return self
        }
        
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = targetSize.width / targetSize.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = targetSize.width / self.size.width
        } else {
            resizeFactor = targetSize.height / self.size.height
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (targetSize.width - scaledSize.width) / 2.0, y: (targetSize.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, scale)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    public func aspectScaled(toFill targetSize: CGSize, scale: CGFloat = 1) -> UIImage {
        if self.isResizable(targetSize: targetSize) == false {
            return self
        }
        
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = targetSize.width / targetSize.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = targetSize.height / self.size.height
        } else {
            resizeFactor = targetSize.width / self.size.width
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (targetSize.width - scaledSize.width) / 2.0, y: (targetSize.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, scale)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    private func isResizable(targetSize: CGSize) -> Bool {
        return targetSize != self.size && self.size.width > 0 && self.size.height > 0 && targetSize.width > 0 && targetSize.height > 0
    }
    
    private func parse(size: CGSize) -> CGSize {
        var result = size
        
        if size.width == -1 && size.height == -1 {
            result = self.size
        }
        else if size.width == -1 {
            result.width = self.size.width / self.size.height * size.height
        }
        else if size.height == -1 {
            result.height = size.width / (self.size.width / self.size.height)
        }
        
        return result
    }
}


extension UIImage {
    
    public func imageFixSize(scaledToSize newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public func normalized() -> UIImage  {
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self;
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        if let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
    
    public func resizeImage() -> UIImage? {
        let originalImg = self
        let width = originalImg.size.width
        let height = originalImg.size.height
        let scale = width / height
        var sizeChange = CGSize()
        if width > 1280 || height > 1280 {
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = 1280
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
            }else if scale >= 0.5 && scale <= 1 {
                let changedheight:CGFloat = 1280
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
            }else if width > 1280 && height > 1280 {
                if scale > 2 {
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                }else if scale < 0.5{
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                }
            }else {
                return originalImg
            }
        } else if width <= 1280 && height <= 1280 {
            return originalImg
        }
        UIGraphicsBeginImageContext(sizeChange)
        originalImg.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImg
    }
    
}
