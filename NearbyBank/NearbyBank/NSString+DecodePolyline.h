//
//  NSString+DecodePolyline.h
//  NearbyBank
//
//  Created by kerofrog on 8/29/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSString (DecodePolyline)
-(NSMutableArray *)decodePolyLine ;
-(NSMutableArray *)decodePolyLineLevel;
@end
