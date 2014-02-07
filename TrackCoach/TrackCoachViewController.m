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


@interface TrackCoachViewController()
@end

@implementation TrackCoachViewController

- (TrackCoachBrain *)trackCoachBrain {
    if (!_trackCoachBrain) {
        _trackCoachBrain = [[TrackCoachBrain alloc] init];
    }
    return _trackCoachBrain;
}

//sender is button either way
- (IBAction)startStopButtonAction:(id)sender {
    if (![self.trackCoachBrain timerIsRunning]) {
        if (self.trackCoachBrain.raceTime.lapTimes.count == 0) {
            [self.trackCoachBrain start];
            [self setupForTimerRunning];
        } else {
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
        [self.trackCoachBrain stop];
        [self.timer invalidate];
        self.timer = nil;
        [self.tableView reloadData];
        self.lapTimerLabel.text = [self timeToString:[self.trackCoachBrain.raceTime mostRecentLapTime]];
        NSLog(@"Total of laps is %f", [self.trackCoachBrain.raceTime totalOfLaps]);
        NSLog(@"Total elapsed time is %@", self.timerLabel.text);
        [self.startStopButton setTitle:@"Undo Stop" forState:UIControlStateNormal];
        [self.startStopButton setBackgroundColor:[UIColor colorWithRed:(255.0/255.0) green:(122.0/255.0) blue:(28.0/255.0) alpha:1.0]];
        [self.lapResetButton setTitle:@"Reset" forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
    }
}

- (IBAction)shareButtonAction:(id)sender {
    NSMutableString *textToShare = [NSMutableString stringWithFormat:@"Total Time: %@", self.timerLabel.text];
    NSArray *laps = [[[self.trackCoachBrain.raceTime.lapTimes copy] reverseObjectEnumerator] allObjects];
    if (laps.count > 0) {
        [textToShare appendString:@"\n"];
    }
    for (NSNumber *lap in laps) {
        [textToShare appendString:[NSString stringWithFormat:@"\nLap %lu: %@", (unsigned long)[laps indexOfObject:lap]+1, [self timeToString:[lap doubleValue]]]];
    }
    NSLog(@"%ld",[[UIDevice currentDevice] userInterfaceIdiom]);
    [textToShare appendString:[NSString stringWithFormat:@"\n\nTimed by TrackCoach for %@", ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"iPhone" : @"iPad")]];
//    [textToShare appendString:@"\nwww.trackcoachapp.com"];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[textToShare] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    if (iOS_7_or_later) {
        activityVC.excludedActivityTypes = [activityVC.excludedActivityTypes arrayByAddingObjectsFromArray:@[UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop]];
    }
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

//sender is nil if triggered by volume button
- (IBAction)lapResetButtonAction:(id)sender {
//    [self.trackCoachBrain lapResetButtonPressed];
    if ([self.trackCoachBrain timerIsRunning]) { // Just lapped
        [self.trackCoachBrain lap];
    } else if (self.trackCoachBrain.raceTime.lapTimes.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset"
                                                        message:@"Are you sure you want to reset?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Reset", nil];
        alert.tag = RESET_ALERT;
        [alert show];
        self.alertIsDisplayed = YES;
        
    }
    [self.tableView reloadData];
}

- (void)setupForTimerRunning {
    [self startNSTimer];
    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor redColor]];
    [self.lapResetButton setTitle:@"Lap" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)updateUI {
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.trackCoachBrain.timerIsRunning) {
            NSTimeInterval totalElapsed = [self.trackCoachBrain.raceTime elapsed];
            self.timerLabel.text = [self timeToString:totalElapsed];
            NSTimeInterval currentLapTime = totalElapsed - [self.trackCoachBrain.raceTime totalOfLaps];
            self.lapTimerLabel.text = [self timeToString:currentLapTime];
        } else {
            self.timerLabel.text = @"0:00.00";
            self.lapTimerLabel.text = @"0:00.00";
        }
//    });
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

#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.trackCoachBrain.raceTime.lapTimes count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LapCell"];
    
    NSNumber *lapTime = self.trackCoachBrain.raceTime.lapTimes[indexPath.row];
    cell.detailTextLabel.text = [self timeToString:[lapTime doubleValue]];
    cell.textLabel.text = [NSString stringWithFormat:@"Lap %lu", (unsigned long)(self.trackCoachBrain.raceTime.lapTimes.count - indexPath.row)];
    return cell;
}

#pragma mark AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == RESET_ALERT) {
        if (buttonIndex == 1) {
            [self.trackCoachBrain reset];
            [self updateUI];
            [self.tableView reloadData];
            [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
            [self.startStopButton setBackgroundColor:[UIColor greenColor]];
        }
    } else if (alertView.tag == UNDO_STOP_ALERT) {
        if (buttonIndex == 1) {
            [self.trackCoachBrain undoStop];
            [self setupForTimerRunning];
            [self.tableView reloadData];
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
                                                selector:@selector(updateUI)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timer = nil;
    self.tableView.dataSource = self;
    self.volumeButtons = [[VolumeButtons alloc] init];
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

- (void)dealloc {
    self.volumeButtons = nil;
}
@end
