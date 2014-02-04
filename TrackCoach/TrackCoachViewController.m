//
//  TestTimerViewController.m
//  TestTimer
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "MediaPlayer/MediaPlayer.h"

#define UNDO_STOP_ALERT 7
#define RESET_ALERT 8

@interface TrackCoachViewController()
@end

@implementation TrackCoachViewController

#pragma mark Buttons
- (VolumeButtons *)volumeButtons {
    if (!_volumeButtons) {
        _volumeButtons = [[VolumeButtons alloc] init];
    }
    return _volumeButtons;
}

//sender is button either way
- (IBAction)startStopButtonAction:(UIButton *)sender {
//    if (!self.timerRunning) {
    if (!self.timer) {
        if (self.raceTime.lapTimes.count == 0) {
            [self start];
        } else /*if (sender != nil)*/ {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Undo Stop?"
                                                            message:@"Are you sure you want to undo? The time will resume as though you did not stop."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Undo Stop", nil];
            alert.tag = UNDO_STOP_ALERT;
            [alert show];
            self.alertIsDisplayed = YES;
        }
    } else {
        [self stop];
    }
}

//sender is nil if triggered by volume button
- (IBAction)lapResetButtonAction:(id)sender {
    if ([self.timer isValid]) {
        [self lap];
    } else if (self.raceTime.lapTimes.count > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset"
                                                            message:@"Are you sure you want to reset?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Reset", nil];
            alert.tag = RESET_ALERT;
            [alert show];
            self.alertIsDisplayed = YES;
    }
}

#pragma mark Timer
- (void)start {
    self.raceTime.startDate = [NSDate date];
    [self startNSTimer];
    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor redColor]];
    [self.lapResetButton setTitle:@"Lap" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)stop {
    [self lap];
    [self.timer invalidate];
    self.timer = nil;
    self.lapTimerLabel.text = [self timeToString:[self.raceTime mostRecentLapTime]];
//    self.timerLabel.text = [self timeToString:[self totalOfLaps]];
    NSLog(@"Total of laps is %f", [self.raceTime totalOfLaps]);
    NSLog(@"Total elapsed time is %@", self.timerLabel.text);
    [self.startStopButton setTitle:@"Undo Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor colorWithRed:0.82 green:0.80 blue:0.20 alpha:1.0]];
    [self.lapResetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)undoStop {
    if ([self.timer isValid]) {
        [NSException raise:@"Tried to undo stop, when already started" format:nil];
    }
    [self.raceTime removeMostRecentLap];
    [self.tableView reloadData];
    [self startNSTimer];
    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor redColor]];
    [self.lapResetButton setTitle:@"Lap" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)lap {
    NSLog(@"Lap");
    if (![self.timer isValid]) {
        [NSException raise:@"Tried to lap while timer not running"
                    format:nil];
    }
    [self.raceTime addNewLap];
    [self.tableView reloadData];
}

- (void)reset {
    if ([self.timer isValid]) {
        [NSException raise:@"Tried to reset while timer running"
                    format:nil];
    }
    NSLog(@"Reset");
//    self.secondsAlreadyRun = 0;
    self.timerLabel.text = @"0:00.00";
    self.lapTimerLabel.text = self.timerLabel.text;
    self.raceTime = [[RaceTime alloc] init];
    [self.tableView reloadData];
    [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor greenColor]];
}

- (void)updateTime {    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.raceTime.startDate != nil && [self.timer isValid]) {
            NSTimeInterval totalElapsed = [self.raceTime elapsed];
            
            self.timerLabel.text = [self timeToString:totalElapsed];
            NSTimeInterval currentLapTime = totalElapsed - [self.raceTime totalOfLaps];
            self.lapTimerLabel.text = [self timeToString:currentLapTime];
        }
    });
}

#pragma mark Utility methods
- (NSString *)timeToString:(NSTimeInterval)time {
    int mins = (int)(time / 60.0);
    time -= mins * 60;
    int secs = (int)(time);
    time -= secs;
    int dec = time * 100.0;
    
    return [NSString stringWithFormat:@"%u:%02u.%02u", mins, secs, dec];
}

//- (NSTimeInterval)totalOfLaps {
//    NSTimeInterval total = 0;
//    for (NSNumber *lap in self.lapTimes) {
////        NSNumber *lapNS = lap;
//        total += [lap doubleValue];
//    }
//    return total;
//}
//
//- (NSTimeInterval)elapsed {
////    NSDate *currentDate = [NSDate date];
//    return [[NSDate date] timeIntervalSinceDate:self.startDate];
//}

#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.raceTime.lapTimes count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LapCell"];
    
    NSNumber *lapTime = self.raceTime.lapTimes[indexPath.row];
    cell.detailTextLabel.text = [self timeToString:[lapTime doubleValue]];
    cell.textLabel.text = [NSString stringWithFormat:@"Lap %lu", (unsigned long)(self.raceTime.lapTimes.count - indexPath.row)];
    return cell;
}

#pragma mark AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == RESET_ALERT) {
        if (buttonIndex == 1) {
            [self reset];
        }
    } else if (alertView.tag == UNDO_STOP_ALERT) {
        if (buttonIndex == 1) {
            [self undoStop];
        }
    } else {
        NSLog(@"Unknown alert clicked.");
    }
    self.alertIsDisplayed = NO;
}

#pragma mark other methods for file
- (void)startNSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 100.0)
                                                  target:self
                                                selector:@selector(updateTime)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lapTimerLabel.text = self.timerLabel.text;
    self.alertIsDisplayed = NO;
    //    self.timerRunning = NO;
//    self.secondsAlreadyRun = 0;
    self.raceTime = [[RaceTime alloc] init];
    self.timer = nil;
    //    self.elapsedTime = 0;
    
    self.tableView.dataSource = self;
    __block TrackCoachViewController *blocksafeSelf = self;
    self.volumeButtons.volumeUpBlock = ^{
        NSLog(@"Volume Up");
        if (!blocksafeSelf.alertIsDisplayed) {
            [blocksafeSelf startStopButtonAction:nil];
        }
    };
    self.volumeButtons.volumeDownBlock = ^{
        NSLog(@"Volume Down");
        if (!blocksafeSelf.alertIsDisplayed) {
            [blocksafeSelf lapResetButtonAction:nil];
        }
    };
    [self.volumeButtons startUsingVolumeButtons];
    
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *appFirstStartOfVersionKey = [NSString stringWithFormat:@"first_start_%@", bundleVersion];
    NSNumber *alreadyStartedOnVersion = [[NSUserDefaults standardUserDefaults] objectForKey:appFirstStartOfVersionKey];
    if (!alreadyStartedOnVersion || [alreadyStartedOnVersion boolValue] == NO) {
        NSLog(@"First time!");
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:appFirstStartOfVersionKey];
    }
    
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
