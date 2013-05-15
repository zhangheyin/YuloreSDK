//
//  MainViewController.h
//  YuloreSDK
//
//  Created by Zhang Heyin on 13-4-25.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"
@class QuoteCell;
@interface MainViewController :  UITableViewController <SectionHeaderViewDelegate>

@property (nonatomic, strong) NSArray* plays;
@property (nonatomic, retain) IBOutlet QuoteCell *quoteCell;

@end



