//
//  MapViewController.h
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property NSMutableArray* foundItems;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, retain) CLLocationManager *locationManager;
- (IBAction)btnAtualiza:(id)sender;


@end
