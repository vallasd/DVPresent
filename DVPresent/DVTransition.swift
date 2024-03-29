//
//    HGPresent  (subclass of UIPresentationController)
//
//    Allows user to easily present viewcontrollers on top of presenting view controller
//
//    The MIT License (MIT)
//
//    Copyright (c) 2018 David C. Vallas (david_vallas@yahoo.com) (dcvallas@twitter)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE

import UIKit

public struct DVTransitionSettings {
    
    /// The final location of the presented view controller when it stops animating.  Can be a CGPoint or a HGPosition.
    let position: DVLocation
    /// The direction which the presented view controller will come from when being presented. Can be a CGPoint or a HGPosition.
    let directionIn: DVLocation
    /// The direction which the presented view controller will go when dismissing, can be a Point or a HGPosition.
    let directionOut: DVLocation
    /// Determines whether the transition will fade in or out (alpha 0.0 to 1.0)
    let fade: DVFade
    /// The speed in seconds at which the transition will take place.
    let speed: TimeInterval
    /// The color of the chrome background color to be used.  If this is nil, user will be able to interact with the background.
    let chrome: UIColor?
    /// Will chrome and view be displayed over entire screen or just within the presenting view (not over header and footers)
    let entireScreen: Bool
    /// Will touching chrome dismiss the presented view controller
    let chromeDismiss: Bool
    /// The starting, ending, and displayed sizes for the presented viewcontroller on the device
    let size: DVTransitionSize
    
    public init(position p: DVLocation,
                directionIn di: DVLocation,
                directionOut d: DVLocation,
                fade f: DVFade,
                speed s: TimeInterval,
                chrome c: UIColor?,
                entireScreen es: Bool,
                chromeDismiss cd: Bool,
                size si: DVTransitionSize) {
        position = p
        directionIn = di
        directionOut = d
        fade = f
        speed = s
        chrome = c
        entireScreen = es
        chromeDismiss = cd
        size = si
    }
    
    static var standard: DVTransitionSettings {
        let color = UIColor(displayP3Red: 0, green: 0, blue: 1.0, alpha: 0.4)
        let size = DVSize(wPercent: 0.8, hPercent: 0.5)
        let transitionSize = DVTransitionSize(start: size, displayed: size, end: size)
        let settings = DVTransitionSettings(position: DVLocation(position: .center),
                                            directionIn: DVLocation(position: .left),
                                            directionOut: DVLocation(position: .right),
                                            fade: DVFade(fadeIn: true, fadeOut: true),
                                            speed: 0.3,
                                            chrome: color,
                                            entireScreen: false,
                                            chromeDismiss: false,
                                            size: transitionSize)
        return settings
    }
}

public struct DVFade {
    let fadeIn: Bool
    let fadeOut: Bool
    
    public init(fadeIn fi: Bool, fadeOut fo: Bool) {
        fadeIn = fi
        fadeOut = fo
    }
}

public struct DVTransitionSize {
    let start: DVSize
    let displayed: DVSize
    let end: DVSize
    
    public init(start s: DVSize, displayed d: DVSize, end e: DVSize) {
        start = s
        displayed = d
        end = e
    }
}

public struct DVSize {
    let wPercent: CGFloat
    let hPercent: CGFloat
    
    public init(wFPercent wp: Float, hFPercent hp: Float) {
        var w = CGFloat(wp), h = CGFloat(hp)
        if w < 0.00 { w = 0.00 }
        if w > 1.00 { w = 1.00 }
        if h < 0.00 { h = 0.00 }
        if h > 1.00 { h = 1.00 }
        wPercent = w; hPercent = h
    }
    
    public init(wPercent wp: CGFloat, hPercent hp: CGFloat) {
        var w = wp, h = hp
        if w < 0.00 { w = 0.00 }
        if w > 1.00 { w = 1.00 }
        if h < 0.00 { h = 0.00 }
        if h > 1.00 { h = 1.00 }
        wPercent = w; hPercent = h
    }
}

public enum DVLocation {
    case point(CGPoint)
    case position(DVPosition)
    
    public init(position: DVPosition) {
        self = .position(position)
    }
    
    public init(point: CGPoint) {
        self = .point(point)
    }
    
    func origin(size: CGSize, container: CGSize) -> CGPoint {
        switch self {
        case let .point(x): return x
        case let .position(y): return y.origin(size: size, container: container)
        }
    }
    
    func origin(location: DVLocation, size: CGSize, container: CGSize) -> CGPoint {
        switch self {
        case let .point(x): return x
        case let .position(pos):
            switch location {
            case .point:
                print("Error: we are not handling locations with point values, return 0,0")
                return CGPoint()
            case let .position(y): return pos.origin(position: y, size: size, container: container)
            }
            
        }
    }
}

public enum DVPosition {
    case bottomLeft
    case bottom
    case bottomRight
    case right
    case center
    case topRight
    case top
    case topLeft
    case left
    
    func origin(size: CGSize, container: CGSize) -> CGPoint {
        switch self {
        case .bottomLeft:
            let x: CGFloat = 0.0
            let y: CGFloat = container.height - size.height
            return CGPoint(x: x, y: y)
        case .bottom:
            let x: CGFloat = (container.width - size.width) / 2.0
            let y: CGFloat = container.height - size.height
            return CGPoint(x: x, y: y)
        case .bottomRight:
            let x: CGFloat = container.width - size.width
            let y: CGFloat = container.height - size.height
            return CGPoint(x: x, y: y)
        case .right:
            let x: CGFloat = container.width - size.width
            let y: CGFloat = (container.height - size.height) / 2.0
            return CGPoint(x: x, y: y)
        case .center:
            let x: CGFloat = (container.width - size.width) / 2.0
            let y: CGFloat = (container.height - size.height) / 2.0
            return CGPoint(x: x, y: y)
        case .topRight:
            let x: CGFloat = container.width - size.width
            let y: CGFloat = 0.0
            return CGPoint(x: x, y: y)
        case .top:
            let x: CGFloat = (container.width - size.width) / 2.0
            let y: CGFloat = 0.0
            return CGPoint(x: x, y: y)
        case .topLeft:
            let x: CGFloat = 0.0
            let y: CGFloat = 0.0
            return CGPoint(x: x, y: y)
        case .left:
            let x: CGFloat = 0.0
            let y: CGFloat = (container.height - size.height) / 2.0
            return CGPoint(x: x, y: y)
        }
    }
    
    func origin(position: DVPosition, size: CGSize, container: CGSize) -> CGPoint {
        
        switch self {
        case .bottomLeft:
            let x: CGFloat = -size.width
            let y: CGFloat = container.height + size.height
            return CGPoint(x: x, y: y)
        case .bottom:
            let x: CGFloat = position.xpos(size: size, container: container)
            let y: CGFloat = container.height + size.height
            return CGPoint(x: x, y: y)
        case .bottomRight:
            let x: CGFloat = container.width + size.width
            let y: CGFloat = container.height + size.height
            return CGPoint(x: x, y: y)
        case .right:
            let x: CGFloat = container.width + size.width
            let y: CGFloat = position.ypos(size: size, container: container)
            return CGPoint(x: x, y: y)
        case .center:
            let x: CGFloat = (container.width - size.width) / 2.0
            let y: CGFloat = (container.height - size.height) / 2.0
            return CGPoint(x: x, y: y)
        case .topRight:
            let x: CGFloat = container.width + size.width
            let y: CGFloat = -size.height
            return CGPoint(x: x, y: y)
        case .top:
            let x: CGFloat = position.xpos(size: size, container: container)
            let y: CGFloat = -size.height
            return CGPoint(x: x, y: y)
        case .topLeft:
            let x: CGFloat = -size.width
            let y: CGFloat = -size.height
            return CGPoint(x: x, y: y)
        case .left:
            let x: CGFloat = -size.width
            let y: CGFloat = position.ypos(size: size, container: container)
            return CGPoint(x: x, y: y)
        }
    }
    
    func ypos(size: CGSize, container: CGSize) -> CGFloat {
        switch self {
        case .bottomLeft, .bottom, .bottomRight:
            return container.height - size.height
        case .left, .center, .right:
            return (container.height - size.height) / 2.0
        case .topLeft, .top, .topRight:
            return 0.0
        }
    }
    
    func xpos(size: CGSize, container: CGSize) -> CGFloat {
        switch self {
        case .bottomLeft, .left, .topLeft:
            return 0.0
        case .top, .center, .bottom:
            return (container.width - size.width) / 2.0
        case .bottomRight, .right, .topRight:
            return container.width - size.width
        }
    }
}

public extension Int {
    
    var dvposition: DVPosition {
        switch self {
        case 0: return .bottomLeft
        case 1: return .bottom
        case 2: return .bottomRight
        case 3: return .right
        case 4: return .center
        case 5: return .topRight
        case 6: return .top
        case 7: return .topLeft
        case 8: return .left
        default:
            print("Error: int |\(self)| out of range for HGPosition")
            return .center
        }
    }
}
