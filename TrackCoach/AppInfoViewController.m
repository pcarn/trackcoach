//
//  AppInfoViewController.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/6/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "AppInfoViewController.h"

@interface AppInfoViewController ()

@end

@implementation AppInfoViewController

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
    self.contentWidth.constant = [[UIScreen mainScreen] bounds].size.width;

    self.topTextView.selectable = YES; //for formatting
    NSArray *webTextStrings = [TrackCoachUI getStringsFromSite:@"appInfo"];
    if (webTextStrings) {
        self.topTextView.text = webTextStrings[0];
    }
    if (IS_IPAD) {
        self.topTextView.text = [self.topTextView.text stringByReplacingOccurrencesOfString:@"iPhone" withString:@"iPad"];
    }
    self.topTextView.selectable = NO; //for formatting
    [self.contactButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.topTextView sizeToFit];
    [self.mainTextView sizeToFit];
    self.copyrightNoticeLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"NSHumanReadableCopyright"];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.confirmResetSwitch.on = [defaults boolForKey:@"confirmReset"];

    [self.confirmResetSwitch addTarget:self action:@selector(setConfirmResetState:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark Confirm Reset
- (void)setConfirmResetState:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[sender isOn] forKey:@"confirmReset"];
    [defaults synchronize];
}

#pragma mark Other
- (IBAction)contactButtonAction:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:@[@"developer@trackcoachapp.com"]];
    [mailController setSubject:@"TrackCoach Feedback"];
    if (mailController) {
        [self presentViewController:mailController animated:YES completion:nil];
    }

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        NSLog(@"Email sent");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender {
    [self.delegate appInfoViewControllerDidCancel:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
