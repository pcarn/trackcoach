//
//  TrackCoachTableViewCell.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 3/9/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackCoachTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *splitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end
