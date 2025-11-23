
    #import <Cocoa/Cocoa.h>
    #import <AudioToolbox/AudioToolbox.h>


    #define kBufferSize 44100


	/**
	 * WavePlayer generates continuous inaudible audio signal to prevent optical/HDMI
	 * audio interface from entering power-saving mode.
	 *
	 * Uses double-buffered AudioQueue with 44.1kHz, 8-bit mono PCM.
	 * Signal pattern: 1-value pulse every 200 samples at 1% volume.
	 */
	@interface WavePlayer : NSObject
	{

		AudioQueueRef				audioQueue;
		AudioQueueBufferRef			frameBuffers[ 2 ];
		AudioStreamBasicDescription	audioFormat;

	}

	@property ( nonatomic , assign , readonly ) BOOL isPlaying;

	- ( instancetype ) init;
	- ( BOOL ) start;  // Returns YES on success, NO on error
	- ( void ) stop;

    @end
