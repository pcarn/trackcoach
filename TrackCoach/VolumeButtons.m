//
//  VolumeButtons.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 10/15/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#define VOLUME_UP 4
#define VOLUME_DOWN 5

#import "VolumeButtons.h"

const double AUTO_VOLUME_INTERVAL_1 = -0.6;
const double AUTO_VOLUME_INTERVAL_2 = -0.2;
const double AUTO_VOLUME_INTERVAL_ERROR = 0.04; //0.03 for iphone 5s, 0.08 for iphone 3gs

@interface VolumeButtons()
@property (nonatomic) BOOL loweredVolume;
@property (nonatomic) BOOL raisedVolume;
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL paused;
@property (nonatomic) float initialVolume;
@property (nonatomic) NSTimeInterval timeOfLastChange;
@property (strong, nonatomic) UIView *volumeView;
@property (nonatomic) int lastChange;
- (void)pauseUsingVolumeButtons;
- (void)resumeUsingVolumeButtons;


@end

@implementation VolumeButtons

void volumeListenerCallback (
                             void                      *inClientData,
                             AudioSessionPropertyID    inID,
                             UInt32                    inDataSize,
                             const void                *inData
                             );
void volumeListenerCallback (
                             void                      *inClientData,
                             AudioSessionPropertyID    inID,
                             UInt32                    inDataSize,
                             const void                *inData
                             ){
    const float *volumePointer = inData;
    float volume = *volumePointer;
    
    
    if (volume > [(__bridge VolumeButtons*)inClientData initialVolume])
    {
        [(__bridge VolumeButtons*)inClientData volumeUp];
    }
    else if (volume < [(__bridge VolumeButtons*)inClientData initialVolume])
    {
        [(__bridge VolumeButtons*)inClientData volumeDown];
    }
    
}


- (id)init {
    self = [super init];
    if (self) {
        self.active = NO;
        self.paused = NO;
        self.timeOfLastChange = 0;
        self.lastChange = 0;
    } else {
        NSLog(@"VolumeButtons did not init");
    }
    return self;
}

- (void)initializeVolumeButtons {
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)(self));
}

- (void)volumeDown {
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)(self)); //Don't want infinite loop
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:self.initialVolume];
    [self performSelector:@selector(initializeVolumeButtons) withObject:self afterDelay:0.1]; //set up again
//    NSLog(@"%f", self.timeOfLastChange-[NSDate timeIntervalSinceReferenceDate]);
    if (self.lastChange != VOLUME_DOWN
        || (fabs(self.timeOfLastChange-[NSDate timeIntervalSinceReferenceDate] - AUTO_VOLUME_INTERVAL_1) > AUTO_VOLUME_INTERVAL_ERROR
        && fabs(self.timeOfLastChange-[NSDate timeIntervalSinceReferenceDate] - AUTO_VOLUME_INTERVAL_2) > AUTO_VOLUME_INTERVAL_ERROR)) {
        if (self.volumeDownBlock) {
            self.volumeDownBlock();
        }
    }
    self.timeOfLastChange = [NSDate timeIntervalSinceReferenceDate];
    self.lastChange = VOLUME_DOWN;
//    NSLog(@"%f", self.timeOfLastChange);
}

- (void)volumeUp {
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)(self)); //Don't want infinite loop
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:self.initialVolume];
    [self performSelector:@selector(initializeVolumeButtons) withObject:self afterDelay:0.1]; //set up again
//    NSLog(@"%f", self.timeOfLastChange-[NSDate timeIntervalSinceReferenceDate]);
    if (self.lastChange != VOLUME_UP
        || (fabs(self.timeOfLastChange-[NSDate timeIntervalSinceReferenceDate] - AUTO_VOLUME_INTERVAL_1) > AUTO_VOLUME_INTERVAL_ERROR
        && fabs(self.timeOfLastChange-[NSDate timeIntervalSinceReferenceDate] - AUTO_VOLUME_INTERVAL_2) > AUTO_VOLUME_INTERVAL_ERROR)) {
        if (self.volumeUpBlock) {
            self.volumeUpBlock();
        }
    }
    self.timeOfLastChange = [NSDate timeIntervalSinceReferenceDate];
    self.lastChange = VOLUME_UP;
//    NSLog(@"%f", self.timeOfLastChange);
}

- (void)startUsingVolumeButtons {
    if (self.active) {
        NSLog(@"Tried to re-activate buttons");
        return;
    }
    self.active = YES;
    
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionSetActive(YES);
    self.initialVolume = [[MPMusicPlayerController applicationMusicPlayer] volume];
    self.loweredVolume = (self.initialVolume == 1.0); //will lower
    self.raisedVolume = (self.initialVolume == 0.0); //will raise
    
    if (self.loweredVolume) {
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.95];
        self.initialVolume = 0.95;
    } else if (self.raisedVolume) {
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.05];
        self.initialVolume = 0.05;
    }
    
    CGRect frame = CGRectMake(-1000, -1000, 0, 0);
    self.volumeView = [[MPVolumeView alloc] initWithFrame:frame];
    [self.volumeView sizeToFit];
    [[[UIApplication sharedApplication] windows][0] addSubview:self.volumeView];
    
    [self initializeVolumeButtons];
    
    if (!self.paused) {
        //Check for notifications to suspend for
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pauseUsingVolumeButtons)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resumeUsingVolumeButtons)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
}

- (void)stopUsingVolumeButtons {
    if (!self.active) {
        NSLog(@"Tried to re-deactivate buttons");
        return;
    }
    //Stop notifications
    if (!self.paused) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)(self));
//    if (self.loweredVolume) {
//        [[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
//    } else if (self.raisedVolume) {
//        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
//    }
    
    [self.volumeView removeFromSuperview];
    self.volumeView = nil;
    
    AudioSessionSetActive(NO);
    self.active = NO;
}

- (void)pauseUsingVolumeButtons {
    if (self.active) {
        self.paused = YES;
        [self stopUsingVolumeButtons];
    }
}

- (void)resumeUsingVolumeButtons {
    if (self.paused) {
        [self startUsingVolumeButtons];
        self.paused = NO;
    }
}

@end
