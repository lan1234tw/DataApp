//
//  Item.h
//  DataApp
//
//  Created by HsiuYi on 2014/3/13.
//  Copyright (c) 2014年 HsiuYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * item_id;
@property (nonatomic, retain) NSString * type;

@end
