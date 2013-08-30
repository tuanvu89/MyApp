//
//  BIDNearbyViewController.h
//  NearbyBank
//
//  Created by kerofrog on 8/19/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BIDNearbyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationCoordinate2D currentCentre;
    int currenDist;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *nearbyTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switcher;

//string return from search viewer, used for search URL
@property (strong, nonatomic) NSString *searchString;

//string passed to detail viewer to query detail place
@property (strong, nonatomic) NSString *referenceString;

//data for nearby table
@property (strong, nonatomic) NSArray *listData;


@property ( nonatomic) CLLocationCoordinate2D destinationReturn;

//ID return from another viewer to nearby viewer
@property (strong, nonatomic) NSString *IDViewerReturn ;
@property (strong , nonatomic) NSString *IDButtonReturn;
@property (assign, nonatomic) NSInteger indexOfTableReturn;

//array of point in route line
@property (strong, nonatomic) NSMutableArray *arrayPoint; 

//route line on map
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView *routeView;

- (IBAction)segmentValueChange:(id)sender;

@end
