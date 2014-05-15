//
//  ARCAddProjectViewController.h
//  ARCHomeImprovementTracker
//
//  Created by Adriana Rincon on 5/15/14.
//  Copyright (c) 2014 Actions and Results consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCProjectListTableViewController.h"

@interface ARCAddProjectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *projectTextField;
- (IBAction)addProjectButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *projectStartDateField;
@property (nonatomic, weak) ARCProjectListTableViewController *projectListTableViewController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end
