//
//  CustomUITableViewCell.h
//  EventManager
//
//  Created by Carl Pan on 2/19/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventEntity.h"

@interface CustomUITableViewCell : UITableViewCell

@property (strong, nonatomic) EventEntity *localEventEntity;

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToEventLabel;

- (void)setInternalFields:(EventEntity *)incomingEventEntity;

@end
