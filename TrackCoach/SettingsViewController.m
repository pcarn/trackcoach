//
//  SettingsViewController.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/6/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.topTextView.selectable = YES; // for formatting
    if (IS_IPAD) {
        self.topTextView.text = [self.topTextView.text stringByReplacingOccurrencesOfString:@"iPhone" withString:@"iPad"];
    }
    self.topTextView.selectable = NO; // for formatting
    
    [self.contactButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.topTextView sizeToFit];
    [self.mainTextView sizeToFit];
    self.copyrightNoticeLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"NSHumanReadableCopyright"];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.confirmResetSwitch.on = [defaults boolForKey:@"confirmReset"];
    self.enableButtonsSwitch.on = [defaults boolForKey:@"enableOnscreenButtons"];

    [self.confirmResetSwitch addTarget:self action:@selector(setConfirmResetState:) forControlEvents:UIControlEventValueChanged];
    [self.enableButtonsSwitch addTarget:self action:@selector(changeOnscreenButtonsState:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {

}

#pragma mark Confirm Reset
- (void)setConfirmResetState:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[sender isOn] forKey:@"confirmReset"];
    [defaults synchronize];
}

#pragma mark On-Screen Buttons
- (void)changeOnscreenButtonsState:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[sender isOn] forKey:@"enableOnscreenButtons"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOnscreenButtonsState" object:nil];

}

#pragma mark Other
- (IBAction)contactButtonAction:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:@[@"developer@trackcoachapp.com"]];
    [mailController setSubject:@"TrackCoach Feedback"];

    NSString *message = [NSString stringWithFormat:@"\n\n\n\niOS Version: %@\nTrackCoach Version: %@\nDevice: %@",
                         [[UIDevice currentDevice] systemVersion],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [TrackCoachUI deviceName]];
    [mailController setMessageBody:message isHTML:NO];
    if (mailController) {
        [self presentViewController:mailController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

@end
