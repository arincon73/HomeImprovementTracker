//
//  ARCCalendarUtil.m
//  ARCHomeImprovementTracker
//
//  Created by Adriana Rincon on 5/27/14.
//  Copyright (c) 2014 Actions and Results consulting. All rights reserved.
//

#import "ARCCalendarUtil.h"

static EKEventStore *eventStore = nil;
static EKCalendar *calendar = nil;
//static BOOL needsToRequestAccessToEventStore = YES;

@implementation ARCCalendarUtil

void getEventStore(void)
{
    if (eventStore == nil) {
        eventStore = [[EKEventStore alloc] init];
    }
}

+ (void)requestAccess:(void (^)(BOOL granted, NSError *error))callback;
{
    getEventStore();
    
    // request permissions
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:callback];
}

+ (EKCalendar *)obtainCalendar
{
    if (calendar != nil)
    {
        return calendar;
    }
    
    /* Go through the calendars one by one */
    /*    NSUInteger counter = 1;
     for (EKCalendar *thisCalendar in eventStore.calendars){
     if ([thisCalendar.title isEqualToString:@"Home Improvement"])
     {
     calendar = thisCalendar;
     return calendar;
     }
     }*/
    
    NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"my_calendar_identifier"];
    
    // when identifier exists, my calendar probably already exists
    // note that user can delete my calendar. In that case I have to create it again.
    if (calendarIdentifier) {
        calendar = [eventStore calendarWithIdentifier:calendarIdentifier];
    }
    
    // calendar doesn't exist, create it and save it's identifier
    if (!calendar) {
        // http://stackoverflow.com/questions/7945537/add-a-new-calendar-to-an-ekeventstore-with-eventkit
        calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
        
        // set calendar name. This is what users will see in their Calendar app
        [calendar setTitle:@"Home Improvement"];
        
        // find appropriate source type. I'm interested only in local calendars but
        // there are also calendars in iCloud, MS Exchange, ...
        // look for EKSourceType in manual for more options
        for (EKSource *s in eventStore.sources) {
            if (s.sourceType == EKSourceTypeLocal) {
                calendar.source = s;
                break;
            }
        }
        
        // save this in NSUserDefaults data for retrieval later
        NSString *calendarIdentifier = [calendar calendarIdentifier];
        
        NSError *error = nil;
        BOOL saved = [eventStore saveCalendar:calendar commit:YES error:&error];
        if (saved) {
            // http://stackoverflow.com/questions/1731530/whats-the-easiest-way-to-persist-data-in-an-iphone-app
            // saved successfuly, store it's identifier in NSUserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:@"my_calendar_identifier"];
        } else {
            // unable to save calendar
            NSLog(@"Unable to save calendar");
            return nil;
        }
    }
    
    // this shouldn't happen
    if (!calendar) {
        return nil;
    }
    
    return calendar;
}

+ (NSString *)addEvent:(NSDate*)eventDate withTitle:(NSString*)title
{
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    
    // assign basic information to the event; location is optional
    event.calendar = [ARCCalendarUtil obtainCalendar];
    //event.location = location;
    event.title = title;
    
    // set the start date to the current date/time and the event duration to two hours
    //NSDate *startDate = eventDate;
    event.startDate = eventDate;
    event.endDate = eventDate;
    //event.endDate = [startDate dateByAddingTimeInterval:3600 * 2];
    event.allDay = true;
    
    NSError *error = nil;
    // save event to the callendar
    BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
    if (result) {
        return event.eventIdentifier;
    } else {
        NSLog(@"Error saving event: %@", error);
        // unable to save event to the calendar
        return nil;
    }
}

+ (NSString *)editEvent:(NSString*)eventIdentifier withTitle:(NSString*)theTitle withStartDate:(NSDate*)theStartDate
{
    getEventStore();
    EKEvent *event = [eventStore eventWithIdentifier:eventIdentifier];
    
    if (!event)
    {
        return nil;
    }
    if (theTitle)
    {
        event.title = theTitle;
    }
    if (theStartDate)
    {
        event.startDate = theStartDate;
        event.endDate = theStartDate;
    }
    
    NSError *error = nil;
    // save event to the calendar
    BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
    if (result) {
        return event.eventIdentifier;
    } else {
        NSLog(@"Error saving event: %@", error);
        // unable to save event to the calendar
        return nil;
    }
}


+ (BOOL) deleteEvent:(NSString*)eventIdentifier
{
    getEventStore();
    EKEvent *event = [eventStore eventWithIdentifier:eventIdentifier];
    
    if (!event)
    {
        return NO;
    }

    if (event != nil) {
        NSError* error = nil;
        BOOL eventRemoved = [eventStore removeEvent:event span:EKSpanThisEvent error:&error];
        if (!eventRemoved){
            NSLog(@"Unable to remove event");
        }
        if (error)
        {
            NSLog(@"Error removing event");
        }
        return eventRemoved;
    }
    
    return NO;
}



+ (NSDate *)eventStartDate:(NSString*)eventIdentifier
{
    getEventStore();
    EKEvent *event = [eventStore eventWithIdentifier:eventIdentifier];
    
    if (!event)
    {
        return nil;
    }
    
    return event.startDate;
}

@end
