//
//  ViewController.m
//  TestPullTableView
//
//  Created by Zhang Heyin on 13-5-16.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//
#define kMaxCellCount 22
#import "ViewController.h"
#import "PWLoadMoreTableFooterView.h"
@interface ViewController () <PWLoadMoreTableFooterDelegate>{
  PWLoadMoreTableFooterView *_loadMoreFooterView;
	BOOL _datasourceIsLoading;
  bool _allLoaded;
  int cellCount;
}

@end

@implementation ViewController

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
  cellCount = 15;          //load your data, here is only demo purpose
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  // Return the number of rows in the section.
  return cellCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"EnterpriseName";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  cell.textLabel.text = @"aCompany.companyName";
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
  cellCount +=-1;
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
