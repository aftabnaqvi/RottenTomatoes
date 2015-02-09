//
//  AppDelegate.m
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/4/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"
#import "DVDViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Create the tab bar controller
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	
	// create a tab control
	self.window.rootViewController = tabBarController;
	
	MoviesViewController *moviesViewController = [[MoviesViewController alloc]init];
	DVDViewController *dvdViewController = [[DVDViewController alloc]init];
	
	UIImage *image = [[UIImage imageNamed:@"movie.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	//moviesViewController.tabBarItem.image = [self imageWithImage:image scaledToSize:CGSizeMake(30, 30)];
	
	moviesViewController.tabBarItem.image = image;
	
	dvdViewController.tabBarItem.image = [[UIImage imageNamed:@"DVD.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	
	UINavigationController *mnvc = [[UINavigationController alloc]initWithRootViewController:moviesViewController];
	
	UINavigationController *dnvc = [[UINavigationController alloc]initWithRootViewController:dvdViewController];
	
	mnvc.tabBarItem.title = @"Movies";
	dnvc.tabBarItem.title = @"DVDs";
	
	tabBarController.tabBar.barTintColor = [UIColor colorWithRed:205.0f/255.0f
															green:153.0f/255.0f
															blue:255.0f/255.0f
															alpha:1.0f];
	
	tabBarController.viewControllers = @[mnvc, dnvc];
	
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	return YES;
	
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
