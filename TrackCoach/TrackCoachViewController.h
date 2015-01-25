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
#import "Defines.h"
#import "TrackCoachTableViewCell.h"
#import "Tutorial.h"

@interface TrackCoachViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property BOOL alertIsDisplayed;
@property BOOL timerSuspended;
@property (weak, nonatomic) IBOutlet UIButton *lapResetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *lapTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) TrackCoachBrain *trackCoachBrain;
@property (strong, nonatomic) Tutorial *tutorial;

- (IBAction)lapResetButtonAction:(id)sender;
- (IBAction)startStopButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;

@end
