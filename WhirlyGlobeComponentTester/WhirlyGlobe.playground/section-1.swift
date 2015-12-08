// Playground - noun: a place where people can play

import UIKit
import WhirlyGlobe

var str = "Hello, playground"

var l = 0.0

var y = MaplyViewController()

print(y)

var v = UIView(frame: CGRectMake(0, 0, 400, 400))

v.addSubview(y.view)

y.startAnimation()

y.stopAnimation()
