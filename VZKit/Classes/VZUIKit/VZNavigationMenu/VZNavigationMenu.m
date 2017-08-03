//
//  VZNavigationMenu.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "VZNavigationMenu.h"
#import "VZMenuButton.h"
#import "VZMenuCollectionView.h"

@interface VZNavigationMenu ()<VZMenuCollectionViewDelegate>

@property (nonatomic, strong) VZMenuButton  *menuButton;
@property (nonatomic, strong) VZMenuCollectionView   *collectionView;
@property (nonatomic, weak)  UIView *menuContainer;

@end

@implementation VZNavigationMenu

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withConfig:(VZNavigationMenuConfig *)config
{
    if (self = [super initWithFrame:frame]) {
        self.config = config ? : [VZNavigationMenuConfig defaultConfig];
        self.menuButton = [[VZMenuButton alloc] initWithFrame:frame
                                                    withImage:self.config.arrowImage
                                             withImagePadding:self.config.arrowPadding];
        self.menuButton.title.text = title;
        [self.menuButton addTarget:self action:@selector(menuTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    return [self initWithFrame:frame withTitle:title withConfig:[VZNavigationMenuConfig defaultConfig]];
}

- (void)dealloc
{
    self.items = nil;
    self.menuButton = nil;
}

- (void)displayMenuInView:(UIView *)view
{
    self.menuContainer = view;
}

- (void)setTitle:(NSString *)title{
    self.menuButton.title.text = title;
    self.menuButton.enabled = YES;
    self.menuButton.arrow.hidden = NO;
    [self.menuButton setNeedsLayout];
}

- (void)setDisableWithTitle:(NSString *)title
{
    self.menuButton.title.text = title;
    self.menuButton.enabled = NO;
    self.menuButton.arrow.hidden = YES;
    [self.menuButton setNeedsLayout];
}

#pragma mark Actions
- (void)menuTap:(id)sender
{
    if (self.menuButton.isActive) {
        [self showMenu];
    } else {
        [self hideMenu];
    }
}

- (void)showMenu
{
    if (!self.collectionView) {
        UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
        CGRect frame = mainWindow.frame;
        frame.origin.y += self.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
        self.collectionView = [[VZMenuCollectionView alloc] initWithFrame:frame items:self.items withConfig:self.config];
        self.collectionView.delegate = self;
    }
    [self.menuContainer addSubview:self.collectionView];
    [self rotateArrow:M_PI];
    [self.collectionView show];
}

- (void)hideMenu
{
    [self rotateArrow:0];
    [self.collectionView hide:YES];
}

- (void)hideMenuWithoutAnimate
{
    [self rotateArrow:0];
    [self.collectionView hide:NO];
}

- (void)rotateArrow:(float)degrees
{
    [UIView animateWithDuration:self.config.animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.menuButton.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

#pragma mark Delegate methods
- (void)didBackgroundTap
{
    self.menuButton.isActive = !self.menuButton.isActive;
    [self menuTap:nil];
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    self.menuButton.isActive = !self.menuButton.isActive;
    [self menuTap:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:index];
    }
}
@end
