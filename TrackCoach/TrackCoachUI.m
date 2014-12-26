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
    NSURL *url = [NSURL URLWithString:[[@"http://trackcoachapp.com/appdata/" stringByAppendingString:filename] stringByAppendingString:@".pcarn"]];
    NSString *data = [NSString stringWithContentsOfURL:url
                                          usedEncoding:NULL
                                                 error:NULL];
    
    return [data componentsSeparatedByString:@"\n"];
}


+ (NSString *)timeToString:(NSTimeInterval)time {
    int hours = (int)(time / 3600.0);
    time -= hours * 3600;
    int mins = (int)(time / 60.0);
    time -= mins * 60;
    int secs = (int)(time);
    time -= secs;
    int dec = time * 100.0;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%u:%02u:%02u.%02u", hours, mins, secs, dec];
    } else {
        return [NSString stringWithFormat:@"%u:%02u.%02u", mins, secs, dec];
    }
}

@end
