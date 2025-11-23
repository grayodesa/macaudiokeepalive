
    #import "SettingsManager.h"

    static NSString* const kSettingsKeyAudioMode = @"audioMode";
    static NSString* const kSettingsKeyIntervalMinutes = @"intervalMinutes";

    static NSInteger const kDefaultIntervalMinutes = 25;
    static AudioMode const kDefaultAudioMode = AudioModeContinuous;

    @implementation SettingsManager

    + ( instancetype ) sharedManager
    {
        static SettingsManager* instance = nil;
        static dispatch_once_t onceToken;
        dispatch_once( &onceToken , ^{
            instance = [ [ SettingsManager alloc ] init ];
            [ instance loadSettings ];
        } );
        return instance;
    }

    - ( void ) loadSettings
    {
        NSUserDefaults* defaults = [ NSUserDefaults standardUserDefaults ];

        if ( [ defaults objectForKey : kSettingsKeyAudioMode ] )
        {
            _audioMode = [ defaults integerForKey : kSettingsKeyAudioMode ];
        }
        else
        {
            _audioMode = kDefaultAudioMode;
        }

        if ( [ defaults objectForKey : kSettingsKeyIntervalMinutes ] )
        {
            _intervalMinutes = [ defaults integerForKey : kSettingsKeyIntervalMinutes ];
        }
        else
        {
            _intervalMinutes = kDefaultIntervalMinutes;
        }

        // Validate interval is within acceptable range
        if ( _intervalMinutes < 5 || _intervalMinutes > 30 )
        {
            _intervalMinutes = kDefaultIntervalMinutes;
        }
    }

    - ( void ) saveSettings
    {
        NSUserDefaults* defaults = [ NSUserDefaults standardUserDefaults ];
        [ defaults setInteger : _audioMode forKey : kSettingsKeyAudioMode ];
        [ defaults setInteger : _intervalMinutes forKey : kSettingsKeyIntervalMinutes ];
        [ defaults synchronize ];
    }

    - ( void ) resetToDefaults
    {
        _audioMode = kDefaultAudioMode;
        _intervalMinutes = kDefaultIntervalMinutes;
        [ self saveSettings ];
    }

    @end
