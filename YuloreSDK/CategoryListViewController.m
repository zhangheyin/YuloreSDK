//
//  CategoryListViewController.m
//  ddddd
//
//  Created by Zhang Heyin on 13-4-16.
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

#import "CategoryListViewController.h"
#import "YuloreAPI.h"
#import "DetailViewController.h"
@interface CategoryListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary *condition;
@property (nonatomic, retain) NSString *categoryID;
@property (nonatomic, retain) NSMutableArray *result;
@end

@implementation CategoryListViewController
@synthesize tableView = _tableView;
@synthesize categoryID = _categoryID;
@synthesize result = _result;
@synthesize condition = _condition;
- (void) setCondition:(NSMutableDictionary *)condition{
  _condition = condition;
  
  self.result = [YuloreAPI executeSearch3:condition];

  
  
  [self.tableView reloadData];
}


- (void)loadView {
  [super loadView];
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  
  [self.view addSubview:self.tableView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization

  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSLog(@"%@", self.categoryID);
  [self.tableView setDataSource:self];
  [self.tableView setDelegate:self];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.result count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"level1";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }
  NSDictionary *aCategory = [self.result objectAtIndex:[indexPath row]];
  cell.textLabel.text = [aCategory objectForKey:@"name"];
  // Configure the cell...
  return cell;
}
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  NSDictionary *currentShop = [self.result objectAtIndex:[indexPath row]];
  DetailViewController *dVC = [[DetailViewController alloc] initWithShop:currentShop];
  
  [self.navigationController pushViewController:dVC animated:YES];
  [dVC release];
  
  
}

@end
