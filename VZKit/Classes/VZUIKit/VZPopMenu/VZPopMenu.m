//
//  VZPopMenu.m
//  VZKit
//
//  Created by VonZen on 2017/8/22.
//

#import "VZPopMenu.h"
#import "VZPopMenuConfig.h"

@interface VZPopMenu ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) VZPopMenuView *popMenuView;
@property (nonatomic, strong) VZPopMenuSelectBlock selectBlock;
@property (nonatomic, strong) VZPopMenuDismissBlock dismissBlock;

@property (nonatomic, strong) UIView *sender;
@property (nonatomic, assign) CGRect senderFrame;
@property (nonatomic, strong) NSArray<NSString*> *menuArray;
@property (nonatomic, strong) NSArray<NSString*> *menuImageArray;
@property (nonatomic, assign) BOOL isCurrentlyOnScreen;

@end

@implementation VZPopMenu

+ (VZPopMenu *)sharedInstance
{
    static dispatch_once_t once = 0;
    static VZPopMenu *shared;
    dispatch_once(&once, ^{ shared = [[VZPopMenu alloc] init]; });
    return shared;
}

#pragma mark - Public Method

+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray<NSString*> *)menuArray
           selectBlock:(VZPopMenuSelectBlock)selectBlock
          dismissBlock:(VZPopMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:sender senderFrame:CGRectNull withMenu:menuArray imageNameArray:nil selectBlock:selectBlock dismissBlock:dismissBlock];
}

+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray<NSString*> *)menuArray
            imageArray:(NSArray *)imageArray
           selectBlock:(VZPopMenuSelectBlock)selectBlock
          dismissBlock:(VZPopMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:sender senderFrame:CGRectNull withMenu:menuArray imageNameArray:imageArray selectBlock:selectBlock dismissBlock:dismissBlock];
}

+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray<NSString*> *)menuArray
           selectBlock:(VZPopMenuSelectBlock)selectBlock
          dismissBlock:(VZPopMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:[event.allTouches.anyObject view] senderFrame:CGRectNull withMenu:menuArray imageNameArray:nil selectBlock:selectBlock dismissBlock:dismissBlock];
}

+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray<NSString*> *)menuArray
            imageArray:(NSArray *)imageArray
           selectBlock:(VZPopMenuSelectBlock)selectBlock
          dismissBlock:(VZPopMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:[event.allTouches.anyObject view] senderFrame:CGRectNull withMenu:menuArray imageNameArray:imageArray selectBlock:selectBlock dismissBlock:dismissBlock];
}

+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray<NSString*> *)menuArray
                 selectBlock:(VZPopMenuSelectBlock)selectBlock
                dismissBlock:(VZPopMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:nil senderFrame:senderFrame withMenu:menuArray imageNameArray:nil selectBlock:selectBlock dismissBlock:dismissBlock];
}

+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray<NSString*> *)menuArray
                  imageArray:(NSArray *)imageArray
                 selectBlock:(VZPopMenuSelectBlock)selectBlock
                dismissBlock:(VZPopMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:nil senderFrame:senderFrame withMenu:menuArray imageNameArray:imageArray selectBlock:selectBlock dismissBlock:dismissBlock];
}

+(void)dismiss
{
    [[self sharedInstance] dismiss];
}

#pragma mark - Private Methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChangeStatusBarOrientationNotification:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}

- (UIWindow *)backgroundWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if (window == nil && [delegate respondsToSelector:@selector(window)]){
        window = [delegate performSelector:@selector(window)];
    }
    return window;
}

-(UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc ]initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTapped:)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
        _backgroundView.backgroundColor = kDefaultBackgroundColor;
    }
    return _backgroundView;
}

-(VZPopMenuView *)popMenuView
{
    if (!_popMenuView) {
        _popMenuView = [[VZPopMenuView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _popMenuView.alpha = 0;
    }
    return _popMenuView;
}

-(CGFloat)menuArrowWidth
{
    return [VZPopMenuConfig defaultConfiguration].allowRoundedArrow ? kDefaultMenuArrowWidth_R : kDefaultMenuArrowWidth;
}

-(CGFloat)menuArrowHeight
{
    return [VZPopMenuConfig defaultConfiguration].allowRoundedArrow ? kDefaultMenuArrowHeight_R : kDefaultMenuArrowHeight;
}

-(void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    if (self.isCurrentlyOnScreen) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self adjustPopOverMenu];
        });
    }
}

- (void) showForSender:(UIView *)sender
           senderFrame:(CGRect )senderFrame
              withMenu:(NSArray<NSString*> *)menuArray
        imageNameArray:(NSArray<NSString*> *)imageNameArray
           selectBlock:(VZPopMenuSelectBlock)selectBlock
          dismissBlock:(VZPopMenuDismissBlock)dismissBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.backgroundView addSubview:self.popMenuView];
        [[self backgroundWindow] addSubview:self.backgroundView];
        
        self.sender = sender;
        self.senderFrame = senderFrame;
        self.menuArray = menuArray;
        self.menuImageArray = imageNameArray;
        self.selectBlock = selectBlock;
        self.dismissBlock = dismissBlock;
        
        [self adjustPopOverMenu];
    });
}

- (float)getMaxRowWid:(NSArray<NSString*> *)menuArray
{
    float maxWidth = 0;
    for (NSString *string in menuArray) {
        NSDictionary *attrs = @{NSFontAttributeName : [VZPopMenuConfig defaultConfiguration].textFont};
        CGSize size= [string sizeWithAttributes:attrs];
        if (maxWidth< size.width) {
            maxWidth = size.width;
        }
    }
    
    return maxWidth;
}

-(void)adjustPopOverMenu
{
    float maxRowWidth = [self getMaxRowWid:self.menuArray];
    if (self.menuImageArray) {
        [VZPopMenuConfig defaultConfiguration].menuWidth = maxRowWidth +[VZPopMenuConfig defaultConfiguration].menuIconMargin + kDefaultMenuIconSize + [VZPopMenuConfig defaultConfiguration].menuTextMargin*2;
    }else{
        [VZPopMenuConfig defaultConfiguration].menuWidth = maxRowWidth + [VZPopMenuConfig defaultConfiguration].menuTextMargin*2;
    }
    
    [self.backgroundView setFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    
    CGRect senderRect ;
    
    if (self.sender) {
        senderRect = [self.sender.superview convertRect:self.sender.frame toView:self.backgroundView];
        // if run into touch problems on nav bar, use the fowllowing line.
        //        senderRect.origin.y = MAX(64-senderRect.origin.y, senderRect.origin.y);
    }else{
        senderRect = self.senderFrame;
    }
    if (senderRect.origin.y > kScreenH) {
        senderRect.origin.y = kScreenH;
    }
    
    CGFloat menuHeight = [VZPopMenuConfig defaultConfiguration].menuRowHeight * self.menuArray.count + self.menuArrowHeight;
    CGPoint menuArrowPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width)/2, 0);
    CGFloat menuX = 0;
    CGRect menuRect = CGRectZero;
    BOOL shouldAutoScroll = NO;
    VZPopMenuArrowDirection arrowDirection;
    
    if (senderRect.origin.y + senderRect.size.height/2  < kScreenH/2) {
        arrowDirection = VZPopMenuArrowDirectionUp;
        menuArrowPoint.y = 0;
    }else{
        arrowDirection = VZPopMenuArrowDirectionDown;
        menuArrowPoint.y = menuHeight;
        
    }
    
    if (menuArrowPoint.x + [VZPopMenuConfig defaultConfiguration].menuWidth/2 + kDefaultMargin > kScreenW) {
        menuArrowPoint.x = MIN(menuArrowPoint.x - (kScreenW - [VZPopMenuConfig defaultConfiguration].menuWidth - kDefaultMargin), [VZPopMenuConfig defaultConfiguration].menuWidth - self.menuArrowWidth - kDefaultMargin);
        menuX = kScreenW - [VZPopMenuConfig defaultConfiguration].menuWidth - kDefaultMargin;
    }else if ( menuArrowPoint.x - [VZPopMenuConfig defaultConfiguration].menuWidth/2 - kDefaultMargin < 0){
        menuArrowPoint.x = MAX( kDefaultMenuCornerRadius + self.menuArrowWidth, menuArrowPoint.x - kDefaultMargin);
        menuX = kDefaultMargin;
    }else{
        menuArrowPoint.x = [VZPopMenuConfig defaultConfiguration].menuWidth/2;
        menuX = senderRect.origin.x + (senderRect.size.width)/2 - [VZPopMenuConfig defaultConfiguration].menuWidth/2;
    }
    
    if (arrowDirection == VZPopMenuArrowDirectionUp) {
        menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height), [VZPopMenuConfig defaultConfiguration].menuWidth, menuHeight);
        // if too long and is out of screen
        if (menuRect.origin.y + menuRect.size.height > kScreenH) {
            menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height), [VZPopMenuConfig defaultConfiguration].menuWidth, kScreenH - menuRect.origin.y - kDefaultMargin);
            shouldAutoScroll = YES;
        }
    }else{
        
        menuRect = CGRectMake(menuX, (senderRect.origin.y - menuHeight), [VZPopMenuConfig defaultConfiguration].menuWidth, menuHeight);
        // if too long and is out of screen
        if (menuRect.origin.y  < 0) {
            menuRect = CGRectMake(menuX, kDefaultMargin, [VZPopMenuConfig defaultConfiguration].menuWidth, senderRect.origin.y - kDefaultMargin);
            menuArrowPoint.y = senderRect.origin.y;
            shouldAutoScroll = YES;
        }
    }
    
    [self prepareToShowWithMenuRect:menuRect
                     menuArrowPoint:menuArrowPoint
                   shouldAutoScroll:shouldAutoScroll
                     arrowDirection:arrowDirection];
    
    
    [self show];
}

-(void)prepareToShowWithMenuRect:(CGRect)menuRect menuArrowPoint:(CGPoint)menuArrowPoint shouldAutoScroll:(BOOL)shouldAutoScroll arrowDirection:(VZPopMenuArrowDirection)arrowDirection
{
    CGPoint anchorPoint = CGPointMake(menuArrowPoint.x/menuRect.size.width, 0);
    if (arrowDirection == VZPopMenuArrowDirectionDown) {
        anchorPoint = CGPointMake(menuArrowPoint.x/menuRect.size.width, 1);
    }
    _popMenuView.transform = CGAffineTransformMakeScale(1, 1);
    
    [_popMenuView showWithFrame:menuRect
                     anglePoint:menuArrowPoint
                  withNameArray:self.menuArray
                 imageNameArray:self.menuImageArray
               shouldAutoScroll:shouldAutoScroll
                 arrowDirection:arrowDirection
                    selectBlock:^(NSInteger selectedIndex) {
                        [self doneActionWithSelectedIndex:selectedIndex];
                    }];
    
    [self setAnchorPoint:anchorPoint forView:_popMenuView];
    
    _popMenuView.transform = CGAffineTransformMakeScale(0.1, 0.1);
}


-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:_popMenuView];
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }else if (CGRectContainsPoint(CGRectMake(0, 0, [VZPopMenuConfig defaultConfiguration].menuWidth, [VZPopMenuConfig defaultConfiguration].menuRowHeight), point)) {
        [self doneActionWithSelectedIndex:0];
        return NO;
    }
    return YES;
}

#pragma mark - onBackgroundViewTapped

-(void)onBackgroundViewTapped:(UIGestureRecognizer *)gesture
{
    [self dismiss];
}

#pragma mark - show animation

- (void)show
{
    self.isCurrentlyOnScreen = YES;
    [UIView animateWithDuration:kDefaultAnimationDuration
                     animations:^{
                         _popMenuView.alpha = 1;
                         _popMenuView.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}

#pragma mark - dismiss animation

- (void)dismiss
{
    self.isCurrentlyOnScreen = NO;
    [self doneActionWithSelectedIndex:-1];
}

#pragma mark - doneActionWithSelectedIndex

-(void)doneActionWithSelectedIndex:(NSInteger)selectedIndex
{
    [UIView animateWithDuration:kDefaultAnimationDuration
                     animations:^{
                         _popMenuView.alpha = 0;
                         _popMenuView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }completion:^(BOOL finished) {
                         if (finished) {
                             [self.popMenuView removeFromSuperview];
                             [self.backgroundView removeFromSuperview];
                             if (selectedIndex < 0) {
                                 if (self.dismissBlock) {
                                     self.dismissBlock();
                                 }
                             }else{
                                 if (self.selectBlock) {
                                     self.selectBlock(selectedIndex);
                                 }
                             }
                         }
                     }];
}

@end
