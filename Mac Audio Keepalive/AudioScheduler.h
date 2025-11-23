
    #import <Foundation/Foundation.h>

    @class WavePlayer;

    /**
     * AudioScheduler manages periodic audio pulses at user-defined intervals.
     * Uses GCD dispatch_source_t timer for precision and low overhead.
     */
    @interface AudioScheduler : NSObject

    @property ( nonatomic , weak ) WavePlayer* wavePlayer;  // Weak to avoid retain cycle
    @property ( nonatomic , assign , readonly ) BOOL isScheduling;

    - ( instancetype ) initWithWavePlayer : ( WavePlayer* ) player;
    - ( void ) startWithIntervalMinutes : ( NSInteger ) minutes;
    - ( void ) stop;

    @end
