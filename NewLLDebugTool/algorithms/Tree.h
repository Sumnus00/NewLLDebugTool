//
//  Tree.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/21.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Element.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tree : NSObject
@property (copy , nonatomic , nonnull) NSString *treeID ;
@property (copy , nonatomic , nonnull) NSString *treeName ;
@property (nonatomic, assign) NSInteger clickTimes ;
@property (nonatomic , strong) NSMutableDictionary<NSString* , Element*> *elements ;
@property (nonatomic ,assign) BOOL isClickedDone ;

- (instancetype)initWithTreeId:(NSString*)treeID withTreeName:(NSString*)treeName ;
-(BOOL)isElementExists:(Element*)element ;
-(void)setElement:(Element*)element ;
-(Element *)getElement:(NSString*)elementID ;
-(void) updateTreeWithElements:(NSArray<Element*>*)elements ;
@end

@interface Path : NSObject
@property (copy , nonatomic , nonnull) NSString *treeName ;
@property (copy , nonatomic , nonnull) Element *element ;
@end

@interface IOSTree : Tree

@property (nonatomic , strong) NSMutableDictionary<NSString* , NSMutableArray<Path*>*> *path ;

@end

@interface CocosTree : Tree

@end

NS_ASSUME_NONNULL_END
