//
//  SearchViewController.m
//  ddddd
//
//  Created by Zhang Heyin on 13-4-7.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//
#define CITYID2 @"c_id"
#define CITYID @"city_id"

#define CATEGORYID @"cat_id"
#define DISTID @"dist_id"
#define STARTRESULT @"S"
#define NUMBEROFRESULT @"N"
#define ORDER @"O"
#define LATITUDE @"lat"
#define LONGITUDE @"lng"
#define KEYWORD @"q"
static NSString *kSaveKeyMarkerLines = @"SaveKeyMarkerLines";
#import "SearchViewController.h"
#import "YuloreAPI.h"
#import "CityScrollView.h"
#import "DetailViewController.h"
#import "CityViewController.h"
#import "YuloreAPICategory.h"
//#import "MBProgressHUD.h"
#import "TDBadgedCell.h"

#import "UINavigationBar+CustomBackground.h"

@interface SearchViewController ()  <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UIAlertViewDelegate> {
}
//@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchdispalyCtrl;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, assign) BOOL noResultsToDisplay;
@property (nonatomic, retain) NSMutableDictionary *searchCondition;
@property (nonatomic, assign) uint cityID;
@property (nonatomic, retain) NSString *cityTitle;
@property (nonatomic, retain) NSMutableArray *searchHistory;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation SearchViewController
@synthesize tableView = _tableView;
@synthesize theSearchBar = _theSearchBar;
@synthesize searchdispalyCtrl = _searchdispalyCtrl;
@synthesize searchResults = _searchResults;
@synthesize searchCondition = _searchCondition;
@synthesize cityID = _cityID;
@synthesize searchHistory = _searchHistory;
//- (void)setSearchResults:(NSMutableArray *)searchResults {
// _searchResults = searchResults;
//[self.searchDisplayController.searchResultsTableView reloadData];
//}




- (void) loadView {
  [super loadView];
  [self.view setBackgroundColor:[UIColor redColor]];
  self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds
                                                 style:UITableViewStylePlain] autorelease];
  
  [self.tableView setDelegate:self];
  [self.tableView setDataSource:self];
  
  self.theSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-50, 40)] autorelease];
  self.theSearchBar.placeholder = @"information";
  self.theSearchBar.tintColor = kNavigationBarCustomTintColor;
  self.theSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
  //self.theSearchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
  // theSearchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"All",@"A",@"B",@"C",@"D" ,nil];
  self.theSearchBar.showsScopeBar = YES;
  self.theSearchBar.keyboardType = UIKeyboardTypeNamePhonePad;
  //theSearchBar.showsBookmarkButton = YES;
  
  
  
  self.tableView.tableHeaderView = self.theSearchBar;
  //将searchBar添加到tableView的头,注意滚动出屏幕后，搜索框也不在了，只出现在首页
  
  
  
  self.searchdispalyCtrl = [[[UISearchDisplayController  alloc] initWithSearchBar:self.theSearchBar
                                                               contentsController:self] autorelease];
  self.searchdispalyCtrl.active = NO;
  self.searchdispalyCtrl.delegate = self;
  self.searchdispalyCtrl.searchResultsDelegate=self;
  self.searchdispalyCtrl.searchResultsDataSource = self;

  [self.view addSubview:self.tableView];
    [self.theSearchBar becomeFirstResponder];
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    
    
    
    
    
    self.searchResults = [[NSMutableArray alloc] init];
    self.searchCondition = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self currentCityID], CITYID, nil, CATEGORYID, nil, DISTID,nil, STARTRESULT, nil, NUMBEROFRESULT, nil, ORDER, nil, LATITUDE, nil, LONGITUDE, nil, KEYWORD, nil];
//    UIBarButtonItem *switchCity = [[[UIBarButtonItem alloc] initWithTitle:@"switch"
//                                                                    style:UIBarButtonItemStyleBordered
//                                                                   target:self
//                                                                    action:@selector(swicthCity)] autorelease];
//    
//    self.navigationItem.leftBarButtonItem = switchCity;
//    
    
    
    UIBarButtonItem *returnMainViewController = [[[UIBarButtonItem alloc] initWithTitle:@"Return"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(returnMainViewController)] autorelease];
    
    self.navigationItem.rightBarButtonItem = returnMainViewController;
    
  }
  return self;
}


- (void)returnMainViewController {
  [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
//- (void)swicthCity{
//
//  CityViewController *cityViewController = [[CityViewController alloc] initWithNibName:nil bundle:nil];
//  UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
//  [aNavigationController.navigationBar applyCustomTintColor];
//  cityViewController.passValueDelegate = self;
//  [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
//  [aNavigationController release];
//  [cityViewController release];
//}
-(void)viewDidAppear:(BOOL)animated
{
  //frame应在表格加载完数据源之后再设置

  [super viewDidAppear:animated];
 
  //[self.navigationController setNavigationBarHidden:NO];
}
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];

  if ([self loadSearchHistory] == nil) {
    self.searchHistory = [[NSMutableArray alloc] init];
  } else {
    self.searchHistory = [self loadSearchHistory];
      [self.tableView reloadData];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  YuloreAPICategory *apiCategory = [[[YuloreAPICategory alloc] init] autorelease];
  NSArray *level1Category = [apiCategory level1Category];
  NSLog(@"%@", level1Category);

	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    return [self.searchResults count];
  } else {
    return [self.searchHistory count] + 1;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    return 1;
  } else {
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"level1";
  TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier] autorelease];
  }
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    NSDictionary *aShop = [self.searchResults objectAtIndex:[indexPath row]];
    cell.textLabel.text = [aShop objectForKey:@"name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.detailTextLabel.text = [[aShop objectForKey:@"tag"] firstObject];
    cell.badgeString =  [[aShop objectForKey:@"telnumber"] firstObject];
    cell.badgeColor = kNavigationBarCustomTintColor; // [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.badge.fontSize = 12.f;
    cell.badgeLeftOffset = 0.f;
    cell.badgeRightOffset = 0.f;
  } else {
    if ([indexPath row] == [self.searchHistory count]) {
      [cell.textLabel setTextAlignment:UITextAlignmentCenter];
      cell.textLabel.text = @"清空历史记录";
    } else {
      NSDictionary *aShop = [self.searchHistory objectAtIndex:[indexPath row]];
      cell.textLabel.text = [aShop objectForKey:@"name"];
    }
  }
  return cell;
}



#pragma mark - UISearchDisplayController delegate methods


- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
  NSLog(@"searchDisplayControllerWillBeginSearch");
  id cityID = [self.searchCondition objectForKey:CITYID];
  if (cityID == nil) {
    NSLog(@"need select a city");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"还没有选择一个城市" message:@"选择一个要搜索的城市" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
    //[self showTextOnly:nil];
  } else {
    NSLog(@"you has selected a city");
  }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
  
  if ([searchString length]) {

    //if ([self.searchResults count] > 0) {
     // NSLog(@"%d", [self.searchResults count]);
      [self.searchResults removeAllObjects];
    //}
   // dispatch_queue_t q = dispatch_queue_create("queue", 0);
   // dispatch_async(q, ^{
      NSMutableArray *filterArray = [self filterContentForSearchText:searchString
                                                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
     // dispatch_async(dispatch_get_main_queue(), ^{
        self.searchResults = filterArray;
        [self.searchDisplayController.searchResultsTableView reloadData];
     // });
    //});
    //dispatch_release(q);
    
    
    if ([self.searchResults count] == 0) {
      NSLog(@"nuulll");
     // NSDictionary *nuulll = [NSDictionary dictionaryWithObject:@"" forKey:@"name"];
     // [self.searchResults removeAllObjects];
     // self.searchResults = [[NSMutableArray alloc] initWithCapacity:1];
     // [self.searchResults addObject:[NSDictionary dictionaryWithObject:@"" forKey:@"name"]];
    }
    return YES;
  } else {
    return NO;
  }
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
  [self.searchResults removeAllObjects];
  dispatch_queue_t q = dispatch_queue_create("queue", 0);
  dispatch_async(q, ^{
    NSMutableArray *filterArray = [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
           	                                                  scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:searchOption]];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.searchResults removeAllObjects];
      self.searchResults = filterArray;
    });
  });
  dispatch_release(q);
  
  return YES;
}


- (NSMutableArray *)filterContentForSearchText:(NSString*)searchText
                                         scope:(NSString*)scope {
  [self.searchCondition setObject:searchText forKey:KEYWORD];

  return [YuloreAPI executeSearch3:self.searchCondition];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  if (tableView == self.searchDisplayController.searchResultsTableView) {
    NSDictionary *currentShop = [self.searchResults objectAtIndex:[indexPath row]];
    DetailViewController *dVC = [[DetailViewController alloc] initWithShop:currentShop];
    
    [self.navigationController pushViewController:dVC animated:YES];
    [dVC release];
    
    [self.searchHistory addObject:currentShop];
    NSLog(@"%@", self.searchHistory);
    
    [self saveSearchHistory:self.searchHistory];
  } else {
    if ([indexPath row] == [self.searchHistory count]) {
      NSLog(@"to cleaner");
    } else {
      NSDictionary *aShop = [self.searchHistory objectAtIndex:[indexPath row]];
      DetailViewController *dVC = [[DetailViewController alloc] initWithShop:aShop];
      
      [self.navigationController pushViewController:dVC animated:YES];
      [dVC release];

    }
  }
  
  

  
}

//- (void)passValue:(uint)cityID{
//  [self.searchCondition setObject:[NSString stringWithFormat:@"%d",cityID] forKey:CITYID];
//}
//

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    NSLog(@"push city select view controller");
    [self performSelector:@selector(swicthCity)];
  }
}

- (NSString *)currentCityID {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *aCity = [defaults objectForKey:@"City"];
  NSString *cityID = [aCity objectForKey:CITYID2];
  return cityID;
}

- (NSMutableArray *)loadSearchHistory {
  NSMutableArray *record = nil;
  NSString *filePath = [self searchHistoryPath];
  if (filePath == nil || [filePath length] == 0 ||
      [[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
    record = [[[NSMutableArray alloc] init] autorelease];
  } else {
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    if (data == nil) {
      return nil;
    }
    NSKeyedUnarchiver *vdUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    record = [vdUnarchiver decodeObjectForKey:kSaveKeyMarkerLines];
    [vdUnarchiver finishDecoding];
    [vdUnarchiver release];
    [data release];
  }
  return record;
}
- (void)saveSearchHistory:(NSMutableArray *)record {
  //NSLog(@"saveCallRecord %@", record);
  
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *vdArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
  [vdArchiver encodeObject:record forKey:kSaveKeyMarkerLines];
  [vdArchiver finishEncoding];
  [data writeToFile:[self searchHistoryPath] atomically:YES];
  [vdArchiver release];
  [data release];
}

- (NSString *)searchHistoryPath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"SearchHistroy.plist"];
  
  return documentLibraryFolderPath;
}
@end
