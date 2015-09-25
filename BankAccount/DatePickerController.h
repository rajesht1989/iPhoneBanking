//
//  DatePickerController.h
//  iDatePickerComponent
//
//  Created by Rajesh on 9/21/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>

- (void)dateSelected:(NSDate *)date;

@end


@interface DatePickerController : UIViewController

@property(nonatomic,assign)id<DatePickerDelegate> delegate;
@property(nonatomic,assign)BOOL isModal;
@property(nonatomic,strong)NSDate *dateSelected;

- (void)completionAction;

@end
