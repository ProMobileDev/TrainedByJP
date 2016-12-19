//
//  ForumCellModel.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 24/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumCellModel : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *comment;

@property (nonatomic, weak) IBOutlet UILabel *timeText;
@property (nonatomic, weak) IBOutlet UILabel *titleText;
@property (nonatomic, weak) IBOutlet UILabel *postsText;
@property (nonatomic, weak) IBOutlet UILabel *voicesText;

@property (nonatomic, weak) IBOutlet UIImageView *forumImg;


@property (nonatomic, weak) IBOutlet UIScrollView  *mScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *mPageControl;

@property (nonatomic, weak) IBOutlet UIWebView *content;

@end
