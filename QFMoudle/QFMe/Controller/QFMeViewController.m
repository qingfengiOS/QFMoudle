//
//  QFMeViewController.m
//  QFMoudle
//
//  Created by 情风 on 2018/11/5.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "QFMeViewController.h"
#import "QFRouter.h"
#import "QFMoudleProtocol.h"

@interface QFMeViewController ()
@property (nonatomic, strong) UIButton *jumpButton;
@end

@implementation QFMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAppreaence];
}

#pragma mark - InitAppreaence
- (void)initAppreaence {
    self.navigationItem.title = @"个人";
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.jumpButton];
}

#pragma mark - Event Response
- (void)buttonAction {
    id <MoudleHome>homeMoudle = [[QFRouter router]interfaceForProtocol:@protocol(MoudleHome)];
    homeMoudle.titleString = @"ModleMe";
    homeMoudle.descString = @"pushed form MeMoudle";
    UIViewController *viewController = homeMoudle.detailViewController;
    homeMoudle.callbackBlock = ^(id parameter) {
        NSLog(@"return paramter = %@",parameter);
    };
    [self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark - Getters
- (UIButton *)jumpButton {
    if (!_jumpButton) {
        _jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpButton setTitle:@"jump detail" forState:UIControlStateNormal];
        _jumpButton.bounds = CGRectMake(0, 0, 100, 50);
        _jumpButton.center = self.view.center;
        _jumpButton.backgroundColor = [UIColor grayColor];
        [_jumpButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpButton;
}
@end


