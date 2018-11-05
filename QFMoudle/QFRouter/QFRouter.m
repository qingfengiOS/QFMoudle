//
//  QFRouter.m
//  QFMoudle
//
//  Created by 情风 on 2018/11/5.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "QFRouter.h"
#import <objc/runtime.h>

@implementation QFRouter

static QFRouter *_router;

#pragma mark - 一个严谨的单例
+ (instancetype)router {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _router = [[self alloc]init];
    });
    return _router;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_router == nil) {
            _router = [super allocWithZone:zone];
        }
    });
    return _router;
}

- (id)copyWithZone:(NSZone *)zone {
    return _router;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _router;
}

#pragma mark - Public
- (id)interfaceForProtocol:(Protocol *)protocol {
    Class class = [self classForProtocol:protocol];
    return [[class alloc]init];
}

- (id)interfaceForURL:(NSURL *)url {
    id result = [self interfaceForProtocol:objc_getProtocol(url.scheme.UTF8String)];
    NSURLComponents *cp = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    [cp.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result setValue:obj.value forKey:obj.name];//KVC设置
    }];
    return result;
}

#pragma mark - Private
- (Class)classForProtocol:(Protocol *)protocol {
    NSString *classString = NSStringFromProtocol(protocol);
    return NSClassFromString(classString);
}


- (void)assertForMoudleWithProtocol:(Protocol *)p {
    if (![self classForProtocol:p]) {
        NSString *protocolName = NSStringFromProtocol(p);
        NSString *clsName = protocolName;
        NSString *reason = [NSString stringWithFormat: @"找不到协议 %@ 对应的接口类 %@ 的实现", protocolName, clsName];
        [self throwException: reason];
    }
}

- (void)assertForMoudleWithURL:(NSURL *)url {
    NSString *protocolName = url.scheme;
    if (![self classForProtocol: objc_getProtocol(protocolName.UTF8String)]) {
        NSString *clsName = protocolName;
        NSString *reason = [NSString stringWithFormat: @"找不到协议 %@ 对应的接口类 %@ 的实现", protocolName, clsName];
        [self throwException: reason];
    }
}

- (void)throwException:(NSString *) reason {
    @throw [NSException exceptionWithName: NSGenericException reason: reason userInfo: nil];
}

@end
