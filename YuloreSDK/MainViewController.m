//
//  MainViewController.m
//  YuloreSDK
//
//  Created by Zhang Heyin on 13-4-25.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
#define DARK_BACKGROUND_COLOR   [UIColor colorWithWhite:235.0f/255.0f alpha:1.0f]
#define LIGHT_BACKGROUND_COLOR  [UIColor colorWithWhite:245.0f/255.0f alpha:1.0f]
#import "Quotation.h"
@interface QuoteCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *characterLabel;
//@property (nonatomic, weak) IBOutlet UILabel *actAndSceneLabel;
//@property (nonatomic, weak) IBOutlet HighlightingTextView *quotationTextView;

@property (nonatomic, retain) Quotation *quotation;

@end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
#import "UIBarButtonItem+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIColor+FlatUI.h"
#define DEFAULT_ROW_HEIGHT 35
#define HEADER_HEIGHT 35
#define CITYID @"city_id"
#define CITYID2 @"c_id"
#define CITYNAME @"c_name"
#define CATEGORYID @"cat_id"
#define DISTID @"dist_id"
#define STARTRESULT @"S"
#define NUMBEROFRESULT @"N"
#define ORDER @"O"
#define LATITUDE @"lat"
#define LONGITUDE @"lng"
#define KEYWORD @"q"
#import "MainViewController.h"
#import "CityViewController.h"
#import "UINavigationBar+CustomBackground.h"
#import "YuloreAPICategory.h"
//#import "QuoteCell.h"
//#import "HighlightingTextView.h"
#import "SectionInfo.h"
#import "SectionHeaderView.h"
#import "YuloreAPI.h"
//#import "Play.h"
#import "Quotation.h"
//#import "CategoryListViewController.h"
#import "ListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NewSearchViewController.h"
#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]
@interface MainViewController () <PassValueDelegate>
@property (nonatomic, strong) NSString *cityTitle;
@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic, retain) NSIndexPath* pinchedIndexPath;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) CGFloat initialPinchHeight;
@property (nonatomic, retain) NSMutableDictionary *condition;
// Use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously.
@property (nonatomic, assign) NSInteger uniformRowHeight;
@property (nonatomic, retain) NSArray *level1Category;
-(void)updateForPinchScale:(CGFloat)scale atIndexPath:(NSIndexPath*)indexPath;

@end

@implementation MainViewController
@synthesize condition = _condition;

@synthesize level1Category = _level1Category;
@synthesize plays=plays_, sectionInfoArray=sectionInfoArray_, quoteCell=newsCell_, pinchedIndexPath=pinchedIndexPath_, uniformRowHeight=rowHeight_, openSectionIndex=openSectionIndex_, initialPinchHeight=initialPinchHeight_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    [self.view setBackgroundColor:[UIColor peterRiverColor]];
  }
  return self;
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

}
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.condition = [[NSMutableDictionary alloc] init];
  [UIBarButtonItem configureFlatButtonsWithColor:[UIColor peterRiverColor] highlightedColor:[UIColor belizeHoleColor] cornerRadius:3];
  
  UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
  self.navigationItem.rightBarButtonItem = searchButton;
  [searchButton release];
  
  UIBarButtonItem *switchCity = [[UIBarButtonItem alloc] initWithTitle:[self currentCityName] style:UIBarButtonItemStylePlain target:self action:@selector(switchCity)];
  [switchCity setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Bold" size:15.0], UITextAttributeFont,nil] forState:UIControlStateNormal];

  
  self.navigationItem.leftBarButtonItem = switchCity;
  [switchCity release];

  
  [self setUpPlaysArray2];
  // Add a pinch gesture recognizer to the table view.
  //	UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
  //	[self.tableView addGestureRecognizer:pinchRecognizer];
  
  // Set up default values.
  self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	/*
   The section info array is thrown away in viewWillUnload, so it's OK to set the default values here. If you keep the section information etc. then set the default values in the designated initializer.
   */
  rowHeight_ = DEFAULT_ROW_HEIGHT;
  openSectionIndex_ = NSNotFound;
	// Do any additional setup after loading the view.
  

  
  
  
  
}



- (void)selectCityFirstTime {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *aCity = [defaults objectForKey:@"City"];

  
  if (![aCity objectForKey:CITYNAME]) {
    //告知城市为空
    [self switchCity];
    
  }
}
- (void)switchCity{
//  CATransition *animation = [CATransition animation];
//  [animation setDuration:0.35f];
//  [animation setType:kCATransitionMoveIn];
//  [animation setSubtype:kCATransitionFromTop];
//  [animation setFillMode:kCAFillModeForwards];
//  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
  
//  [view.layer addAnimation:animation forKey:nil];
  CityViewController *cityViewController = [[CityViewController alloc] initWithNibName:nil bundle:nil currentCityID:[self currentCityID]];

  UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
  [aNavigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
  //[aNavigationController.navigationBar applyCustomTintColor];
  cityViewController.passValueDelegate = self;
 // [aNavigationController.view.layer addAnimation:animation forKey:nil];
  [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
  [aNavigationController release];
  [cityViewController release];
}
- (void)search {
  
  //SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:nil bundle:nil];
  NewSearchViewController *newSearchViewController = [[NewSearchViewController alloc] initWithNibName:nil bundle:nil];
  UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:newSearchViewController];
  
  
  //[aNavigationController.navigationBar applyCustomTintColor];
    [aNavigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
  //searchViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  newSearchViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;



  
  
  
  [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
  [newSearchViewController release];
 // [searchViewController release];
  [aNavigationController release];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)passValue:(NSDictionary *)aCity  {
  self.cityTitle = [aCity objectForKey:CITYNAME];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:aCity forKey:@"City"];
  [defaults synchronize];
  [self.navigationItem.leftBarButtonItem setTitle:self.cityTitle];
  //[self.searchCondition setObject:[NSString stringWithFormat:@"%d",cityID] forKey:CITYID];
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

- (NSString *)currentCityID {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *aCity = [defaults objectForKey:@"City"];
  NSString *cityID = [aCity objectForKey:CITYID2];
  return cityID;
}

- (void)setUpPlaysArray2 {
  YuloreAPICategory *apiCategory = [[[YuloreAPICategory alloc] init] autorelease];
  NSArray *level1Category = [apiCategory level1Category];
  NSMutableArray *playsArray = [NSMutableArray arrayWithCapacity:[level1Category count]];
  for (NSDictionary *aLeve1Category in level1Category) {
   // NSLog(@"%@", aLeve1Category);
    Play *play = [[[Play alloc] init] autorelease];
    play.name = [aLeve1Category objectForKey:@"name"];
    
    
    NSArray *singleCategory = [apiCategory level2Category:aLeve1Category];
    
    
    NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:[singleCategory count]];
    for (NSDictionary *aCategory in singleCategory) {
      Quotation *quotation = [[[Quotation alloc] init] autorelease];
      // [quotation setValuesForKeysWithDictionary:aCategory];
      quotation.character = [aCategory objectForKey:@"name"];
      quotation.identity = [aCategory objectForKey:@"id"];
      [quotations addObject:quotation];
    }
    play.quotations = quotations;
    
    [playsArray addObject:play];
  }
  
  self.plays = playsArray;
  
}


-(BOOL)canBecomeFirstResponder {
  
  return YES;
}




#pragma mark Table view data source and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  
  return [self.plays count];
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	NSInteger numStoriesInSection = [[sectionInfo.play quotations] count];
	
  return sectionInfo.open ? numStoriesInSection : 0;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  
  static NSString *QuoteCellIdentifier = @"QuoteCellIdentifier";
  
  QuoteCell *cell = (QuoteCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
  
  if (!cell) {
    cell = [[QuoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuoteCellIdentifier ];
    
    
    //UINib *quoteCellNib = [UINib nibWithNibName:@"QuoteCell" bundle:nil];
    //[quoteCellNib instantiateWithOwner:self options:nil];
    //cell = self.quoteCell;
    // self.quoteCell = nil;
  }
  
  Play *play = (Play *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
  cell.quotation = [play.quotations objectAtIndex:indexPath.row];
  
  return cell;
}


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
  /*
   Create the section header views lazily.
   */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
  if (!sectionInfo.headerView) {
		NSString *playName = sectionInfo.play.name;
    sectionInfo.headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:playName section:section delegate:self];
  }
  
  return sectionInfo.headerView;
}
- (BOOL)shouldAutorotate {
  return NO;
}


- (NSInteger)supportedInterfaceOrientations {
  return 0;
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
  
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
  return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
  // Alternatively, return rowHeight.
}


-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  
  Play *play = (Play *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
  Quotation *q = [play.quotations objectAtIndex:[indexPath row]];
  NSLog(@"didSelectRowAtIndexPath %@", q.identity);
  //cell.quotation = [play.quotations objectAtIndex:indexPath.row];
  [self.condition setObject:q.identity forKey:CATEGORYID];
  [self.condition setObject:[self currentCityID] forKey:CITYID];
 /* CategoryListViewController *clvc = [[CategoryListViewController alloc] initWithNibName:nil bundle:nil];
  //[clvc performSelector:@selector(setCategoryID:) withObject:q.identity];
  [clvc performSelector:@selector(setCondition:) withObject:self.condition];
  [self.navigationController pushViewController:clvc  animated:YES];*/
  ListViewController *viewController = [[ListViewController alloc] init];
  [viewController performSelector:@selector(setCategoryID:) withObject:q.identity];
  [viewController performSelector:@selector(setCondition:) withObject:self.condition];
  viewController.title = q.character;
  [self.navigationController pushViewController:viewController animated:YES];
  
  //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Section header delegate

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
  
  /*
   Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
   */
  NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
  NSMutableArray *indexPathsToInsert = [[[NSMutableArray alloc] init] autorelease];
  for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
  }
  
  /*
   Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
   */
  NSMutableArray *indexPathsToDelete = [[[NSMutableArray alloc] init] autorelease];
  
  NSInteger previousOpenSectionIndex = self.openSectionIndex;
  if (previousOpenSectionIndex != NSNotFound) {
		
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
    previousOpenSection.open = NO;
    [previousOpenSection.headerView toggleOpenWithUserAction:NO];
    NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
      [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
    }
  }
  
  // Style the animation so that there's a smooth flow in either direction.
  UITableViewRowAnimation insertAnimation;
  UITableViewRowAnimation deleteAnimation;
  if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
    insertAnimation = UITableViewRowAnimationFade;
    deleteAnimation = UITableViewRowAnimationFade;
  } else {
    insertAnimation = UITableViewRowAnimationFade;
    deleteAnimation = UITableViewRowAnimationFade;
  }
  
  // Apply the updates.
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
  [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
  [self.tableView endUpdates];
  self.openSectionIndex = sectionOpened;
  
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
  
  /*
   Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
   */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
  sectionInfo.open = NO;
  NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
  
  if (countOfRowsToDelete > 0) {
    NSMutableArray *indexPathsToDelete = [[[NSMutableArray alloc] init] autorelease];
    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
      [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
  }
  self.openSectionIndex = NSNotFound;
}


#pragma mark Handling pinches


-(void)handlePinch:(UIPinchGestureRecognizer*)pinchRecognizer {
  
  if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
    
    CGPoint pinchLocation = [pinchRecognizer locationInView:self.tableView];
    NSIndexPath *newPinchedIndexPath = [self.tableView indexPathForRowAtPoint:pinchLocation];
		self.pinchedIndexPath = newPinchedIndexPath;
    
		SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:newPinchedIndexPath.section];
    self.initialPinchHeight = [[sectionInfo objectInRowHeightsAtIndex:newPinchedIndexPath.row] floatValue];
    // Alternatively, set initialPinchHeight = uniformRowHeight.
    
    [self updateForPinchScale:pinchRecognizer.scale atIndexPath:newPinchedIndexPath];
  }
  else {
    if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
      [self updateForPinchScale:pinchRecognizer.scale atIndexPath:self.pinchedIndexPath];
    }
    else if ((pinchRecognizer.state == UIGestureRecognizerStateCancelled) || (pinchRecognizer.state == UIGestureRecognizerStateEnded)) {
      self.pinchedIndexPath = nil;
    }
  }
}


-(void)updateForPinchScale:(CGFloat)scale atIndexPath:(NSIndexPath*)indexPath {
  
  if (indexPath && (indexPath.section != NSNotFound) && (indexPath.row != NSNotFound)) {
    
		CGFloat newHeight = round(MAX(self.initialPinchHeight * scale, DEFAULT_ROW_HEIGHT));
    
		SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    [sectionInfo replaceObjectInRowHeightsAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:newHeight]];
    // Alternatively, set uniformRowHeight = newHeight.
    
    /*
     Switch off animations during the row height resize, otherwise there is a lag before the user's action is seen.
     */
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:animationsEnabled];
  }
}




- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
  [self.tableView reloadData];
	NSLog(@"viewWillAppear");
  /*
   Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
   */
	if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
		
    // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[[NSMutableArray alloc] init] autorelease];
		
		for (Play *play in self.plays) {
			
			SectionInfo *sectionInfo = [[[SectionInfo alloc] init] autorelease];
			sectionInfo.play = play;
			sectionInfo.open = NO;
			
      NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
			NSInteger countOfQuotations = [[sectionInfo.play quotations] count];
			for (NSInteger i = 0; i < countOfQuotations; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
		}
		
		self.sectionInfoArray = infoArray;
	}
	
}

- (void)viewDidUnload {
  			
  [super viewDidUnload];
  
  // To reduce memory pressure, reset the section info array if the view is unloaded.
	self.sectionInfoArray = nil;

}

- (BOOL)hasSelectCity {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  id aCity = [defaults objectForKey:@"City"];
  
  return aCity ? YES : NO;
}
@end



@class HighlightingTextView;
@class Quotation;




//#import "HighlightingTextView.h"

@implementation QuoteCell

@synthesize characterLabel/*, quotationTextView, actAndSceneLabel*/, quotation;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.characterLabel = [[UILabel alloc] initWithFrame:CGRectMake(53.f, 2.f, 247.f, 25.f)];
    [self.characterLabel setTextColor:[UIColor whiteColor]];
    self.characterLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.characterLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.characterLabel];
    [self.contentView setBackgroundColor:[UIColor peterRiverColor]];
  }
  
  return self;
}

- (void)setQuotation:(Quotation *)newQuotation {
  
  if (quotation != newQuotation) {
    quotation = newQuotation;
    
    characterLabel.text = quotation.character;
    // actAndSceneLabel.text = [NSString stringWithFormat:@"Act %d, Scene %d", quotation.act, quotation.scene];
    // quotationTextView.text = quotation.quotation;
  }
}



@end