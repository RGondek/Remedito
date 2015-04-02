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
    NSMutableArray *itens;
}

@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mapView setDelegate:self];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDelegate:self];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    [_mapView.userLocation setTitle:@"Você"];
    [_mapView userTrackingMode];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
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
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Não foi possível encontrar sua localização.");
}
//
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    self.mapView.frame = self.view.bounds;
//}

- (void) recarregar {
    [_mapView removeAnnotations:[_mapView annotations]];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Drugstore";
    request.region = _mapView.region;
    
    itens = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                [itens addObject:item];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return itens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListaTableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"MapaCell" forIndexPath:indexPath];
    MKMapItem *it = [itens objectAtIndex:indexPath.row];
    CLLocation *ini = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.location.coordinate.latitude longitude:_mapView.userLocation.location.coordinate.longitude];
    CLLocation *fim = [[CLLocation alloc] initWithLatitude:it.placemark.location.coordinate.latitude longitude:it.placemark.location.coordinate.longitude];
    CLLocationDistance dist = [fim distanceFromLocation:ini];
    
    [cell.nome setText:it.name];
    [cell.distancia setText:[NSString stringWithFormat:@"%.2f Km", dist/1000]];
//    cell.nome.text = farm.nome;
//    UIButton *rota = [[UIButton alloc] init];
//    rota.frame = CGRectMake(20, 12, 30, 25);
//    rota.tag = indexPath.row;
//    [rota setImage:[UIImage imageNamed:@"carro.png"] forState:UIControlStateNormal];
//    [rota addTarget:self action:@selector(tracarRota:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.contentView addSubview:rota];
    return cell;
}

- (IBAction)btnAtualiza:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self recarregar];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



@end
