//
//  AddNoteViewController.m
//  Note App
//
//  Created by Sathish Chinniah on 11/08/15.
//  Copyright (c) 2015 sathish chinniah. All rights reserved.
//

#import "AddNoteViewController.h"
#import "ViewController.h"

@interface AddNoteViewController ()
{
    UIBarButtonItem *doneButton;
 
    UIBarButtonItem *editButton;
}
@end


@implementation AddNoteViewController
@synthesize note;
@synthesize textView;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    

    [[UIBarButtonItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                                         [UIFont fontWithName:@"Avenir" size:20.0], NSFontAttributeName, nil]
                                               forState:UIControlStateNormal];
    
    //self.navigationItem.title = @"New Note";
    
    if (self.note) {
        [textView setText:[self.note valueForKey:@"note"]];
        [textView setEditable:NO];
        editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
        self.navigationItem.rightBarButtonItem = editButton;
        self.navigationItem.title = textView.text;
    }
    else{
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
        self.navigationItem.rightBarButtonItem = doneButton;
        
        //self.navigationItem.title = @"New Note";
    }
    
    
    
   [self.view addSubview:textView];

    // Do any additional setup after loading the view.
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}






- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Note"
                                                    message:@"Do you really want to save this note?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Save", nil];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    //NSLog(@"button index = %@",buttonIndex);
    if(buttonIndex == 0) {
        NSLog(@"OK Button is clicked");
    }
    else if(buttonIndex == 1) {
        
        if([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
        {
            if(!self.note)
            {
                NSManagedObjectContext *context = [self managedObjectContext];
                NSManagedObject *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:context];
                
                NSLog(@"%@",textView.text);
                
                [newNote setValue:textView.text forKey:@"note"];
                if([textView.text length]>30)
                {
                    [newNote setValue:[NSString stringWithFormat:@"%@...",[textView.text substringToIndex:25]] forKey:@"title"];
                }
                else
                    [newNote setValue:textView.text forKey:@"title"];
                [newNote setValue:[NSDate date] forKey:@"mod_time"];
                [newNote setValue:@"no" forKey:@"check"];
                //[newDevice setValue:self.versionTextField.text forKey:@"version"];
                //[newDevice setValue:self.companyTextField.text forKey:@"company"];
                
                NSError *error = nil;
                // Save the object to persistent store
                if (![context save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
            }
            else
            {
                [self.note setValue:textView.text forKey:@"note"];
                if([textView.text length]>30)
                {
                    [self.note setValue:[NSString stringWithFormat:@"%@...",[textView.text substringToIndex:25]] forKey:@"title"];
                }
                else
                    [self.note setValue:textView.text forKey:@"title"];
                [self.note setValue:[NSDate date] forKey:@"mod_time"];
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsuccessful"
                                                            message:@"Empty Note cannot be saved!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)editButtonPressed:(id)sender
{
    [textView setEditable:YES];
    self.navigationItem.rightBarButtonItem = doneButton;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"edit"]) {
//        UITableViewCell *cell = sender;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        UINavigationController *navigationController = segue.destinationViewController;
//        UIInputViewController *entryViewController = (entryViewController *)navigationController.topViewController;
//        entryViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        
//    }
//}

@end
