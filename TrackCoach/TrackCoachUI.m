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
    int minutes = (int)(time / 60.0);
    time -= minutes * 60;
    int seconds = (int)(time);
    time -= seconds;
    int decimal = time * 100.0;

    if (hours > 0) {
        return [NSString stringWithFormat:@"%u:%02u:%02u.%02u", hours, minutes, seconds, decimal];
    } else {
        return [NSString stringWithFormat:@"%u:%02u.%02u", minutes, seconds, decimal];
    }
}

@end
