//
//  CustomUITableViewController.m
//  EventManager
//
//  Created by Carl Pan on 2/19/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "CustomUITableViewController.h"
#import "CustomUITableViewCell.h"
#import "EventEntity.h"

@interface CustomUITableViewController () <NSFetchedResultsControllerDelegate>

// Local copy of MOC to keep track of it
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// NSFetchedResultsController
@property (strong, nonatomic) NSFetchedResultsController *resultsController;

@end

@implementation CustomUITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeFetchedResultsControllerDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get EventEntity at the row
    EventEntity *item = self.resultsController.sections[indexPath.section].objects[indexPath.row];
    
    // Get cell
    CustomUITableViewCell *cell = (CustomUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setInternalFields:item];
    
    return cell;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)initializeFetchedResultsControllerDelegate {
    // Initialize NSFetchRequest object
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Entity description
    fetchRequest.entity = [NSEntityDescription entityForName:@"EventEntity" inManagedObjectContext:self.managedObjectContext];
    // Predicate
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    // Sorting based on date
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"eventDate" ascending:YES]];
    
    // Create results controller
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Set delegate to self
    self.resultsController.delegate = self;
    
    // Perform fetch
    NSError *err;
    BOOL fetchSucceeded = [self.resultsController performFetch:&err];
    if (!fetchSucceeded) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Couldn't fetch" userInfo:nil];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        case NSFetchedResultsChangeUpdate: {
            CustomUITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            EventEntity *item = [controller objectAtIndexPath:indexPath];
            [cell setInternalFields:item];
            break;
        }
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Child is the destination view controller
    // sender is the current table view controller
    id<YPMOCManager, YPEventEntityManager> child = (id<YPMOCManager, YPEventEntityManager>)[segue destinationViewController];
    [child receiveMOC:self.managedObjectContext];
    
    // We have two cases for segue: either from add bar or from table cell
    // Check the current class that is causing the segue
    EventEntity *item;
    if ([sender isMemberOfClass:[UIBarButtonItem class]]) {
        // Insert new row to entity to be passed down
        item = [NSEntityDescription insertNewObjectForEntityForName:@"EventEntity" inManagedObjectContext:self.managedObjectContext];
    } else {
        // Sender is tableview cell, it has its entity information
        CustomUITableViewCell *source = (CustomUITableViewCell *)sender;
        // Pull out the associated entity
        item = source.localEventEntity;
    }
    
    // Pass down to detail view controller
    [child receiveEventEntity:item];
}



#pragma mark - YPMOCManager

- (void)receiveMOC:(NSManagedObjectContext *)incomingMOC {
    // Table view controller will not pass MOC down to detail view controller
    // it will be down in segue
    self.managedObjectContext = incomingMOC;
}




@end
