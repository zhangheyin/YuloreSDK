//
//  POI.h
//  ddddd
//
//  Created by Zhang Heyin on 13-4-7.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface POI : NSObject <MKAnnotation>
- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate
                     title:(NSString*)title
                  subtitle:(NSString*)subtitle;
@end
