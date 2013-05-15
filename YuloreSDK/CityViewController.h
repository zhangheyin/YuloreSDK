//
//  CityViewController.h
//  ddddd
//
//  Created by Zhang Heyin on 13-4-10.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PassValueDelegate <NSObject>

-(void)passValue:(NSDictionary *)aCity;

@end
@interface CityViewController : UIViewController
@property(nonatomic,assign) id<PassValueDelegate> passValueDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil currentCityID:(NSString *)currentCityID;
@end
