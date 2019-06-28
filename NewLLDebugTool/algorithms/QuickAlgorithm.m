//
//  QuickAlgorithm.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/21.
//  Copyright © 2019 li. All rights reserved.
//

#import "QuickAlgorithm.h"

@implementation QuickAlgorithm
-(Element *) chooseElementFromTree:(Tree *)currentTree{
    
    NSArray<Element*> *elements = currentTree.elements.allValues ;
    //获取的元素列表为空，则表示没有元素
    if(elements == nil || [elements count] == 0){
        NSLog(@"current tree no elements") ;
        return nil ;
    }

    NSInteger minScore = 10000 ;
    NSInteger maxWeight = -1 ;
    Element *minElement = nil ;
    
    for(int i=0;i<[elements count] ;i++){
        Element *element = [elements objectAtIndex:i] ;
        NSInteger score = [element getElementScore] ;
        if(score == 1 || score == 4 || score == 5 ){
            continue ;
        }
        
        if(score < minScore){
            minScore = score ;
            minElement = element ;
            maxWeight = element.weight ;
        }else if(score == minScore){
            if(element.weight > maxWeight){
                minScore = score ;
                minElement = element ;
                maxWeight = element.weight ;
            }
        }
    }
    
    if(minScore > 3 ){
        NSLog(@"elements of current tree are clicked") ;
    }
    
    if(minScore > 9){
        NSLog(@"elements of current tree are clicked over 7 times") ;
        return nil ;
    }
    return minElement ;
}

@end
