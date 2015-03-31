//
//  MapViewController.m
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "MapViewController.h"
#import "ListaTableViewCell.h"
//#import "Annotation.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    NSArray *arai;
}

@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_mapView setDelegate:self];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDelegate:self];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [_mapView.userLocation setTitle:@"Você"];
    [_mapView userTrackingMode];
    [locationManager startUpdatingLocation];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map View

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [locations lastObject]);
    CLLocationCoordinate2D loc = [[locations lastObject] coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    [_mapView setRegion:region animated:YES];
    [locationManager stopUpdatingLocation];
    [self recarregar:region];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Não foi possível encontrar sua localização.");
}
//
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    self.mapView.frame = self.view.bounds;
//}

- (void) recarregar:(MKCoordinateRegion)reg {
    [_mapView removeAnnotations:[_mapView annotations]];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Farmacia";
    request.region = reg;
    
    _matchingItems = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                [_matchingItems addObject:item];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                annotation.subtitle = [item.placemark.addressDictionary objectForKeyedSubscript:@"Street"];
                NSLog(@"%@" , item.name);
                [_mapView addAnnotation:annotation];
                [_mapView setNeedsDisplay];
            }
    }];
    [_tableView reloadData];
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    [_tableView reloadData];
}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    MKAnnotationView *pinView = nil;
//    if(annotation != mapView.userLocation) {
//        static NSString *defaultPinID = @"com.invasivecode.pin";
//        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//        if (pinView == nil)
//            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
//        UIButton *buttonRota = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        UIImage *img = [UIImage imageNamed:@"carro.png"];
//        [buttonRota setImage:img forState:UIControlStateNormal];
//        pinView.leftCalloutAccessoryView = buttonRota;
//        UIButton *info = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        img = [UIImage imageNamed:@"rightarrow"];
//        [info setImage:img forState:UIControlStateNormal];
//        pinView.rightCalloutAccessoryView = info;
//        pinView.canShowCallout = YES;
//        //É adicionada uma imagem para sobrescrever a imagem padrão do pino. Caso existam múltiplas annotations, elas serão vermelhas. Caso exista apenas uma, ela será amarela.
//        pinView.image = [UIImage imageNamed:@"bluepin.png"];
//        if (_mapView.annotations.count == 2) {
//            pinView.image = [UIImage imageNamed:@"greenpin.png"];
//        }
//        
//    }
//    return pinView;
//}

#pragma mark - Table View

#pragma mark ARRUMA ISSO AQUI BROTHER \/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListaTableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"MapaCell" forIndexPath:indexPath];
    MKPointAnnotation *ann = [arai objectAtIndex:indexPath.row];
    [cell.nome setText:ann.title];
//    cell.nome.text = farm.nome;
//    UIButton *rota = [[UIButton alloc] init];
//    rota.frame = CGRectMake(20, 12, 30, 25);
//    rota.tag = indexPath.row;
//    [rota setImage:[UIImage imageNamed:@"carro.png"] forState:UIControlStateNormal];
//    [rota addTarget:self action:@selector(tracarRota:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.contentView addSubview:rota];
    return cell;
}

- (IBAction)voltar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
