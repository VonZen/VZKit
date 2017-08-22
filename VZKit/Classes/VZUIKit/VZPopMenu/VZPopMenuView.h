//
//  VZPopMenuView.h
//  VZKit
//
//  Created by VonZen on 2017/8/22.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VZPopMenuArrowDirection) {
    VZPopMenuArrowDirectionUp,
    VZPopMenuArrowDirectionDown,
};

typedef void (^VZPopMenuSelectBlock)(NSInteger selectedIndex);
typedef void (^VZPopMenuDismissBlock)(void);

@interface VZPopMenuView : UIControl

-(void)showWithFrame:(CGRect )frame
          anglePoint:(CGPoint )anglePoint
       withNameArray:(NSArray<NSString*> *)nameArray
      imageNameArray:(NSArray *)imageNameArray
    shouldAutoScroll:(BOOL)shouldAutoScroll
      arrowDirection:(VZPopMenuArrowDirection)arrowDirection
         selectBlock:(VZPopMenuSelectBlock)selectBlock;
@end
