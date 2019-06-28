//
//  Element.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/21.
//  Copyright © 2019 li. All rights reserved.
//

#import "Element.h"

/**
 weight type
 **/
typedef NS_ENUM(NSUInteger, LLWeightType) {
    SUPERHIGH = 5 ,
    HIGH = 4,
    MIDDLE= 3,
    LOW = 2 ,
    SUPERLOW = 1,
};

@implementation Element
- (instancetype)initWithElementId:(NSString*)elementId elementName:(NSString*)elementName type:(NSString*)type{
    if(self = [super init]){
        _elementId = elementId ;
        _elementName = elementName ;
        _clickTimes = 0 ;
        _weight = [self initWeight:type] ;
        _isTreeChanged = false ;
        _isJumped = false ;
        _isBack = false ;
        _isMenu = false ;
        _toTree = nil ;
        _type = type ;
        _info = [[NSMutableDictionary alloc] init]  ;
    }
    return self ;
}

-(NSInteger)initWeight:(NSString*)type{
    if([type isEqual:@"UITableView"]){
        return LOW ;
    }else if([type isEqual:@"UISwitch"]){
        return LOW ;
    }else if([type isEqual:@"UITabBar"]){
        return SUPERLOW ;
    }else if([type isEqual:@"UINavigationBar"]){
        return LOW ;
    }else if([type isEqual:@"UITextField"]){
        //UITextField和UITextView优先级最高
        return SUPERHIGH ;
    }else if([type isEqual:@"UITextView"]){
        //UITextField和UITextView优先级最高
        return SUPERHIGH ;
    }else if([type isEqual:@"UIButton"]){
        return HIGH ;
    }else if([type isEqual:@"UISegmentedControl"]){
        return LOW ;
    }else if([type isEqual:@"UICollectionView"]){
        return LOW ;
    }else if([type isEqual:@"UITableViewCell"]){
        return MIDDLE ;
    }else if([type isEqual:@"UICollectionViewCell"]){
        return MIDDLE ;
    }else if([type isEqual:@"UITabBarButton"]){
        return SUPERLOW ;
    }else if([type isEqual:@"UIPickerView"]){
        return LOW ;
    }
    else{
        return LOW ;
    }
}

-(void)setInfoKey:(NSString*)key withInfoValue:(NSString*)value{
    [_info setObject:value forKey:key] ;
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
