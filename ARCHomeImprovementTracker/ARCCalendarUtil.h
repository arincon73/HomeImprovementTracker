//
//  ARCCalendarUtil.h
//  ARCHomeImprovementTracker
//
//  Created by Adriana Rincon on 5/27/14.
//  Copyright (c) 2014 Actions and Results consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface ARCCalendarUtil : NSObject

+ (EKCalendar *) calendar;
+ (EKEventStore *) eventStore;
+ (void)requestAccess:(void (^)(BOOL granted, NSError *error))success;
+ (NSString *)addEvent:(NSDate*)eventDate withTitle:(NSString*)title;
+ (NSString *)editEvent:(NSString*)eventIdentifier withTitle:(NSString*)theTitle withStartDate:(NSDate*)theStartDate;
+ (NSDate *)eventStartDate:(NSString*)eventIdentifier;
@end
