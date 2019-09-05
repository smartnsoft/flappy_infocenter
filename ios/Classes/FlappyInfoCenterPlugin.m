#import "FlappyInfoCenterPlugin.h"
#import <flappy_infocenter/flappy_infocenter-Swift.h>

@implementation FlappyInfoCenterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlappyInfoCenterPlugin registerWithRegistrar:registrar];
}
@end
