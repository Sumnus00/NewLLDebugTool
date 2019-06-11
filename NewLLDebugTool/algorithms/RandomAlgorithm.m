//
//  RandomAlgorithm.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/11.
//  Copyright © 2019 li. All rights reserved.
//

#import "RandomAlgorithm.h"

@implementation RandomAlgorithm
-(Element *) chooseElementFromTree:(Tree *)currentTree{
    NSArray<Element*> *elements = currentTree.elements.allValues ;
    //获取的元素列表为空，则表示没有元素
    if(elements == nil || [elements count] == 0){
        NSLog(@"current tree no elements") ;
        return nil ;
    }
    int random = arc4random() % [elements count] ;
    
    Element *element = [elements objectAtIndex:random] ;
    return element ;
}
@end
