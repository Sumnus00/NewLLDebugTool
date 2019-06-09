//
//  FindElementTree.m
//  TenMinDemo
//
//  Created by haleli on 2019/4/8.
//  Copyright © 2019 CYXiang. All rights reserved.
//

#import "FindElementTree.h"

@implementation FindElementTree

+(NSMutableArray *)tree{
    NSMutableArray *array = [UIView tree] ;
    return array ;
}

+(Tree *)tree1{
    NSString * treeId = NSStringFromClass([[FindTopController topController] class]) ;
    Tree* tree = [[Tree alloc] initWithTreeId:treeId withTreeName:treeId] ;
    NSMutableDictionary *dict = [UIView tree1] ;
    tree.elements = dict ;
    return tree ;
}
@end
