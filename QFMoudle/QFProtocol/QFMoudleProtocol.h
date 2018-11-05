//
//  QFMoudleProtocol.h
//  QFMoudle
//
//  Created by 情风 on 2018/11/5.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QFCallBackBlock)(id parameter);

#pragma mark - 基础协议
@protocol QFMoudleProtocol <NSObject>

/// 暴露给组件外部的控制器，一般为该组件的主控制器
@property (nonatomic, weak) UIViewController *interfaceViewController;

/// 回调
@property (nonatomic, copy) QFCallBackBlock callbackBlock;

@end

#pragma mark - ”首页“组件
@protocol MoudleHome <QFMoudleProtocol>

/// 组件“Home”首页所需要的参数
@property (nonatomic, copy) NSString *paramterForHome;

/// 组件“Home”中详情页面所需要的参数
@property (nonatomic, copy) NSString *titleString;

/// 组件“Home”中详情页面所需要的参数
@property (nonatomic, copy) NSString *descString;

/// 组件“Home”所需要暴露的特殊接口，比如其他组件也要跳转到该页面
@property (nonatomic, weak) UIViewController *detailViewController;

@end

#pragma mark - “我的”组件
@protocol MoudleMe <QFMoudleProtocol>

/// 组件“Me”所需要的参数
@property (nonatomic, copy) NSString *paramterForMe;

@end
