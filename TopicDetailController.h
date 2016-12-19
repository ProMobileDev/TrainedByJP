//
//  TopicDetailController.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 31/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumCellModel.h"

@interface TopicDetailController : BaseController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleText;
@property (nonatomic, weak) IBOutlet UITableView *mTable;

@property (nonatomic, strong) NSMutableArray *mainCommentsArray;
@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) UIWebView *mWebView;

@property (nonatomic, weak) IBOutlet UIButton *mSubscribeBtn;

@property (nonatomic, weak) IBOutlet UIView *createView;

@property (nonatomic, weak) IBOutlet UITextView *topicContent;
@property (nonatomic, weak) IBOutlet UITextField *topicTags;

@property (nonatomic, weak) IBOutlet UISwitch *mNotifOption;

@property (nonatomic, strong) NSMutableDictionary *mainDict;

@property (nonatomic, weak) IBOutlet UIScrollView *mScrollView;

@property (nonatomic, strong) UIButton *selectedBtn;

@end
