
    #import "AudioScheduler.h"
    #import "WavePlayer.h"

    @interface AudioScheduler()
    {
        dispatch_source_t timer;
    }
    @end

    @implementation AudioScheduler

    - ( instancetype ) initWithWavePlayer : ( WavePlayer* ) player
    {
        self = [ super init ];
        if ( self )
        {
            _wavePlayer = player;
            _isScheduling = NO;
            timer = nil;
        }
        return self;
    }

    - ( void ) startWithIntervalMinutes : ( NSInteger ) minutes
    {
        // Stop any existing timer
        [ self stop ];

        if ( !_wavePlayer )
        {
            NSLog( @"AudioScheduler: No wave player configured" );
            return;
        }

        // Convert minutes to nanoseconds
        int64_t intervalNanoseconds = minutes * 60 * NSEC_PER_SEC;

        // Create timer using GCD
        timer = dispatch_source_create( DISPATCH_SOURCE_TYPE_TIMER ,
                                        0 ,
                                        0 ,
                                        dispatch_get_main_queue() );

        if ( !timer )
        {
            NSLog( @"AudioScheduler: Failed to create timer" );
            return;
        }

        // Set timer to fire immediately, then at interval
        dispatch_source_set_timer( timer ,
                                   dispatch_time( DISPATCH_TIME_NOW , 0 ) ,  // Start immediately
                                   intervalNanoseconds ,
                                   0 );  // No leeway

        // Setup event handler
        __weak typeof( self ) weakSelf = self;
        dispatch_source_set_event_handler( timer , ^{
            [ weakSelf timerFired ];
        } );

        // Start the timer
        dispatch_resume( timer );
        _isScheduling = YES;

        NSLog( @"AudioScheduler: Started with interval of %ld minutes" , ( long ) minutes );
    }

    - ( void ) timerFired
    {
        if ( !_wavePlayer )
        {
            NSLog( @"AudioScheduler: Wave player no longer available" );
            [ self stop ];
            return;
        }

        NSLog( @"AudioScheduler: Timer fired, playing pulse" );

        // Start audio for 1 second pulse
        BOOL success = [ _wavePlayer start ];

        if ( !success )
        {
            NSLog( @"AudioScheduler: Failed to start wave player" );
            return;
        }

        // Stop after 5 seconds (longer pulse to reset speaker standby timers)
        dispatch_after( dispatch_time( DISPATCH_TIME_NOW , 5 * NSEC_PER_SEC ) ,
                       dispatch_get_main_queue() ,
                       ^{
                           [ self.wavePlayer stop ];
                           NSLog( @"AudioScheduler: Pulse complete" );
                       } );
    }

    - ( void ) stop
    {
        if ( timer )
        {
            dispatch_source_cancel( timer );
            timer = nil;
        }
        _isScheduling = NO;
        NSLog( @"AudioScheduler: Stopped" );
    }

    - ( void ) dealloc
    {
        [ self stop ];
    }

    @end
