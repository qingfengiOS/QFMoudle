//
//  QFDetailViewController.m
//  QFMoudle
//
//  Created by 情风 on 2018/11/5.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "QFDetailViewController.h"
#import "MoudleHome.h"

@interface QFDetailViewController ()
/// 描述Label
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation QFDetailViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAppreaence];
}

- (void)dealloc {
    NSLog(@"%@ dealloc resumed",NSStringFromClass([self class]));
}

#pragma mark - InitAppreaence
- (void)initAppreaence {
    self.navigationItem.title = self.interface.titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self.view addSubview:self.descLabel];
    self.descLabel.text = self.interface.descString;
}

#pragma mark - Event Response
- (void)backAction {
    if (self.interface.callbackBlock) {
        self.interface.callbackBlock(@"callBack paramter");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.bounds = CGRectMake(0, 0, 200, 100);
        _descLabel.center = self.view.center;
        _descLabel.numberOfLines = 0;
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}

@end
