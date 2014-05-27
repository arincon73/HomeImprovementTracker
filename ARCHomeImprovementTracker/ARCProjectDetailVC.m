//
//  ARCProjectDetailVC.m
//  ARCHomeImprovementTracker
//
//  Created by Adriana Rincon on 5/21/14.
//  Copyright (c) 2014 Actions and Results consulting. All rights reserved.
//

#import "ARCProjectDetailVC.h"

@interface ARCProjectDetailVC ()

@end

@implementation ARCProjectDetailVC
@synthesize ProjectNameField;
@synthesize StartDateField;
@synthesize project;

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
    StartDateField.datePickerMode = UIDatePickerModeDate;
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ProjectNameField setText:project.name];
    [StartDateField setDate:project.startDate];
}

@end
