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
    
    if (IOS_7_OR_LATER) {
        self.topTextView.selectable = YES;
    }
    NSArray *webTextStrings = [TrackCoachUI getStringsFromSite:@"appInfo.txt"];
    if (webTextStrings) {
        self.topTextView.text = webTextStrings[0];
        if (!IOS_7_OR_LATER) {
            if (IS_IPAD) {
                self.topTextViewHeightConstraint.constant = 117;
            } else {
                self.topTextViewHeightConstraint.constant = 100;
            }
        }
    }
    if (IS_IPAD) {
        self.topTextView.text = [self.topTextView.text stringByReplacingOccurrencesOfString:@"iPhone" withString:@"iPad"];
    }
    if (IOS_7_OR_LATER) {
        self.topTextView.selectable = NO;
    }
    
    [self.contactButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.topTextView sizeToFit];
    [self.mainTextView sizeToFit];
    self.copyrightNoticeLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"NSHumanReadableCopyright"];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];}

- (void)viewDidAppear:(BOOL)animated {
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

- (IBAction)contactButtonAction:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:@[@"developer@trackcoachapp.com"]];
    [mailController setSubject:@"TrackCoach Feedback"];
    if (mailController) {
        [self presentViewController:mailController animated:YES completion:nil];
    }
    
}

- (IBAction)back:(id)sender {
    [self.delegate appInfoViewControllerDidCancel:self];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        NSLog(@"Email sent");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
