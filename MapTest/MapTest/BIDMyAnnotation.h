//
//  BIDMyAnnotation.h
//  MapTest
//
//  Created by kerofrog on 8/20/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BIDMyAnnotation : NSObject
@property (strong, nonatomic) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *) title;

@end
