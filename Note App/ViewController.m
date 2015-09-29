//
//  ViewController.m
//  Note App
//
//  Created by Sathish Chinniah on 11/08/15.
//  Copyright (c) 2015 sathish chinniah. All rights reserved.
//

#import "ViewController.h"
#import "AddNoteViewController.h"
#import <CoreData/CoreData.h>
#import "TableViewCell.h"
#import "Notes.h"
#import "AppDelegate.h"
#import "FilterButton.h"

@interface ViewController ()
{
    
//    UILabel *textLabel;
//    UILabel *detailLabel;
    NSDateFormatter *formatter;
    UIBarButtonItem *sideBtn;
    NSString *GettouchStr;
}



@property (strong) NSMutableArray *notes;
@end

@implementation ViewController
@synthesize tableView;
@synthesize addButton;
@synthesize catefetchedResultsController,filteredTableData,searchSTR;


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark -  fetching
- (NSFetchedResultsController *)fetchedResultsControllerCate
{
    if (catefetchedResultsController == nil)
    {
        
        
        
        
        NSManagedObjectContext* mangedobjectContext=[self appDelegate].managedObjectContext;
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes"
                                                  inManagedObjectContext:mangedobjectContext];
        NSFetchRequest *request= [[NSFetchRequest alloc] init];
      
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"mod_time" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1,sd2, nil];
        

        
        
        [request setSortDescriptors:sortDescriptors];
        [request setEntity:entity];
        
        
        
        
        
        
        NSPredicate *predicate;
        
        
        if (self.searchSTR.length > 0) {
            predicate=nil;
          
                
                
                NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(note CONTAINS[c] %@)",self.searchSTR]; //[NSPredicate predicateWithFormat:@"name LIKE %@",searchResults];
                [request setPredicate:predicate];
       
        }else{
        
        
        }
        
        [request setFetchBatchSize:10];
        
        catefetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                           managedObjectContext:mangedobjectContext
                                                                             sectionNameKeyPath:nil
                                                                                      cacheName:nil];
        
        [catefetchedResultsController setDelegate:self];
        
        
        NSError *error = nil;
        if (![catefetchedResultsController performFetch:&error])
        {
            NSLog(@"Error performing fetch: %@", error);
        }
    }
  //  NSLog(@"inside fetch %@",self.notes);
    return catefetchedResultsController;
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (controller==catefetchedResultsController)
    {
        [self.tableView reloadData];
      //  NSLog(@"inside");
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField == self.searchCate){
        
     //   [self filterCate:searchStr];
      
        
        self.searchSTR=searchStr;
        catefetchedResultsController=nil;
        [self catefetchedResultsController];
        [self.tableView reloadData];
    }
    return true;
}


-(void)filterCate:(NSString*)text
{
    filteredTableData = [[NSMutableArray alloc] init];
    
    // Create our fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Define the entity we are looking for
    
    NSManagedObjectContext* mangedobjectContext=[self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes"
                                              inManagedObjectContext:mangedobjectContext];
    
    
    [fetchRequest setEntity:entity];
    NSPredicate *predicate;// = [NSPredicate predicateWithFormat:@"mod_time==%i",0];
   // [fetchRequest setPredicate:predicate];
    

    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"mod_time" ascending:YES];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1,sd2, nil];
      [fetchRequest setSortDescriptors:sortDescriptors];
    
    // If we are searching for anything...
    if(text.length > 0)
    {
        // Define how we want our entities to be filtered
        predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[c] %@)", text];
        [fetchRequest setPredicate:predicate];
    }
    NSError *error;
    
    // Finally, perform the load
    NSArray* loadedEntities = [mangedobjectContext executeFetchRequest:fetchRequest error:&error];
    filteredTableData = [[NSMutableArray alloc] initWithArray:loadedEntities];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   self.navigationItem.title = @"My Notes";
   // [_navigationItem setFont: [UIFont fontWithName:@"Avenir" size:15.0]];
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIFont fontWithName:@"Avenir" size:21],
//      NSFontAttributeName, nil]];
    
    
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:20.0],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    };


    tableView.dataSource = self;
    tableView.delegate = self;
    
    
  //  button in below tBLEVIEW.
 [self.view addSubview:tableView];
    
    
    
    // Button in above tableview
    [self.view addSubview:addButton];
    

    
    
//    sideBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(sideButtonPressed:)];
//    self.navigationItem.rightBarButtonItem = sideBtn;
//    _searchCate.hidden = YES;
//    
//    GettouchStr=@"hidden";
    
    formatter = [[NSDateFormatter alloc] init];
    formatter.doesRelativeDateFormatting = YES;
    formatter.locale = [NSLocale currentLocale];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
                CATransition *animation = [CATransition animation];
            [animation setDuration:2.0];
            [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromTop];
    
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
        [[addButton layer] addAnimation:animation forKey:@"SwitchToDown"];
        
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
//

   


}
//- (void)sideButtonPressed:(id)sender
//{
//    if ([GettouchStr isEqualToString:@"hidden"])
//    {
//        
//        _searchCate.alpha = 0;
//        [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
//            _searchCate.alpha = 0;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                _searchCate.alpha = 1;
//                _searchCate.hidden = NO;
//                GettouchStr=@"UNhidden";
//            } completion:nil];
//        }];
//        
//        [self.searchCate becomeFirstResponder ];
//        
//    
//        
//        
//    }
//    else
//    {
//        _searchCate.alpha = 1;
//        [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
//            _searchCate.alpha = 1;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                _searchCate.alpha = 0;
//                _searchCate.hidden = YES;
//                GettouchStr=@"hidden";
//            } completion:nil];
//        }];
//        
//        
//        [_searchCate resignFirstResponder];
//        
//        
//        
//    }
//    
//    
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   //  Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Notes"];
    
    NSError *error = nil;
    self.notes = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    NSSortDescriptor *titleSorter= [[NSSortDescriptor alloc] initWithKey:@"mod_time" ascending:NO];
    
    [self.notes sortUsingDescriptors:[NSArray arrayWithObject:titleSorter]]
    ;
    
    NSLog(@"Your Error - %@",error.description);
    
    [tableView reloadData];
}

//-(void)dismissKeyboard {
//    [_searchCate resignFirstResponder];
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[self fetchedResultsControllerCate] sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    // Return the number of rows in the section.
   // return self.notes.count;


    NSArray *sectionCate = [[self fetchedResultsControllerCate] sections];
    
    

        
        
        if (sectionIndex < [sectionCate count])
        {
            id <NSFetchedResultsSectionInfo> sectionInfo = [sectionCate objectAtIndex:sectionIndex];
            
           // NSLog(@"sectionInfo.numberOfObjects %lu",(unsigned long)sectionInfo.numberOfObjects);
            
            return sectionInfo.numberOfObjects;
            
        }
    
    
    return 0;


}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

      FilterButton *testButton = [[FilterButton alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    UIImageView*sideImage=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];

    // Configure the cell...
    Notes*note=(Notes*)[[self fetchedResultsControllerCate] objectAtIndexPath:indexPath];
    
    NSDate *date =note.mod_time;
    
        NSString *dateString = [formatter stringFromDate:date];
    if([note.check isEqualToString:@"yes"]){
        
        cell.textLabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];

     

        [sideImage setImage:[UIImage imageNamed:@"tick"]];
    
    }else{
        cell.backgroundColor = [UIColor clearColor];
        
    

  
        [sideImage setImage:[UIImage imageNamed:@"oval"]];
    // NSLog(@" write no");
    }

     testButton.myDate=note.mod_time;
    cell.textLabel.text = note.title;

    cell.detailTextLabel.text = dateString;
     [testButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
     [cell setIndentationLevel:1];
    [cell setIndentationWidth:45];
    [cell.contentView addSubview:sideImage];
    [cell.contentView addSubview:testButton];


    
    return cell;
    
}



-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    //[textField resignFirstResponder];
    [_searchCate resignFirstResponder];
    return YES;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.textLabel.font = [UIFont fontNamesForFamilyName:@"Avenir"];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:19.0];
    
     cell.detailTextLabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
    
    cell.detailTextLabel.font=[UIFont fontWithName:@"Avenir" size:15.0];
//    self.navigationItem.title = @"My Notes";
    

   
}

-(void)buttonTouched:(id)sender

{
        FilterButton *btn = (FilterButton *)sender;
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    Notes * NotesUpdateing;
    
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"mod_time==%@",btn.myDate];
   // NSLog(@"btn.myDate   ..%@",btn.myDate);
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    
    NSError *error = nil;
    
    // Below line is giving me error
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if (array != nil) {
        NSUInteger count = [array count]; // may be 0 if the object has been deleted.
        if(count==0){
            
            NSLog(@"nothing  to updates");
          
            
            
        }else{
           NotesUpdateing = (Notes*)[array objectAtIndex:0];
       
            if ([NotesUpdateing.check isEqualToString:@"no"]) {
           
            
            NotesUpdateing.check=@"yes";
             NSLog(@" write yes");
                btn.selected=NO;
            
            }
            else
            {
                NotesUpdateing.check=@"no";
                btn.selected=NO;
                 NSLog(@" write no");
                
            }
            
        }
    }
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [self.tableView reloadData];
    

        

        

    }
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UIView * txt in self.view.subviews){
//        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
//            [txt resignFirstResponder];
//        }
//    }
//}
-(void) textFieldDidBeginEditing: (UITextField *) textField{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DismissKeyboard:)]];
}


-(void) DismissKeyboard:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:sender];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Notes *note = (Notes *)[[self fetchedResultsControllerCate] objectAtIndexPath:indexPath];
    NSDate *date =note.mod_time;
//
//    [self dismissKeyboard];
    note.check = [note.check isEqualToString:@"yes"] ? @"no" : @"yes";
    //[_searchCate resignFirstResponder];

    
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    //[[_notes objectAtIndex:indexPath.row] checked];
//    //[tableView reloadData];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    // _notes.taskArray[indexPath.row][@"CheckStat"] = @YES
//    
//}



- (IBAction)addButtonPressed:(id)sender {
    AddNoteViewController *addNoteVC = [AddNoteViewController new];
    
    


    // to remove unused warning....
#pragma unused (addNoteVC)

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)cTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSManagedObjectContext *context = [self managedObjectContext];
    
    
    
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database

        
        NSError *error = nil;
        
        
        
        
         Notes*note=(Notes*)[[self fetchedResultsControllerCate] objectAtIndexPath:indexPath];
        
        
        NSManagedObjectContext *context = [self managedObjectContext];
       
        
        NSFetchRequest *request= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:context];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"mod_time==%@",note.mod_time];
        // NSLog(@"btn.myDate   ..%@",btn.myDate);
        [request setEntity:entity];
        [request setPredicate:predicate];
        
        
        
        // Below line is giving me error
        
        NSArray *array = [context executeFetchRequest:request error:&error];
        
        if (array != nil) {
            NSUInteger count = [array count]; // may be 0 if the object has been deleted.
            if(count==0){
                
                NSLog(@"nothing  to updates");
                
                
                
            }else{
                
                
                [context deleteObject:[array objectAtIndex:0]];
                
            }
        }
       

    
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }

    }
}
- (IBAction)btnClick:(id)sender {
}



-(UITableViewCell*)CategoryTablecreateCellFor:(UITableViewCell*)cell CellindexPath:(NSIndexPath*)indexPath{
    Notes*cateRecipe=(Notes*)[[self fetchedResultsControllerCate] objectAtIndexPath:indexPath];
    
    
    UILabel *txt=[[UILabel alloc] initWithFrame:CGRectMake(130, 0, 150, 70)];
    txt.text=cateRecipe.title;
    txt.textColor=[UIColor darkGrayColor];
    [txt setFont: [UIFont fontWithName:@"Avenir" size:19.0]];
    
    
    
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.contentView addSubview:txt];
    
    
    return cell;
}
@end
