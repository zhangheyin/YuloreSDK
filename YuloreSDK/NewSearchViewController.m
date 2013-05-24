//
//  NewSearchViewController.m
//  YuloreSDK
//
//  Created by Zhang Heyin on 13-5-22.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//
#define CITYID2 @"c_id"
#define CITYID @"city_id"
static NSString *kSaveKeyMarkerLines = @"SaveKeyMarkerLines";
#define CATEGORYID @"cat_id"
#define DISTID @"dist_id"
#define STARTRESULT @"S"
#define NUMBEROFRESULT @"N"
#define ORDER @"O"
#define LATITUDE @"lat"
#define LONGITUDE @"lng"
#define KEYWORD @"q"
#import "TDBadgedCell.h"
#import "NewSearchViewController.h"
#import "YuloreAPI.h"
#import "UIImage+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "ListViewController.h"
@interface NewSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableDictionary *searchCondition;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, retain) NSMutableArray *searchHistory;
@end

@implementation NewSearchViewController
@synthesize searchResults = _searchResults;
@synthesize theSearchBar = _theSearchBar;
@synthesize tableView = _tableView;
@synthesize searchCondition = _searchCondition;
@synthesize isSearching = _isSearching;
@synthesize searchHistory = _searchHistory;

- (void)loadView {
  [super loadView];
  self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds
                                                 style:UITableViewStylePlain] autorelease];
  
  [self.tableView setDelegate:self];
  [self.tableView setDataSource:self];
  
  self.theSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-50, 40)] autorelease];
  [[self.theSearchBar.subviews objectAtIndex:0] setHidden:YES];
  [[self.theSearchBar.subviews objectAtIndex:0] removeFromSuperview];
  for (UIView *subview in self.theSearchBar.subviews){
    if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
      [subview removeFromSuperview];
      break;
    }
  }
  
  self.theSearchBar.placeholder = @"information";
  self.theSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
  //self.theSearchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
  // theSearchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"All",@"A",@"B",@"C",@"D" ,nil];
  self.theSearchBar.showsCancelButton = NO;
  self.theSearchBar.showsScopeBar = YES;
  self.theSearchBar.keyboardType = UIKeyboardTypeNamePhonePad;
  self.theSearchBar.delegate = self;
  
  self.tableView.tableHeaderView = self.theSearchBar;
  
  [self.view addSubview:self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGRect rect = self.tableView.tableFooterView.frame;
  rect.origin.y = MIN(0, self.tableView.contentOffset.y);
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.isSearching = NO;
    self.searchResults = [[NSMutableArray alloc] init];
    self.searchCondition = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self currentCityID], CITYID, nil, CATEGORYID, nil, DISTID,nil, STARTRESULT, nil, NUMBEROFRESULT, nil, ORDER, nil, LATITUDE, nil, LONGITUDE, nil, KEYWORD, nil];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setImage:[UIImage cancelButtonImageWithColor:[UIColor peterRiverColor] barMetrics:UIBarMetricsDefault cornerRadius:0] forState:UIControlStateNormal];
    [button setImage:[UIImage cancelButtonImageWithColor:[UIColor belizeHoleColor] barMetrics:UIBarMetricsDefault cornerRadius:0] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dismissNavgationController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [cancelButton setAction:@selector(dismissNavgationController)];
    [cancelButton setTarget:self];
    self.navigationItem.rightBarButtonItem = cancelButton;
    [cancelButton release];
  }
  return self;
}

- (void)dismissNavgationController {
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)currentCityID {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *aCity = [defaults objectForKey:@"City"];
  NSString *cityID = [aCity objectForKey:CITYID2];
  return cityID;
}
- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)filterContentForSearchText:(NSString*)searchText {
  [self.searchCondition setObject:searchText forKey:KEYWORD];
  
  return [YuloreAPI executeSearch3:self.searchCondition];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
  self.isSearching = YES;
  NSLog(@"%@", searchText);
  [self.searchResults removeAllObjects];
  dispatch_queue_t q = dispatch_queue_create("queue", 0);
  dispatch_async(q, ^{
    NSMutableArray *filterArray = [self filterContentForSearchText:searchText];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.searchResults removeAllObjects];
      self.searchResults = filterArray;
      [self.tableView reloadData];
    });
  });
  dispatch_release(q);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  NSLog(@"searchBarCancelButtonClicked");
  searchBar.text=@"";
  [searchBar setShowsCancelButton:NO animated:YES];
  [searchBar resignFirstResponder];
  self.isSearching = NO;
  self.searchHistory = [self loadSearchHistory];
  [self.tableView reloadData];
  
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  [searchBar setShowsCancelButton:YES animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.isSearching ? [self.searchResults count] : [self.searchHistory count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"level1";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:CellIdentifier] autorelease];
  }
  if (self.isSearching) {
    
    NSDictionary *aShop = [self.searchResults objectAtIndex:[indexPath row]];
    cell.textLabel.text = [aShop objectForKey:@"name"];
    //    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    //    cell.detailTextLabel.text = [[aShop objectForKey:@"tag"] firstObject];
    //    cell.badgeString =  [[aShop objectForKey:@"telnumber"] firstObject];
    //    cell.badgeColor =  [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.badge.fontSize = 12.f;
    //    cell.badgeLeftOffset = 0.f;
    //    cell.badgeRightOffset = 0.f;
    return cell;
  } else {
    static NSString *CellIdentifier = @"history";
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                    reuseIdentifier:CellIdentifier];
    if ([indexPath row] == [self.searchHistory count]) {
      UILabel *title = [[UILabel alloc] initWithFrame:cell.bounds];
      [title setText:@"清空历史记录"];
      [title setTextAlignment:UITextAlignmentCenter];
      [cell.contentView addSubview:title];
      // [cell.textLabel setTextAlignment:UITextAlignmentCenter];
      // cell.textLabel.text = @"清空历史记录";
    } else {
      cell.textLabel.text = [self.searchHistory objectAtIndex:[indexPath row]];
    }
    return cell;
    
  }

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

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  if ([self loadSearchHistory] == nil) {
    self.searchHistory = [[NSMutableArray alloc] init];
  } else {
    self.searchHistory = [self loadSearchHistory];
    [self.tableView reloadData];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (self.isSearching) {
    NSDictionary *currentShop = [self.searchResults objectAtIndex:[indexPath row]];
    
    
    for (uint i = 0; i < [self.searchHistory count] ; i++) {
      if ([[currentShop objectForKey:@"name"] isEqualToString:[self.searchHistory objectAtIndex:i]]) {
        [self.searchHistory removeObject:[self.searchHistory objectAtIndex:i]];
        break;
      }
    }
    [self.searchHistory insertObject:[currentShop objectForKey:@"name"] atIndex:0];

    [self saveSearchHistory:self.searchHistory];

    NSDictionary *aShop = [self.searchResults objectAtIndex:[indexPath row]];
    NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
    [condition setObject:[self currentCityID] forKey:CITYID];
    [condition setObject:[aShop objectForKey:@"name"] forKey:KEYWORD];
    ListViewController *viewController = [[ListViewController alloc] init];
    //[viewController performSelector:@selector(setCategoryID:) withObject:q.identity];
    [viewController performSelector:@selector(setCondition:) withObject:condition];
    
    [self.navigationController pushViewController:viewController animated:YES];

  } else {
    if ([indexPath row] == [self.searchHistory count]) {
      NSLog(@"to cleaner");
      [self.searchHistory removeAllObjects];
      [self saveSearchHistory:self.searchHistory];
      [self.tableView reloadData];
    } else {
      NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
      [condition setObject:[self currentCityID] forKey:CITYID];
      [condition setObject:[self.searchHistory objectAtIndex:indexPath.row] forKey:KEYWORD];
      ListViewController *viewController = [[ListViewController alloc] init];
      //[viewController performSelector:@selector(setCategoryID:) withObject:q.identity];
      [viewController performSelector:@selector(setCondition:) withObject:condition];
      
      [self.navigationController pushViewController:viewController animated:YES];
      
    }
  }
  
}

- (NSString *)searchHistoryPath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"SearchHistroy.plist"];
  
  return documentLibraryFolderPath;
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

@end
