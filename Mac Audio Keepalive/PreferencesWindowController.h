
    #import <Cocoa/Cocoa.h>

    @protocol PreferencesWindowDelegate <NSObject>
    - ( void ) preferencesDidChange;
    @end

    /**
     * PreferencesWindowController manages the preferences window UI.
     * Handles user input, updates settings, and notifies delegate of changes.
     */
    @interface PreferencesWindowController : NSWindowController

    @property ( nonatomic , weak ) id<PreferencesWindowDelegate> delegate;

    // IBOutlets connected to PreferencesWindow.xib
    @property ( weak ) IBOutlet NSMatrix* modeMatrix;
    @property ( weak ) IBOutlet NSPopUpButton* intervalPopup;
    @property ( weak ) IBOutlet NSTextField* statusLabel;

    - ( instancetype ) init;
    - ( void ) showWindow : ( id ) sender;
    - ( void ) updateUI;

    // IBActions from PreferencesWindow.xib
    - ( IBAction ) modeChanged : ( id ) sender;
    - ( IBAction ) intervalChanged : ( id ) sender;
    - ( IBAction ) resetToDefaults : ( id ) sender;

    @end
