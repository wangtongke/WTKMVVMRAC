**iOS7推出了新的转场动画API，以协议id<UIViewControllerInterativeTransition>、id<UIViewAnimatedTransitioning>方式开放给开发者，不同于代理、类别，这样更易于我们自定义动画，更加灵活。下面介绍一下自定义转场动画**


![仿酷狗push](http://upload-images.jianshu.io/upload_images/2455861-b55c0066271dd571.gif?imageMogr2/auto-orient/strip)

![push](http://upload-images.jianshu.io/upload_images/2455861-0bdf47402e5e012b.gif?imageMogr2/auto-orient/strip)
##### 要使用的协议
* UIViewControllerInteractiveTransitioning 交互协议，主要在右滑返回时用到
* UIViewControllerAnimatedTransitioning 动画协议，含有动画时间及转场上下文两个必须实现协议
* UIViewControllerContextTransitioning 动画协议里边的协议之一，动画实现的主要部分
* UIPrecentDrivenInteractiveTransition 用在交互协议，百分比控制当前动画进度。

##### 自定义步骤
* 首先要实现navigation的代理，navigation有两个返回id类型的协议，实现这两个协议

第一个方法返回一个UIPercentDrivenInterativeTransition类型的对象即可，这个对象默认实现了UIPercentInterativeTransitioning协议，`需要注意的是，这个返回值主要是用于交互动画，也就是右滑返回时需要用到`，这里我在基类baseViewController定义了一个UIPercentDrivenInterativeTransition类型的属性。
      - (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(WTKBaseAnimation*) animationControlle{
    return animationControlle.interactivePopTransition;
}
第二个方法我自定义了一个遵循UIViewControllerAnimationTransitioning协议的类`WTKBaseAnimation`,

<pre><code>
      - (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(WTKBaseViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (fromVC.interactivePopTransition)
    {
        WTKBaseAnimation *animation = [[WTKBaseAnimation alloc]initWithType:operation Duration:0.6 animateType:self.animationType];
        animation.interactivePopTransition = fromVC.interactivePopTransition;
        return animation; //手势
    }
    else
    {
        WTKBaseAnimation *animation = [[WTKBaseAnimation alloc]initWithType:operation Duration:0.6 animateType:self.animationType];
        return animation;//非手势
    };}

</code></pre>
第二个方法返回对象自定义如下
![baseAnimation构建方法.png](http://upload-images.jianshu.io/upload_images/2455861-0b2d5589dc2a2eb2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
也就是需要把navigation的代理方法中的参数都传过来。
在本类中，需要实现转场动画协议：
      -  (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;}

    - (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (self.transitionType == UINavigationControllerOperationPush)
    {
        [self push:transitionContext];
    }
    else if (self.transitionType == UINavigationControllerOperationPop)
    {
        [self pop:transitionContext];
    }}   

` [self push:transitionContext];` `[self pop:transitionContext];`在本类中并没有真正的实现，具体交给子类实现
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/2455861-8fd12606df70ffbe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    - (void)push:(id<UIViewControllerContextTransitioning>)transitionContext{}
    - (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext{}

下面介绍子类的具体实现，
### push
|
<pre><code>- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController * fromVc   = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIViewController * toVc     = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    NSTimeInterval duration     = [self transitionDuration:transitionContext];

    CGRect bounds               = [[UIScreen mainScreen] bounds];
    
    fromVc.view.hidden          = YES;

    [[transitionContext containerView] addSubview:toVc.view];

    [[toVc.navigationController.view superview] insertSubview:fromVc.snapshot belowSubview:toVc.navigationController.view];

    toVc.navigationController.view.transform = 
CGAffineTransformMakeTranslation(CGRectGetWidth(bounds), 0);
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVc.snapshot.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(bounds) * 0.3, 0);
                         toVc.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished) {
                         fromVc.view.hidden = NO;
                         [fromVc.snapshot removeFromSuperview];
                         [transitionContext completeTransition:YES];
    }];
    }
</code></pre>
其中fromVC与toVC、为函数参数transitionContext协议获得，duration调用父类方法获得，最终为navigation的代理方法中返回的时间，也可以自定义。fromVC为原来的ViewController，toVC为要push的VC
首先将fromVC的view隐藏，使用VC的`snapshot`代替，`snapshot`为viewController的截图，这里使用类别关联属性实现的。
`[transitionContext containerView]` 为容器，存转场需要的view，
分别将toVC.view及fromVC.snapshot添加到容器中，注意添加顺序、view存放的顺序。

下面将toVC移动到屏幕右边，这里使用的是改变transform，

使用UIView做动画，需要注意的是，使用`usingSpringWithDamping`的动画，关于这个动画不再多说。
UIView动画，需要把fromVC移动到左边（移动多少可自定），toVC移动到右边。
动画完成后，需要把原来隐藏的fromVC.view显示，添加到容器的view移除，当前显示的vc不需要移除。
** 最后需要调用转场完成方法** `[transitionContext completeTransition:YES];`

### Pop
|
<pre><code>
      - (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext {

    WTKBaseViewController * fromVc  = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController * toVc         = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration         = [self transitionDuration:transitionContext];
    
    CGRect bounds                   = [[UIScreen mainScreen] bounds];
    
    [fromVc.view addSubview:fromVc.snapshot];
    fromVc.navigationController.navigationBar.hidden = YES;
    fromVc.view.transform = CGAffineTransformIdentity;
    
    toVc.view.hidden                = YES;
    toVc.snapshot.transform         = CGAffineTransformMakeTranslation(-CGRectGetWidth(bounds) * 0.3, 0);
    
    [[transitionContext containerView] addSubview:toVc.view];
    [[transitionContext containerView] addSubview:toVc.snapshot];
    [[transitionContext containerView] sendSubviewToBack:toVc.snapshot];

    if (fromVc.interactivePopTransition)
    {
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVc.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bounds), 0.0);
                             toVc.snapshot.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {

                             toVc.navigationController.navigationBar.hidden = NO;
                             toVc.view.hidden = NO;

                             [fromVc.snapshot removeFromSuperview];
                             [toVc.snapshot removeFromSuperview];
                             fromVc.snapshot = nil;

                             if (![transitionContext transitionWasCancelled]) {
                                 toVc.snapshot = nil;
                             }

                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];

    }
    else
    {
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVc.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bounds), 0.0);
                             toVc.snapshot.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {

                             toVc.navigationController.navigationBar.hidden = NO;
                             toVc.view.hidden = NO;

                             [fromVc.snapshot removeFromSuperview];
                             [toVc.snapshot removeFromSuperview];
                             fromVc.snapshot = nil;

                             if (![transitionContext transitionWasCancelled]) {
                                 toVc.snapshot = nil;
                             }

                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }}

</code></pre>

pop方法与push类似，不再多说，需要注意的是** 一定要区分手势和非手势 **，也就是如果点击按钮返回，需要使用`usingSpringWithDamping`动画，右滑返回不使用这个。
判断方式`fromVc.interactivePopTransition`，这个为在基类baseViewController里边自定义的一个UIPercentDrivenInterativeTransition类型的属性，也就是navigation代理方法`- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(WTKBaseAnimation*) animationControlle`的返回值。
    
* 在baseViewController中添加手势:UIPanGestureRecognizer,添加到self.view上面，viewDidLoad中如下：

<pre><code>
    if (self.navigationController && self != self.navigationController.viewControllers.firstObject)
    {
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePopRecognizer:)];
        [self.view addGestureRecognizer:popRecognizer];
        popRecognizer.delegate = self;
    }

</code></pre>
在手势方法中创建UIPercentInterativeTransition，在拖动过程中，用这个实例变量调用`updateInteractiveTransition`方法，代码如下

<pre><code>
  
    - (void)handlePopRecognizer:(UIPanGestureRecognizer *)recognizer{
    CGFloat progress = [recognizer translationInView:self.view].x / CGRectGetWidth(self.view.frame);
    progress = MIN(1.0, MAX(0.0, progress));
    NSLog(@"progress---%.2f",progress);
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        if (progress > 0.25)
        {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }}

</code></pre>
上面定义的`progress`，为了记录滑动的百分比，随时更新`interactivePopTransition`  当手势结束,根据progress判断当前是否可以pop回来，这里是以0.25为标准。