
    #import "AppDelegate.h"
    #import "AudioController.h"
    #import "SettingsManager.h"
    #import "PreferencesWindowController.h"

    @interface AppDelegate ()
    {
        NSStatusItem* statusItem;
        AudioController* audioController;
        PreferencesWindowController* preferencesWindow;
    }
    @end

    @implementation AppDelegate

    - ( void ) applicationDidFinishLaunching : ( NSNotification*) theNotification
    {
        // Load settings first
        [ [ SettingsManager sharedManager ] loadSettings ];

        // Create menu
        NSMenu *menu = [ [ NSMenu alloc ] init ];

        [ menu addItemWithTitle : @"Running" action : nil keyEquivalent : @"" ];
        [ menu addItem : [ NSMenuItem separatorItem ] ];
        [ menu addItemWithTitle : @"Preferences..." action : @selector(showPreferences:) keyEquivalent : @"," ];
        [ menu addItem : [ NSMenuItem separatorItem ] ];
        [ menu addItemWithTitle : @"Donate if you like the app" action : @selector(support) keyEquivalent : @"" ];
        [ menu addItemWithTitle : @"Check for updates" action : @selector(update) keyEquivalent : @"" ];
        [ menu addItemWithTitle : @"Quit" action : @selector(terminate) keyEquivalent : @"" ];

        // Setup status item
        statusItem = [ [ NSStatusBar systemStatusBar ] statusItemWithLength : NSVariableStatusItemLength ];
        [ statusItem setToolTip : @"Audio Keepalive" ];
        [ statusItem setMenu : menu ];
        [ statusItem setImage : [ NSImage imageNamed : @"icon" ] ];
        [ [ statusItem image ] setTemplate : YES ];

        // Initialize audio system
        audioController = [ [ AudioController alloc ] init ];
        if ( audioController )
        {
            [ audioController applySettings ];
            NSLog( @"AppDelegate: Audio system initialized" );
        }
        else
        {
            NSLog( @"AppDelegate: Failed to initialize audio system" );
        }
    }

    - ( void ) terminate
    {
        [ NSApp terminate : nil ];
    }

    - ( void ) support
    {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: @"https://paypal.me/milgra"]];
    }

    - ( void ) update
    {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: @"https://milgra.com/macos-audio-keepalive.html"]];
    }

    - ( void ) showPreferences : ( id ) sender
    {
        if ( !preferencesWindow )
        {
            preferencesWindow = [ [ PreferencesWindowController alloc ] init ];
            preferencesWindow.delegate = self;
            NSLog( @"AppDelegate: Created preferences window" );
        }
        [ preferencesWindow showWindow : sender ];
    }

    - ( void ) preferencesDidChange
    {
        NSLog( @"AppDelegate: Preferences changed, reconfiguring audio" );
        [ audioController applySettings ];
    }

    @end
