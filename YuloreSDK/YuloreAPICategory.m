//
//  YuloreAPICategory.m
//  TestAPI
//
//  Created by Zhang Heyin on 13-4-2.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import "YuloreAPICategory.h"

@interface YuloreAPICategory()
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) NSMutableArray *sortWithLevelArray;
@property (nonatomic, retain) NSMutableDictionary *levelDictionary;

@end
@implementation YuloreAPICategory

- (id) init {
  self = [super init];
  if (self) {
    NSString *urlString = @"http://w10.test.yulore.com/api/category.php";
    //query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key", query];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    self.results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error)
      NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    NSMutableArray *filterAllCategory = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary *aCategory in self.results) {
      if (![[aCategory objectForKey:@"type"] isEqualToString:@"2"]) {
        [filterAllCategory addObject:aCategory];
      }
    }
    
    /*构造一个空的字典*/
    self.levelDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    for (int i = 1; i < 4; i++) {
      NSMutableArray *nullArray = [[[NSMutableArray alloc] init] autorelease];
      [self.levelDictionary setObject:nullArray forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.sortWithLevelArray = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary *aCategory in filterAllCategory) {
      NSString *level = [aCategory objectForKey:@"level"];
      self.sortWithLevelArray = [self.levelDictionary valueForKey:level];
      [self.sortWithLevelArray addObject:aCategory];
    }
  }
  return self;
}

- (NSArray *)level3Category:(NSDictionary *)aLevel2Category {
  //pid==aLevel1Category->id level==3
  //allLevel1Category : all category which level is 3
  NSMutableArray *allLevel2Category = [self.levelDictionary objectForKey:@"2"];
  //current level 1
  NSString *categoryID = [aLevel2Category objectForKey:@"id"];
  
  NSMutableArray *currentLevel3Category = [[[NSMutableArray alloc] init] autorelease];
  for (NSDictionary *aLevel2Category in allLevel2Category) {
    if ([[aLevel2Category objectForKey:@"pid"] isEqualToString:categoryID]) {
      [currentLevel3Category addObject:aLevel2Category];
    }
  }
  
  /*按照ranking排序*/
  NSArray *resuletLevel3Category = [currentLevel3Category sortedArrayUsingComparator:^(id obj1,id obj2) {
    NSDictionary *dic1 = (NSDictionary *)obj1;
    NSDictionary *dic2 = (NSDictionary *)obj2;
    NSNumber *num1 = (NSNumber *)[dic1 objectForKey:@"ranking"];
    NSNumber *num2 = (NSNumber *)[dic2 objectForKey:@"ranking"];
    if ([num1 integerValue] > [num2 integerValue])
    {
      return (NSComparisonResult)NSOrderedAscending;
    }
    else
    {
      return (NSComparisonResult)NSOrderedDescending;
    }
    return (NSComparisonResult)NSOrderedSame;
  }];
  
  return resuletLevel3Category;
}



- (NSArray *)level2Category:(NSDictionary *)aLevel1Category {
  //pid==aLevel1Category->id level==2
  //allLevel1Category : all category which level is 2
  NSMutableArray *allLevel1Category = [self.levelDictionary objectForKey:@"2"];
  //current level 1 
  NSString *categoryID = [aLevel1Category objectForKey:@"id"];
  NSMutableArray *currentLevel2Category = [[[NSMutableArray alloc] init] autorelease];
  for (NSDictionary *aLevel2Category in allLevel1Category) {
    if ([[aLevel2Category objectForKey:@"pid"] isEqualToString:categoryID]) {
      [currentLevel2Category addObject:aLevel2Category];
    }
  }
  
  /*按照ranking排序*/
  NSArray *resultLevel2Category = [currentLevel2Category sortedArrayUsingComparator:^(id obj1,id obj2) {
    NSDictionary *dic1 = (NSDictionary *)obj1;
    NSDictionary *dic2 = (NSDictionary *)obj2;
    NSNumber *num1 = (NSNumber *)[dic1 objectForKey:@"ranking"];
    NSNumber *num2 = (NSNumber *)[dic2 objectForKey:@"ranking"];
    if ([num1 integerValue] > [num2 integerValue])
    {
      return (NSComparisonResult)NSOrderedAscending;
    }
    else
    {
      return (NSComparisonResult)NSOrderedDescending;
    }
    return (NSComparisonResult)NSOrderedSame;
  }];

  return resultLevel2Category;
}



- (NSArray *)level1Category {
  NSMutableArray *level1Category = [self.levelDictionary objectForKey:@"1"];
  
  NSArray *newResult = [level1Category sortedArrayUsingComparator:^(id obj1,id obj2) {
     NSDictionary *dic1 = (NSDictionary *)obj1;
     NSDictionary *dic2 = (NSDictionary *)obj2;
     NSNumber *num1 = (NSNumber *)[dic1 objectForKey:@"ranking"];
     NSNumber *num2 = (NSNumber *)[dic2 objectForKey:@"ranking"];
     if ([num1 integerValue] > [num2 integerValue])
     {
       return (NSComparisonResult)NSOrderedAscending;
     }
     else
     {
       return (NSComparisonResult)NSOrderedDescending;
     }
     return (NSComparisonResult)NSOrderedSame;
   }];

  
  return newResult;
}


@end
