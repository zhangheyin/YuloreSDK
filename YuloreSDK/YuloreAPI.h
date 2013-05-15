//
//  YuloreAPI.h
//  TestAPI
//
//  Created by Zhang Heyin on 13-4-1.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YuloreAPI : NSObject
+ (NSString *)shopSearchWithKeyWord:(NSString *)keyWord;
+ (NSMutableArray *)executeSearch:(NSString *)keyWord;
+ (NSMutableArray *)executeSearch2:(NSString *)keyWord;
+ (void) yuloreCategory;
+ (NSMutableArray *)cityList;
+ (NSMutableArray *)executeSearch3:(NSMutableDictionary *)searchCondition;

+ (NSMutableArray *)hotCityList;
+ (NSArray *)wholeCityList;

// DATA INTERFACE
+ (NSString *)queryShopInformationWithShopID:(NSString *)shopID;
@end
