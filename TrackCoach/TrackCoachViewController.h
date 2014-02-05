//
//  TestTimerViewController.h
//  TestTimer
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackCoachBrain.h"

@interface TrackCoachViewController : UIViewController <UITableViewDataSource, UIAlertViewDelegate>

@property (assign) BOOL alertIsDisplayed;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *lapResetButton;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *lapTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TrackCoachBrain *trackCoachBrain;
@property (strong, nonatomic) VolumeButtons *volumeButtons;

- (IBAction)lapResetButtonAction:(id)sender;
- (IBAction)startStopButtonAction:(UIButton *)sender;
- (void)updateUI;

@end
