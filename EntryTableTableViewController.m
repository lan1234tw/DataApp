//
//  EntryTableTableViewController.m
//  DataApp
//
//  Created by HsiuYi on 2014/3/13.
//  Copyright (c) 2014年 HsiuYi. All rights reserved.
//

#import "EntryTableTableViewController.h"
#import "CoreDataHelper.h"
#import "Item.h"

@interface EntryTableTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController* fetchController;

@end


@implementation EntryTableTableViewController
@synthesize tableView = _tableView;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configureFetch {
  
  
  NSFetchRequest* request =nil;
  request =[NSFetchRequest fetchRequestWithEntityName:@"Item"];
  
  NSSortDescriptor *sortDesc =nil;
  sortDesc =[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  
  request.sortDescriptors =[NSArray arrayWithObjects:sortDesc, nil];
  
  self.fetchController =[[NSFetchedResultsController alloc]
                         initWithFetchRequest:request
                         managedObjectContext:[[CoreDataHelper instance] managedObjectContext]
                         sectionNameKeyPath:nil
                         cacheName:nil];
  
  self.fetchController.delegate =self;
}

- (void)performFetch {
  if(nil != self.fetchController) {
    // [self.fetchController.managedObjectContext performBlockAndWait:^{
      NSError* err;
      
      NSLog(@">>>>>>>>>>> performFetch");
      if(NO == [self.fetchController performFetch:&err]) {
        NSLog(@"%@", err.debugDescription);
      } // if
      
      [self.tableView reloadData];
    // }];
  } // if
  else {
    NSLog(@"Fetch controller is nil.");
  } // else
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
  NSLog(@"controllerWillChangeContent");
}


- (void)controller:(NSFetchedResultsController *)controller
        didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
        atIndex:(NSUInteger)sectionIndex
        forChangeType:(NSFetchedResultsChangeType)type {
  
  NSLog(@"didChangeSection");
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller
        didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
        forChangeType:(NSFetchedResultsChangeType)type
        newIndexPath:(NSIndexPath *)newIndexPath {
  
  NSLog(@"didChangeObject");
  
  UITableView *tableView = self.tableView;
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      NSLog(@"NSFetchedResultsChangeInsert");
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      NSLog(@"NSFetchedResultsChangeDelete");
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      NSLog(@"NSFetchedResultsChangeUpdate");
      // [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
  NSLog(@"controllerDidChangeContent");
}

#pragma mark - View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
  
  // 加上下面這行可以在切換頁面的時候保留被選擇的列
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // 下面這行用來顯示navigation bar上的Edit按鈕
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
  [self configureFetch];
  [self performFetch];
  
  [self configureNotification];
  
  /*
  dispatch_queue_t queue;
  queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  // queue =dispatch_get_main_queue();
  
  dispatch_async(queue, ^{
    
    NSDateFormatter* dateFormatter =nil;
    dateFormatter =[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh.mm.ss"];
    
    for(int i =0; i < 10; ++i) {
      NSString* dateValue =[dateFormatter stringFromDate:[NSDate date]];
      NSLog(@"%@", dateValue);
      
      Item *item =nil;
      item =[NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                 inManagedObjectContext:[[CoreDataHelper instance] managedObjectContext]];
      
      item.name =dateValue;
      item.type =@"type_a";
      item.item_id =dateValue;
      
      [[CoreDataHelper instance] saveContext];
      
      sleep(3);
      // dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];
      // });
    } // for
  });
  */
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)configureNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(performFetch)
                                        name:@"dataChanged"
                                        object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.fetchController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self.fetchController.sections objectAtIndex:section] numberOfObjects];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  return [self.fetchController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [[self.fetchController.sections objectAtIndex:section] name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
  Item* item =nil;
  item =[self.fetchController objectAtIndexPath:indexPath];
  cell.textLabel.text =item.name;
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
