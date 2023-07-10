
import Foundation
import UIKit
 
extension UITextField {
 
    /// 添加左内边距
    public func addLeftRightTextPadding(_ blankSize: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
        
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.rightView = rightView
        self.rightViewMode = UITextField.ViewMode.always
    }
    
    public func addLeftTextPadding(_ blankSize: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    public func addRightTextPadding(_ blankSize: CGFloat) {
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.rightView = rightView
        self.rightViewMode = UITextField.ViewMode.always
    }
     
    /// 在文本框的左边添加一个图标
    public func addLeftIcon(_ image: UIImage?, frame: CGRect, imageSize: CGSize) {
        let leftView = UIView()
        leftView.frame = frame
        let imgView = UIImageView()
        imgView.frame = CGRect(x: frame.width - 8 - imageSize.width, y: (frame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgView.image = image
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
 
}

