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
//#import "Farm.h"

//@protocol MapViewDelegate <NSObject>
//
//-(void)tracarRota:(Farm *)f;
//
//@end

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property Farm *farm;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property NSMutableArray* foundItems;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, retain) CLLocationManager *locationManager;


@end
