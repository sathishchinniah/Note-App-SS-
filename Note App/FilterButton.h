//
//  FilterButton.h
//  MellToo
//
//  Created by Apple on 01/09/2015.
//  Copyright (c) 2015 sathish chinniah. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface FilterButton : UIButton
@property (nonatomic, retain) NSDate *myDate;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger indexPathSection;
@end
