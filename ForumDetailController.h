//
//  ForumDetailController.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 30/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumCellModel.h"

@interface ForumDetailController : BaseController

@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *topicsArray;

@property (nonatomic, weak) IBOutlet UILabel *titleText;
@property (nonatomic, weak) IBOutlet UIButton *mSubscribeBtn;

@property (nonatomic, strong) NSMutableDictionary *mainDict;



@property (nonatomic, strong) IBOutlet UIView *createView;

@property (nonatomic, strong) IBOutlet UITextField *topicTitle;
@property (nonatomic, strong) IBOutlet UITextView *topicContent;

@property (nonatomic, strong) IBOutlet UITextField *topicTags;

@property (nonatomic, strong) IBOutlet UISwitch *mNotifOption;


@end
