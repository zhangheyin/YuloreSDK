//
//  ViewController.m
//  TestPullTableView
//
//  Created by Zhang Heyin on 13-5-16.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//
#define kMaxCellCount 22
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
#define DARK_BACKGROUND_COLOR   [UIColor colorWithWhite:235.0f/255.0f alpha:1.0f]
#define LIGHT_BACKGROUND_COLOR  [UIColor colorWithWhite:245.0f/255.0f alpha:1.0f]
#import "DAAppObject.h"
#import "DAAppViewCell.h"
#import "ListViewController.h"
#import "PWLoadMoreTableFooterView.h"
#import "YuloreAPI.h"
@interface ListViewController () <PWLoadMoreTableFooterDelegate> {
  PWLoadMoreTableFooterView *_loadMoreFooterView;
	BOOL _datasourceIsLoading;
  bool _allLoaded;
  int cellCount;
}
@property (nonatomic, retain) NSMutableDictionary *condition;
@property (nonatomic, retain) NSString *categoryID;
@property (nonatomic, retain) NSMutableArray *result;
@end

@implementation ListViewController
@synthesize condition = _condition;
@synthesize categoryID = _categoryID;
@synthesize result = _result;
- (void) setCondition:(NSMutableDictionary *)condition{
  _condition = condition;
  
  self.result = [YuloreAPI executeSearch3:condition];
  [self.tableView reloadData];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  CGRect bounds = self.view.bounds;
  
  self.tableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStylePlain];

  //config the load more view
  if (_loadMoreFooterView == nil) {
		
		PWLoadMoreTableFooterView *view = [[PWLoadMoreTableFooterView alloc] init];
		view.delegate = self;
		_loadMoreFooterView = view;
		
	}
  self.tableView.tableFooterView = _loadMoreFooterView;
  
  //*****IMPORTANT*****
  //you need to do this when you first load your data
  //need to check whether the data has all loaded
  //Get the data first time
  cellCount = [self.result count];          //load your data, here is only demo purpose
  [self check];
  //tell the load more view: I have load the data.
  [self doneLoadingTableViewData];
  
  // [self.view addSubview:self.tableView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.backgroundColor = (indexPath.row % 2 ? DARK_BACKGROUND_COLOR : LIGHT_BACKGROUND_COLOR);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  // Return the number of rows in the section.
  return [self.result count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//  static NSString *CellIdentifier = @"EnterpriseName";
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//  if (cell == nil) {
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//  }
//  cell.textLabel.text = @"aCompany.companyName";
//  return cell;
  NSDictionary *aCategory = [self.result objectAtIndex:[indexPath row]];
  //cell.textLabel.text = [aCategory objectForKey:@"name"];
  // Configure the cell...
  DAAppObject *dappObject = [[DAAppObject alloc] init];
  //dappObject.appId = 99;
  //dappObject.artistId = 12;
  dappObject.name = [aCategory objectForKey:@"name"];
  dappObject.genre =  ([[aCategory objectForKey:@"address"] isKindOfClass:[NSNull class]]) ? @"无" : [aCategory objectForKey:@"address"];//[aCategory objectForKey:@"address"];
  // dappObject.iconIsPrerendered = YES;
  dappObject.userRatingCount = 4;
  static NSString *CellIdentifier = @"Cell";
  DAAppViewCell *cell = (DAAppViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[DAAppViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier];
  }
  
  cell.appObject = dappObject;
  
  [dappObject release];
  
  return cell;

}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)check {
  //data source should call this when it can load more
  //when all items loaded, set this to YES;
  if (cellCount >= kMaxCellCount) {               // kMaxCellCount is only demo purpose
    _allLoaded = YES;
  } else
    _allLoaded = NO;
}

- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
	[_loadMoreFooterView pwLoadMoreTableDataSourceDidFinishedLoading];
  [self.tableView reloadData];
  // self.navigationItem.rightBarButtonItem.enabled = YES;
}


#pragma mark -
#pragma mark PWLoadMoreTableFooterDelegate Methods

- (void)pwLoadMore {
  //just make sure when loading more, DO NOT try to refresh your data
  //Especially when you do your work asynchronously
  //Unless you are pretty sure what you are doing
  //When you are refreshing your data, you will not be able to load more if you have pwLoadMoreTableDataSourceIsLoading and config it right
  //disable the navigationItem is only demo purpose
  // self.navigationItem.rightBarButtonItem.enabled = NO;
  _datasourceIsLoading = YES;

  
  /**/
  [self.condition setObject:@"100" forKey:NUMBEROFRESULT];
  self.result = [YuloreAPI executeSearch3:self.condition];
  cellCount = [self.result count];
  [self check];
	_datasourceIsLoading = NO;
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}


- (BOOL)pwLoadMoreTableDataSourceIsLoading {	
  return _datasourceIsLoading;
}
- (BOOL)pwLoadMoreTableDataSourceAllLoaded {
  return _allLoaded;
}

@end
