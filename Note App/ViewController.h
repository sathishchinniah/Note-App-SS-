//
//  ViewController.h
//  Note App
//
//  Created by Sathish Chinniah on 11/08/15.
//  Copyright (c) 2015 sathish chinniah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Notes.h"
#import "AppDelegate.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UITextFieldDelegate,UITextViewDelegate> {
//    UILabel *subtitle;
//    UILabel *title;
    
    
}


@property(nonatomic,retain)NSFetchedResultsController *catefetchedResultsController;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic, retain) IBOutlet UITextField *searchCate;
@property(nonatomic, retain)NSMutableArray *filteredTableData;
@property(nonatomic,retain)NSString*searchSTR;
- (IBAction)btnClick:(id)sender;



@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (AppDelegate *)appDelegate;

- (IBAction)addButtonPressed:(id)sender;

//@property (strong, nonatomic) IBOutlet UILabel *subTitle;
//
//@property (strong, nonatomic) IBOutlet UILabel *title;








@end

