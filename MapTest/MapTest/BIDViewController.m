//
//  BIDViewController.m
//  MapTest
//
//  Created by kerofrog on 8/20/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDViewController.h"
#import "BIDMyAnnotation.h"

@interface BIDViewController ()

@end

@implementation BIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //4
    self.mapView.delegate = self;
    //5
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 40.740848;
    zoomLocation.longitude= -73.991145;
    
    CLLocationCoordinate2D curLocation = [[[self.mapView userLocation] location] coordinate];
    BIDMyAnnotation *anno = [[BIDMyAnnotation alloc] initWithCoordinate:zoomLocation title:@"we'r here !"];
    [self.mapView addAnnotation:anno];
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];

}

@end
