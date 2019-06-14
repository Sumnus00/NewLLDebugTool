//
//  UIPickerViewActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/13.
//  Copyright © 2019 li. All rights reserved.
//

#import "UIPickerViewActions.h"

@implementation UIPickerViewActions
+(void)selectPickerViewRowWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UIPickerView class]]){
        UIPickerView *pickerView = ((UIPickerView *)view) ;
        NSInteger components = pickerView.numberOfComponents ;
        for(int component = 0 ;component < components ;component++){
            NSInteger rows = [pickerView.dataSource pickerView:pickerView numberOfRowsInComponent:component];
            if(rows > 0){
                int row = arc4random() % rows ;
                NSString *rowTitle = nil;
                if ([pickerView.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
                    rowTitle = [pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component];
                } else if ([pickerView.delegate respondsToSelector:@selector(pickerView:attributedTitleForRow:forComponent:)]) {
                    rowTitle = [[pickerView.delegate pickerView:pickerView attributedTitleForRow:row forComponent:component] string];
                } else if ([pickerView.delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
                    
                    UIView *rowView = [pickerView.delegate pickerView:pickerView viewForRow:row forComponent:component reusingView:nil];
                    UILabel *label;
                    if ([rowView isKindOfClass:[UILabel class]] ) {
                        label = (id)rowView;
                    } else {
                        // This delegate inserts views directly, so try to figure out what the title is by looking for a label
                        NSArray *labels = [rowView subviewsWithClassNameOrSuperClassNamePrefix:@"UILabel"];
                        label = (labels.count > 0 ? labels[0] : nil);
                    }
                    rowTitle = label.text;
                }
                if(rowTitle){
                    //KIF has a bug in here
                    [tester selectPickerViewRowWithTitle:rowTitle inComponent:component] ;
                }
            }
            
        }
    }
}
@end
