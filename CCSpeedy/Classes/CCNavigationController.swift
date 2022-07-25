
import Foundation
import UIKit

extension UINavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    //自定义返回按钮后恢复侧滑返回
    func replyLateralSpreadsToReturn() {
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled = true
        if viewControllers.count == 1 {
            interactivePopGestureRecognizer?.isEnabled = false
        }
    }    
}


extension UINavigationController {
    //设置导航栏背景颜色
    func setup(backgroundColor: UIColor = .white, textColor: UIColor = .black , isTranslucent: Bool = true) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = backgroundColor
            navBarAppearance.backgroundEffect = nil
            navBarAppearance.shadowColor = nil
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
            navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.isTranslucent = isTranslucent
        } else {
            navigationBar.setBackgroundImage(UIImage(color: backgroundColor), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
            navigationBar.tintColor = .black
            navigationBar.isTranslucent = isTranslucent
        }

    }
    
}
