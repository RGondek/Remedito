//
//  MapViewController.m
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "MapViewController.h"

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
}

#pragma mark - Métodos

- (IBAction)btnAtualiza:(id)sender {
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
    [self recarregar];
}

- (void) recarregar {
    // Mostra Network indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // Remove todas as anotações
    [_mapView removeAnnotations:[_mapView annotations]];
    
    // Cria LocalSearch
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Drugstore";
    request.region = _mapView.region;
    
    itens = [[NSMutableArray alloc] init];
    
    // Realiza a Busca
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else{
            for (MKMapItem *item in response.mapItems)
            {
                Farm *f = [[Farm alloc]initWithMapItem:item eUserLocation:_mapView.userLocation];
                [itens addObject:f];
                
                // Cria Annotation
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                annotation.subtitle = [item.placemark.addressDictionary objectForKeyedSubscript:@"Street"];
                [_mapView addAnnotation:annotation];
                
                [_mapView setNeedsDisplay];
            }
            // Ordena os resultados por distância até Usuário
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"distancia" ascending:YES];
            NSArray *sa = [NSArray arrayWithObject:sd];
            NSArray *farmSort = [itens sortedArrayUsingDescriptors:sa];
            itens = [NSMutableArray arrayWithArray:farmSort];
        }
        // Oculta Network indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [_tableView reloadData];
}

#pragma mark - Map View

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [locations lastObject]);
    CLLocationCoordinate2D loc = [[locations lastObject] coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1500, 1500);
    [_mapView setRegion:region animated:YES];
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Não foi possível encontrar sua localização.");
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    [_tableView reloadData];
}

// Pino customizado
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation) {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil){
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        }
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"orangepin.png"];
    }
    return pinView;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListaTableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"MapaCell" forIndexPath:indexPath];
    Farm *f = [itens objectAtIndex:indexPath.row];
    
    [cell.nome setText:f.nome];
    [cell.distancia setText:[NSString stringWithFormat:@"%.2f Km", f.distancia/1000]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Envia pro Apple Maps com as coordenadas para fazer a rota passo a passo
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aplicativo externo" message:@"Você será redirecionado para o aplicativo Mapas" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Seguir", nil];
    [alerta show];
    [alerta setTag:indexPath.row];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Redireciona ao Apple Maps
    if(buttonIndex == 1){
        Farm *f = [itens objectAtIndex:alertView.tag];
        NSString *urlRota = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=Current+Location&daddr=%f,%f", f.coordenada.latitude,f.coordenada.longitude];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlRota]];
    }
}


@end
