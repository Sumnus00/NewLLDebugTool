//
//  Tree.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/21.
//  Copyright © 2019 li. All rights reserved.
//

#import "Tree.h"

@implementation Tree

- (instancetype)initWithTreeId:(NSString*)treeID withTreeName:(NSString*)treeName{
    
    if(self = [super init]){
        _treeID = treeID ;
        _treeName = treeName ;
        _elements = [[NSMutableDictionary alloc] init] ;
    }
    return self ;
}

-(BOOL)isSameTreeId:(Tree*)tree{
    if(tree == nil){
        return false ;
    }
    return [_treeID isEqualToString:tree.treeID] ;
}


-(BOOL)isSameTree:(Tree*)tree{
    if(tree==nil){
        return false ;
    }
    if([self isSameTreeId:tree]){
        return [self.elements isEqual:tree.elements] ;
    }else{
        return false ;
    }
}

-(BOOL)isExistsElement:(Element*)element{
    if([_elements objectForKey:element.elementId]){
        return true ;
    }else{
        return false ;
    }
}

-(void)setElement:(Element*)element{
    [_elements setObject:element forKey:element.elementId] ;
}
-(Element *)getElement:(NSString*)elementId{
    return [_elements objectForKey:elementId] ;
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
    NSArray *elements = _elements.allValues ;
    for(int i=0;i<elements.count;i++){
        Element *element = [elements objectAtIndex:i] ;
        if(element.clickTimes > 0){
            clickedViewsNum = clickedViewsNum + 1 ;
        }
    }
    return clickedViewsNum ;
}
-(NSInteger)getViews{
    return _elements.count ;
}
@end
