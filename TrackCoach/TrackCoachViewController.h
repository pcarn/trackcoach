//
//  TrackCoachViewController.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackCoachBrain.h"
#import "SettingsViewController.h"
#import "TutorialViewController.h"
#import "Tutorial1ViewController.h"
#import "Tutorial2ViewController.h"
#import "Tutorial3ViewController.h"
#import "Defines.h"
#import "TrackCoachTableViewCell.h"

@interface TrackCoachViewController : UIViewController <UITableViewDataSource, UIAlertViewDelegate, UIPageViewControllerDataSource>

@property (assign) BOOL alertIsDisplayed;
@property (assign) BOOL tutorialIsDisplayed;
@property (weak, nonatomic) IBOutlet UIButton *lapResetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *lapTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) TrackCoachBrain *trackCoachBrain;
@property (strong, nonatomic) VolumeButtons *volumeButtons;

- (IBAction)lapResetButtonAction:(id)sender;
- (IBAction)startStopButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;
- (void)updateUI;
- (void)startNSTimer;
- (void)stopNSTimer;
- (void)saveSettings;

@end
