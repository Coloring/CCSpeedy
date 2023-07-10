import SnapKit

public extension UIView {
    
    var safeAreaTop: ConstraintItem {
        get {
            return safeAreaLayoutGuide.snp.top
        }
    }
    
    var safeAreaBottom: ConstraintItem {
        get {
            return safeAreaLayoutGuide.snp.bottom
        }
    }
    
    var safeTop: CGFloat {
        get {
            return safeAreaLayoutGuide.layoutFrame.minY
        }
    }
    
    var safeBottom: CGFloat {
        get {
            return frame.size.height - safeTop - safeAreaLayoutGuide.layoutFrame.height
        }
    }
    
    var safeAreaHeight: CGFloat {
        get {
            return frame.size.height - safeTop - safeBottom
        }
    }
    
    var size: CGSize {
        set {
            self.frame.size = newValue
        }
        get {
            return self.frame.size
        }
    }
}

extension UIView {
    
    public func asImage() -> UIImage {
        let render = UIGraphicsImageRenderer(bounds: bounds)
        let image = render.image(actions: { (context) in
            layer.render(in: context.cgContext)
        })
        return image
    }
    
}
