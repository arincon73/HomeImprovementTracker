//
//  ARCProjectListTableViewController.h
//  ARCHomeImprovementTracker
//
//  Created by Adriana Rincon on 5/14/14.
//  Copyright (c) 2014 Actions and Results consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"

@interface ARCProjectListTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *projectArray;
-(void)addProject:(Projects *)newProject;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
