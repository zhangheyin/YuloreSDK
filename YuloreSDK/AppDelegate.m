//
//  AppDelegate.m
//  YuloreSDK
//
//  Created by Zhang Heyin on 13-4-25.
//  Copyright (c) 2013年 Yulore. All rights reserved.
//

#import "AppDelegate.h"
#import "UINavigationBar+CustomBackground.h"
#import "AHReach.h"
#import "UINavigationBar+FlatUI.h"
#import "UIColor+FlatUI.h"

@interface AppDelegate()<UIAlertViewDelegate> {
  
}
@end

@implementation AppDelegate
@synthesize mainViewController = _mainViewController;

- (void)dealloc
{
  [_window release];
  [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  NSLog(@"didFinishLaunchingWithOptions");
  AHReach *hostReach = [AHReach reachForHost:@"www.yulore.com"];
	[hostReach startUpdatingWithBlock:^(AHReach *reach) {
    NSLog(@"%@", reach);
		BOOL status = [self updateAvailabilityWithReach:reach];
    
    if (status == NO) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"网络链接失败"
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"OK", nil];
      [alertView show];
    } else {
      [self cityListToFile];
      [self preDownloadJson];
    }
	}];
  
  return YES;
}


- (void)createSearchHistory {
  NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"SearchHistroy.plist"];
  if ([[NSFileManager defaultManager] fileExistsAtPath:documentLibraryFolderPath]) {
    NSLog(@"文件已经存在了");
  }else {
    
    [[NSFileManager defaultManager] createFileAtPath:documentLibraryFolderPath
                                            contents:nil
                                          attributes:nil];
  }
}

- (BOOL)updateAvailabilityWithReach:(AHReach *)reach {
	
  //field.text = @"Not reachable";
	
	if([reach isReachableViaWWAN])
		NSLog(@"Available via WWAN"); //field.text = @"Available via WWAN";
	if([reach isReachableViaWiFi])
		NSLog(@"Available via WiFi");
  if (![reach isReachable]) {
    NSLog(@"Available via isUNReachable");
    return NO;
  }
  return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)hotCityListToFile {
  
  NSString *urlString = @"http://w10.test.yulore.com/api/city.php?hot=1";
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  
  if (jsonData != nil) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"hotcity.json"];
    
    [jsonData writeToFile:documentLibraryFolderPath atomically:YES];
  }
  
  
}
- (void)cityListToFile {
  
  NSString *urlString = @"http://w10.test.yulore.com/api/city.php";
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  
  if (jsonData != nil) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"city.json"];
    
    [jsonData writeToFile:documentLibraryFolderPath atomically:YES];
  }
  
}

- (void)categoryToFile {
  
  NSString *urlString = @"http://w10.test.yulore.com/api/category.php";
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
  
  if (jsonData != nil) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"category.json"];
    
    [jsonData writeToFile:documentLibraryFolderPath atomically:YES];
  }
  
}




- (void) preDownloadJson {
  dispatch_group_t taskGroup = dispatch_group_create();
  dispatch_queue_t mainQueue = dispatch_get_main_queue();
  dispatch_group_async(taskGroup, mainQueue, ^{
    [self categoryToFile];
    NSLog(@"categoryToFile");
  });
  dispatch_group_async(taskGroup, mainQueue, ^{
    [self hotCityListToFile];
    NSLog(@"hotCityListToFile");
  });
  dispatch_group_async(taskGroup, mainQueue, ^{
    [self cityListToFile];
    NSLog(@"cityListToFile");
  });
  
  dispatch_group_notify(taskGroup, mainQueue, ^{
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.mainViewController = [[[MainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    
    //[aNavigationController.navigationBar configureFlatNavigationBarWithColor:kNavigationBarCustomTintColor];
    [aNavigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    //[aNavigationController.navigationBar applyCustomTintColor];
    self.window.rootViewController = aNavigationController;
    [aNavigationController release];
    
    
    self.window.backgroundColor = [UIColor midnightBlueColor];
    [self.window makeKeyAndVisible];
    
  });
  dispatch_release(taskGroup);
  
}

@end
