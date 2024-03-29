//
//  TrackCoachViewController.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2017 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "MediaPlayer/MediaPlayer.h"
#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"

@interface TrackCoachViewController () <JVFloatingDrawerCenterViewController>
@end

@implementation TrackCoachViewController

- (TrackCoachBrain *)trackCoachBrain {
    if (!_trackCoachBrain) {
        _trackCoachBrain = [[TrackCoachBrain alloc] init];
    }
    return _trackCoachBrain;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = nil;
    [self setupEncodedRaceTime];
    [self.timerLabel setAdjustsFontSizeToFitWidth:YES];

    [self updateUI];
    [self changeOnscreenButtonsState];
    [self.tableView reloadData];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startNSTimerIfSuspended)
                                                 name:@"startNSTimerIfSuspended"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopNSTimerIfRunning)
                                                 name:@"stopNSTimerIfRunning"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveSettings)
                                                 name:@"saveSettings"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeOnscreenButtonsState)
                                                 name:@"changeOnscreenButtonsState"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadConfig"
                                                        object:nil];
}

- (void)viewDidAppear:(BOOL)animated {

}

#pragma mark Button Actions
- (IBAction)shareButtonAction:(id)sender {
    NSMutableString *textToShare = [NSMutableString stringWithFormat:@"Total Time: %@", self.timerLabel.text];
    NSArray *laps = [[[self.trackCoachBrain.raceTime.lapTimes copy] reverseObjectEnumerator] allObjects];
    for (NSNumber *lap in laps) {
        [textToShare appendString:[NSString stringWithFormat:@"\nLap %lu: %@ Total: %@",
                                   (unsigned long)[laps indexOfObject:lap]+1,
                                   [TrackCoachUI timeToString:[lap doubleValue]],
                                   [TrackCoachUI timeToString:[self.trackCoachBrain.raceTime totalOfLapAndBelow:([laps count] - [laps indexOfObject:lap] - 1)]]]];
    }
    [textToShare appendString:[NSString stringWithFormat:@"\n\nTimed with TrackCoach for %@", ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone")]];


    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[textToShare] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop];
    if ([activityVC respondsToSelector:@selector(popoverPresentationController)]) {
        activityVC.popoverPresentationController.barButtonItem = sender;
    }
    [self presentViewController:activityVC animated:YES completion:nil];
}

//sender is button either way
- (IBAction)startStopButtonAction:(id)sender {
    if (!self.trackCoachBrain.timerIsRunning) {
        if (self.trackCoachBrain.raceTime.lapTimes.count == 0) { // Start
            [self.trackCoachBrain start];
            [self setupForTimerRunning];
        } else { // Undo Stop
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Undo Stop?"
                                                                           message:@"Are you sure you want to undo? The time will resume as though you did not stop."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * action) {
                                                                     self.alertIsDisplayed = NO;
                                                                 }];
            UIAlertAction *undoStopAction = [UIAlertAction actionWithTitle:@"Undo Stop"
                                                                     style:UIAlertActionStyleDestructive
                                                                   handler:^(UIAlertAction * action) {
                                                                       self.alertIsDisplayed = NO;
                                                                       [self undoStop];
                                                                       [self saveSettings];
                                                                   }];
            [alert addAction:cancelAction];
            [alert addAction:undoStopAction];
            [self presentViewController:alert
                               animated:YES
                             completion:^(void) {
                 self.alertIsDisplayed = YES;
             }];
        }
    } else { // Stop
        [self.trackCoachBrain stop];
        [self.tableView reloadData];
        [self setupForTimerStopped];

    }
    [self saveSettings];
}

- (IBAction)lapResetButtonAction:(id)sender {
    if (self.trackCoachBrain.timerIsRunning) { // Just lapped
        [self.trackCoachBrain lap];
    } else if (self.trackCoachBrain.raceTime.lapTimes.count > 0) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"confirmReset"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset"
                                                                           message:@"Are you sure you want to reset?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * action) {
                                                                     self.alertIsDisplayed = NO;
                                                                 }];
            UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"Reset"
                                                                  style:UIAlertActionStyleDestructive
                                                                handler:^(UIAlertAction * action) {
                                                                    self.alertIsDisplayed = NO;
                                                                    [self reset];
                                                                    [self saveSettings];
                                                                }];
            [alert addAction:cancelAction];
            [alert addAction:resetAction];
            [self presentViewController:alert
                               animated:YES
                             completion:^(void) {
                                 self.alertIsDisplayed = YES;
                             }];
        } else {
            [self reset];
        }
    }
    [self.tableView reloadData];
    [self saveSettings];
}


#pragma mark UI Setup for Timer
- (void)setupForTimerRunning {
    [self startNSTimer];
    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor redColor]];
    [self.lapResetButton setTitle:@"Lap" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.shareButton setEnabled:NO];
}

- (void)setupForTimerStopped {
    self.timerLabel.text = [TrackCoachUI timeToString:[self.trackCoachBrain.raceTime totalOfAllLaps]];
    self.lapTimerLabel.text = [TrackCoachUI timeToString:[self.trackCoachBrain.raceTime mostRecentLapTime]];
    [self.startStopButton setTitle:@"Undo Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor colorWithRed:(255.0/255.0) green:(122.0/255.0) blue:(28.0/255.0) alpha:1.0]];
    [self.lapResetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.shareButton setEnabled:YES];
    [self stopNSTimer];
}

- (void)reset {
    [self.trackCoachBrain reset];
    [self updateUI];
    [self.tableView reloadData];
    [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor greenColor]];
    [self.shareButton setEnabled:NO];
}

- (void)undoStop {
    [self.trackCoachBrain undoStop];
    [self setupForTimerRunning];
    [self.tableView reloadData];
}

- (void)updateUI {
    if (self.trackCoachBrain.timerIsRunning) {
        NSTimeInterval totalElapsed = [self.trackCoachBrain.raceTime elapsed];
        self.timerLabel.text = [TrackCoachUI timeToString:totalElapsed];
        NSTimeInterval currentLapTime = totalElapsed - [self.trackCoachBrain.raceTime totalOfAllLaps];
        self.lapTimerLabel.text = [TrackCoachUI timeToString:currentLapTime];
    } else {
        NSTimeInterval totalOfLaps = [self.trackCoachBrain.raceTime totalOfAllLaps];
        self.timerLabel.text = [TrackCoachUI timeToString:totalOfLaps];
        self.lapTimerLabel.text = [TrackCoachUI timeToString:[self.trackCoachBrain.raceTime mostRecentLapTime]];
    }
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
    TrackCoachTableViewCell *cell = (TrackCoachTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LapCell"];

    NSNumber *lapTime = self.trackCoachBrain.raceTime.lapTimes[indexPath.row];
    cell.splitLabel.text = [TrackCoachUI timeToString:[lapTime doubleValue]];
    cell.titleLabel.text = [NSString stringWithFormat:@"Lap %lu", (unsigned long)(self.trackCoachBrain.raceTime.lapTimes.count - indexPath.row)];
    cell.totalLabel.text = [TrackCoachUI timeToString:[self.trackCoachBrain.raceTime totalOfLapAndBelow:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

#pragma mark UserDefaults
- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedRaceTime = [NSKeyedArchiver archivedDataWithRootObject:self.trackCoachBrain.raceTime];

    [defaults setBool:self.trackCoachBrain.timerIsRunning forKey:@"timerIsRunning"];
    [defaults setObject:encodedRaceTime forKey:@"encodedRaceTime"];
    [defaults synchronize];
}

#pragma mark On-Screen Buttons
- (void)changeOnscreenButtonsState {
    BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"enableOnscreenButtons"];
    self.lapResetButton.enabled = enabled;
    self.lapResetButton.alpha = enabled ? 1.0 : 0.2;
    self.startStopButton.enabled = enabled;
    self.startStopButton.alpha = enabled ? 1.0 : 0.2;
    self.buttonsDisabledLabel.hidden = enabled;
}

#pragma mark Other/Utility methods
- (void)startNSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 100.0)
                                                  target:self
                                                selector:@selector(updateUI)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopNSTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startNSTimerIfSuspended {
    if (self.timerSuspended) {
        self.timerSuspended = NO;
        [self startNSTimer];
    }
}

- (void)stopNSTimerIfRunning {
    if (self.timer) {
        self.timerSuspended = YES;
        [self stopNSTimer];
    }
}

- (void)setupEncodedRaceTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedRaceTime = [defaults objectForKey:@"encodedRaceTime"];
    if (encodedRaceTime) {
        self.trackCoachBrain.raceTime = [NSKeyedUnarchiver unarchiveObjectWithData:encodedRaceTime];
    }
    self.trackCoachBrain.timerIsRunning = [defaults boolForKey:@"timerIsRunning"];
    if (self.trackCoachBrain.timerIsRunning) {
        [self setupForTimerRunning];
    } else if (self.trackCoachBrain.raceTime.startTime != 0) {  // Stopped
        [self setupForTimerStopped];
    } else {    // Clear
        [self.shareButton setEnabled:NO];
    }
}

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - JVFloatingDrawerCenterViewController

- (BOOL)shouldOpenDrawerWithSide:(JVFloatingDrawerSide)drawerSide {
    return YES;
}

@end
