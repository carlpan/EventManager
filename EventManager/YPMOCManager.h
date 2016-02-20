//
//  YPMOCManager.h
//  EventManager
//
//  Created by Carl Pan on 2/19/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YPMOCManager <NSObject>

- (void)receiveMOC:(NSManagedObjectContext *)incomingMOC;

@end
