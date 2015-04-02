//
//  MapViewController.m
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "MapViewController.h"
#import "ListaTableViewCell.h"
#import "Farm.h"
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

- (void) recarregar {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_mapView removeAnnotations:[_mapView annotations]];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Drugstore";
    request.region = _mapView.region;
    
    itens = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else{
            for (MKMapItem *item in response.mapItems)
            {
                Farm *f = [[Farm alloc]initWithMapItem:item eUserLocation:_mapView.userLocation];
                [itens addObject:f];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                annotation.subtitle = [item.placemark.addressDictionary objectForKeyedSubscript:@"Street"];
                [_mapView addAnnotation:annotation];
                [_mapView setNeedsDisplay];
            }
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [_tableView reloadData];
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    [_tableView reloadData];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation) {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
//        UIButton *buttonRota = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        UIImage *img = [UIImage imageNamed:@"carro.png"];
//        [buttonRota setImage:img forState:UIControlStateNormal];
//        pinView.leftCalloutAccessoryView = buttonRota;
//        UIButton *info = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        img = [UIImage imageNamed:@"rightarrow"];
//        [info setImage:img forState:UIControlStateNormal];
//        pinView.rightCalloutAccessoryView = info;
        pinView.canShowCallout = YES;
//        //É adicionada uma imagem para sobrescrever a imagem padrão do pino. Caso existam múltiplas annotations, elas serão vermelhas. Caso exista apenas uma, ela será amarela.
        pinView.image = [UIImage imageNamed:@"orangepin.png"];
//        if (_mapView.annotations.count == 2) {
//            pinView.image = [UIImage imageNamed:@"greenpin.png"];
//        }
        
    }
    return pinView;
}

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
    Farm *f = [itens objectAtIndex:indexPath.row];
    
    [cell.nome setText:f.nome];
    [cell.distancia setText:[NSString stringWithFormat:@"%.2f Km", f.distancia/1000]];
    
    return cell;
}

- (IBAction)btnAtualiza:(id)sender {
    [self recarregar];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Farm *f = [itens objectAtIndex:indexPath.row];
    NSString *urlRota = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=Current+Location&daddr=%f,%f", f.coordenada.latitude,f.coordenada.longitude];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlRota]];
}
@end
