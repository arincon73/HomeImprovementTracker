//
//  Projects.h
//  ARCHomeImprovementTracker
//
//  Created by Adriana Rincon on 5/15/14.
//  Copyright (c) 2014 Actions and Results consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Projects : NSManagedObject

@property (nonatomic, retain) NSNumber * budget;
@property (nonatomic, retain) NSString * eventIdentifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSDate * startDate;

@end
