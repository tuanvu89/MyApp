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
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *nearbyTable;
@property (strong, nonatomic) NSString *searchInfo;
@property (strong, nonatomic) NSString *referenceString; //to query detail place
@property (strong, nonatomic) NSArray *listData;
- (IBAction)segmentValueChange:(id)sender;

@end
