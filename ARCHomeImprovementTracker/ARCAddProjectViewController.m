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
    
    if (sender != self.addProjectButton) return;
    NSString *newProjectName = [projectTextField text];
    NSDate *newProjectStartDate = [projectStartDateField date];
    
    
    Projects *newProject = [NSEntityDescription insertNewObjectForEntityForName:@"Projects" inManagedObjectContext:_managedObjectContext];
    // If unable to create event/calendar save anyways but keep event identifier = null
    [newProject setEventIdentifier:nil];
    newProject.name = newProjectName;
    newProject.startDate = newProjectStartDate;
    NSError *errorSaving = nil;
    if (![_managedObjectContext save:&errorSaving])
    {
        //handle the error
        NSLog(@"Error saving in addProjectButtonPressed");
    }

    
    [projectListTableViewController addProject:newProject];
    
    
    // Add item to calendar
    [ARCCalendarUtil requestAccess:^(BOOL granted, NSError *error) {
        if (granted) {
            BOOL result = [ARCCalendarUtil addEvent:newProjectStartDate withTitle:newProjectName];
            //BOOL result = [ARCCalendarUtil addEvent:nil withTitle:nil];
            if (result) {
                // added to calendar
            } else {
                // unable to create event/calendar
            }
        } else {
            // you don't have permissions to access calendars
            NSLog(@"No permission to access calendars");
        }
    }];
    
    
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
@end
