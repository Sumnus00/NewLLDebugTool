//
//  QuickAlgorithm.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/21.
//  Copyright © 2019 li. All rights reserved.
//

#import "QuickAlgorithm.h"

@implementation QuickAlgorithm
-(Element *) chooseElementFromTree:(Tree *)currentTree AmongElements:(NSArray<Element*>*)elements{
    //获取的元素列表为空，则表示没有元素
    if(elements == nil || [elements count] == 0){
        NSLog(@"current tree no elements") ;
        return nil ;
    }
    
    //更新树
    [self updateTree:currentTree withElements:elements] ;
    
    NSInteger maxScore = -1 ;
    Element *maxElement = nil ;
    
    for(int i=0;i<[elements count] ;i++){
        Element *element = [elements objectAtIndex:i] ;
        NSInteger score = [element getElementScore] ;
        if(score == 1 || score == 4 || score == 5 ){
            continue ;
        }
        
        if(score > maxScore){
            maxScore = score ;
            maxElement = element ;
        }
    }
    return maxElement ;
}

-(void) updateTree:(Tree *)currentTree withElements:(NSArray<Element*>*)elements{
    [currentTree updateTreeWithElements:elements] ;
}
@end
