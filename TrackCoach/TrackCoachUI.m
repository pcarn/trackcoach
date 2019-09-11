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
                        @{
                          @"i386"       :@"Simulator",    // Wikipedia List of iOS Devices
                          @"x86_64"     :@"Simulator",
                          @"iPod1,1"    :@"iPod Touch 1",
                          @"iPod2,1"    :@"iPod Touch 2",
                          @"iPod3,1"    :@"iPod Touch 3",
                          @"iPod4,1"    :@"iPod Touch 4",
                          @"iPod5,1"    :@"iPod Touch 5",
                          @"iPod7,1"    :@"iPod Touch 6",
                          @"iPod9,1"    :@"iPod Touch 7",
                          @"iPhone1,1"  :@"iPhone 2G",
                          @"iPhone1,2"  :@"iPhone 3G",
                          @"iPhone2,1"  :@"iPhone 3GS",
                          @"iPhone3,1"  :@"iPhone 4",
                          @"iPhone3,2"  :@"iPhone 4",
                          @"iPhone3,3"  :@"iPhone 4",
                          @"iPhone4,1"  :@"iPhone 4S",
                          @"iPhone5,1"  :@"iPhone 5",
                          @"iPhone5,2"  :@"iPhone 5",
                          @"iPhone5,3"  :@"iPhone 5c",
                          @"iPhone5,4"  :@"iPhone 5c",
                          @"iPhone6,1"  :@"iPhone 5s",
                          @"iPhone6,2"  :@"iPhone 5s",
                          @"iPhone7,1"  :@"iPhone 6 Plus",
                          @"iPhone7,2"  :@"iPhone 6",
                          @"iPhone8,1"  :@"iPhone 6s",
                          @"iPhone8,2"  :@"iPhone 6s Plus",
                          @"iPhone8,4"  :@"iPhone SE",
                          @"iPhone9,1"  :@"iPhone 7",
                          @"iPhone9,3"  :@"iPhone 7",
                          @"iPhone9,2"  :@"iPhone 7 Plus",
                          @"iPhone9,4"  :@"iPhone 7 Plus",
                          @"iPhone10,1" :@"iPhone 8",
                          @"iPhone10,2" :@"iPhone 8 Plus",
                          @"iPhone10,3" :@"iPhone X",
                          @"iPhone10,4" :@"iPhone 8",
                          @"iPhone10,5" :@"iPhone 8 Plus",
                          @"iPhone10,6" :@"iPhone X",
                          @"iPhone11,2" :@"iPhone XS",
                          @"iPhone11,4" :@"iPhone XS Max",
                          @"iPhone11,6" :@"iPhone XS Max Global",
                          @"iPhone11,8" :@"iPhone XR",
                          @"iPad1,1"    :@"iPad Original",
                          @"iPad2,1"    :@"iPad 2",
                          @"iPad2,2"    :@"iPad 2",
                          @"iPad2,3"    :@"iPad 2",
                          @"iPad2,4"    :@"iPad 2",
                          @"iPad2,5"    :@"iPad Mini",
                          @"iPad2,6"    :@"iPad Mini",
                          @"iPad2,7"    :@"iPad Mini",
                          @"iPad3,1"    :@"iPad 3",
                          @"iPad3,2"    :@"iPad 3",
                          @"iPad3,3"    :@"iPad 3",
                          @"iPad3,4"    :@"iPad 4",
                          @"iPad3,5"    :@"iPad 4",
                          @"iPad3,6"    :@"iPad 4",
                          @"iPad4,1"    :@"iPad Air",
                          @"iPad4,2"    :@"iPad Air",
                          @"iPad4,3"    :@"iPad Air",
                          @"iPad4,4"    :@"iPad Mini 2",
                          @"iPad4,5"    :@"iPad Mini 2",
                          @"iPad4,6"    :@"iPad Mini 2",
                          @"iPad4,7"    :@"iPad Mini 3",
                          @"iPad4,8"    :@"iPad Mini 3",
                          @"iPad4,9"    :@"iPad Mini 3",
                          @"iPad5,1"    :@"iPad Mini 4",
                          @"iPad5,2"    :@"iPad Mini 4",
                          @"iPad5,3"    :@"iPad Air 2",
                          @"iPad5,4"    :@"iPad Air 2",
                          @"iPad6,3"    :@"iPad Pro (9.7-inch)",
                          @"iPad6,4"    :@"iPad Pro (9.7-inch)",
                          @"iPad6,7"    :@"iPad Pro (12.9-inch)",
                          @"iPad6,8"    :@"iPad Pro (12.9-inch)",
                          @"iPad6,11"   :@"iPad (5th generation)",
                          @"iPad6,12"   :@"iPad (5th generation)",
                          @"iPad7,1"    :@"iPad Pro (12.9-inch, 2nd generation)",
                          @"iPad7,2"    :@"iPad Pro (12.9-inch, 2nd generation)",
                          @"iPad7,3"    :@"iPad Pro (10.5-inch)",
                          @"iPad7,4"    :@"iPad Pro (10.5-inch)",
                          @"iPad7,5"    :@"iPad (6th generation)",
                          @"iPad7,6"    :@"iPad (6th generation)",
                          @"iPad8,1"    :@"iPad Pro 3rd Gen (11 inch, WiFi)",
                          @"iPad8,2"    :@"iPad Pro 3rd Gen (11 inch, 1TB, WiFi)",
                          @"iPad8,3"    :@"iPad Pro 3rd Gen (11 inch, WiFi+Cellular)",
                          @"iPad8,4"    :@"iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)",
                          @"iPad8,5"    :@"iPad Pro 3rd Gen (12.9 inch, WiFi)",
                          @"iPad8,6"    :@"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)",
                          @"iPad8,7"    :@"iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)",
                          @"iPad8,8"    :@"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)",
                          @"iPad11,1"   :@"iPad mini 5th Gen (WiFi)",
                          @"iPad11,2"   :@"iPad mini 5th Gen",
                          @"iPad11,3"   :@"iPad Air 3rd Gen (WiFi)",
                          @"iPad11,4"   :@"iPad Air 3rd Gen"
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
