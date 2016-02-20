//
//  DetailViewController.m
//  EventManager
//
//  Created by Carl Pan on 2/19/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "DetailViewController.h"
#import <MapKit/MapKit.h>

@interface DetailViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) EventEntity *localEventEntity;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *placeField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateField;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Location manager
@property (strong, nonatomic) CLLocationManager *locationManager;

// Annotations
@property (strong, nonatomic) MKPointAnnotation *currentAnno;
@property (strong, nonatomic) MKPointAnnotation *customAnno;

@property (nonatomic, assign) BOOL wasDeleted;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    // Set up delete state
    self.wasDeleted = NO;
    
    // Setup title field before view controller finalizes
    self.titleField.text = self.localEventEntity.eventTitle;
    
    // Setup place field
    NSString *place = self.localEventEntity.eventPlace;
    // place field not empty
    if (place != nil) {
        self.placeField.text = place;
        
        // Update map annotation
        [self initializeSearchLocationRequest:place];
    } else {
        // Add default location to show on map
        [self initializeLocationManger];

        // Add annotation
        self.currentAnno = [[MKPointAnnotation alloc] init];
        self.currentAnno.coordinate = CLLocationCoordinate2DMake(41.7886079, -87.600902);
        self.currentAnno.title = @"Current location";
        [self.mapView addAnnotations:@[self.currentAnno]];
        [self centerMap:self.currentAnno];
    }
    
    // Show date picker view
    NSDate *date = self.localEventEntity.eventDate;
    if (date != nil) {
        [self.dateField setDate:date];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    // If we trash icon is not hit
    if (self.wasDeleted == NO) {
        // Save everything in case the edit event not triggered
        NSString *title = self.titleField.text;
        NSString *place = self.placeField.text;
        NSDate *date = self.dateField.date;
    
        if ([title length] != 0 && [place length] != 0) {
            self.localEventEntity.eventTitle = title;
            self.localEventEntity.eventPlace = place;
            self.localEventEntity.eventDate = date;
            [self saveEntity];
        }
    }
}


#pragma mark - Private method

- (void)saveEntity {
    NSError *err;
    BOOL saveSuccess = [self.managedObjectContext save:&err];
    if (!saveSuccess) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Couldn't save" userInfo:@{NSUnderlyingErrorKey:err}];
    }
}

- (void)initializeLocationManger {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // Request permission from user
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)initializeSearchLocationRequest: (NSString *)query {
    // Create and initialize a search request object
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = query;
    
    // Make custom search region hint
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(41.7886079, -87.600902);
    MKCoordinateRegion searchRegion = MKCoordinateRegionMakeWithDistance(coordinate, 20000, 20000);
    request.region = searchRegion;
    
    // Create and initialize a search object
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    // Start the search and display the search result as annotation on map
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSMutableArray *placemarks = [NSMutableArray array];
        //NSLog(@"%d", (int)[response.mapItems count]);
        for (MKMapItem *item in response.mapItems) {
            [placemarks addObject:item.placemark];
        }
        
        [self.mapView removeAnnotations:[self.mapView annotations]];
        [self.mapView showAnnotations:placemarks animated:NO];
        
        // Center the map
        [self centerMap:placemarks[0]];
    }];
}

- (void)centerMap:(MKPointAnnotation *)centerPoint {
    //[self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerPoint.coordinate, 5000, 5000);
    MKCoordinateRegion adjusted = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjusted animated:YES];
}


#pragma mark - Event Trigger

- (IBAction)titleFieldEdited:(id)sender {
    // As soon as user finished editing title, update entity
    NSString *title = self.titleField.text;
    self.localEventEntity.eventTitle = title;
    
    if ([title length] != 0) {
        [self saveEntity];
    }
}

- (IBAction)placeFieldEdited:(id)sender {
    NSString *place = self.placeField.text;
    self.localEventEntity.eventPlace = place;
    
    // Update annotation on the map view
    if ([place length] != 0) {
        [self saveEntity];
        [self initializeSearchLocationRequest:place];
    }
}

- (IBAction)dateEdited:(id)sender {
    NSDate *date = self.dateField.date;
    self.localEventEntity.eventDate = date;
    
    if (date != nil) {
        [self saveEntity];
    }
}

- (IBAction)trashTapped:(id)sender {
    self.wasDeleted = YES;
    
    // Delete the entity
    [self.managedObjectContext deleteObject:self.localEventEntity];
    // save the state
    [self saveEntity];
    
    // Go back to one hierachy
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - YPMOCManager

- (void)receiveMOC:(NSManagedObjectContext *)incomingMOC {
    self.managedObjectContext = incomingMOC;
}


#pragma mark - YPEventEntityManager

- (void)receiveEventEntity:(EventEntity *)incomingEventEntity {
    self.localEventEntity = incomingEventEntity;
}


@end
