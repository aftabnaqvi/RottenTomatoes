//
//  MovieCell.m
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/4/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	if (highlighted) {
		self.titleLabel.textColor = [UIColor purpleColor];
		self.synopsisLabel.textColor = [UIColor purpleColor];
	} else {
		self.titleLabel.textColor = [UIColor blackColor];
		self.synopsisLabel.textColor = [UIColor blackColor];
	}
}

@end
