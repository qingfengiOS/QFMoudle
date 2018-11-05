//
//  QFRouter.h
//  QFMoudle
//
//  Created by 情风 on 2018/11/5.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFRouter : NSObject<NSCopying,NSMutableCopying>

/**
 单例路由
 
 @return 路由实例
 */
+ (instancetype)router;


/**
 通过协议获取对应的Module
 
 @param protocol 协议
 @return 对应的组件实例（比如ModuleA，ModuleB...）
 */
- (id)interfaceForProtocol:(Protocol *)protocol;


/**
 通过url获取对应的Module
 
 @param url 目标url
 [NSURL URLWithString:@"ModuleA://?paramterA=testA"]
 其中：
 ModuleA表示组件名
 paramterA=testA为对应参数
 
 @return 对应的组件实例（比如ModuleA，ModuleB...）
 */
- (id)interfaceForURL:(NSURL *)url;
@end
