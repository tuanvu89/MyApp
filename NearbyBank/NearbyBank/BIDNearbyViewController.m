//
//  BIDNearbyViewController.m
//  NearbyBank
//
//  Created by kerofrog on 8/19/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDNearbyViewController.h"
#import "BIDDetailViewController.h"
#import "NSString+DecodePolyline.h"
#import "BIDMapPoint.h"

#define METERS_PER_MILE 1609.344
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kGOOGLE_API_KEY @"AIzaSyDpqmJIb0JcL5unRlibKPC0lG_Kb39QLJo"


@interface BIDNearbyViewController ()


@end


@implementation BIDNearbyViewController

@synthesize nearbyTable;
@synthesize searchString;
@synthesize mapView;
@synthesize listData;
@synthesize indexOfTableReturn;
@synthesize referenceString;
@synthesize IDButtonReturn;
@synthesize IDViewerReturn;
@synthesize switcher;
@synthesize arrayPoint;
@synthesize destinationReturn;
@synthesize routeLine;
@synthesize routeView;


//static NSString* addressFormat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //addressFormat = @"vicinity";
    self.mapView.delegate = self;
    // Ensure that you can view your own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    
    if ([self.IDViewerReturn isEqualToString:@"BIDDetailViewController"]) {
        nearbyTable.hidden = YES;
        self.mapView.hidden = NO;
        [self.switcher setSelectedSegmentIndex:1];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.listData= nil;
    self.switcher = nil;
    self.mapView = nil;
    self.nearbyTable = nil;
    self.searchString = nil;
    self.routeLine = nil;
    self.routeView = nil;
    self.referenceString = nil;
    self.IDButtonReturn = nil;
    self.IDViewerReturn = nil;
}

#pragma mark Get google place information

-(void) queryGooglePlaces: (NSString *) googleType {
    
    NSString *url = @"";
    
    //indentify IDViewer return to confirm next action
    if ([self.IDViewerReturn isEqualToString:@"BIDDetailViewController"])
    {
        if ([self.IDButtonReturn isEqualToString:@"ViewOnMap"]) {
            NSArray *placeToPin = [NSArray arrayWithObject:[listData objectAtIndex:self.indexOfTableReturn]];
            [self plotPositions:placeToPin];
        }
        
        if ([self.IDButtonReturn isEqualToString:@"GetDirection"]) {
            
            [self queryArrayPointDirection];
        }
    }
    else
    {
        if ([self.IDViewerReturn isEqualToString: @"BIDSuburbViewController"])
        {
            url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", self.searchString, currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
        }
        else if(self.IDViewerReturn == nil)
        {
            url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
        }
        
        NSLog(@"\n URL ::::::::::::::::::::::::::::::::\n %@", url);
        
        NSURL *googleRequestURL=[NSURL URLWithString:url];
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            [self performSelectorOnMainThread:@selector(fetchedDataGooglePlace:) withObject:data waitUntilDone:YES];
        });
    }
}


- (void)fetchedDataGooglePlace:(NSData *)responseData {
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

#pragma mark Get google direction information

-(void) queryArrayPointDirection{
    
    CLLocationCoordinate2D userlocation= self.mapView.userLocation.coordinate;
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false",userlocation.latitude,userlocation.longitude,destinationReturn.latitude, destinationReturn.longitude];
    
    NSLog(@"\n URL ::::::::::::::::::::::::::::::::\n %@", url);
    
    NSURL *RequestURL=[NSURL URLWithString:url];
    
    dispatch_async(kBgQueue, ^{
        NSData* data1 = [NSData dataWithContentsOfURL: RequestURL];
        [self performSelectorOnMainThread:@selector(fetchedDataDirection:) withObject:data1 waitUntilDone:YES];
    });
}

- (void)fetchedDataDirection:(NSData *)responseData {
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *routes =  [json objectForKey:@"routes"];// routes array from JSON response
    
    NSDictionary *route = [routes objectAtIndex:0];
    
    //grab string of overview route
    NSDictionary *overViewPolyline = [route objectForKey:@"overview_polyline"];
    NSString *codeOverViewPoint = [overViewPolyline objectForKey:@"points"];

    //decode string of array point from google polyline encode
    self.arrayPoint = [codeOverViewPoint decodePolyLine];
    
    //pin destination
    [self plotPositions:[[NSArray alloc] initWithObjects:[self.listData objectAtIndex:indexOfTableReturn], nil]];
    
    //convert array of location to array of cllocationCooordinate2D
    CLLocationCoordinate2D coordinateArray[self.arrayPoint.count];
    for(int idx = 0; idx < self.arrayPoint.count; idx++)
    {
        CLLocation *loc = [self.arrayPoint objectAtIndex:idx];
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([loc coordinate].latitude, [loc coordinate].longitude);
        coordinateArray[idx] = coordinate;
    }
    
    //show direction
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:arrayPoint.count];
    if(self.routeLine != nil){
       [self.mapView addOverlay:self.routeLine];
    }
}

#pragma segment toogle

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

#pragma mark Table method

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
        NSString *address = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"vicinity"];
        if(address == nil)
            address = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"formatted_address"];
        addressLabel.text = address;
    }
    
    return cell;
}

#pragma mark MapView Delegate Methods


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if(annotationView.annotation == self.mapView.userLocation) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            span.latitudeDelta=0.05;
            span.longitudeDelta=0.05;
            
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
    MKMapPoint southMapPoint = MKMapPointMake(MKMapRectGetMidX(mRect), MKMapRectGetMinY(mRect));
    MKMapPoint northMapPoint = MKMapPointMake(MKMapRectGetMidX(mRect), MKMapRectGetMaxY(mRect));
    
    //Set your current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(southMapPoint, northMapPoint)/2;
    
    //Set your current center point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
    
    //load when radius from center not exceed 40 km
    if (currenDist < 40000) {
        
        [self queryGooglePlaces:@"bank"];
    }
    
    
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now.
		if(nil == self.routeView)
		{
			self.routeView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
			self.routeView.fillColor = [UIColor redColor];
			self.routeView.strokeColor = [UIColor redColor];
			self.routeView.lineWidth = 3;
		}
		
		overlayView = self.routeView;
		
	}
	
	return overlayView;
	
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
        NSString *address=[place objectForKey:@"vicinity"];
        if(address == nil)
            address = [place objectForKey:@"formatted_address"];
        
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        // 5 - Create a new annotation.
        BIDMapPoint *placeObject = [[BIDMapPoint alloc] initWithName:name address:address coordinate:placeCoord];
        
        [self.mapView addAnnotation:(id)placeObject];
    }
}

#pragma Navigation


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BIDDetailViewController *controller = segue.destinationViewController;
    //chuyen tiep de luu lai vi tri va du lieu trong table ma khong phai load lai table khi quay tro lai nearbyview
    NSIndexPath *indexPath = [nearbyTable indexPathForCell:sender];
    controller.indexReturn = [indexPath row];
    controller.listDataReturn = self.listData;
    controller.refecenceString = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"reference"];
    
}

@end
