//
//  Notes.h
//  Note App
//
//  Created by Apple on 01/09/2015.
//  Copyright (c) 2015 sathish chinniah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notes : NSManagedObject

@property (nonatomic, retain) NSDate * mod_time;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * check;

@end
