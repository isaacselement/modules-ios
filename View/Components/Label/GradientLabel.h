#import "StrokeLabel.h"

@interface GradientLabel : StrokeLabel

@property (assign) int gradientCount;

@property (assign) float gradientStartR;
@property (assign) float gradientStartG;
@property (assign) float gradientStartB;
@property (assign) float gradientStartAlpah;

@property (assign) float gradientEndR;
@property (assign) float gradientEndG;
@property (assign) float gradientEndB;
@property (assign) float gradientEndAlpah;

@property (assign) float gradientStartPointX; // [0,1]
@property (assign) float gradientStartPointY; // [0,1]

@property (assign) float gradientEndPointX;
@property (assign) float gradientEndPointY;


@end
