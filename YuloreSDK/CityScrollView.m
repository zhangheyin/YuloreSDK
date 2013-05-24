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
#import <QuartzCore/QuartzCore.h>
#import "UIImage+FlatUI.h"
#import "UINavigationBar+CustomBackground.h"
#import "UIColor+FlatUI.h"
@interface CityScrollView ()
@property (nonatomic, retain) NSMutableArray *hotcitylist;
@property (nonatomic, retain) NSString *currentCityID;
@end
@implementation CityScrollView
@synthesize hotcitylist = _hotcitylist;
@synthesize currentCityID = _currentCityID;

- (id)initWithFrame:(CGRect)frame withHotCityList:(NSMutableArray *)hotCityList withCurrentCityID:(NSString *)currentCityID changeCity:(BOOL)changeCity
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = kNavigationBarCustomTintColor;
    // NSMutableArray *cityArray = [YuloreAPI cityList];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40.f)];
    [titleLabel setText:@"热门城市"];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:titleLabel];
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
    CGFloat yOffset = 40;
    CGFloat xOffset = 0;
    
    
    for (int i = 0; i < numberOfButton; i++) {
      NSDictionary *aCityDic = [self.hotcitylist objectAtIndex:i];
      UIButton *aCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
      //[[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, buttonWidth, 40)];
      [aCityButton setFrame:CGRectMake(xOffset, yOffset, buttonWidth, 40)];
      
      if ([self.currentCityID isEqualToString:[aCityDic objectForKey:CITYID2]]) {
        //CGFloat minEdgeSize = 5 * 2 + 1;
        CGRect rect = CGRectMake(0, 0, 60, 40);
        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 4, 40, 32) cornerRadius:0];
        roundedRect.lineWidth = 0;
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
        [[UIColor peterRiverColor] setFill];
        [roundedRect fill];
        [roundedRect stroke];
        [roundedRect addClip];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [aCityButton setBackgroundImage:image forState:UIControlStateNormal];
        
        if (changeCity) {
          
          CABasicAnimation *theAnimation;
          theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
          theAnimation.delegate = self;
          theAnimation.duration = 1;
          theAnimation.repeatCount = 0;
          theAnimation.removedOnCompletion = FALSE;
          theAnimation.fillMode = kCAFillModeForwards;
          theAnimation.autoreverses = NO;
          theAnimation.fromValue = [NSNumber numberWithFloat:-M_PI];
          //CGFloat radian = 350 * (M_2_PI / 360);
          theAnimation.toValue =[NSNumber numberWithFloat:2*M_PI];
          [aCityButton.layer addAnimation:theAnimation forKey:@"animateLayer"];
        }
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
