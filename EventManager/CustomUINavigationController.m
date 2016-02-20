//
//  CustomUINavigationController.m
//  EventManager
//
//  Created by Carl Pan on 2/19/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "CustomUINavigationController.h"

@interface CustomUINavigationController ()

// Local copy of MOC to keep track of it
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation CustomUINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - YPMOCManager

- (void)receiveMOC:(NSManagedObjectContext *)incomingMOC {
    self.managedObjectContext = incomingMOC;
    
    // Pass it down to the chain to table view controller
    // So that table view controller will be the delegate of YPMOCManager
    id<YPMOCManager> child = (id<YPMOCManager>)self.viewControllers[0];
    [child receiveMOC:self.managedObjectContext];
}


@end
