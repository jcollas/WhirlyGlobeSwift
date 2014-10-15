//
//  WhirlyGlobeComponentTester-Bridging-Header.m
//  WhirlyGlobeComponentTester
//
//  Created by Juan J. Collas on 10/7/2014.
//  Copyright (c) 2014 Moreira Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WhirlyGlobeComponentTester-Bridging-Header.h"

@implementation AFXMLParserResponseSerializer (CustomInit)

+ (instancetype)sharedSerializer {
    return [AFXMLParserResponseSerializer serializer];
}

@end

@implementation AFJSONResponseSerializer (CustomInit)

+ (instancetype)sharedSerializer {
    return [AFJSONResponseSerializer serializer];
}

@end