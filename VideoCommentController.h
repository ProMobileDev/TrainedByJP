//
//  VideoCommentController.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 03/09/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumCellModel.h"

@interface VideoCommentController : BaseController <UIWebViewDelegate, UITextViewDelegate>
{
    long currentPageIndex;
}

@property (nonatomic, weak) IBOutlet UITableView *mTable;

@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) NSMutableDictionary *mainDict;

@property (nonatomic, weak) IBOutlet UIScrollView *mScrollView;

@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, weak) IBOutlet UITextView *commentBox;

@end
