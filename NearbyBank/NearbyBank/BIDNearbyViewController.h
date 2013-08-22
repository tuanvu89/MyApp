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
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *nearbyTable;

@property (weak, nonatomic) IBOutlet UISegmentedControl *switcher;

@property (strong, nonatomic) NSString *searchInfo;
@property (strong, nonatomic) NSString *referenceString; //to query detail place
@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) NSString *IDViewer;
@property (assign, nonatomic) NSInteger indexOfTableReturn;

- (IBAction)segmentValueChange:(id)sender;

@end
