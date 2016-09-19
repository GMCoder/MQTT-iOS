//
//  ChatViewCell.m
//  MQTTChat
//
//  Created by 高明 on 16/9/18.
//
//

#import "ChatViewCell.h"

@implementation ChatViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)setContentStr:(NSString *)contentStr
{
    _contentLabel.text = contentStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
