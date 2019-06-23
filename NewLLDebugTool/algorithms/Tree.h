//
//  Tree.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/21.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Element.h"
#import <UIKit/UIKit.h>

@class Element ;
NS_ASSUME_NONNULL_BEGIN

@interface Tree : NSObject
@property (copy , nonatomic , nonnull) NSString *treeID ;
@property (copy , nonatomic , nonnull) NSString *treeName ;
@property (nonatomic , strong) NSMutableDictionary<NSString* , Element*> *elements ;

- (instancetype)initWithTreeId:(NSString*)treeID withTreeName:(NSString*)treeName ;
-(BOOL)isSameTree:(Tree*)tree ;
-(BOOL)isSameTreeId:(Tree*)tree ;
-(BOOL)isExistsElement:(Element*)element ;
-(void)setElement:(Element*)element ;
-(Element *)getElement:(NSString*)elementID ;
-(CGFloat)getCoverage ;
-(NSInteger)getClickedViews;
-(NSInteger)getViews ;
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
