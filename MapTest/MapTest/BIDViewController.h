//
//  BIDViewController.h
//  MapTest
//
//  Created by kerofrog on 8/20/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.334

@interface BIDViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
        CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
