//
//  DetailViewController.m
//  ddddd
//
//  Created by Zhang Heyin on 13-4-7.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailInfomationView.h"
#import "JSONKit.h"

@interface DetailViewController () 
@property (nonatomic, retain) DetailInfomationView *detailInformationView;
//@property (nonatomic, strong) IBOutlet UILabel *shopNameLable;
@property (nonatomic, retain) NSDictionary *currentShop;
@end

@implementation DetailViewController
@synthesize currentShop = _currentShop;


- (id)initWithShop:(NSDictionary *)aShop {
  self = [super init];
  if (self) {
    self.currentShop = aShop;
    self.detailInformationView = [[[DetailInfomationView alloc] initWithFrame:self.view.bounds withShop:self.currentShop] autorelease];
    [self.view addSubview:self.detailInformationView];

    //NSLog(@"%@", [aShop JSONString]);
  }
  
  return self;
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

@end
