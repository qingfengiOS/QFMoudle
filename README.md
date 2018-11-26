# QFMoudle
一个极其轻量级的组件化实践

## 前言  
说起组件化大家应该都不陌生，不过也再提一下，由于业务的复杂度扩展，各个模块之间的耦合度越来越高，不但造成了“牵一发动全身”的尴尬境地，还增加了测试的重复工程，此时，组件化就值得考虑了。组件化就是将APP拆分成各个组件（或者说模块），同时解除这些组件之间的耦合，然后通过路由中间件将项目所需要的组件结合起来。这样做的好处有：      

- 解耦合，增强可移植性，不用再自身业务模块中大量引入其他业务的头文件。
- 提高复用性，如果其他项目中有类似的功能，直接将模块引入稍作修改就能使用了。 
- 减少测试成本，当修改或者迭代某个小组件的过程中就不用进行大规模的回归测试。    

网上关于组件化的方案不少，流传最广的是[蘑菇街组件化的技术方案](https://limboy.me/tech/2016/03/10/mgj-components.html)和[iOS应用架构谈 组件化方案](https://casatwy.com/iOS-Modulization.html)这里不对大佬们的方案妄加评价，感兴趣的同学可以自己看看。这里我们聊聊另外的一种方式[Protocol-Moudle](https://github.com/qingfengiOS/QFMoudle)  

## 思路
在iOS中，[协议（Protocol）](https://juejin.im/post/5bda59da5188257f8f1e1a02)**定义了一个纲领性的接口，所有类都可以选择实现。它主要是用来定义一套对象之间的通信规则。protocol也是我们设计时常用的一个东西，相对于直接继承的方式，protocol则偏向于组合模式。他使得两个毫不相关的类能够相互通信，从而实现特定的目标。**  

在之前的一篇文章[ResponderChain+Strategy+MVVM实现一个优雅的TableView](https://juejin.im/post/5bd6c734e51d45410c10eb54)中我们用到了protocol来为View提供公共的方法:  

```- (void)configCellDateByModel:(id<QFModelProtocol>)model;```  

为Model提供公共的方法:

```
- (NSString *)identifier;
- (CGFloat)height;
```
那么我们也可以以此来构建一个轻量级的路由中间件，定义一套各个组件的通信规则，各自管理和维护各自的模块，对外提供必要的接口。  

## 实践
首先看一下这个Demo的结构图和运行效果  
![结构](https://user-gold-cdn.xitu.io/2018/11/8/166f372c2073a148?w=540&h=1270&f=png&s=211387) 

![效果](https://user-gold-cdn.xitu.io/2018/11/8/166f374df5170fcc?w=227&h=420&f=gif&s=4773661)

### 路由
好了我们看看路由的一些细节，它只需要提供两个关键的东西：  

1. 提供路由器单例  
2. 获取对应的Moudle 
	- 通过Protocol获取
	- 通过URL获取

首先提供单例：  

```
+ (instancetype)router {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _router = [[self alloc]init];
    });
    return _router;
}
```
这样的单例可能没有人不会写，but，这其实这仅仅是个“假的”单例，不信你可以使用```[QFRouter router]``` 和```[[QFRouter alloc]init]```以及```[router copy]```试试他们会不会生成三个内存地址不同的实例。可能你会说，谁会无聊这么干？但是如果设计的时候能更严谨的规避这种坑不会更好么。  那么怎么才能才能做一个严谨的单例呢？可以重写他的```alloc```和```copy```方法避免创建多个实例,你可以在[Demo工程](https://github.com/qingfengiOS/QFMoudle)中看到细节，这里不做展开。  

回归正题，我们看看如何获取Module   

通过Runtime的反射机制，我们可以通过NSString获取一个class进而创建对应的对象，而Protocol又可以得到一个NSString，那么是否可以由此入手呢？答案是可以的：    

```
- (Class)classForProtocol:(Protocol *)protocol {
    NSString *classString = NSStringFromProtocol(protocol);
    return NSClassFromString(classString);
}
```
这里传入一个protocol即可获取对应的Module的class，再通过class即可以得到对应的Module的object。  

通过Protocol或者URL获取对应的Module：

```
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

```
这里有个瑕疵就是调用方（外部组件）需要知道这个目标组件对外暴露的协议名称，不过既然是协议，对外公开应该不算大问题吧,调用实例如下：  
wayOne：

```
id <MoudleHome>homeMoudle = [[QFRouter router]interfaceForProtocol:@protocol(MoudleHome)];
```
这样就拿到了对应的目标组件实例，通过对外暴露的属性可以对其进行传值，通过其回调block则可以拿到回调参数。  

wayTwo：  

```
id <MoudleMe>meMoudle = [[QFRouter router]interfaceForURL:[NSURL URLWithString:@"MoudleMe://?paramterForMe=ModuleMe"]];
```
这里通过url传入，通过KVC设置其属性值。同样地，通过其回调block则可以拿到回调参数。  

### 公共协议  
通过上面我们了解到：通过Protocol可以获取对应的组件实例，那么这个协议放在哪儿？如何管理呢?   
在日常开发过程中，跨组件的交互场景最多的应该就是：从组件A附带参数跳转到组件B的某个页面，组件B的这个页面中做一些操作，再回到组件A（可能有回调参数，也可能不回调参数），那么我们的协议应该能处理这两个最常见和基础的操作，所以给protocol定义了两个属性：  

```
typedef void(^QFCallBackBlock)(id parameter);

#pragma mark - 基础协议
@protocol QFMoudleProtocol <NSObject>

/// 暴露给组件外部的控制器，一般为该组件的主控制器
@property (nonatomic, weak) UIViewController *interfaceViewController;
/// 回调参数
@property (nonatomic, copy) QFCallBackBlock callbackBlock;

@end
```

>这里的interfaceViewController为何声明成了weak属性？这个问题先留一下，后面会聊到这一点。

有了这里的两个属性我们即可完成，对应的跳转和参数回调，但是如何正向传值呢？  

应该还需要对应的属性来做入参,但是组件何其多，入参何其多，如果都把正向的属性写入这里面，那么随着时间和业务的增长，这个协议可能会十分杂乱和臃肿。  

所以这里把这个协议定为基础协议，对应的组件都继承自它，然后定义各自的需要的入参属性：  

首页组件：

```
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

```
可以看到，由于首页组件需要对外暴露一个主页面 ```QFHomeViewController``` 和详细页面 ``QFDetailViewController``所以参数会多一点。

我的组件：  

```
#pragma mark - “我的”组件
@protocol MoudleMe <QFMoudleProtocol>

/// 组件“Me”所需要的参数
@property (nonatomic, copy) NSString *paramterForMe;

@end
```
而“我的”组件，只对外提供一个```QFMeViewController```页面，参数比较简单。  

这样，基本算是达成了对协议的处理，但是无可避免的问题就是: 这个公共协议中定义了各个组件的协议，所以需要对多个开发团队可见，感觉这也是组件化过程中的一个普遍问题，目前没找到好的解决方式。 


### Module  
上面我们说到了公开protocol中定义了一些属性，比如```interfaceViewController``` 那么这些属性由谁提供呢？没错，就是Module，通过上面的步骤我们可以获取到对应的Module实例，但是我们跳转需要的是Controller，所以，在此时就需要Module的帮助了, Module通过公共协议定义的属性为外部提供Controller接口：

```
- (UIViewController *)interfaceViewController {
    QFHomeViewController *homeViewController = [[QFHomeViewController alloc]init];
    homeViewController.interface = self;
    interfaceViewController = (UIViewController *)homeViewController;
    return interfaceViewController;
}
```
因为Module是在对应的组件中，所以可以随意引用自己组件内部的头文件完成初始化，  
而对应的控制器中，需要组件外部的参数，所以这里把Module实例也暴露给对应的控制器实例，也就是```homeViewController.interface = self;```所做的事情。  

>在上面说协议的时候我们提到为什么要使用weak，至此，应该比较明朗了 ———— 打破循环强引用。

通过公共协议解耦获取到Module，Module完成为组件内和组件外的搭桥铺路工作，由此，使得跨组件传值、调用、参数回调得以实现。更多细节请看[QFMoudle](https://github.com/qingfengiOS/QFMoudle.git)。  

由于时间关系，如何制作私有库就不再赘述了，有需要欢迎留言，我们一起手把手创建一个属于你自己的pod私有库。   

## 后记
在这种组件化的实践中，一般会把对应的组件、路由以及公共协议做成pod私有库，而需要多个团队知道的也就只有这个公共协议库，把所有的协议放入这个公开协议库中，每次升级也只需要更新这个库就好了。    

关于对组件化的态度：上面说了那么多好处，下面说说弊端（亲身体会）  
如果团队规模较小业务复杂度较低的话，不太建议做私有库，原因：  

1. 它的 修改 -> 升级 -> 集成 -> 测试是一个比较耗时的过程，可能一点小小的改动（比如改个颜色，换个背景）需要耗费成倍的时间。 
2. 增加项目的调用复杂度，增加新成员的熟悉成本。

任何事情都是双面的，有利有弊，望各位看官自行取舍。最后由于笔者文笔有限，若给您造成了困扰，实在抱歉，有任何疑问or意见or建议，欢迎交流讨论，当然，如果对您有用，希望顺手给个Star，点个关注。赠人玫瑰，手留余香，您的支持是我最大的动力！

