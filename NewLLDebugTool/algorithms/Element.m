//
//  Element.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/21.
//  Copyright © 2019 li. All rights reserved.
//

#import "Element.h"

@implementation Element
- (instancetype)initWithElementId:(NSString*)elementId elementName:(NSString*)elementName type:(NSString*)type{
    if(self = [super init]){
        _elementId = elementId ;
        _elementName = elementName ;
        _clickTimes = 0 ;
        _isTreeChanged = false ;
        _isJumped = false ;
        _isBack = false ;
        _toTree = nil ;
        _type = type ;
    }
    return self ;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[Element class]]) {
        return NO;
    }
    
    Element *element = (Element *)object ;
    return self.elementId && element.elementId && [self.elementId isEqualToString:element.elementId] ;
}

- (NSInteger) getElementScore{
    return 4 *  ( _clickTimes > 0 ? 1 : 0 ) + 2 * (( _isJumped || _isTreeChanged ) ? 1 : 0) + (_isBack ? 1 : 0) + ( ( _clickTimes > 0 ) && ( _isJumped || _isTreeChanged ) ? 0.5 : 0 ) * _clickTimes ;
}
@end

@implementation IOSElement

@end
