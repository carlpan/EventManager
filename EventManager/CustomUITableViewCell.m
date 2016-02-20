//
//  CustomUITableViewCell.m
//  EventManager
//
//  Created by Carl Pan on 2/19/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "CustomUITableViewCell.h"

@implementation CustomUITableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInternalFields:(EventEntity *)incomingEventEntity {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // Calculate the hours till event
    NSTimeInterval secondsBetween = [incomingEventEntity.eventDate timeIntervalSinceNow];
    int numberOfHours = secondsBetween / 3600;
    
    self.localEventEntity = incomingEventEntity;
    self.eventTitleLabel.text = incomingEventEntity.eventTitle;
    //self.timeToEventLabel.text = [dateFormatter stringFromDate:incomingEventEntity.eventDate];
    self.timeToEventLabel.text = [NSString stringWithFormat:@"in %d hours", numberOfHours];
}

@end
