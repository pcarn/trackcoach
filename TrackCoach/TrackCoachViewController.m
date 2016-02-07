//
//  TrackCoachViewController.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "MediaPlayer/MediaPlayer.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

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

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"confirmReset"]) {
        [defaults setBool:YES forKey:@"confirmReset"];
        [defaults synchronize];
    }

    [self updateUI];
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
                                             selector:@selector(volumeDown)
                                                 name:@"volumeDown"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeUp)
                                                 name:@"volumeUp"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissTutorial)
                                                 name:@"dismissTutorial"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self runTutorialIfNeeded];
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
    //    [textToShare appendString:@"\nwww.trackcoachapp.com"];


    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[textToShare] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop];
    if ([activityVC respondsToSelector:@selector(popoverPresentationController)]) {
        activityVC.popoverPresentationController.barButtonItem = sender;
    }
    [self presentViewController:activityVC animated:YES completion:^{
        [PFAnalytics trackEvent:@"sharedTime" dimensions:@{@"numberOfLaps": [NSString stringWithFormat:@"%lu", (unsigned long)self.trackCoachBrain.raceTime.lapTimes.count]}];
    }];
}

//sender is button either way
- (IBAction)startStopButtonAction:(id)sender {
    if (!self.trackCoachBrain.timerIsRunning) {
        if (self.trackCoachBrain.raceTime.lapTimes.count == 0) { // Start
            [self.trackCoachBrain start];
            [self setupForTimerRunning];
        } else { // Undo Stop
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Undo Stop?"
                                                            message:@"Are you sure you want to undo? The time will resume as though you did not stop."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Undo Stop", nil];
            alert.tag = undoStopAlert;
            [alert show];
            self.alertIsDisplayed = YES;
        }
    } else { // Stop
        [self.trackCoachBrain stop];
        [self.tableView reloadData];
        [self setupForTimerStopped];

    }
    [self saveSettings];
}

//sender is nil if triggered by volume button
- (IBAction)lapResetButtonAction:(id)sender {
    if (self.trackCoachBrain.timerIsRunning) { // Just lapped
        [self.trackCoachBrain lap];
    } else if (self.trackCoachBrain.raceTime.lapTimes.count > 0) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"confirmReset"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset"
                                                            message:@"Are you sure you want to reset?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Reset", nil];
            alert.tag = resetAlert;
            [alert show];
            self.alertIsDisplayed = YES;
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
    [PFAnalytics trackEvent:@"reset" dimensions:@{@"numberOfLaps": [NSString stringWithFormat:@"%lu", (unsigned long)self.trackCoachBrain.raceTime.lapTimes.count]}];
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
    [PFAnalytics trackEvent:@"undoStop"];
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

#pragma mark AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!self.trackCoachBrain.timerIsRunning && self.trackCoachBrain.raceTime.lapTimes.count > 0) {
        if (alertView.tag == resetAlert) {
            if (buttonIndex == 1) {
                [self reset];
            }
        } else if (alertView.tag == undoStopAlert) {
            if (buttonIndex == 1) {
                [self undoStop];
            }
        } else {
            NSLog(@"Other alert clicked.");
        }
    }
    self.alertIsDisplayed = NO;
    [self saveSettings];
}

#pragma mark UserDefaults
- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedRaceTime = [NSKeyedArchiver archivedDataWithRootObject:self.trackCoachBrain.raceTime];

    [defaults setBool:self.trackCoachBrain.timerIsRunning forKey:@"timerIsRunning"];
    [defaults setObject:encodedRaceTime forKey:@"encodedRaceTime"];
    [defaults synchronize];
    NSLog(@"Data saved");
}

#pragma mark Tutorial
- (void)runTutorialIfNeeded {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:TUTORIAL_RUN_STRING] || ![defaults boolForKey:TUTORIAL_RUN_STRING]) {
        // Doesn't exist, or false
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!appDel.hideVolumeButtons) {
            self.tutorial = [[Tutorial alloc] init];
            UIPageViewController *pageViewController = [self.tutorial runTutorial];
            if (pageViewController) {
                [self.navigationController presentViewController:pageViewController animated:YES completion:nil];
            } else {
                self.tutorial = nil;
            }
        }
    }
}

- (void)dismissTutorial {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.tutorial = nil;
}

#pragma mark - Volume Buttons
- (void)volumeDown {
    if (!self.alertIsDisplayed && self.isViewLoaded && self.view.window) {
        [PFAnalytics trackEvent:@"volumeButtonUsed" dimensions:@{@"direction": @"down"}];
        [self lapResetButtonAction:nil];
    }
}

- (void)volumeUp {
    if (!self.alertIsDisplayed && self.isViewLoaded && self.view.window) {
        [PFAnalytics trackEvent:@"volumeButtonUsed" dimensions:@{@"direction": @"up"}];
        [self startStopButtonAction:nil];
    }
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
    } else if (self.trackCoachBrain.raceTime.startDate) {  // Stopped
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

@end
