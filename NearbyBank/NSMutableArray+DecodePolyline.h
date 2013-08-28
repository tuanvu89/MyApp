//
//  NSMutableArray+DecodePolyline.h
//  NearbyBank
//
//  Created by kerofrog on 8/28/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSMutableArray (DecodePolyline)
-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr ;
-(NSMutableArray *)decodePolyLineLevel:(NSString *)encodedStr ;
@end
