//
//  VZPopMenu.h
//  VZKit
//
//  Created by VonZen on 2017/8/22.
//

#import <Foundation/Foundation.h>
#import "VZPopMenuView.h"

@interface VZPopMenu : NSObject

+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray<NSString*> *)menuArray
           selectBlock:(VZPopMenuSelectBlock)selectBlock
          dismissBlock:(VZPopMenuDismissBlock)dismissBlock;

+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray<NSString*> *)menuArray
            imageArray:(NSArray *)imageArray
           selectBlock:(VZPopMenuSelectBlock)selectBlock
          dismissBlock:(VZPopMenuDismissBlock)dismissBlock;

+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray<NSString*> *)menuArray
           selectBlock:(VZPopMenuSelectBlock)selectBlock
          dismissBlock:(VZPopMenuDismissBlock)dismissBlock;

+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray<NSString*> *)menuArray
            imageArray:(NSArray *)imageArray
           selectBlock:(VZPopMenuSelectBlock)selectBlock
          dismissBlock:(VZPopMenuDismissBlock)dismissBlock;

+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray<NSString*> *)menuArray
                 selectBlock:(VZPopMenuSelectBlock)selectBlock
                dismissBlock:(VZPopMenuDismissBlock)dismissBlock;

+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray<NSString*> *)menuArray
                  imageArray:(NSArray *)imageArray
                 selectBlock:(VZPopMenuSelectBlock)selectBlock
                dismissBlock:(VZPopMenuDismissBlock)dismissBlock;

+ (void) dismiss;

@end
