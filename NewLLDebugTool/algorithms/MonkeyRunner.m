//
//  MonkeyRunner.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/5.
//  Copyright © 2019 li. All rights reserved.
//

#import "MonkeyRunner.h"

@implementation MonkeyRunner

- (instancetype)initWithAlgorithm: (id<MonkeyAlgorithmDelegate>) algorithm{
    self = [super init] ;
    if(self){
        _preTree = nil ;
        _curTree = nil ;
        _preElement = nil ;
        _algorithm = algorithm ;
    }
    return self ;
}

-(void)runOneStep{
    _preTree = _curTree ;
    _curTree = [[App sharedApp] getCurrentTree] ;
    
    if(_curTree != nil && _preElement != nil){
        _preElement.toTree = _curTree ;
    }
    
    if(_preElement != nil && _preTree != nil && _curTree != nil){
        if(_curTree != _preTree){
            _preElement.isJumped = true ;
        }else if(_curTree.elements != _preTree.elements){
            _preElement.isTreeChanged = true ;
        }
    }
    
    //从树里面选择一个控件
    Element *element = [_algorithm chooseElementFromTree:_curTree AmongElements:_curTree.elements.allValues] ;
    
    if(element == nil){
        //需要返回上一个界面
        _preElement = nil ;
        _curTree = _preTree ;
        
    }else{
        _preElement = element ;
        [self OperateElement:element] ;
        element.clickTimes = element.clickTimes + 1 ;
    }
    
}

-(void)OperateElement:(Element *)element{
    
}
@end
