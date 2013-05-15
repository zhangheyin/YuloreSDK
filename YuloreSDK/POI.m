//
//  POI.m
//  ddddd
//
//  Created by Zhang Heyin on 13-4-7.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import "POI.h"

@interface POI()
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSString *coordinatesubtitle;
@property (nonatomic,retain) NSString *coordinatetitle;

@end
@implementation POI

@synthesize coordinate  = _coordinate;
@synthesize subtitle = _subtitle;
@synthesize title = _title;
- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate
                     title:(NSString*)title
                  subtitle:(NSString*)subtitle {
  
	self = [super init];
  
	if (self != nil) {
    
		self.coordinate = coordinate;
    self.coordinatetitle = title;
    self.coordinatesubtitle = subtitle;
    
    
	}
  
	return self;
  
}

@end
