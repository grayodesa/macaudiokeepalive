
    #import "AudioController.h"
    #import "WavePlayer.h"
    #import "AudioScheduler.h"
    #import "SettingsManager.h"

    @interface AudioController()
    {
        WavePlayer* wavePlayer;
        AudioScheduler* audioScheduler;
    }
    @end

    @implementation AudioController

    - ( instancetype ) init
    {
        self = [ super init ];
        if ( self )
        {
            wavePlayer = [ [ WavePlayer alloc ] init ];
            if ( !wavePlayer )
            {
                NSLog( @"AudioController: Failed to create WavePlayer" );
                return nil;
            }

            audioScheduler = [ [ AudioScheduler alloc ] initWithWavePlayer : wavePlayer ];
            if ( !audioScheduler )
            {
                NSLog( @"AudioController: Failed to create AudioScheduler" );
                return nil;
            }
        }
        return self;
    }

    - ( void ) startWithMode : ( AudioMode ) mode intervalMinutes : ( NSInteger ) minutes
    {
        // Stop current mode
        [ self stop ];

        NSLog( @"AudioController: Starting with mode %ld" , ( long ) mode );

        // Start new mode
        if ( mode == AudioModeContinuous )
        {
            // Continuous mode: just start and leave running
            BOOL success = [ wavePlayer start ];
            if ( success )
            {
                NSLog( @"AudioController: Continuous mode started" );
            }
            else
            {
                NSLog( @"AudioController: Failed to start continuous mode" );
            }
        }
        else  // AudioModeInterval
        {
            // Interval mode: start scheduler
            [ audioScheduler startWithIntervalMinutes : minutes ];
            NSLog( @"AudioController: Interval mode started with %ld minute interval" , ( long ) minutes );
        }
    }

    - ( void ) stop
    {
        [ audioScheduler stop ];
        [ wavePlayer stop ];
        NSLog( @"AudioController: Stopped all audio" );
    }

    - ( void ) applySettings
    {
        SettingsManager* settings = [ SettingsManager sharedManager ];

        NSLog( @"AudioController: Applying settings - mode: %ld, interval: %ld" ,
               ( long ) settings.audioMode ,
               ( long ) settings.intervalMinutes );

        [ self startWithMode : settings.audioMode
             intervalMinutes : settings.intervalMinutes ];
    }

    - ( void ) dealloc
    {
        [ self stop ];
    }

    @end
