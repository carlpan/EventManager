//
//  EventEntity+CoreDataProperties.h
//  EventManager
//
//  Created by Carl Pan on 2/19/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EventEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *eventTitle;
@property (nullable, nonatomic, retain) NSString *eventPlace;
@property (nullable, nonatomic, retain) NSDate *eventDate;

@end

NS_ASSUME_NONNULL_END
