//
//  VolumeButtons.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 10/15/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

typedef void (^volumeBlock)();

extern const double AUTO_VOLUME_INTERVAL_1;
extern const double AUTO_VOLUME_INTERVAL_2;
extern const double AUTO_VOLUME_INTERVAL_ERROR;

@interface VolumeButtons : NSObject
@property (nonatomic, copy) volumeBlock volumeUpBlock;
@property (nonatomic, copy) volumeBlock volumeDownBlock;

- (void)startUsingVolumeButtons;
- (void)stopUsingVolumeButtons;
@end
