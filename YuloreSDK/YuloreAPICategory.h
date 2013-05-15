//
//  YuloreAPICategory.h
//  TestAPI
//
//  Created by Zhang Heyin on 13-4-2.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YuloreAPICategory : NSObject
- (NSArray *)level1Category;
- (NSArray *)level2Category:(NSDictionary *)aLevel1Category;
- (NSArray *)level3Category:(NSDictionary *)aLevel2Category;
@end
