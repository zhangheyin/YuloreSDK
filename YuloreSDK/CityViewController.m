//
//  CityViewController.m
//  ddddd
//
//  Created by Zhang Heyin on 13-4-10.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//
#define CITYID2 @"c_id"
#define CITYNAME @"c_name"
#define CITYENAME @"c_en"
#define CITYSENAME @"c_sen"
#import "CityViewController.h"
#import "YuloreAPI.h"
#import "SearchViewController.h"
#import "CityScrollView.h"
#import "UINavigationBar+CustomBackground.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
@interface CityViewController ()  <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, CityViewDelegate, MBProgressHUDDelegate, CLLocationManagerDelegate> {
  
  MBProgressHUD *HUD;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchdispalyCtrl;
@property (nonatomic, retain) NSArray *searchCityResults;
@property (nonatomic, retain) CityScrollView *cityScrollView;
@property (nonatomic, retain) NSMutableArray *hotCityList;
@property (nonatomic, retain) NSArray *wholeCityList;
@property (nonatomic, retain) NSString *currentCityID;
@end

@implementation CityViewController
@synthesize passValueDelegate = _passValueDelegate;
@synthesize tableView = _tableView;
@synthesize theSearchBar = _theSearchBar;
@synthesize searchdispalyCtrl = _searchdispalyCtrl;
@synthesize hotCityList = _hotCityList;
@synthesize wholeCityList = _wholeCityList;
@synthesize currentCityID = _currentCityID;
- (void)loadView {
  [super loadView];
  CGRect frame = [[UIScreen mainScreen] 	applicationFrame];
  UITableView *aTableView = [[[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain] autorelease];
  
  
  [aTableView setDelegate:self];
  [aTableView setDataSource:self];
  self.tableView = aTableView;
  
  self.theSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)] autorelease];
  self.theSearchBar.placeholder = @"北京/beijing/bj";
  self.theSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
  //self.theSearchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
  // theSearchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"All",@"A",@"B",@"C",@"D" ,nil];
  self.theSearchBar.showsScopeBar = YES;
  self.theSearchBar.keyboardType = UIKeyboardTypeNamePhonePad;
  //theSearchBar.showsBookmarkButton = YES;
  self.theSearchBar.tintColor = kNavigationBarCustomTintColor;
  
  //self.view = self.theSearchBar;
  self.tableView.tableHeaderView = self.theSearchBar;  //将searchBar添加到tableView的头,注意滚动出屏幕后，搜索框也不在了，只出现在首页
  
  
  
  self.searchdispalyCtrl = [[[UISearchDisplayController  alloc] initWithSearchBar:self.theSearchBar
                                                               contentsController:self] autorelease];
  self.searchdispalyCtrl.active = NO;
  self.searchdispalyCtrl.delegate = self;
  self.searchdispalyCtrl.searchResultsDelegate=self;
  self.searchdispalyCtrl.searchResultsDataSource = self;
  self.searchdispalyCtrl.searchResultsTableView.backgroundColor = kNavigationBarCustomTintColor;
  [self.searchdispalyCtrl.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  //[self.view addSubview:self.theSearchBar];
  
  CGRect rect = frame;
  rect.size.height = rect.size.height - 40.f;
  rect.origin.y =  self.theSearchBar.frame.size.height;
  self.cityScrollView  = [[[CityScrollView alloc] initWithFrame:rect withHotCityList:self.hotCityList withCurrentCityID:self.currentCityID] autorelease];
  
  self.cityScrollView.cvdelegate = self;
  
  
  [self.view addSubview:self.tableView];
  [self.view addSubview:self.theSearchBar];
  //self.cityView = [[CityView alloc] initWithFrame:self.view.bounds];
  //self.cityView.delegate = self;
  //[self.view addSubview:self.cityView];
  //self.view = self.cityScrollView;
  [self.view addSubview:self.cityScrollView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil currentCityID:(NSString *)currentCityID {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.hotCityList = [YuloreAPI hotCityList];
    self.currentCityID = currentCityID;
    self.wholeCityList = [YuloreAPI wholeCityList];
    // Custom initialization
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    BOOL enable = [CLLocationManager locationServicesEnabled];
    NSLog(@"%@", enable? @"Enabled" : @"Not Enabled");
  }
  return self;
}

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  //NSLog(@"didUpdateToLocation");
  // store all of the measurements, just so we can see what kind of data we might receive
  [self.locationMeasurements addObject:newLocation];
  // test the age of the location measurement to determine if the measurement is cached
  // in most cases you will not want to rely on cached measurements
  NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
  if (locationAge > 20.0) return;
  // test that the horizontal accuracy does not indicate an invalid measurement
  if (newLocation.horizontalAccuracy < 0) return;
  // test the measurement to see if it is more accurate than the previous measurement
  if (self.bestEffortAtLocation == nil || self.bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
    // store the location as the "best effort"
    self.bestEffortAtLocation = newLocation;
    // test the measurement to see if it meets the desired accuracy
    //
    // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
    // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
    // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
    //
    if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
      // we have a measurement that meets our requirements, so we can stop updating the location
      //
      // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
      //
      // NSLog(@"self.bestEffortAtLocation    %@", self.bestEffortAtLocation);
      
      // [self.addressDelegate fetchCurrentLocationAddress:self.bestEffortAtLocation.coordinate];
      [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
      
      
      NSLog(@"latitude:%f  longitude:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
      [self.locationManager stopUpdatingLocation];
      // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
      //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
    }
  }
  // update the display with the new location data
  
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  // The location "unknown" error simply means the manager is currently unable to get the location.
  // We can ignore this error for the scenario of getting a single location fix, because we already have a
  // timeout that will stop the location manager to save power.
  if ([error code] != kCLErrorLocationUnknown) {
    [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
  }
}



- (void)stopUpdatingLocation:(NSString *)state {
  //self.stateString = state;
  // [self.tableView reloadData];
  // [self.locationManager stopUpdatingLocation];
  self.bestEffortAtLocation = nil;
  // self.locationManager.delegate = nil;
  
  //UIBarButtonItem *resetItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", @"Reset") style:UIBarButtonItemStyleBordered target:self action:@selector(reset)] autorelease];
  // [self.navigationItem setLeftBarButtonItem:resetItem animated:YES];;
}


- (void)selectCity{
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.title = [@"当前城市:" stringByAppendingString:[self currentCityName]];
	// Do any additional setup after loading the view.
  
  
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    return [self.searchCityResults count];
  } else {
    return 0;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    return 1;
  } else {
    return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"level1";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier];
  }
  [cell.textLabel setBackgroundColor:[UIColor clearColor]];//文字背景透明
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    
    NSDictionary *aCity = [self.searchCityResults objectAtIndex:[indexPath row]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = [aCity objectForKey:CITYNAME];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ , %@", [aCity objectForKey:CITYENAME], [aCity objectForKey:CITYSENAME]];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor darkGrayColor]];
    [cell setSelectedBackgroundView:bgColorView];
    [bgColorView release];
    
    
    
  } else {
    return cell;
  }
  
  // Configure the cell...
  return cell;
}




#pragma mark - UISearchDisplayController delegate methods


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
  
  // [self.searchResults removeAllObjects];
  // dispatch_queue_t q = dispatch_queue_create("queue", 0);
  //dispatch_async(q, ^{
  [self filterContentForSearchText:searchString
                             scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
  //  dispatch_async(dispatch_get_main_queue(), ^{
  //   [self.searchDisplayController.searchResultsTableView reloadData];
  //  });
  //});
  //dispatch_release(q);
  
  
  
  return YES;
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
  //[self.searchCityResults removeAllObjects];
  //dispatch_queue_t q = dispatch_queue_create("queue", 0);
  //dispatch_async(q, ^{
  [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                             scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:searchOption]];
  //dispatch_async(dispatch_get_main_queue(), ^{
  //   [self.searchDisplayController.searchResultsTableView reloadData];
  // });
  //});
  // dispatch_release(q);
  
  
  return YES;
  
}


- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope {
  
  //self.searchCityResults = [YuloreAPI executeSearch:searchText];
  
  NSString *match = [NSString stringWithFormat:@"%@*", searchText];
  
  //NSString *format = ([self inputCharacterType:searchText]) ? [CITYNAME stringByAppendingString:@" like[cd] %@"] : [ stringByAppendingString:@" like[cd] %@"];//"cityname like[cd] %@" : @"city_en like[cd] %@";
  
  if ([self inputCharacterType:searchText]) {
    NSString *format = [CITYNAME stringByAppendingString:@" like[cd] %@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format, match];
    
    self.searchCityResults = [self.wholeCityList filteredArrayUsingPredicate:predicate];
  } else {
    
    NSString *format_en = [CITYENAME stringByAppendingString:@" like[cd] %@"];
    NSString *format_sen = [CITYSENAME stringByAppendingString:@" like[cd] %@"];
    NSPredicate *predicate_en = [NSPredicate predicateWithFormat:format_en, match];
    NSPredicate *predicate_sen = [NSPredicate predicateWithFormat:format_sen, match];
    
    NSArray *searchCityWithEN = [self.wholeCityList filteredArrayUsingPredicate:predicate_en];
    NSArray *searchCityWithSEN = [self.wholeCityList filteredArrayUsingPredicate:predicate_sen];
    
    
    
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", searchCityWithSEN];
    
    searchCityWithEN = [searchCityWithEN filteredArrayUsingPredicate:thePredicate];
    
    NSArray *result = [searchCityWithEN arrayByAddingObjectsFromArray:searchCityWithSEN];
    
    
    /*按照ranking排序*/
    NSArray *resultSorted = [result sortedArrayUsingComparator:^(id obj1,id obj2) {
      NSDictionary *dic1 = (NSDictionary *)obj1;
      NSDictionary *dic2 = (NSDictionary *)obj2;
      NSNumber *num1 = (NSNumber *)[dic1 objectForKey:CITYID2];
      NSNumber *num2 = (NSNumber *)[dic2 objectForKey:CITYID2];
      if ([num1 integerValue] > [num2 integerValue])
      {
        return (NSComparisonResult)NSOrderedDescending;
      }
      else
      {
        return (NSComparisonResult)NSOrderedAscending;
      }
      return (NSComparisonResult)NSOrderedSame;
    }];
    // NSLog(@"%@", resultSorted);
    self.searchCityResults = resultSorted;
  }
}

- (BOOL)inputCharacterType:(NSString *)inputString {
  BOOL type = NO;
  int alength = [inputString length];
  for (int i = 0; i<alength; i++) {
  //  char commitChar = [inputString characterAtIndex:i];
    NSString *temp = [inputString substringWithRange:NSMakeRange(i,1)];
    const char *u8Temp = [temp UTF8String];
    if (3 == strlen(u8Temp)){
      type = YES;//NSLog(@"字符串中含有中文");
    }else {
      type = NO;
    }// if((commitChar>64)&&(commitChar<91)){
    // NSLog(@"字符串中含有大写英文字母");
    // }else if((commitChar>96)&&(commitChar<123)){
    //   NSLog(@"字符串中含有小写英文字母");
    //}else if((commitChar>47)&&(commitChar<58)){
    //  NSLog(@"字符串中含有数字");
    //}else{
    //  NSLog(@"字符串中含有非法字符");
    // }
  }
  
  
  return type;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //[self.passValueDelegate passValue:[self.searchCityResults objectAtIndex:[indexPath row]]];
  [self.theSearchBar resignFirstResponder];
  [self selectCityWithDic:[self.searchCityResults objectAtIndex:[indexPath row]]];
  
  
  
  // [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (NSUInteger)selectCityWithDic:(NSDictionary *)aDic{
  //  NSLog(@"selectCityWithTag     %@", [aDic objectForKey:CITYNAME]);
  [self.passValueDelegate passValue:aDic];
  
  
  //----REDRAW CITYCROLLVIEW----//
  [self.cityScrollView removeFromSuperview];
  self.currentCityID = [aDic objectForKey:CITYID2];
  CGRect frame = [[UIScreen mainScreen] 	applicationFrame];
  CGRect rect = frame;
  rect.size.height = rect.size.height - 40.f;
  rect.origin.y =  self.theSearchBar.frame.size.height;
  self.cityScrollView  = [[[CityScrollView alloc] initWithFrame:rect
                                                withHotCityList:self.hotCityList
                                              withCurrentCityID:self.currentCityID] autorelease];
  
  self.cityScrollView.cvdelegate = self;
  [self.view addSubview:self.cityScrollView];
  //----REDRAW CITYCROLLVIEW----//
  [self showWithCustomView:[aDic objectForKey:CITYNAME]];
  //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
  // [self.navigationController popViewControllerAnimated:YES];
  self.navigationItem.title = [@"当前城市:" stringByAppendingString:[aDic objectForKey:CITYNAME]];
  
  return 1;
}


- (IBAction)showWithCustomView:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText = [NSString stringWithFormat:@"选择城市:%@", sender];
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:1];
}
- (NSString *)currentCityName {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *aCity = [defaults objectForKey:@"City"];
  NSString *cityName = [aCity objectForKey:CITYNAME];
  
  if (cityName == nil) {
    cityName = @"未定义";
  }
  
  return cityName;
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
