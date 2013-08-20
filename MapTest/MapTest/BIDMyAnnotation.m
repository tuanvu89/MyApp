//
//  BIDMyAnnotation.m
//  MapTest
//
//  Created by kerofrog on 8/20/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDMyAnnotation.h"

@implementation BIDMyAnnotation
@synthesize title = _title;
@synthesize coordinate = _coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title
{
    if(self == [super init])
    {
        self.coordinate = coordinate;
        self.title = title;
    }
    return self;
}

@end
