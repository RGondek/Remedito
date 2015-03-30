//
//  MapViewController.m
//  RemedioJa
//
//  Created by Victor Lisboa on 28/03/15.
//  Copyright (c) 2015 Remedito. All rights reserved.
//

#import "MapViewController.h"
#import "ListaTableViewCell.h"
#import "Annotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
    [locationManager startUpdatingLocation];
    [_mapView.userLocation setTitle:@"Você"];
    _matchingItems = [[NSMutableArray alloc] initWithCapacity:10];
    _foundItems = [[NSMutableArray alloc] init];
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
    _mapView.showsUserLocation=YES;
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Não foi possível encontrar sua localização.");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.view.bounds;
}

- (IBAction)recarregar:(id)sender {
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
    [_matchingItems removeAllObjects];
    [_mapView removeAnnotations:_mapView.annotations];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Drug";
    request.region = MKCoordinateRegionMakeWithDistance(_mapView.centerCoordinate, 1000, 1000);
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"Nenhuma farmácia encontrada.");
        else {
            if (_foundItems.count == 0) {
                for (MKMapItem *item in response.mapItems) {
                    Farm *farm = [[Farm alloc] initWithNome:item.name andCoordenadas:item.placemark.coordinate andEndereco:item.placemark.thoroughfare andCep:item.placemark.postalCode];
                    [_matchingItems addObject:farm];
                }
                //Todos os postos de gasolina encontrados são adicionados ao vetor foundItems.
                [_foundItems addObjectsFromArray:_matchingItems];
            } else {
                NSUInteger count = _foundItems.count;
                //Todos os itens encontrados são acessados.
                for (MKMapItem *item in response.mapItems) {
                    BOOL alreadyFound = NO;
                    //É verificado se o posto de gasolina encontrado já havia sido encontrado previamente. Se sim, ele manterá os valores originais. Se não, ele irá gerar valores genéricos para os preços.
                    //Obs.: Foi necessário um for simples porque o vetor foundItems pode aumentar de tamanho durante a execução do for, impossibilitando o for avançado.
                    for (int i = 0; i<count; i++) {
                        Farm *f = _foundItems[i];
                        if (f.coordenadas.latitude == item.placemark.coordinate.latitude &&
                            f.coordenadas.longitude == item.placemark.coordinate.longitude) {
                            [_matchingItems addObject:f];
                            alreadyFound = YES;
                        }
                    }
                    if (!alreadyFound) {
                        Farm *farm = [[Farm alloc] initWithNome:item.name andCoordenadas:item.placemark.coordinate andEndereco:item.placemark.thoroughfare andCep:item.placemark.postalCode];
                        [_matchingItems addObject:farm];
                        [_foundItems addObject:farm];
                    }
                }
            }
            for (Farm *f in _matchingItems) {
                //É criada uma annotation para adicionar os pinos no mapa com base nos parâmetros dados.
                Annotation *annotation = [[Annotation alloc] init];
                annotation.coordinate = f.coordenadas;
                annotation.titulo = f.nome;
                [_mapView addAnnotation:annotation];
            }
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation) {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        UIButton *buttonRota = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        UIImage *img = [UIImage imageNamed:@"carro.png"];
        [buttonRota setImage:img forState:UIControlStateNormal];
        pinView.leftCalloutAccessoryView = buttonRota;
        UIButton *info = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        img = [UIImage imageNamed:@"rightarrow"];
        [info setImage:img forState:UIControlStateNormal];
        pinView.rightCalloutAccessoryView = info;
        pinView.canShowCallout = YES;
        //É adicionada uma imagem para sobrescrever a imagem padrão do pino. Caso existam múltiplas annotations, elas serão vermelhas. Caso exista apenas uma, ela será amarela.
        pinView.image = [UIImage imageNamed:@"bluepin.png"];
        if (_mapView.annotations.count == 2) {
            pinView.image = [UIImage imageNamed:@"greenpin.png"];
        }
        
    }
    return pinView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {    Annotation *annotation = view.annotation;
    Farm *f;
    //É encontrado o posto de gasolina selecionado dentre os postos de gasolina guardados no vetor.
    for (f in _matchingItems) {
        if (f.coordenadas.latitude == annotation.coordinate.latitude &&
            f.coordenadas.longitude == annotation.coordinate.longitude)
            break;
    }
    if (control == view.leftCalloutAccessoryView)
        [self tracarRota:f];
    else {
        _farm = f;
        [self performSegueWithIdentifier:@"descricaoViewSegue" sender:self];
    }
}
- (void)tracarRota:(Farm *)f {
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:f.coordenadas addressDictionary:(NSDictionary *)@{(NSString *)kABPersonAddressStreetKey:f.endereco, (NSString *)kABPersonAddressZIPKey:f.cep}];
    //No atributo destination é guardado o destino da rota, no caso, o posto de gasolina recebido.
    request.destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    //É criado um MKDirections, que é responsável por realizar a busca e o preenchimento de possíveis rotas entre a origem e o destino atribuídas na request.
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    //Método que calcula possíveis rotas.
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Falha em encontrar uma rota.");
        } else {
            [_mapView removeOverlays:[_mapView overlays]];
            //A sequência de rotas encontradas é adicionada no mapa.
            for (MKRoute *route in response.routes) {
                [_mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
                [_mapView setVisibleMapRect:route.polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0) animated:YES];
            }
            [_mapView removeAnnotations:[_mapView annotations]];
            Annotation *annotation = [[Annotation alloc] init];
            annotation.coordinate = f.coordenadas;
            annotation.titulo = f.nome;
            [_mapView addAnnotation:annotation];
            [_mapView selectAnnotation:annotation animated:YES];
        }
    }];
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

#pragma mark - Table View

#pragma mark ARRUMA ISSO AQUI BROTHER \/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

// Comentar pra não esquecer

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListaTableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"ListaTableCell" forIndexPath:indexPath];
//    Farm *farm = _matchingItems[[indexPath row]];
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
