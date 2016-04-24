//
//  SettingsViewController.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/6/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TrackCoachUI.h"
#import "Defines.h"

@class SettingsViewController;

@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UITextView *topTextView;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UILabel *copyrightNoticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *confirmResetSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enableButtonsSwitch;

- (IBAction)contactButtonAction:(id)sender;
@end
