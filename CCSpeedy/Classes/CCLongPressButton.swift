//
//  CCLongPressButton.swift
//  DigitalSignage
//
//  Created by Coloring on 2023/6/8.
//

import UIKit

public typealias CCLongPressCallback = () -> Void

open class CCLongPressButton: UIButton {
    
    /// 长按起始时间，长按多久开始触发长按事件
    public var timeStart: TimeInterval = 0.5
    
    /// 长按时间间隔，每隔多久触发一次长按事件
    public var timeGap: TimeInterval = 0.2
    
    /// 长按事件回调，如果没触发长按，会触发一次点击事件
    public var longPress: CCLongPressCallback?
    
    /// 是否开始长按
    private var hasLongPress: Bool = false
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpCancel), for: .touchCancel)
        addTarget(self, action: #selector(touchUpCancel), for: .touchUpOutside)
        addTarget(self, action: #selector(touchUpCancel), for: .touchDragOutside)
    }
    
    @objc private func touchDown() {
        perform(#selector(delayMethod), with: nil, afterDelay: timeStart)
    }
    
    @objc private func delayMethod() {
        self.longPress?()
        hasLongPress = true
        perform(#selector(delayMethod), with: nil, afterDelay: timeGap)
    }
    
    @objc private func touchUpInside() {
        if !hasLongPress {
            self.longPress?()
        }
        touchUpCancel()
    }
    
    @objc private func touchUpCancel() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delayMethod), object: nil)
        hasLongPress = false
    }
}
