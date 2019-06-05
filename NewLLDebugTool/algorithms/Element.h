//
//  Element.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/21.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Element : NSObject
@property (copy , nonatomic , nonnull) NSString *elementId ;
@property (copy , nonatomic , nonnull) NSString *elementName ;
@property (nonatomic, assign) NSInteger clickTimes ;
@property (nonatomic ,assign) BOOL isClicked ;
@property (nonatomic ,assign) BOOL isTreeChanged ;
@property (nonatomic , assign) BOOL isJumped ;
@property (nonatomic , assign) BOOL isBack ;
- (instancetype)initWithElementId:(NSString*)elementId withElementName:(NSString*)elementName ;
- (NSInteger) getElementScore ;
@end

@interface IOSElement : Element
@property (copy , nonatomic , nonnull) NSString *accessbilityIdentifier ;
@end

@interface CocosElement:Element

@end

NS_ASSUME_NONNULL_END
