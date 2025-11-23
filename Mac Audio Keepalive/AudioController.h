
    #import <Foundation/Foundation.h>
    #import "SettingsManager.h"

    /**
     * AudioController coordinates audio playback between continuous and interval modes.
     * Central management component for all audio operations.
     */
    @interface AudioController : NSObject

    - ( instancetype ) init;
    - ( void ) startWithMode : ( AudioMode ) mode intervalMinutes : ( NSInteger ) minutes;
    - ( void ) stop;
    - ( void ) applySettings;  // Reads from SettingsManager, reconfigures audio

    @end
