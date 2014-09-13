//
//  Tutorial1ViewController.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/25/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "Tutorial1ViewController.h"

@interface Tutorial1ViewController ()

@end

@implementation Tutorial1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.pageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!IS_IPHONE_5_SIZE && !IS_IPAD) {
        NSLog(@"not iphone 5");
        self.aboveButtonIndicatorsSpaceConstraint.constant = 5;
        self.differenceBetweenButtonIndicatorsSpaceConstraint.constant = 35;
        self.titleTopSpaceConstraint.constant = 120;
        self.centerSubtitleVerticalOffsetConstraint.constant = 18;
        self.aboveLogoTopContraint.constant = -17;
        self.betweenSubtitleAndMainTextSpaceConstraint.constant -= 5;
    }
    
    NSArray *webTextStrings = [TrackCoachUI getStringsFromSite:@"tutorial"];
    if (webTextStrings) {
        self.mainTextTitle.text = webTextStrings[0];
        self.mainTextView.selectable = YES; //for formatting
        self.mainTextView.selectable = NO;
        self.mainTextView.text = webTextStrings[1];
        if (IS_IPAD) {
            self.mainTextView.text = [self.mainTextView.text stringByReplacingOccurrencesOfString:@"iPhone" withString:@"iPad"];
        }
        if ([webTextStrings[2] isEqualToString:@"showButtons = true"]) {
            self.startStopLabel.hidden = NO;
            self.lapResetLabel.hidden = NO;
            if (IS_IPAD) {
                self.centerHorizontalOffsetLogoConstraint.constant = 90;
            } else {
                self.centerHorizontalOffsetLogoConstraint.constant = -71;
            }
        }
    }
    
    // Do any additional setup after loading the view.
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

@end
