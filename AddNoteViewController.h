//
//  AddNoteViewController.h
//  Note App
//
//  Created by Sathish Chinniah on 11/08/15.
//  Copyright (c) 2015 sathish chinniah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddNoteViewController : UIViewController<UIAlertViewDelegate, UIGestureRecognizerDelegate>
@property (strong) NSManagedObject *note;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
