//
//  CityScrollView.h
//  ddddd
//
//  Created by Zhang Heyin on 13-4-11.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CityViewDelegate <NSObject>
- (NSUInteger) selectCityWithDic:(NSDictionary *)aDic;

@end
@interface CityScrollView : UIScrollView
- (id)initWithFrame:(CGRect)frame withHotCityList:(NSMutableArray *)hotCityList withCurrentCityID:(NSString *)currentCityID;
@property (nonatomic, assign) id<CityViewDelegate> cvdelegate;
@end
