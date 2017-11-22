#line 1 "/Users/xhq/Desktop/fanbianyi/10_31/11_09/支持wifi的钉钉/ddXHQDylib/ddXHQDylib.xm"
#import "MenuWindow/WBAssistantManager.h"
#import "WIFI/WBWifiStore.h"
#import "WIFI/WBWifiModel.h"
#import <SystemConfiguration/CaptiveNetwork.h>


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class DTAppDelegate; 
static void (*_logos_orig$_ungrouped$DTAppDelegate$applicationDidBecomeActive$)(_LOGOS_SELF_TYPE_NORMAL DTAppDelegate* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$DTAppDelegate$applicationDidBecomeActive$(_LOGOS_SELF_TYPE_NORMAL DTAppDelegate* _LOGOS_SELF_CONST, SEL, id); 

#line 6 "/Users/xhq/Desktop/fanbianyi/10_31/11_09/支持wifi的钉钉/ddXHQDylib/ddXHQDylib.xm"
 

static void _logos_method$_ungrouped$DTAppDelegate$applicationDidBecomeActive$(_LOGOS_SELF_TYPE_NORMAL DTAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
	_logos_orig$_ungrouped$DTAppDelegate$applicationDidBecomeActive$(self, _cmd, arg1);

	[[WBAssistantManager sharedManager] showMenu];
}






































































static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$DTAppDelegate = objc_getClass("DTAppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$DTAppDelegate, @selector(applicationDidBecomeActive:), (IMP)&_logos_method$_ungrouped$DTAppDelegate$applicationDidBecomeActive$, (IMP*)&_logos_orig$_ungrouped$DTAppDelegate$applicationDidBecomeActive$);} }
#line 83 "/Users/xhq/Desktop/fanbianyi/10_31/11_09/支持wifi的钉钉/ddXHQDylib/ddXHQDylib.xm"
