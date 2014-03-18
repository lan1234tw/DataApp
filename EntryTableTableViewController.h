//
//  EntryTableTableViewController.h
//  DataApp
//
//  Created by HsiuYi on 2014/3/13.
//  Copyright (c) 2014年 HsiuYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryTableTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
