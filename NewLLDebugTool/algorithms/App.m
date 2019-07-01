//
//  App.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/5.
//  Copyright © 2019 li. All rights reserved.
//

#import "App.h"

static App *_instance = nil;
@implementation App
/**
 * Singleton
 @return Singleton
 */
+ (instancetype)sharedApp {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[App alloc] init];
        [_instance initial];
    });
    return _instance;
}

/**
 Initial something.
 */
- (void)initial {
    _trees = [[NSMutableDictionary alloc] init] ;
}

-(Tree *)getCurrentTree{
    return [FindElementTree tree] ;
}


-(NSString *)getCurrentTreeId{
    return [FindElementTree treeId] ;
}

-(BOOL)isNewTree:(Tree*)tree{
    if ([_trees objectForKey:tree.treeID]){
        return false ;
    }else{
        return true ;
    }
}

-(void)addTree:(Tree*)tree{
    [_trees setObject:tree forKey:tree.treeID] ;
}

-(Tree*)getTree:(NSString*)treeID{
    
    return [_trees objectForKey:treeID] ;
}

-(void) updateTree:(Tree*)tree{
    if(tree == nil){
        return ;
    }
    if([self isNewTree:tree]){
        [self addTree:tree] ;
    }else{
        Tree* oldTree = [self getTree:tree.treeID] ;
        
        NSArray<Element*>* elements = tree.elements.allValues;
        for(int i=0 ;i<[elements count] ;i++){
            Element *element = [elements objectAtIndex:i] ;
            if([oldTree isExistsElement:element]){
                [tree setElement:[oldTree getElement:element.elementId]] ;
            }else{
                [oldTree setElement:element] ;
            }
        }
    }
}

-(CGFloat)getCoverage{
    int views = [self getViews] ;
    if(views==0){
        return 0.0 ;
    }else{
        return ([self getClickedViews] * 100.0 / views) ;
    }
}

-(NSInteger)getClickedViews{
    int clickedViewsNum = 0 ;
    NSArray *trees = _trees.allValues ;
    for(int i=0;i<trees.count;i++){
        Tree* tree = [trees objectAtIndex:i] ;
        clickedViewsNum = clickedViewsNum + [tree getClickedViews] ;
    }
    return clickedViewsNum ;
}

-(NSInteger)getViews{
    int viewNum = 0 ;
    NSArray *trees = _trees.allValues ;
    for(int i=0;i<trees.count;i++){
        Tree* tree = [trees objectAtIndex:i] ;
        viewNum = viewNum + [tree getViews] ;
    }
    return viewNum ;
}
@end
