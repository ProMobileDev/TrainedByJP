//
//  ForumsController.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 25/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumsController : BaseController

@property (nonatomic, weak) IBOutlet UITableView *myTable;

@property (nonatomic, strong) NSMutableArray *topicsArray;

@end
