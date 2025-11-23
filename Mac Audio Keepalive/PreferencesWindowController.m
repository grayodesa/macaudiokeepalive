
    #import "PreferencesWindowController.h"
    #import "SettingsManager.h"

    @implementation PreferencesWindowController

    - ( instancetype ) init
    {
        self = [ super initWithWindowNibName : @"PreferencesWindow" ];
        if ( self )
        {
            // Window will be loaded from PreferencesWindow.xib
        }
        return self;
    }

    - ( void ) windowDidLoad
    {
        [ super windowDidLoad ];

        // Configure window
        [ [ self window ] setLevel : NSFloatingWindowLevel ];
        [ [ self window ] center ];

        // Load current settings and update UI
        [ self updateUI ];

        NSLog( @"PreferencesWindowController: Window loaded" );
    }

    - ( void ) showWindow : ( id ) sender
    {
        [ super showWindow : sender ];
        [ self updateUI ];
        [ [ self window ] makeKeyAndOrderFront : sender ];
        [ NSApp activateIgnoringOtherApps : YES ];
    }

    - ( void ) updateUI
    {
        SettingsManager* settings = [ SettingsManager sharedManager ];

        // Update mode radio buttons
        [ _modeMatrix selectCellWithTag : settings.audioMode ];

        // Update interval popup
        [ _intervalPopup selectItemWithTag : settings.intervalMinutes ];

        // Update status label
        if ( settings.audioMode == AudioModeContinuous )
        {
            [ _statusLabel setStringValue : @"✓ Audio keepalive is active (Continuous Mode)" ];
        }
        else
        {
            NSString* statusText = [ NSString stringWithFormat : @"✓ Audio keepalive is active (Interval: %ld minutes)" ,
                                    ( long ) settings.intervalMinutes ];
            [ _statusLabel setStringValue : statusText ];
        }

        NSLog( @"PreferencesWindowController: UI updated - mode: %ld, interval: %ld" ,
               ( long ) settings.audioMode ,
               ( long ) settings.intervalMinutes );
    }

    - ( IBAction ) modeChanged : ( id ) sender
    {
        NSMatrix* matrix = ( NSMatrix* ) sender;
        NSInteger selectedTag = [ [ matrix selectedCell ] tag ];

        SettingsManager* settings = [ SettingsManager sharedManager ];
        settings.audioMode = ( AudioMode ) selectedTag;
        [ settings saveSettings ];

        NSLog( @"PreferencesWindowController: Mode changed to %ld" , ( long ) selectedTag );

        [ self updateUI ];

        // Notify delegate
        if ( _delegate && [ _delegate respondsToSelector : @selector(preferencesDidChange) ] )
        {
            [ _delegate preferencesDidChange ];
        }
    }

    - ( IBAction ) intervalChanged : ( id ) sender
    {
        NSPopUpButton* popup = ( NSPopUpButton* ) sender;
        NSInteger selectedTag = [ [ popup selectedItem ] tag ];

        SettingsManager* settings = [ SettingsManager sharedManager ];
        settings.intervalMinutes = selectedTag;
        [ settings saveSettings ];

        NSLog( @"PreferencesWindowController: Interval changed to %ld minutes" , ( long ) selectedTag );

        [ self updateUI ];

        // Notify delegate
        if ( _delegate && [ _delegate respondsToSelector : @selector(preferencesDidChange) ] )
        {
            [ _delegate preferencesDidChange ];
        }
    }

    - ( IBAction ) resetToDefaults : ( id ) sender
    {
        SettingsManager* settings = [ SettingsManager sharedManager ];
        [ settings resetToDefaults ];

        NSLog( @"PreferencesWindowController: Reset to defaults" );

        [ self updateUI ];

        // Notify delegate
        if ( _delegate && [ _delegate respondsToSelector : @selector(preferencesDidChange) ] )
        {
            [ _delegate preferencesDidChange ];
        }
    }

    - ( BOOL ) windowShouldClose : ( id ) sender
    {
        // Hide window instead of closing
        [ [ self window ] orderOut : sender ];
        return NO;
    }

    @end
