# MVVM+RAC
**采用MVVM设计模式**
[博客链接](http://www.jianshu.com/p/84ce914f22ac)
####前言
本项目的数据为抓包所得，并且都是用的本地数据，只作为学习用途。**项目中所用到的appKey，为了方便调试，不再删除！但是仅作为本项目使用！**

写这个项目之前也是对MVVM及RAC了解止于博客之类，写之前花了几天动手写了RAC的一些demo，然后才正式开始的项目，如果对RAC一点不了解的话，建议先看看RAC及FRP(函数响应式编程)，然后再看本项目。[RACdemo](https://github.com/wangtongke/WTKRacDemo.git)。

![首页](http://upload-images.jianshu.io/upload_images/2455861-68e3709d61e0ba99.gif?imageMogr2/auto-orient/strip)

![搜索](http://upload-images.jianshu.io/upload_images/2455861-42824a76fc121a38.gif?imageMogr2/auto-orient/strip)

![订单](http://upload-images.jianshu.io/upload_images/2455861-da450e798cbbe7c9.gif?imageMogr2/auto-orient/strip)

![分享](http://upload-images.jianshu.io/upload_images/2455861-4f9a069f647b25f7.gif?imageMogr2/auto-orient/strip)

![分类](http://upload-images.jianshu.io/upload_images/2455861-e437e2fda96caf8e.gif?imageMogr2/auto-orient/strip)

![购物车](http://upload-images.jianshu.io/upload_images/2455861-bfaba29b40f7bc36.gif?imageMogr2/auto-orient/strip)
![指纹支付](http://upload-images.jianshu.io/upload_images/2455861-f08d595e4c8a97c1.gif?imageMogr2/auto-orient/strip)

####关于RAC及MVVM
* RAC-函数响应式编程(FRP)的一个重量级的库，学习难度较为陡峭，不过极大的简化代码，统一了消息传递机制。另外就是性能较原生的有一定的差距，当然，硬件的提升这些差距基本上会感觉不到。
* MVVM-不管是MVVM还是MVP、VIEPR或者MV(X)，用意皆在使代码结构清晰、易于维护、易于测试。另外不管是MVC还是MVVM，都有两种情况，1、整个项目一个大的MVC。2、每个模块都有自己的MVC，比如首页的MVC，我的页面的MVC。各有有点吧。
**这两点不再赘述，适合自己的、自己熟悉的才是最好用的**， **另外，新的设计模式会使调试、debug的时间增加很多**

####pod
使用的第三方不多，除了RAC都是一般项目都有的
```
use_frameworks!
platform :ios, ‘8.0’
target “WTKWineMVVM” do
pod 'ReactiveCocoa', '4.2.2'
pod 'AFNetworking', '~> 3.1.0'
pod 'SVProgressHUD', '~> 2.0.3'
pod 'SDWebImage' , '3.7.3'
pod 'Masonry'
pod 'MJRefresh', '~> 3.1.12'
pod 'DZNEmptyDataSet', '~> 1.8.1'
pod 'Reachability', '~> 3.2'
pod 'MJExtension', '~> 3.0.13'
end
```

####Common

![common](http://upload-images.jianshu.io/upload_images/2455861-8d5d7dc6ddfa17ea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
wtk开头的几个是我开发中封装的，这个建议开发中多思考，看那些是可以复用的（或者其他项目可以复用的），都尽量封装起来，方便以后使用。
* WTKQRCode 二维码扫描的，使用的系统的API，已经封装好，[QRCode连接](https://github.com/wangtongke/WTKQRCode.git)。
* WTKStar 星级评价的view，可以支持触摸修改、整形浮点型两种，[WTKStar连接](https://github.com/wangtongke/WTKStarView.git)
* WTKDropView 带动画下拉列表，项目中有两处用到，一个是还第一次写的，没有封装好，第二次时封装了一下，所以还是建议多封装，避免重复写一样的代码。[WTKDropView连接](https://github.com/wangtongke/WTKDropView.git)
* WTKTransition 转场动画，项目中的push、pop动画都是圆形扩散的，项目中用的也是还没有封装好的，需要借助basedViewController来实现，后来封装了一个，两行代码可以实现。使用中，如果某界面有手势与pop手势冲突，把pop手势从view上删除即可。[WTKTransition连接](https://github.com/wangtongke/WTKTransitionAnimate.git)

####Based
这里面包括了`tabbarController、navigationController、basedViewController、basedViewModel、viewModelServices、viewModelNavigationImpl`

#####tabbarController
tabbarController主要有添加子控制器、广告页、监听badgeValue、读取本地数据、自定义切换动画，
* 切换动画
![切换动画.gif](http://upload-images.jianshu.io/upload_images/2455861-fbfa35844d68fba8.gif?imageMogr2/auto-orient/strip)

```
- (void)beginAnimation
{
    CATransition *animation         = [[CATransition alloc]init];
    animation.duration              = 0.5;
    animation.type                  = kCATransitionFade;
    animation.subtype               = kCATransitionFromRight;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.accessibilityFrame    = CGRectMake(0, 64, kWidth, kHeight);
    [self.view.layer addAnimation:animation forKey:@"switchView"];
}
```
* 监听bageValue
  实际上就是监听购物车的总数(单例类的一个属性)，然后设置下标，这里使用RACObserver代替KVO实现。
```
    @weakify(self);
    [RACObserve([WTKUser currentUser], bageValue) subscribeNext:^(id x) {
        @strongify(self);
        UIViewController *vc = self.viewControllers[3];
        NSInteger num = [x integerValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (num > 0)
            {
                [vc.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",num]];
            }
            else
            {
                [vc.tabBarItem setBadgeValue:nil];
            }
        });
    }];
```

#####navigationController
 一般项目中，只有一级界面显示tabbar，所以有许多地方push的时候都会隐藏，所以在navigation中，可以实现push方法，然后隐藏，其他地方都不用再处理
```
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
```
另外navigation还有转场动画相关的代理，不再多说。

##### BasedViewController
basedVC主要是配置一些通用的东西，比如属性viewModel、背景色、返回按钮以及MVVM的核心Bind（绑定）方法。使用basedVC的好处就是一处配置，整个项目通用。
```
    if (self.navigationController && self != self.navigationController.viewControllers.firstObject)
    {
        [self resetNaviWithTitle:@""];
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePopRecognizer:)];
        [self.view addGestureRecognizer:popRecognizer];
        popRecognizer.delegate = self;
    }
```
如果不是一级页面，则会自动添加返回按钮。
bindViewModel
```
- (void)bindViewModel
{
    RAC(self.navigationItem,title)     = RACObserve(self.viewModel, title);
}
```
这里只是完成了title的绑定，因为每次push的都是viewModel而不是viewController，所以viewModel也声明了一个title的属性。

#####basedViewModel
主要是实现了构建方法、登录相关。
```
- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params
{
    self = [super init];
    if (self)
    {
        self.title      = params[@"title"];
        self.params     = params;
        self.services   = service;
    }
    return self;
}
```
每次创建需要传一个service和param，service用来push，不过这个项目一开始并没有用这个，所以比较遗憾。param用来传值，title必须有！！。

#####WTKViewModelServices协议
协议，协议方法为push、pop等，
```
- (void)pushViewModel:(WTKBasedViewModel *)viewModel animated:(BOOL)animated;

- (void)popViewControllerWithAnimation:(BOOL)animated;

- (void)popToRootViewModelWithAnimation:(BOOL)animated;

- (void)presentViewModel:(WTKBasedViewModel *)viewModel animated:(BOOL)animated complete:(void(^)())complete;
///模态弹出vc，用于alert
- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated complete:(void(^)())complete;
```
由于一开始并没有想的太多，所以一开始并没有写模态，以至于需要弹出alert的时候，需要把vc传给viewModel。后来才加上的这个协议，所以一个好的架构师相当的重要。

#####WTKViewModelNavigationImpl
实现了`WTKViewModelServices`协议，也就是push、pop都会走这里。由于最后还要pushViewController，而viewModel里面也没有包含vc，所以push的时候，还要指定vc的name，也是一个缺陷吧。
*push方法
```
WTKRecommendViewModel *viewModel = [[WTKRecommendViewModel alloc]initWithService:self.services params:@{@"title":@"推荐有奖"}];
                self.naviImpl.className = @"WTKRecommendVC";
                [self.naviImpl pushViewModel:viewModel animated:YES];
```

####Tools

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/2455861-c539bbf3a1a895f9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
有按功能创建的工具类，还有各种公用的tool，
* dataManager 主要是用户数据相关的一些方法，保存、读取、删除。
* shoppingManager 存储购物车数据。
* requestManager 网络请求类。 使用了RAC，一般网络请求的block也使用了RACSignal代替，方法中传一个signal，或者返回一个signal。这里选择了返回一直signal。
```
 + (RACSignal *)postDicDataWithURL:(NSString *)urlString
                     withpramater:(NSDictionary *)paremater
{
    CGFloat time = arc4random()%15 / 10.0;
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:urlString ofType:nil]];
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:dic];
        [subscriber sendCompleted];
        return nil;
    }] delay:time];
}
```
由于是加载的本地数据，所以模拟了网络延迟。
* WTKTool 项目中一些常用的方法（分享、登录、购物车动画、指纹验证等等）
**如果是用AFN请求数据，则用下面的方法**
```
 + (RACSignal *)getWithURL:(NSString *)urlString withParamater:(NSDictionary *)paramter
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    RACSubject *sub =[ RACSubject subject];
    [manager GET:urlString parameters:paramter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [sub sendNext:@{@"code":@100,@"data":responseObject}];
        [sub sendCompleted];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [sub sendNext:@{@"code":@-400,@"data":@"请求失败"}];
        [sub sendCompleted];
    }];
    return sub;
}
```
RACSubject为RACSignal的子类，可以允许先创建，再发送信号，所以使用RACSubject。
* mapManager 地图相关。

#### 实现
* 因为多用绑定，并且函数响应式编程，只需要关心结果，所以项目中基本所有的属性基本都用懒加载，避免绑定时还没有创建

---
下面以几个页面来说一下MVVM具体使用。
---
---
* #####  homeVC
viewDidLoad
```
 - (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPop) name:@"wtk_cancelPop" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self bindViewModel];
    [self configView];
}
```
非常简短，监听取消侧滑返回，绑定viewModel，初始化view。
下面主要说说`bindViewModel`
跟viewDidLoad一样，需要在bindViewModel中实现`[super bindViewModel]`
绑定数据
```
    @weakify(self);
//    绑定数据
    RAC(self.collectionView,headArray)  = RACObserve(self.viewModel, headData);
    RAC(self.collectionView,dataArray)  = RACObserve(self.viewModel,dataArray);
    
    self.collectionView.mj_header       = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.refreshCommand execute:self.collectionView];
    }];
    [self.collectionView.mj_header beginRefreshing];
//    navi
    RAC(self,leftButton.rac_command)    = RACObserve(self.viewModel, naviCommand);
```
解释一下，RAC(...)把某个对象的属性与信号绑定起来。这里把collectionView的dataArray与viewModel的dataArray绑定。
collectionView的刷新方法，让viewModel的refreshCommand执行，并且把collectionView传递过去。
另外，RAC把许多类都添加的属性，一般都是control有关的。比如最后一行的leftbtn的rac_command。

* ##### homeViewModel
实现了业务相关的逻辑、网络请求。 .h文件如下
```
 /**刷新数据*/
 @property(nonatomic,strong)RACCommand   *refreshCommand;

 @property(nonatomic,strong)NSArray      *headData;

 @property(nonatomic,strong)NSArray      *dataArray;
 ///头视图
 @property(nonatomic,strong)RACCommand   *headCommand;

 ///中间按钮点击
 @property(nonatomic,strong)RACCommand   *btnCommand;

 ///good
 @property(nonatomic,strong)RACCommand   *goodCommand;

 ///导航栏
 @property(nonatomic,strong)RACCommand   *naviCommand;

 @property(nonatomic,strong)RACSubject   *searchSubject;
```
collectionView不需要再实现传递事件的block，只需要把viewModel传给collectionView，点击方法中执行响应的command即可。

* ##### categoryVC（分类）
```
 - (void)bindViewModel
 {
    [super bindViewModel];
    @weakify(self);
    [self.viewModel.refreshCommand      execute:@[self.leftTableView,self.rightTableView]];
  //    绑定数据
    RAC(self,leftDataArray)             = RACObserve(self.viewModel, leftArray);
    RAC(_rightTableView,sectionArray)   = RACObserve(self.viewModel, leftArray);
    RAC(_rightTableView,dataDic)        = RACObserve(self.viewModel, dataDic);
    RAC(self.siftView,dataArray)        = RACObserve(self.viewModel, selectArray);
    self.rightTableView.mj_header       = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.refreshCommand execute:@[self.leftTableView,self.rightTableView]];
    }];
 //    右侧tableView滑动
    [self.viewModel.rightCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        NSIndexPath *indexPath = x;
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }];
 //    需要传值，所以不这样写
 //    RAC(self.rightBtn,rac_command)      = RACObserve(self.viewModel, selectedCommand);
 //    点击筛选按钮
    [[self.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self resetSiftView];
        if (self.isFirstSift)
        {
            [self.viewModel.selectedCommand execute:@[self.leftTableView,self.rightTableView,self.siftView]];
            self.isFirstSift = NO;
        }
    }];
 //    移除siftView
    [self.siftView.dismissSubject subscribeNext:^(id x) {
 //       消失
        @strongify(self);
        [self.viewModel beginDismissAnimation:@[self.leftTableView,self.rightTableView]];
    }];
 }
```
先刷新数据，并且把left、right tableView传过去，供刷新使用。
绑定数据，绑定刷新方法，button使用rac的话，一种是直接绑定它的rac_command，另外一种就是上面代码的那种，如果绑定rac_command，则传过去的只是一个btn，需要其他传值的时候，使用上面的方法。

* #####cateViewModel
 * requestManager的用法
```
        RACSignal *signal   = [WTKRequestManager postArrayDataWithURL:@"CategoryAllGoods" withpramater:@{}];
        [signal subscribeNext:^(id x) {
//            NSLog(@"%@",x);
            [leftTableView reloadData];
            [rightTableView reloadData];
            [SVProgressHUD dismiss];
            if([rightTableView.mj_header isRefreshing])
            {
                [rightTableView.mj_header endRefreshing];
            }
        }];
```
获取网络请求的signal,然后订阅即可。

* ##### shoppingCarVC
购物车界面则主要是价格的监听，删除、选中物品的逻辑。只有本次启动app后添加到购物车的商品才会默认选中，读取的本地购物车数据，默认没有选中。
为了简便处理，给商品添加了一个w_isSelected属性，表示是否选中。
全选按钮：
```
    [[self.selectAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.isClickAllBtn = YES;
        self.viewModel.isClickAllBtn = YES;
        UIButton *btn = x;
        btn.selected = !btn.selected;
        SHOPPING_MANAGER.flag = NO;
        NSArray *array = [SHOPPING_MANAGER.goodsDic allValues];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WTKGood *good = obj;
            good.w_isSelected = btn.selected;
            if (idx == array.count - 1)
            {
                [self.tableView w_reloadData];
                SHOPPING_MANAGER.goodsDic;
            }
        }];
    }];
RAC(self.selectAllBtn,selected)  = RACObserve(self.viewModel, btnState);
```
isClickAllBtn，标志当前是否为点击按钮。
* ##### shoppingCarViewModel
主要说一下监听价格
```
// - 监听价格
    [RACObserve([WTKShoppingManager manager], changed) subscribeNext:^(id x) {
        static BOOL isFirst;//是否是第一次检测到没有选中。用来避免多次改变selectAllBtn
        isFirst                 = YES;
        SHOPPING_MANAGER.flag   = YES;
        NSDictionary *dic       = SHOPPING_MANAGER.goodsDic;
        [[dic allValues] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            WTKGood *good = obj;
            if(isFirst && !good.w_isSelected && !self.isClickAllBtn)
            {
//                self.selectAllBtn.selected = !self.selectAllBtn;
                isFirst = NO;
                self.btnState = NO;
            }
            if (idx == 0)
            {
                SHOPPING_MANAGER.price = 0;
            }
            if (good.w_isSelected)
            {
                SHOPPING_MANAGER.price += good.price * good.num;
            }
            if (idx == [dic allValues].count - 1 && isFirst && !self.isClickAllBtn)
            {
                self.btnState = YES;
            }
            if(idx == [dic allValues].count - 1)
            {
                //                self.isClickAllBtn = NO;
                self.isClickAllBtn = NO;
            }
//            self.priceLabel.text    = [NSString stringWithFormat:@"共¥ %.2f",SHOPPING_MANAGER.price];
            self.price = [NSString stringWithFormat:@"共¥ %.2f",SHOPPING_MANAGER.price];
        }];
            SHOPPING_MANAGER.flag = NO;
        [self.emptySubject sendNext:@([dic allValues].count)];
    }];
```
由于不能监听数组、字典等容器类属性，所以在shoppingManager中，声明了一个change的属性，监听这个属性来获取实时的购物车数据。每次添加、删除购物车数据，都会改变change这个属性，来传递数据。flag属性来判断当前是操作购物车数据还是监听，监听的话就不再改变change，以避免死循环。

* ##### goodVC（商品详情）
商品详情为h5页面，不再多说。评论的cell，带图的和不带图的使用的是同一个cell，合理的利用cell，会减少不必要的冗余。

![评论](http://upload-images.jianshu.io/upload_images/2455861-7089ad65cb183dc8.gif?imageMogr2/auto-orient/strip)

* ##### loginVC
这个项目除了cell只有这一个页面使用的xib布局，登录页面使用MVVM更加典型，所以详细解释一下这个页面。

![login.gif](http://upload-images.jianshu.io/upload_images/2455861-50bb9da694dd6013.gif?imageMogr2/auto-orient/strip)
首先是viewDidLoad
```
 - (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, 0.99)] forBarMetrics:UIBarMetricsDefault];
}
```
`initView`主要是设置view的相关属性，不多说。
`bindViewModel`

```
- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    RAC(self.viewModel,phoneNum)            = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel,codeNum)             = self.psdTextField.rac_textSignal;
    RAC(self.loginBtn,enabled)              = self.viewModel.canLoginSignal;
    RAC(self.codeBtn,enabled)               = self.viewModel.canCodeSignal;
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.codeCommand execute:x];
    }];
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.loginCommand execute:x];
    }];
    [self.viewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        if ([x[@"code"] integerValue] == 100)
        {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
```
前两个个RAC(self.viewModel,phoneNum) = textField.rac_textSignal
把textField的text赋值给viewModel的phoneNum,并不是只赋值一次，每一次textField改变，都会重新给phoneNum赋值.
RAC(self.loginBtn,enable) = self.viewModel.canLoginSignal
把viewModel的`canLoginSignal`赋值给loginBtn的enable属性，控制loginBtn的状态.
下面两个block为登录和获取验证码按钮的点击方法，也可以写成下面这样的
```
RAC(self.codeBtn,rac_command)   = RACObserve(self.viewModel, codeCommand)
```
也就是点击按钮，viewModel的command会执行。

* ##### loginViewModel
代码：
```
 - (void)initViewModel
 {
     @weakify(self);
    RACSignal *phoneSignal      = [RACObserve(self, phoneNum) map:^id(id value) {
        @strongify(self);
        return @([self isPhoneNum:value]);
    }];
    RACSignal *codeSignal       = [RACObserve(self, codeNum) map:^id(id value) {
        @strongify(self);
        return @([self isCodeNum:value]);
    }];
    self.canLoginSignal         = [RACSignal combineLatest:@[phoneSignal,codeSignal]
                                                    reduce:^id(NSNumber *phone,NSNumber *code){
        return @([phone boolValue] && [code boolValue]);
    }];
    self.canCodeSignal          = [RACSignal combineLatest:@[phoneSignal]
                                                    reduce:^id(NSNumber *phone){
        return @([phone boolValue]);
    }];
    self.codeCommand            = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        UIButton *btn           = input;
        btn.enabled             = NO;
        self.time               = 60;
        [btn setTitle:[NSString stringWithFormat:@"%ld",self.time] forState:UIControlStateNormal];
       __block NSTimer *timer   = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCodeTime:) userInfo:btn repeats:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [timer invalidate];
            timer               = nil;
            btn.enabled         = YES;
            [btn setTitle:@"验证" forState:UIControlStateNormal];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random() % 12 / 15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SHOW_SUCCESS(@"发送成功");
            DISMISS_SVP(1.2);
            
        });
        return [RACSignal empty];
    }];
    self.loginCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [WTKTool login];
        CURRENT_USER.phoneNum   = self.phoneNum;
        [WTKDataManager saveUserData];
        SHOW_SUCCESS(@"登录成功");
        DISMISS_SVP(1);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@{@"code":@100}];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"信号被销毁");
            }];
        }];
    }];
 }

 - (BOOL)isPhoneNum:(NSString *)phoneNum
 {
    if ([phoneNum hasPrefix:@"1"])
    {
        return phoneNum.length == 13;
    }
    return NO;
 }
 - (BOOL)isCodeNum:(NSString *)code
{
    return [code integerValue] == self.code;
}
```
* `phoneSignal` - 监听phoneNum，并且判断当前的phoneNum是否为正确的手机号。
* `codeSignal`与phoneSignal相同，判断当前code是否为正确的验证码（是否等于@“1234”）。
* `self.canLoginSignal` - 将phoneSignal与codeSignal合并成一个信号，如果两个同时为YES，则canLoginSignal会发一个内容YES的信号。登录页面的loginBtn的enable会根据信号的内容而改变。
* `self.canCodeSignal`与canLoginSignal类似，不过不是两个信号的合并。
* `self.codeCommand`，codeBtn的点击方法，与MVVM无关，不再多说.
* `self.loginCommand`,登录方法，处理一些登录的逻辑。
下面两个方法为判断手机号及验证码的相关逻辑。

### 总结
使用MVVM+RAC写完这个项目，感觉很不错，很屌的框架，根本就停不下来。就算不用MVVM，也建议使用一下RAC框架开发试试。简化、统一，就是不大量使用RAC，也可以使用它代替原来的代理、block、通知，把回调、代理之类的写一个函数里，使得一个业务的代码写在一个地方，比如项目中`我的`页面的导航栏渐变。并且使用通知及KVO，不用在dealloc中移除了，RAC已经处理。
不过由于RAC由cocoa的OOP变成了FRP，使得学习曲线陡峭，所以并没有被大规模的采纳，并且刚入手时，debug时间也会增加。
如果对你有帮助，可以在git上给个star，会持续更新。
[项目连接](https://github.com/wangtongke/WTKMVVMRAC.git)
