
import UIKit

open class CCLabel: UILabel {

    open var contentInset: UIEdgeInsets = .zero
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect: CGRect = super.textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= contentInset.left;
        rect.origin.y -= contentInset.top;
        rect.size.width += contentInset.left + contentInset.right;
        rect.size.height += contentInset.top + contentInset.bottom;
        return rect
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }

}
