//
//
//  PLAppDelegate.m
//  ParallelViewController
//
//  Created by xiaoxiang on 11/12/2021.
//  Copyright (c) 2021 xiaoxiang. All rights reserved   .
//

#import "AppDelegate.h"
@import ParallelViewController;
#import "DemoViewController.h"
#import "MainViewController.h"
@interface TabBarViewController : UITabBarController
@end
@implementation TabBarViewController
-(BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers{
    return  YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
@end

@interface AppDelegate()
{
    
}
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DemoViewController * left = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];
    DemoViewController * right = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];

    ParallelNavigationModeViewController * containerController = [[ParallelNavigationModeViewController alloc]initWithLeftViewController:left rightViewController:right];
//    ParallelShoppingModeViewController * containerController = [[ParallelShoppingModeViewController alloc]initWithLeftViewController:tabVC rightViewController:right];

    _window = [[UIWindow alloc]init];
    _window.rootViewController = containerController;
    [_window makeKeyAndVisible];
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

@end
