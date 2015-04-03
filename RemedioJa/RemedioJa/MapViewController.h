//
//  MapViewController.h
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

#import "ListaTableViewCell.h"
#import "Farm.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property NSMutableArray* foundItems;

- (IBAction)btnAtualiza:(id)sender;

@end
