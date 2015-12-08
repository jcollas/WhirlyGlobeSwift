//
//  AnimationTest.m
//  WhirlyGlobeComponentTester
//
//  Created by Steve Gifford on 7/31/13.
//  Copyright (c) 2013 mousebird consulting. All rights reserved.
//

import WhirlyGlobe

class AnimatedSphere : MaplyActiveObject {
    var start : NSTimeInterval
    var period : Float
    var radius : Float
    var color : UIColor
    var startPt : MaplyCoordinate?
    var sphereObj : MaplyComponentObject?
    
    init(period: Float, radius: Float, color: UIColor, viewC: MaplyBaseViewController) {
    
        self.period = period
        self.radius = radius
        self.color = color
        
        start = CFAbsoluteTimeGetCurrent()
        
        super.init(viewController: viewC)
    }

    func hasUpdate() -> Bool {
        return true;
    }

    func updateForFrame(frameInfo : AnyObject) {
        
        if (sphereObj != nil) {
            self.viewC?.removeObjects([sphereObj!], mode: .Current)
            sphereObj = nil
        }

        var t : Float = Float(CFAbsoluteTimeGetCurrent()-start)/period
        t -= Float(Int(t))
        
        let center = MaplyCoordinateMakeWithDegrees(-180.0+Float(t)*360.0, 0.0)
        
        let sphere = MaplyShapeSphere()
        sphere.radius = radius
        sphere.center = center
        
        // Here's the trick, we must use MaplyThreadCurrent to make this happen right now
        sphereObj = self.viewC?.addShapes([sphere], desc:[ kMaplyColor: color ], mode: .Current)
    }

    func shutdown() {
        if (sphereObj != nil) {
            self.viewC?.removeObjects([sphereObj!], mode: .Current)
            sphereObj = nil;
        }
    }
}