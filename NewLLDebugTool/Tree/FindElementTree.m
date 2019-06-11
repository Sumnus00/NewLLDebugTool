//
//  FindElementTree.m
//  TenMinDemo
//
//  Created by haleli on 2019/4/8.
//  Copyright © 2019 CYXiang. All rights reserved.
//

#import "FindElementTree.h"

@implementation FindElementTree

+(Tree *)tree{
    NSString * treeId = NSStringFromClass([[FindTopController topController] class]) ;
    Tree* tree = [[Tree alloc] initWithTreeId:treeId withTreeName:treeId] ;
    NSMutableDictionary *dict = [UIView tree] ;
    tree.elements = dict ;
    return tree ;
}
@end
