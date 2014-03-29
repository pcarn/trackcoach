//
//  AppInfoViewController.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/6/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@class AppInfoViewController;

@protocol AppInfoViewControllerDelegate <NSObject>
- (void)appInfoViewControllerDidCancel:(AppInfoViewController *)controller;
@end

@interface AppInfoViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) id <AppInfoViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UITextView *topTextView;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UILabel *copyrightNoticeLabel;

- (IBAction)contactButtonAction:(id)sender;
- (IBAction)back:(id)sender;
@end
