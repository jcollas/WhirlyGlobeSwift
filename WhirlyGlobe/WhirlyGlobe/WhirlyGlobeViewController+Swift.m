//
//  WhirlyGlobeViewController+Swift.m
//  WhirlyGlobeComponentTester
//
//  Created by Juan J. Collas on 9/2/2014.
//  Copyright (c) 2014 mousebird consulting. All rights reserved.
//

#import "WhirlyGlobeViewController+Swift.h"

@implementation WhirlyGlobeViewController (Swift)

- (MaplyViewControllerLayer *)addSphericalEarthLayerWithImageSetName:(NSString *)name
{
    
    return (MaplyViewControllerLayer *)[self addSphericalEarthLayerWithImageSet:name];
}

@end
