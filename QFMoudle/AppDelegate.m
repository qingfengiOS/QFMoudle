//
//  AppDelegate.m
//  QFMoudle
//
//  Created by 情风 on 2018/11/5.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "AppDelegate.h"
#import "QFRouter.h"
#import "QFMoudleProtocol.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
     测试一个严谨的单例，需要重写alloc copy mutableCopy方法
     */
    QFRouter *r1 = [QFRouter router];
    QFRouter *r2 = [[QFRouter alloc]init];
    QFRouter *r3 = [r1 copy];
    QFRouter *r4 = [r1 mutableCopy];
    NSLog(@"\n%p\n%@\n%@\n%@",r1,r2,r3,r4);
    
    // Home组件
    id <MoudleHome>homeMoudle = [[QFRouter router]interfaceForProtocol:@protocol(MoudleHome)];
    homeMoudle.paramterForHome = @"MoudleHome";
    UIViewController *homeViewController = homeMoudle.interfaceViewController;
    UINavigationController *homeNavi = [[UINavigationController alloc]initWithRootViewController:homeViewController];
    homeNavi.tabBarItem.title = @"首页";
    homeNavi.tabBarItem.image = [UIImage imageNamed:@"home"];
    
    // Me组件
    id <MoudleMe>meMoudle = [[QFRouter router]interfaceForURL:[NSURL URLWithString:@"MoudleMe://?paramterForMe=ModuleMe"]];
    UIViewController *meViewConterller = meMoudle.interfaceViewController;
    UINavigationController *meNavi = [[UINavigationController alloc]initWithRootViewController:meViewConterller];
    meNavi.tabBarItem.title = @"个人";
    meNavi.tabBarItem.image = [UIImage imageNamed:@"me"];
    
    // tabbr和window
    UITabBarController *tabbarController = [[UITabBarController alloc]init];
    tabbarController.viewControllers = @[homeNavi,meNavi];
    _window.rootViewController = tabbarController;
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
