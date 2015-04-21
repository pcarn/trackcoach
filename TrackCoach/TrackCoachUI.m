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
    NSString *code = [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];

    NSDictionary* deviceNamesByCode =
                        @{@"i386"      :@"Simulator",    // Wikipedia List of iOS Devices
                          @"x86_64"    :@"Simulator",
                          @"iPod1,1"   :@"iPod Touch 1",
                          @"iPod2,1"   :@"iPod Touch 2",
                          @"iPod3,1"   :@"iPod Touch 3",
                          @"iPod4,1"   :@"iPod Touch 4",
                          @"iPod5,1"   :@"iPod Touch 5",
                          @"iPhone1,1" :@"iPhone 2G",
                          @"iPhone1,2" :@"iPhone 3G",
                          @"iPhone2,1" :@"iPhone 3GS",
                          @"iPhone3,1" :@"iPhone 4",
                          @"iPhone3,2" :@"iPhone 4",
                          @"iPhone3,3" :@"iPhone 4",
                          @"iPhone4,1" :@"iPhone 4S",
                          @"iPhone5,1" :@"iPhone 5",
                          @"iPhone5,2" :@"iPhone 5",
                          @"iPhone5,3" :@"iPhone 5c",
                          @"iPhone5,4" :@"iPhone 5c",
                          @"iPhone6,1" :@"iPhone 5s",
                          @"iPhone6,2" :@"iPhone 5s",
                          @"iPhone7,1" :@"iPhone 6 Plus",
                          @"iPhone7,2" :@"iPhone 6",
                          @"iPad1,1"   :@"iPad Original",
                          @"iPad2,1"   :@"iPad 2",
                          @"iPad2,2"   :@"iPad 2",
                          @"iPad2,3"   :@"iPad 2",
                          @"iPad2,4"   :@"iPad 2",
                          @"iPad2,5"   :@"iPad Mini",
                          @"iPad2,6"   :@"iPad Mini",
                          @"iPad2,7"   :@"iPad Mini",
                          @"iPad3,1"   :@"iPad 3",
                          @"iPad3,2"   :@"iPad 3",
                          @"iPad3,3"   :@"iPad 3",
                          @"iPad3,4"   :@"iPad 4",
                          @"iPad3,5"   :@"iPad 4",
                          @"iPad3,6"   :@"iPad 4",
                          @"iPad4,1"   :@"iPad Air",
                          @"iPad4,2"   :@"iPad Air",
                          @"iPad4,3"   :@"iPad Air",
                          @"iPad4,4"   :@"iPad Mini 2",
                          @"iPad4,5"   :@"iPad Mini 2",
                          @"iPad4,6"   :@"iPad Mini 2",
                          @"iPad4,7"   :@"iPad Mini 3",
                          @"iPad4,8"   :@"iPad Mini 3",
                          @"iPad4,9"   :@"iPad Mini 3",
                          @"iPad5,3"   :@"iPad Air 2",
                          @"iPad5,4"   :@"iPad Air 2"
                          };

    NSString* deviceName = [deviceNamesByCode objectForKey:code];

    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:

        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    return deviceName;
}

@end
