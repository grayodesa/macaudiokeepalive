
    #import <Foundation/Foundation.h>

    typedef NS_ENUM( NSInteger , AudioMode )
    {
        AudioModeContinuous = 0,
        AudioModeInterval = 1
    };

    /**
     * SettingsManager handles persistence of user preferences via NSUserDefaults.
     * Singleton pattern provides centralized settings access.
     */
    @interface SettingsManager : NSObject

    + ( instancetype ) sharedManager;

    // Settings Properties
    @property ( nonatomic , assign ) AudioMode audioMode;
    @property ( nonatomic , assign ) NSInteger intervalMinutes;  // 5, 10, 15, 20, 25, 30

    // Methods
    - ( void ) loadSettings;
    - ( void ) saveSettings;
    - ( void ) resetToDefaults;

    @end
