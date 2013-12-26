//
//  TestTimerViewController.m
//  TestTimer
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import "timerAppViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "MediaPlayer/MediaPlayer.h"


@interface TimerAppViewController()
@end

@implementation TimerAppViewController

//@synthesize timerLabel = _timerLabel;
@synthesize volumeButtons = _volumeButtons;
@synthesize lapTimes = _lapTimes;
@synthesize timer = _timer;

- (VolumeButtons *)volumeButtons {
    if (!_volumeButtons) {
        _volumeButtons = [[VolumeButtons alloc] init];
    }
    return _volumeButtons;
}

- (NSMutableArray *)lapTimes {
    if (!_lapTimes) {
        _lapTimes = [[NSMutableArray alloc] init];
    }
    return _lapTimes;
}

//sender is button either way
- (IBAction)startStopButtonAction:(UIButton *)sender {
//    if (!self.timerRunning) {
    if (!self.timer) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

//sender is nil if triggered by volume button
- (IBAction)lapResetButtonAction:(id)sender {
    if ([self.timer isValid]) {
        [self lap];
    } else {
        [self reset];
#warning not if volume button used though
    }
}

- (void)startTimer {
//    if (!self.timerRunning) {
//        self.timerRunning = YES;
//        self.startTime = [NSDate timeIntervalSinceReferenceDate];
//        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
//        [self.startStopButton setBackgroundColor:[UIColor redColor]];
//        [self.lapResetButton setTitle:@"Lap" forState:UIControlStateNormal];
//        [self updateTime];
//    } else {
//        NSLog(@"Tried to restart timer");
//    }
    self.startDate = [NSDate date];
    [self startNSTimer];
    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor redColor]];
    [self.lapResetButton setTitle:@"Lap" forState:UIControlStateNormal];
}

- (void)stopTimer {
//    if (self.timerRunning) {
//        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
//        [self.startStopButton setBackgroundColor:[UIColor greenColor]];
//        [self.lapResetButton setTitle:@"Reset" forState:UIControlStateNormal];
//        self.secondsAlreadyRun += ([NSDate timeIntervalSinceReferenceDate] - self.startTime);
//        self.timerRunning = NO;
//    } else {
//        NSLog(@"Tried to restop timer");
//    }
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
    self.secondsAlreadyRun += [[NSDate date] timeIntervalSinceDate:self.startDate];
    [self updateTime];
    [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor greenColor]];
    [self.lapResetButton setTitle:@"Reset" forState:UIControlStateNormal];
}

- (void)lap {
    NSLog(@"Lap");
    if (![self.timer isValid]) {
        [NSException raise:@"Tried to lap while timer not running"
                    format:nil];
    }
    [self.lapTimes addObject:[NSNumber numberWithDouble:([self elapsed] - [self totalOfLaps])]];
}

- (void)reset {
    if ([self.timer isValid]) {
        [NSException raise:@"Tried to reset while timer running"
                    format:nil];
    }
    NSLog(@"Reset");
    self.secondsAlreadyRun = 0;
    self.timerLabel.text = @"0:00.00";
    self.lapTimerLabel.text = self.timerLabel.text;
    self.lapTimes = nil;
//#warning remove all laps
}

- (void)updateTime {
    if (self.startDate != nil && [self.timer isValid]) {
        NSTimeInterval totalElapsed = [self elapsed];
//        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        self.timerLabel.text = [self timeToString:totalElapsed];
        NSTimeInterval currentLapTime = totalElapsed - [self totalOfLaps];
        self.lapTimerLabel.text = [self timeToString:currentLapTime];
}
    
//    if (!self.timerRunning) {
//        return;
//    }
//    
//    //calculate elapsed time
//    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
//    NSTimeInterval elapsed = currentTime - self.startTime + self.secondsAlreadyRun;
//    int mins = (int)(elapsed / 60.0);
//    elapsed -= mins * 60;
//    int secs = (int)(elapsed);
//    elapsed -= secs;
//    int dec = elapsed * 100.0;
//    
//    self.timerLabel.text = [NSString stringWithFormat:@"%u:%02u.%02u", mins, secs, dec];
//    
//    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.01];
}

- (NSString *)timeToString:(NSTimeInterval)elapsed {
    int mins = (int)(elapsed / 60.0);
    elapsed -= mins * 60;
    int secs = (int)(elapsed);
    elapsed -= secs;
    int dec = elapsed * 100.0;
    
    return [NSString stringWithFormat:@"%u:%02u.%02u", mins, secs, dec];
}

- (NSTimeInterval)totalOfLaps {
    NSTimeInterval total = 0;
    for (id lap in self.lapTimes) {
        if ([lap isKindOfClass:[NSNumber class]]) {
            NSNumber *lapNS = lap;
            total += [lapNS doubleValue];
        }
    }
    return total;
}

- (NSTimeInterval)elapsed {
    NSDate *currentDate = [NSDate date];
    return [currentDate timeIntervalSinceDate:self.startDate] + self.secondsAlreadyRun;
}

- (void)startNSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 100.0
                                              target:self
                                            selector:@selector(updateTime)
                                            userInfo:nil
                                             repeats:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.startStopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startStopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.startStopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

	self.timerLabel.text = @"0:00.00";
    self.lapTimerLabel.text = self.timerLabel.text;
//    self.timerRunning = NO;
    self.secondsAlreadyRun = 0;
    self.startDate = nil;
    self.timer = nil;
    //    self.elapsedTime = 0;
    
    __block TimerAppViewController *blocksafeSelf = self;
    self.volumeButtons.volumeUpBlock = ^{
        NSLog(@"Volume Up");
        [blocksafeSelf startStopButtonAction:blocksafeSelf.startStopButton];
    };
    self.volumeButtons.volumeDownBlock = ^{
        NSLog(@"Volume Down");
    };
    [self.volumeButtons startUsingVolumeButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.volumeButtons = nil;
}
@end
