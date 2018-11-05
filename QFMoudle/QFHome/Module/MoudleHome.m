//
//  MoudleHome.m
//  QFMoudle
//
//  Created by 情风 on 2018/11/5.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "MoudleHome.h"
#import "QFHomeViewController.h"
#import "QFDetailViewController.h"
@implementation MoudleHome

@synthesize callbackBlock;

@synthesize detailViewController;

@synthesize interfaceViewController;

@synthesize paramterForHome;

@synthesize titleString;

@synthesize descString;

- (UIViewController *)interfaceViewController {
    QFHomeViewController *homeViewController = [[QFHomeViewController alloc]init];
    homeViewController.interface = self;
    interfaceViewController = (UIViewController *)homeViewController;
    
    return interfaceViewController;
}

- (QFDetailViewController *)detailViewController {
    QFDetailViewController *detailViewController = [[QFDetailViewController alloc]init];
    detailViewController.interface = self;
    return detailViewController;
}


@end
