//
//  TrackCoachTableViewCell.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 3/9/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachTableViewCell.h"

@implementation TrackCoachTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
