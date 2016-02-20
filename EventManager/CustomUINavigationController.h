//
//  CustomUINavigationController.h
//  EventManager
//
//  Created by Carl Pan on 2/19/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPMOCManager.h"

@interface CustomUINavigationController : UINavigationController <YPMOCManager>

// Delegate protocol method
- (void)receiveMOC:(NSManagedObjectContext *)incomingMOC;

@end
