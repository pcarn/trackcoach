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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        }
    }
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
