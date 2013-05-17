//
//  DetailInfomationView.m
//  ddddd
//
//  Created by Zhang Heyin on 13-4-7.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//
#import "POI.h"
#import "DetailInfomationView.h"
#import <MapKit/MapKit.h>

@interface DetailInfomationView() <MKMapViewDelegate> 
@end
@implementation DetailInfomationView

- (id)initWithFrame:(CGRect)frame withShop:(NSDictionary *)shop {
  self = [super initWithFrame:frame];
  if (self) {
    
    NSString *name = ([[shop objectForKey:@"name"] isKindOfClass:[NSNull class]]) ? @"无" : [shop objectForKey:@"name"];
    NSString *address = ([[shop objectForKey:@"address"] isKindOfClass:[NSNull class]]) ? @"无" : [shop objectForKey:@"address"];
    NSArray *telnumbers = ([[shop objectForKey:@"telnumber"] isKindOfClass:[NSNull class]]) ? nil : [shop objectForKey:@"telnumber"];
    
    CLLocationCoordinate2D  coordinate;
    if ([[shop objectForKey:@"lng"] isKindOfClass:[NSNull class]] &&
        [[shop objectForKey:@"lat"] isKindOfClass:[NSNull class]]) {
      coordinate.latitude = -999;
      coordinate.longitude = -999;
    } else {
      coordinate.latitude = [[shop objectForKey:@"lat"] doubleValue];
      coordinate.longitude = [[shop objectForKey:@"lng"] doubleValue];
    }
    
    
    //--------------------------nameLable-------------------------------------//
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    [nameLable setText:name];
    [self addSubview:nameLable];
    
    //--------------------------addressLable-------------------------------------//
    UILabel *addressLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.bounds.size.width, 30)];
    [addressLable setText:address];
    [self addSubview:addressLable];
    
    //--------------------------numberOfTelnumbers-------------------------------------//
    uint numberOfTelnumbers = [telnumbers count];
    CGFloat start = 60.f;
    for (int i = 0; i < numberOfTelnumbers; i++) {
      CGFloat offset = 30.f * i + start;
      UILabel *telNumberLable = [[UILabel alloc] initWithFrame:CGRectMake(0, offset, self.bounds.size.width, 30)];
      [telNumberLable setText:[telnumbers objectAtIndex:i]];
      [self addSubview:telNumberLable];
    }
    
    
    
    //    CGSize titleBrandSizeForHeight = [self.telenumber.text sizeWithFont:self.telenumber.font];
    //    CGSize titleBrandSizeForLines = [self.telenumber.text sizeWithFont:self.telenumber.font constrainedToSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    //    self.telenumber.numberOfLines = ceil(titleBrandSizeForLines.height/titleBrandSizeForHeight.height);
    //    if (self.telenumber.numberOfLines <= 1) {
    //      self.telenumber.frame = CGRectMake(0, 60 , self.bounds.size.width, titleBrandSizeForHeight.height);
    //    }else {
    //      self.telenumber.frame = CGRectMake(0, 60 , self.bounds.size.width, self.telenumber.numberOfLines*titleBrandSizeForHeight.height);
    //    }
    
    
    if (coordinate.latitude != -999 && coordinate.longitude != -999 && (30.f * numberOfTelnumbers + 60.f < self.bounds.size.height)) {
    
      
      MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 30.f * numberOfTelnumbers + 60.f, self.bounds.size.width, self.bounds.size.height - 30.f * numberOfTelnumbers - 60.f - 40.f)];
      mapView.mapType = MKMapTypeStandard;
      mapView.zoomEnabled=YES;
      //self.mapView.showsUserLocation=YES;
      mapView.delegate=self;
      
      MKCoordinateSpan  span = MKCoordinateSpanMake(0.1,0.1);
      MKCoordinateRegion  region = MKCoordinateRegionMake(coordinate, span);
      
      [mapView setRegion:region];
      
      POI *currentShopCoordinate = [[POI alloc] initWithCoordinate2D:coordinate title:name subtitle:address];
      
      [mapView addAnnotation:currentShopCoordinate];
      [self addSubview:mapView];
    }
  }
  return self;
}

@end
