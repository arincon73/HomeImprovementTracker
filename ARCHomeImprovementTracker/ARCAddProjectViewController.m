//
//  ARCAddProjectViewController.m
//  ARCHomeImprovementTracker
//
//  Created by Adriana Rincon on 5/15/14.
//  Copyright (c) 2014 Actions and Results consulting. All rights reserved.
//

#import "ARCAddProjectViewController.h"
#import "Projects.h"
#import "ARCAppDelegate.h"
#import "ARCCalendarUtil.h"

@interface ARCAddProjectViewController ()

@end

@implementation ARCAddProjectViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize projectTextField;
@synthesize projectStartDateField;
@synthesize projectListTableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ARCAppDelegate *appDelegate = (ARCAppDelegate *) [[UIApplication sharedApplication]delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    // Do any additional setup after loading the view from its nib.
    self.projectStartDateField.datePickerMode = UIDatePickerModeDate;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addProjectButtonPressed:(id)sender {
    
    // Only respond to add button click
    if (sender != self.addProjectButton) return;
    
    NSString *newProjectName = [projectTextField text];
    
    // Do not allow project with empty description
    if (newProjectName.length <= 0) return;
    
    NSDate *newProjectStartDate = [projectStartDateField date];
    
    
    Projects *newProject = [NSEntityDescription insertNewObjectForEntityForName:@"Projects" inManagedObjectContext:_managedObjectContext];
    // If unable to create event/calendar save anyways but keep event identifier = null
    [newProject setEventIdentifier:nil];
    newProject.name = newProjectName;
    newProject.startDate = newProjectStartDate;
    
    // Add item to calendar
    [ARCCalendarUtil requestAccess:^(BOOL granted, NSError *error) {
        if (granted) {
            NSString* result = [ARCCalendarUtil addEvent:newProjectStartDate withTitle:newProjectName];
            //BOOL result = [ARCCalendarUtil addEvent:nil withTitle:nil];
            if (result) {
                // added to calendar
                newProject.eventIdentifier = result;
            } else {
                // unable to create event/calendar set event identifier to nil, log the error
                newProject.eventIdentifier = nil;
                NSLog(@"Unable to create event in calendar");
            }
        } else {
            // you don't have permissions to access calendars
            NSLog(@"No permission to access calendars");
        }
    }];
    
    // Save project
    NSError *errorSaving = nil;
    if (![_managedObjectContext save:&errorSaving])
    {
        //handle the error
        NSLog(@"Error saving in addProjectButtonPressed");
    }
    
    // Add project to project list
    [projectListTableViewController addProject:newProject];
    
    // Close view
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
@end
