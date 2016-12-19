//
//  DetailVideoController.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 31/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@interface DetailVideoController : BaseController
{
    BOOL shouldLoadMore;
    int currentPageIndex;
}

@property (nonatomic, weak) IBOutlet UILabel *titleText;
@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *workoutsArray;

@property (nonatomic, strong) NSDictionary *mainDict;


@end
