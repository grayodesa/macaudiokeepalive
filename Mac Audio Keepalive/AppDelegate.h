
    #import <Cocoa/Cocoa.h>
    #import "PreferencesWindowController.h"

    @interface AppDelegate : NSObject <NSApplicationDelegate, PreferencesWindowDelegate>

    - ( void ) showPreferences : ( id ) sender;

    @end

