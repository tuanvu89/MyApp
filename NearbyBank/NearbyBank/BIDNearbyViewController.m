//
//  BIDNearbyViewController.m
//  NearbyBank
//
//  Created by kerofrog on 8/19/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDNearbyViewController.h"
#import "BIDDetailViewController.h"
#import "BIDMapPoint.h"

#define METERS_PER_MILE 1609.344
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kGOOGLE_API_KEY @"AIzaSyDpqmJIb0JcL5unRlibKPC0lG_Kb39QLJo"


@interface BIDNearbyViewController ()


@end

@implementation BIDNearbyViewController
@synthesize nearbyTable;
@synthesize mapView;
@synthesize listData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    // Ensure that you can view your own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some parameters for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.listData= nil;
}

#pragma JSON

-(void) queryGooglePlaces: (NSString *) googleType {

    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
    
    NSLog(@"%@", url);

    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}


- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //get data to listdata
    listData = places;
    
    //pin places
    [self plotPositions:places];
    //reload table content
    [self.nearbyTable reloadData];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
    
}



#pragma segment toogle ----------------
- (IBAction)segmentValueChange:(id)sender {
    if([sender selectedSegmentIndex] == 0)
    {
        nearbyTable.hidden = NO;
        self.mapView.hidden = YES;
        
    }else
    {
        nearbyTable.hidden = YES;
        self.mapView.hidden = NO;
    }
}

#pragma table ------------------
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listData count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankResultCell"];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *addressLabel = (UILabel *)[cell viewWithTag:2];
      
    if(listData != nil)
    {
        nameLabel.text = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"name"];
        addressLabel.text = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"vicinity"];
    }
    
    return cell;
}

#pragma Map View


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -MapView Delegate Methods


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if(annotationView.annotation == self.mapView.userLocation) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            
            CLLocationCoordinate2D location= self.mapView.userLocation.coordinate;
            
            region.span=span;
            region.center=location;
            
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
        }
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set your current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set your current center point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
    
    NSLog(@"la %f", currentCentre.latitude);
    NSLog(@"lo %f", currentCentre.longitude);
    NSLog(@"%d",currenDist);
    
    //load json
    [self queryGooglePlaces:@"bank"];

}

-(void)plotPositions:(NSArray *)data {
    // 1 - Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[BIDMapPoint class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    // 2 - Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        // Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        // 4 - Get your name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        // 5 - Create a new annotation.
        BIDMapPoint *placeObject = [[BIDMapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [self.mapView addAnnotation:placeObject];
    }
}

#pragma segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BIDDetailViewController *controller = segue.destinationViewController;
    NSIndexPath *indexPath = [nearbyTable indexPathForCell:sender];
    
    controller.name = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"name"];
    controller.address = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"vicinity"];
    controller.refecenceString = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"reference"];
    
}

@end
