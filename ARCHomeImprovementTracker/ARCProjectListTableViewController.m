//
//  ARCProjectListTableViewController.m
//  ARCHomeImprovementTracker
//
//  Created by Adriana Rincon on 5/14/14.
//  Copyright (c) 2014 Actions and Results consulting. All rights reserved.
//

#import "ARCProjectListTableViewController.h"
#import "ARCAddProjectViewController.h"
#import "ARCAppDelegate.h"
#import "ARCProjectDetailVC.h"

@interface ARCProjectListTableViewController ()

@end

@implementation ARCProjectListTableViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize projectArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ARCAppDelegate *appDelegate = (ARCAppDelegate *) [[UIApplication sharedApplication]delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    // Grab the data
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *myProjects = [NSEntityDescription entityForName:@"Projects" inManagedObjectContext:_managedObjectContext];
    [request setEntity:myProjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"startDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    
    if (mutableFetchResults == nil){
        //handle error
    }
    [self setProjectArray:mutableFetchResults];
    NSLog(@"there are %u projects in the array",[projectArray count]);
    
    
//    projectArray = [[NSMutableArray alloc] initWithObjects:@"Exterior Paint", @"Deck Sealing", @"Fumigate Carpenter Bees", @"Repair Shower", nil];
//    projectArray = [[NSMutableArray alloc] initWithObjects:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [projectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell" forIndexPath:indexPath];
    
    // Configure the cell...
    int rowNumber = [indexPath row];
    Projects *project = [projectArray objectAtIndex:rowNumber];

    [[cell textLabel] setText:project.name];
    NSLog(@"tableView is asking for cell %d", [indexPath row]);
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Projects *tappedItem = [self.projectArray objectAtIndex:indexPath.row];
        [_managedObjectContext deleteObject:tappedItem];
        NSError *errorSaving = nil;
        if (![_managedObjectContext save:&errorSaving])
        {
            //handle the error
            NSLog(@"Error saving while deleting item");
        }
        
        [projectArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        NSLog(@"Deleting item");
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"AddProjectSegue"])
    {
        ARCAddProjectViewController *addProjectViewController = [segue destinationViewController];
        [addProjectViewController setProjectListTableViewController:self];
    }
    else if ([[segue identifier] isEqualToString:@"ProjectDetailSegue"])
    {
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        Projects *selectedProject = [projectArray objectAtIndex:[selectedRow row]];
        ARCProjectDetailVC *projectDetailVC = [segue destinationViewController];
        projectDetailVC.project = selectedProject;
    }
};


-(void)addProject:(Projects *)newProject{
    [projectArray addObject:newProject];
    [[self tableView] reloadData];
    NSLog(@"adding project");
}



@end
