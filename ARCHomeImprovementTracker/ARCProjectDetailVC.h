//
//  ARCProjectDetailVC.h
//  ARCHomeImprovementTracker
//
//  Created by Adriana Rincon on 5/21/14.
//  Copyright (c) 2014 Actions and Results consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"

@interface ARCProjectDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *ProjectNameField;
@property (weak, nonatomic) IBOutlet UIDatePicker *StartDateField;
@property (nonatomic, strong) Projects *project;

@end
