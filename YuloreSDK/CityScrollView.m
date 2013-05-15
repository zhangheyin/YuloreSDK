//
//  CityScrollView.m
//  ddddd
//
//  Created by Zhang Heyin on 13-4-11.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//
#define CITYID2 @"c_id"
#define CITYNAME @"c_name"
#import "CityScrollView.h"
#import "YuloreAPI.h"
#import "UINavigationBar+CustomBackground.h"
@interface CityScrollView ()
@property (nonatomic, retain) NSMutableArray *hotcitylist;
@property (nonatomic, retain) NSString *currentCityID;
@end
@implementation CityScrollView
@synthesize hotcitylist = _hotcitylist;
@synthesize currentCityID = _currentCityID;

- (id)initWithFrame:(CGRect)frame withHotCityList:(NSMutableArray *)hotCityList withCurrentCityID:(NSString *)currentCityID
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = kNavigationBarCustomTintColor;
    // NSMutableArray *cityArray = [YuloreAPI cityList];
    
    
    self.hotcitylist = hotCityList;
    self.currentCityID = currentCityID;
    
    
    
    CGFloat buttonWidth = 80.f;
    
    uint numberOfButton = [self.hotcitylist count];
    // CGFloat totalLength = numberOfButton * 80;
    
    uint mod = (numberOfButton * 80) % (int)self.frame.size.width;
    
    uint lines = (numberOfButton * 80) / (int)self.frame.size.width;
    lines = (mod == 0) ? lines + 1 : lines + 2;
    
    
    
    self.contentSize = CGSizeMake(self.frame.size.width, lines * 40.f);
    //
    CGFloat yOffset = 0;
    CGFloat xOffset = 0;
    
    
    for (int i = 0; i < numberOfButton; i++) {
      NSDictionary *aCityDic = [self.hotcitylist objectAtIndex:i];
      UIButton *aCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
      //[[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, buttonWidth, 40)];
      [aCityButton setFrame:CGRectMake(xOffset, yOffset, buttonWidth, 40)];
      
      
      if ([self.currentCityID isEqualToString:[aCityDic objectForKey:CITYID2]]) {
        [aCityButton setImage:[UIImage imageNamed:@"selectcity.png"]
                     forState:UIControlStateNormal];
      }


      
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.f, 40.f)];
      label.text = [aCityDic objectForKey:CITYNAME]; //[[aCityDic allKeys] objectAtIndex:0];
      label.adjustsFontSizeToFitWidth = YES;
      label.font = [UIFont boldSystemFontOfSize:18];
      [label setTextAlignment:UITextAlignmentCenter];
      label.minimumFontSize = 1.0f;
      
      
      
      // CGRect bounds = label.bounds;
      
      // bounds.size = [[[aCityDic allKeys] objectAtIndex:0] sizeWithFont:label.font];
      
      //label.bounds = bounds;
      [label setTextColor:[UIColor whiteColor]];
      [label setBackgroundColor:[UIColor clearColor]];
      [aCityButton addTarget:self action:@selector(selectCity:)
            forControlEvents:UIControlEventTouchUpInside];
      //[aCityButton setBackgroundColor:[UIColor clearColor]];

      [aCityButton setTag:i];
      [aCityButton addSubview:label];
      //[aCity setTitle:[[aCityDic allKeys] objectAtIndex:0]
      //      forState:UIControlStateNormal];
      [self addSubview:aCityButton];
      if ((xOffset + buttonWidth > (frame.size.width - buttonWidth))) {
        yOffset = yOffset + 40;
        xOffset = 0.f;
      } else {
        xOffset += buttonWidth;
      }
    }
  }
  return self;
}

- (void) selectCity:(UIButton *)aButton {
  [self.cvdelegate selectCityWithDic:[self.hotcitylist objectAtIndex:[aButton tag]]];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
