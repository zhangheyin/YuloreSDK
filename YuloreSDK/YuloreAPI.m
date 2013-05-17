//
//  YuloreAPI.m
//  TestAPI
//
//  Created by Zhang Heyin on 13-4-1.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import "YuloreAPI.h"
#import "JSONKit.h"
@implementation YuloreAPI

//+ (NSMutableArray *)cityList {
//  NSArray *cityNameArray = [NSArray arrayWithObjects:@"杭州",@"林芝",@"台北",@"大理",@"巴塞罗那",@"伦敦",@"济南",@"北海道",@"墨尔本",@"重庆",@"银川",@"兰州",@"西安",@"乌鲁木齐",@"长沙",@"武汉",@"洛阳",@"桂林",@"呼和浩特",@"澳门",@"香港",@"沈阳",@"北京",@"杭州",@"林芝",@"台北",@"大理",@"巴塞罗那",@"伦敦",@"济南",@"北海道",@"墨尔本",@"重庆",@"银川",@"兰州",@"西安",@"乌鲁木齐",@"长沙",@"武汉",@"洛阳",@"桂林",@"呼和浩特",@"澳门",@"香港",@"沈阳",@"北京",@"杭州",@"林芝",@"台北",@"大理",@"巴塞罗那",@"伦敦",@"济南",@"北海道",@"墨尔本",@"重庆",@"银川",@"兰州",@"西安",@"乌鲁木齐",@"长沙",@"武汉",@"洛阳",@"桂林",@"呼和浩特",@"澳门",@"香港",@"沈阳",@"北京", nil];
//  NSMutableArray *cityArray = [[[NSMutableArray alloc] init] autorelease];
//  for (int i = 0; i < [cityNameArray count]; i++) {
//    NSDictionary *aCity = @{[cityNameArray objectAtIndex:i]: [NSString stringWithFormat:@"%d", i]};
//    [cityArray addObject:aCity];
//  }
//  
//  return cityArray;
//}


+ (NSArray *)wholeCityList {
  NSString *urlString = @"http://w10.test.yulore.com/api/city.php";
  //query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key", query];
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  NSError *error = nil;
  NSMutableArray *hotCityList = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
  
  
  return [hotCityList valueForKey:@"info"];
}
+ (NSMutableArray *)hotCityList {
  NSString *urlString = @"http://w10.test.yulore.com/api/city.php?hot=1";
  //query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key", query];
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  NSError *error = nil;
  NSMutableArray *hotCityList = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
 
  
  return [hotCityList valueForKey:@"info"];
}

#define CITYID @"city_id"
#define CATEGORYID @"cat_id"
#define DISTID @"dist_id"
#define STARTRESULT @"S"
#define NUMBEROFRESULT @"N"
#define ORDER @"O"
#define LATITUDE @"lat"
#define LONGITUDE @"lng"
#define KEYWORD @"q"




#define DETAILQUERYURL @"http://www.test.yulore.com/detailnew/index_new.php?info="
+ (NSString *)shopSearchWithSearchCondition:(NSMutableDictionary *)searchCondition {
  id cityID = [searchCondition objectForKey:CITYID];
  id categoryID = [searchCondition objectForKey:CATEGORYID];
  id distID = [searchCondition objectForKey:DISTID];
  id startResult = [searchCondition objectForKey:STARTRESULT];
  id numberOfResult = [searchCondition objectForKey:NUMBEROFRESULT];
  id order = [searchCondition objectForKey:ORDER];
  id latitude = [searchCondition objectForKey:LATITUDE];
  id longitude = [searchCondition objectForKey:LONGITUDE];
  id keywords = [searchCondition objectForKey:KEYWORD];
  
  
  NSMutableArray *paraArray = [[[NSMutableArray alloc] init] autorelease];

  if (keywords != nil) {
    [paraArray addObject:[NSString stringWithFormat:@"q=%@", keywords]];
  }
  if (cityID != nil) {
    [paraArray addObject:[NSString stringWithFormat:@"city_id=%@", cityID]];
  }
  
  if (categoryID != nil) {
    [paraArray addObject:[NSString stringWithFormat:@"cat_id=%@", categoryID]];
    
  }
  if (startResult != nil) {
    [paraArray addObject:[NSString stringWithFormat:@"s=%@",startResult]];
  }
  
  if (numberOfResult != nil) {
    [paraArray addObject:[NSString stringWithFormat:@"n=%@",numberOfResult]];
  }
  if (distID != nil) {
    [paraArray addObject:[NSString stringWithFormat:@"dist_id=%@", distID]];
    


    BOOL useCoordinate = NO;
    if (order != nil) {
      if ([order intValue] != 0) {
        if ([order intValue] == 2) {
          useCoordinate = YES;
          [paraArray addObject:[NSString stringWithFormat:@"o=2&lat=%@&lng=%@", latitude, longitude]];
        }
        [paraArray addObject:[NSString stringWithFormat:@"o=%@", order]];
      }
    }
    if (latitude != nil && latitude != nil && !useCoordinate) {
      [paraArray addObject:[NSString stringWithFormat:@"lat=%@&lng=%@", latitude, longitude]];
    }
    
  }

  NSString *newParaString = [[[NSString alloc] init] autorelease];
  for (int i = 0; i < [paraArray count]; i++) {
    if (i == 0) {
      newParaString = [@"?" stringByAppendingString:[paraArray objectAtIndex:i]];
    } else {
      newParaString = [newParaString stringByAppendingFormat:@"&%@", [paraArray objectAtIndex:i]];
    }
  }
  
  
  NSString *request =  [NSString stringWithFormat:@"http://api.test.yulore.com/search%@", newParaString];
  
  NSLog(@"%@", request);
  return request;

}




+ (NSMutableArray *)executeSearch3:(NSMutableDictionary *)searchCondition
{
  NSLog(@"start");
  NSString *urlString = [self shopSearchWithSearchCondition:searchCondition];
  //query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key", query];
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding
                                                  error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  NSError *error = nil;
  NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
  if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
  // NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
  
  
  NSMutableArray *shopArray = [results valueForKey:@"itms"];
  NSLog(@"stop");
  return shopArray;
}
/*
+ (NSMutableArray *)executeSearch:(NSString *)keyWord
{
  NSLog(@"start");
  NSString *urlString = [self shopSearchWithKeyWord:keyWord];
  //query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key", query];
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding
                                                  error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  NSError *error = nil;
  NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
  if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
  // NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
  
  
  NSMutableArray *shopArray = [results valueForKey:@"itms"];
  NSLog(@"stop");
  return shopArray;
}*/

/*
+ (NSString *)shopSearchWithKeyWord:(NSString *)keyWord {
  return [self shopSearchWithCityID:1 categoryID:0 distID:0 startResult:0 numberOfResult:30 order:0 latitude:999 longitude:999 keyWord:keyWord];
}*/


/*
+ (NSString *)shopSearchWithCityID2:(uint)cityID
                         categoryID:(uint)categoryID
                             distID:(uint)distID
                        startResult:(uint)startResult
                     numberOfResult:(uint)numberOfResult
                              order:(uint)order
                           latitude:(double)latitude
                          longitude:(double)longitude
                            keyWord:(NSString *)keyWord {
  NSString *parameters = [[NSString alloc] init];
  if (![keyWord isEqualToString:@""]) {
    parameters = [parameters stringByAppendingFormat:@"?q=%@", keyWord];
  }
  if (cityID != -1) {
    parameters = [parameters stringByAppendingFormat:@"&city_id=%d", cityID];
  }
  
  //if (categoryID != -1) {
  parameters = [parameters stringByAppendingFormat:@"&cat_id=%d", categoryID];
  //}
  
  //if (distID != -1) {
  parameters = [parameters stringByAppendingFormat:@"&dist_id=%d", distID];
  //}
  
  if (startResult != 0) {
    parameters = [parameters stringByAppendingFormat:@"&s=%d", startResult];
  }
  
  if (numberOfResult != 0) {
    parameters = [parameters stringByAppendingFormat:@"&n=%d", numberOfResult];
  }
  
  
  
  BOOL useCoordinate = NO;
  if (order != 0) {
    if (order == 2) {
      useCoordinate = YES;
      parameters = [parameters stringByAppendingFormat:@"&&o=2&&lat=%f&&lng=%f", latitude, longitude];
    }
    parameters = [parameters stringByAppendingFormat:@"&&o=%d", order];
  }
  
  if (latitude != 999 && latitude != 999 && !useCoordinate) {
    parameters = [parameters stringByAppendingFormat:@"?lat=%f&&lng=%f", latitude, longitude];
  }
  
  
  
  NSString *request =  [NSString stringWithFormat:@"http://api.test.yulore.com/search%@", parameters];
  
  NSLog(@"%@", request);
  return request;
}
*/
/*

+ (NSString *)shopSearchWithCityID:(uint)cityID
                        categoryID:(uint)categoryID
                            distID:(uint)distID
                       startResult:(uint)startResult
                    numberOfResult:(uint)numberOfResult
                             order:(uint)order
                          latitude:(double)latitude
                         longitude:(double)longitude
                           keyWord:(NSString *)keyWord {
  NSString *parameters = [[NSString alloc] init];
  if (![keyWord isEqualToString:@""]) {
    parameters = [parameters stringByAppendingFormat:@"?q=%@", keyWord];
  }
  if (cityID != -1) {
    parameters = [parameters stringByAppendingFormat:@"&city_id=%d", cityID];
  }
  
  //if (categoryID != -1) {
  parameters = [parameters stringByAppendingFormat:@"&cat_id=%d", categoryID];
  //}
  
  //if (distID != -1) {
  parameters = [parameters stringByAppendingFormat:@"&dist_id=%d", distID];
  //}
  
  if (startResult != 0) {
    parameters = [parameters stringByAppendingFormat:@"&s=%d", startResult];
  }
  
  if (numberOfResult != 0) {
    parameters = [parameters stringByAppendingFormat:@"&n=%d", numberOfResult];
  }
  
  
  
  BOOL useCoordinate = NO;
  if (order != 0) {
    if (order == 2) {
      useCoordinate = YES;
      parameters = [parameters stringByAppendingFormat:@"&&o=2&&lat=%f&&lng=%f", latitude, longitude];
    }
    parameters = [parameters stringByAppendingFormat:@"&&o=%d", order];
  }
  
  if (latitude != 999 && latitude != 999 && !useCoordinate) {
    parameters = [parameters stringByAppendingFormat:@"?lat=%f&&lng=%f", latitude, longitude];
  }
  
  
  
  NSString *request =  [NSString stringWithFormat:@"http://api.test.yulore.com/search%@", parameters];
  
  NSLog(@"%@", request);
  return request;
}

*/
/*
+ (NSMutableArray *)executeSearch2:(NSString *)keyWord{
  NSString *urlString = [self shopSearchWithKeyWord:keyWord];
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  
  
  JSONDecoder *jd=[[JSONDecoder alloc] init];
  NSDictionary *searchResult = jsonData ? [jd objectWithData:jsonData] : nil;
  
  return (NSMutableArray *)[searchResult objectForKey:@"itms"];
}
*/
/*
+ (void) yuloreCategory {
  NSString *urlString = @"http://w10.test.yulore.com/api/category.php";
  //query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key", query];
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  NSError *error = nil;
  NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                                       error:&error] : nil;
  if (error)
    NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
  
  
  NSMutableDictionary *allCategory = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *newCategory = [[NSMutableDictionary alloc] init];
  // NSMutableArray *bigCategory = [[NSMutableArray alloc] init];
  for (NSDictionary *aCategory in results) {
    newCategory = [[NSMutableDictionary alloc] init];
    // NSString *level = [aCategory objectForKey:@"level"];
    NSString *pid = [aCategory objectForKey:@"pid"];
    //NSString *cid = [aCategory objectForKey:@"id"];
    
    
    NSMutableArray *singleCategory = [[NSMutableArray alloc] init];
    [allCategory setObject:singleCategory forKey:pid];
  }
  
  NSLog(@"all %@", allCategory);
  
  NSMutableArray *singleCategory = [[NSMutableArray alloc] init];
  for (NSDictionary *aCategory in results) {
    NSString *key = [aCategory objectForKey:@"pid"];
    singleCategory = [allCategory valueForKey:key];
    [singleCategory addObject:aCategory];
  }
  
  NSMutableDictionary *levelDic = [[NSMutableDictionary alloc] init];
  for (int i = 1; i < 4; i++) {
    NSMutableArray *nullArray = [[NSMutableArray alloc] init];
    [levelDic setObject:nullArray forKey:[NSString stringWithFormat:@"%d", i]];
  }
  
  NSLog(@"%@", levelDic);
  
  NSMutableArray *singleLevelArray = [[NSMutableArray alloc] init];
  for (NSDictionary *aCategory in results) {
    NSString *level = [aCategory objectForKey:@"level"];
    singleLevelArray = [levelDic valueForKey:level];
    [singleLevelArray addObject:aCategory];
    
  }
  NSLog(@"%@", levelDic);
  NSLog(@"all %@", allCategory);
  
  

  NSMutableArray *level1DisplayArray = [levelDic objectForKey:@"1"];
  NSLog(@"%@", level1DisplayArray);
  
  
  NSMutableDictionary *level2CategoryDictionary = [[NSMutableDictionary alloc] init];
  NSMutableArray *level_2 = [[NSMutableArray alloc] init];
  for (NSDictionary *aCategory in level1DisplayArray) {
    NSString *key = [aCategory objectForKey:@"id"];
    NSMutableArray *aLevel2Array = [allCategory valueForKey:key];
    
    //NSLog(@"%@", level_2);
    
    NSMutableDictionary *aLevel2 = [NSMutableDictionary dictionaryWithObject:aLevel2Array
                                                                      forKey:key];
    
    [level_2 addObject:aLevel2];
    //[level2CategoryDictionary setObject:aLevel2Array forKey:aCategory];
  }
  
  NSLog(@"%@", level2CategoryDictionary);
  
  
  
  NSMutableArray *level2CategoryArray = [levelDic objectForKey:@"2"];
  
  NSMutableArray *buildLevel3CategoryArray = [[NSMutableArray alloc] init];
  for (NSDictionary *aCategory in level2CategoryArray) {
    NSString *key = [aCategory objectForKey:@"id"];
    NSMutableArray *aLevel3Array = [allCategory valueForKey:key];
    
    NSMutableDictionary *aLevel3 = [NSMutableDictionary dictionaryWithObject:aLevel3Array
                                                                      forKey:key];
    [buildLevel3CategoryArray addObject:aLevel3];
  }
  NSLog(@"%@", buildLevel3CategoryArray);
  

}
*/


+ (NSString *)queryShopInformationWithShopID:(NSString *)shopID {
  //http://www.test.yulore.com/detailnew/index_new.php?info={%22type%22:%221%22,%22shopid%22:%22fa963aaa7775d979fddaaebced2bea2681052682%22,%22fields%22:{%22name%22:true,%22tel%22:true,%22scores%22:true}}
  NSDictionary *fields = @{@"name" : @"1" , @"tel" : @"1", @"scores" : @"1"};
  //[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"name", @"1", @"tel", @"1" , @"scores", nil];
  
  NSDictionary *queryInformation = @{@"type": @"1", @"shopID": shopID, @"scores": @"1", @"fields" : fields};
  //[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"type",  shopID, @"shopid", fields, @"fields", nil];
  NSString *json = [queryInformation JSONString];
  NSString *urlString = [DETAILQUERYURL stringByAppendingString:json];
  
  
  NSLog(@"%@", urlString);
  
  
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding
                                                  error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  NSError *error = nil;
//  NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
  if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
  
  return urlString;
}
@end
