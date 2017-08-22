//
//  VZPopMenuView.m
//  VZKit
//
//  Created by VonZen on 2017/8/22.
//

#import "VZPopMenuView.h"
#import "VZPopMenuConfig.h"
#import "VZPopMenuCell.h"

@interface VZPopMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSArray<NSString *> *menuStringArray;
@property (nonatomic, strong) NSArray *menuImageArray;
@property (nonatomic, assign) VZPopMenuArrowDirection arrowDirection;
@property (nonatomic, strong) VZPopMenuSelectBlock selectBlock;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) UIColor *tintColor;

@end

@implementation VZPopMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(UITableView *)menuTableView
{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableView.backgroundColor = kDefaultBackgroundColor;
        _menuTableView.separatorColor = [UIColor grayColor];
        _menuTableView.layer.cornerRadius = kDefaultMenuCornerRadius;
        _menuTableView.scrollEnabled = NO;
        _menuTableView.clipsToBounds = YES;
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        [self addSubview:_menuTableView];
    }
    return _menuTableView;
}

-(CGFloat)menuArrowWidth
{
    return [VZPopMenuConfig defaultConfiguration].allowRoundedArrow ? kDefaultMenuArrowWidth_R : kDefaultMenuArrowWidth;
}
-(CGFloat)menuArrowHeight
{
    return [VZPopMenuConfig defaultConfiguration].allowRoundedArrow ? kDefaultMenuArrowHeight_R : kDefaultMenuArrowHeight;
}

-(void)showWithFrame:(CGRect )frame
          anglePoint:(CGPoint )anglePoint
       withNameArray:(NSArray<NSString*> *)nameArray
      imageNameArray:(NSArray *)imageNameArray
    shouldAutoScroll:(BOOL)shouldAutoScroll
      arrowDirection:(VZPopMenuArrowDirection)arrowDirection
         selectBlock:(VZPopMenuSelectBlock)selectBlock
{
    self.frame = frame;
    _menuStringArray = nameArray;
    _menuImageArray = imageNameArray;
    _arrowDirection = arrowDirection;
    self.selectBlock = selectBlock;
    self.menuTableView.scrollEnabled = shouldAutoScroll;
    
    
    CGRect menuRect = CGRectMake(0, self.menuArrowHeight, self.frame.size.width, self.frame.size.height - self.menuArrowHeight);
    if (_arrowDirection == VZPopMenuArrowDirectionDown) {
        menuRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.menuArrowHeight);
    }
    [self.menuTableView setFrame:menuRect];
    [self.menuTableView reloadData];
    
    [self drawBackgroundLayerWithAnglePoint:anglePoint];
}
-(void)drawBackgroundLayerWithAnglePoint:(CGPoint)anglePoint
{
    if (_backgroundLayer) {
        [_backgroundLayer removeFromSuperlayer];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    BOOL allowRoundedArrow = [VZPopMenuConfig defaultConfiguration].allowRoundedArrow;
    CGFloat offset = 2.f*kDefaultMenuArrowRoundRadius*sinf(M_PI_4/2.f);
    CGFloat roundcenterHeight = offset + kDefaultMenuArrowRoundRadius*sqrtf(2.f);
    CGPoint roundcenterPoint = CGPointMake(anglePoint.x, roundcenterHeight);
    
    switch (_arrowDirection) {
        case VZPopMenuArrowDirectionUp:{
            if (allowRoundedArrow) {
                [path addArcWithCenter:CGPointMake(anglePoint.x + self.menuArrowWidth, self.menuArrowHeight - 2.f*kDefaultMenuArrowRoundRadius) radius:2.f*kDefaultMenuArrowRoundRadius startAngle:M_PI_2 endAngle:M_PI_4*3.f clockwise:YES];
                [path addLineToPoint:CGPointMake(anglePoint.x + kDefaultMenuArrowRoundRadius/sqrtf(2.f), roundcenterPoint.y - kDefaultMenuArrowRoundRadius/sqrtf(2.f))];
                [path addArcWithCenter:roundcenterPoint radius:kDefaultMenuArrowRoundRadius startAngle:M_PI_4*7.f endAngle:M_PI_4*5.f clockwise:NO];
                [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth + (offset * (1.f+1.f/sqrtf(2.f))), self.menuArrowHeight - offset/sqrtf(2.f))];
                [path addArcWithCenter:CGPointMake(anglePoint.x - self.menuArrowWidth, self.menuArrowHeight - 2.f*kDefaultMenuArrowRoundRadius) radius:2.f*kDefaultMenuArrowRoundRadius startAngle:M_PI_4 endAngle:M_PI_2 clockwise:YES];
            } else {
                [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, self.menuArrowHeight)];
                [path addLineToPoint:anglePoint];
                [path addLineToPoint:CGPointMake( anglePoint.x - self.menuArrowWidth, self.menuArrowHeight)];
            }
            
            [path addLineToPoint:CGPointMake( kDefaultMenuCornerRadius, self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(kDefaultMenuCornerRadius, self.menuArrowHeight + kDefaultMenuCornerRadius) radius:kDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
            [path addLineToPoint:CGPointMake( 0, self.bounds.size.height - kDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(kDefaultMenuCornerRadius, self.bounds.size.height - kDefaultMenuCornerRadius) radius:kDefaultMenuCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - kDefaultMenuCornerRadius, self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - kDefaultMenuCornerRadius, self.bounds.size.height - kDefaultMenuCornerRadius) radius:kDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , kDefaultMenuCornerRadius + self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - kDefaultMenuCornerRadius, kDefaultMenuCornerRadius + self.menuArrowHeight) radius:kDefaultMenuCornerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
            [path closePath];
            
        }break;
        case VZPopMenuArrowDirectionDown:{
            roundcenterPoint = CGPointMake(anglePoint.x, anglePoint.y - roundcenterHeight);
            
            if (allowRoundedArrow) {
                [path addArcWithCenter:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*kDefaultMenuArrowRoundRadius) radius:2.f*kDefaultMenuArrowRoundRadius startAngle:M_PI_2*3 endAngle:M_PI_4*5.f clockwise:NO];
                [path addLineToPoint:CGPointMake(anglePoint.x + kDefaultMenuArrowRoundRadius/sqrtf(2.f), roundcenterPoint.y + kDefaultMenuArrowRoundRadius/sqrtf(2.f))];
                [path addArcWithCenter:roundcenterPoint radius:kDefaultMenuArrowRoundRadius startAngle:M_PI_4 endAngle:M_PI_4*3.f clockwise:YES];
                [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth + (offset * (1.f+1.f/sqrtf(2.f))), anglePoint.y - self.menuArrowHeight + offset/sqrtf(2.f))];
                [path addArcWithCenter:CGPointMake(anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*kDefaultMenuArrowRoundRadius) radius:2.f*kDefaultMenuArrowRoundRadius startAngle:M_PI_4*7 endAngle:M_PI_2*3 clockwise:NO];
            } else {
                [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
                [path addLineToPoint:anglePoint];
                [path addLineToPoint:CGPointMake( anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
            }
            
            [path addLineToPoint:CGPointMake( kDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(kDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight - kDefaultMenuCornerRadius) radius:kDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [path addLineToPoint:CGPointMake( 0, kDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(kDefaultMenuCornerRadius, kDefaultMenuCornerRadius) radius:kDefaultMenuCornerRadius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - kDefaultMenuCornerRadius, 0)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - kDefaultMenuCornerRadius, kDefaultMenuCornerRadius) radius:kDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , anglePoint.y - (kDefaultMenuCornerRadius + self.menuArrowHeight))];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - kDefaultMenuCornerRadius, anglePoint.y - (kDefaultMenuCornerRadius + self.menuArrowHeight)) radius:kDefaultMenuCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [path closePath];
            
        }break;
        default:
            break;
    }
    
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.path = path.CGPath;
    _backgroundLayer.lineWidth = [VZPopMenuConfig defaultConfiguration].borderWidth;
    _backgroundLayer.fillColor = [VZPopMenuConfig defaultConfiguration].tintColor.CGColor;
    _backgroundLayer.strokeColor = [VZPopMenuConfig defaultConfiguration].borderColor.CGColor;
    [self.layer insertSublayer:_backgroundLayer atIndex:0];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VZPopMenuConfig defaultConfiguration].menuRowHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuStringArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id menuImage;
    if (_menuImageArray.count - 1 >= indexPath.row) {
        menuImage = _menuImageArray[indexPath.row];
    }
    VZPopMenuCell *menuCell = [[VZPopMenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"VZPopMenuCell"
                               ];
    [menuCell setMenuName:[NSString stringWithFormat:@"%@", _menuStringArray[indexPath.row]] withMenuImage:menuImage];
    if (indexPath.row == _menuStringArray.count-1) {
        menuCell.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0);
    }else{
        menuCell.separatorInset = UIEdgeInsetsMake(0, [VZPopMenuConfig defaultConfiguration].menuTextMargin, 0, [VZPopMenuConfig defaultConfiguration].menuTextMargin);
    }
    
    return menuCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
}

@end
