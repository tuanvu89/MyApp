//
//  BIDMapPoint.h
//  NearbyBank
//
//  Created by kerofrog on 8/22/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BIDMapPoint : MKAnnotationView

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
@end
