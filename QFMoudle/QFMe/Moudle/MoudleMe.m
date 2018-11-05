//
//  MoudleMe.m
//  QFMoudle
//
//  Created by 情风 on 2018/11/5.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "MoudleMe.h"
#import "QFMeViewController.h"

@implementation MoudleMe

@synthesize callbackBlock;

@synthesize interfaceViewController;

@synthesize paramterForMe;


- (UIViewController *)interfaceViewController {
    
    QFMeViewController *interfaceViewController = [[QFMeViewController alloc]init];
    interfaceViewController.interface = self;
    
    return (UIViewController *)interfaceViewController;
}

@end
