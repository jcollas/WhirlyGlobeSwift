//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "ConfigViewController.h"
#import "AFHTTPRequestOperation.h"
#import "DDXML.h"

@interface AFXMLParserResponseSerializer (CustomInit)

+ (instancetype)sharedSerializer;

@end

@interface AFJSONResponseSerializer (CustomInit)

+ (instancetype)sharedSerializer;

@end
