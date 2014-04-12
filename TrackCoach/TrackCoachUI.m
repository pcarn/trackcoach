//
//  TrackCoachUI.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 4/12/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachUI.h"

@implementation TrackCoachUI

+ (NSArray *)getStringsFromSite:(NSString *)filename {
    NSURL *url = [NSURL URLWithString:[@"http://trackcoachapp.com/appdata/" stringByAppendingString:filename]];
    NSString *data = [NSString stringWithContentsOfURL:url
                                          usedEncoding:NULL
                                                 error:NULL];
    
    return [data componentsSeparatedByString:@"\n"];
}

@end
