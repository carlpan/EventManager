//
//  DetailViewController.h
//  EventManager
//
//  Created by Carl Pan on 2/19/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPMOCManager.h"
#import "YPEventEntityManager.h"

@interface DetailViewController : UIViewController <YPMOCManager, YPEventEntityManager>

// Delegate protocol method
- (void)receiveMOC:(NSManagedObjectContext *)incomingMOC;
- (void)receiveEventEntity:(EventEntity *)incomingEventEntity;

@end
