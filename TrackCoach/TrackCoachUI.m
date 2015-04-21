//
//  TrackCoachUI.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 4/12/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachUI.h"
#import <sys/utsname.h>

@implementation TrackCoachUI

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

+ (NSString *)deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end
