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
        _clickTimes = 0 ;
        _elements = [[NSMutableDictionary alloc] init] ;
        _isClickedDone = false ;
    }
    return self ;
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

-(void) updateTreeWithElements:(NSArray<Element*>*)elements{
    bool isClickedDone = true ;
    for(int i=0 ;i<[elements count] ;i++){
        Element *element = [elements objectAtIndex:i] ;
        if([self isExistsElement:element]){
            
        }else{
            isClickedDone = isClickedDone && element.isClicked ;
            [self setElement:element] ;
        }
    }
    _isClickedDone = _isClickedDone && isClickedDone ;
}
@end
