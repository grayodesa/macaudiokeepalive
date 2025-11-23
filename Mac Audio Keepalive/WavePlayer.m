
    #import "WavePlayer.h"


	// plain c callback function called by AudioQueue when last buffer is empty

	void updateQueue (  void*               theData   ,
                        AudioQueueRef       theQueue  ,
                        AudioQueueBufferRef theBuffer )
	{

		AudioQueueEnqueueBuffer( theQueue ,
                                 theBuffer ,
                                 0 ,
                                 NULL );

	}


    @implementation WavePlayer


    // constructor

	- ( id ) init
	{

        self = [ super init ];

        if ( self )
        {

            _isPlaying = NO;

            // setup audio format

            audioFormat = ( AudioStreamBasicDescription )
            {
                .mFormatID          = kAudioFormatLinearPCM,
                .mFormatFlags       = 0 |
                                      kAudioFormatFlagIsPacked |
                                      kAudioFormatFlagIsSignedInteger |
                                      kAudioFormatFlagsNativeEndian ,
                .mSampleRate        = 44100 ,
                .mBitsPerChannel    = 8,
                .mChannelsPerFrame  = 1,
                .mBytesPerFrame     = 1,
                .mFramesPerPacket   = 1,
                .mBytesPerPacket    = 1,
            };

            // create output and assign to audioQueue

            OSStatus status = AudioQueueNewOutput(
                &audioFormat ,			// audio format
                updateQueue  ,			// callback function on buffer update request
                NULL         ,			// custom parameter, passing ourself
                NULL         ,			// timing comes from the audioqueue's thread
                NULL         ,			// default loop mode
                0            ,			// flags
                &audioQueue  );         // audio queue which stores the created session

            if ( status != noErr )
            {
                NSLog( @"WavePlayer: Failed to create audio queue: %d" , status );
                return nil;
            }

            // allocate buffers

            for ( int bufferCount = 0 ;
                      bufferCount < 2 ;
                    ++bufferCount   )
            {

                // allocate buffer

                status = AudioQueueAllocateBuffer(
                    audioQueue                   ,
                    kBufferSize                  ,
                    &frameBuffers[ bufferCount ] );

                if ( status != noErr )
                {
                    NSLog( @"WavePlayer: Failed to allocate buffer %d: %d" , bufferCount , status );
                    AudioQueueDispose( audioQueue , true );
                    return nil;
                }

            }

            // Set volume to 100% (10Hz is inaudible regardless of volume)
            // Maximum signal strength ensures KRK speaker detection circuit can sense it

            AudioQueueSetParameter(
                audioQueue              ,
                kAudioQueueParam_Volume ,
                1.0                     );

        }

        return self;

	}


	// start playing audio

	- ( BOOL ) start
	{

        if ( _isPlaying )
        {
            return YES;  // Already playing
        }

        // Generate 10Hz sine wave (below human hearing, but detectable by KRK speakers)
        // This is the known "10Hz hack" used to prevent KRK auto-standby

        for ( int bufferCount = 0 ;
                  bufferCount < 2 ;
                ++bufferCount   )
        {

            for ( int index = 0 ;
                      index < kBufferSize / 4 ;
                      index++ )
            {

                int8_t* buffer = ( int8_t* ) ( frameBuffers[ bufferCount ]->mAudioData );

                // 10Hz sine wave calculation
                // Sample rate: 44100 Hz, Frequency: 10 Hz
                // Amplitude: 20% of 8-bit range (±25 out of ±127)
                // Formula: amplitude * sin(2π * frequency * sample / sampleRate)

                double frequency = 10.0;
                double sampleRate = 44100.0;
                double amplitude = 25.0;  // 20% of 127 (inaudible at 10Hz but strong signal)

                for ( int i = 0; i < 4; i++ )
                {
                    int globalSampleIndex = ( bufferCount * kBufferSize / 4 + index ) * 4 + i;
                    double phase = 2.0 * M_PI * frequency * globalSampleIndex / sampleRate;
                    buffer[ index * 4 + i ] = ( int8_t )( amplitude * sin( phase ) );
                }

            }

            // set size

            frameBuffers[ bufferCount ]->mAudioDataByteSize = kBufferSize;

            // enqueue buffer

            OSStatus status = AudioQueueEnqueueBuffer( audioQueue                  ,
                                         frameBuffers[ bufferCount ] ,
                                         0                           ,
                                         NULL                       );

            if ( status != noErr )
            {
                NSLog( @"WavePlayer: Failed to enqueue buffer %d: %d" , bufferCount , status );
                return NO;
            }

        }

        // start playing audioqueue

        OSStatus status = AudioQueueStart(
            audioQueue ,
            NULL       );

        if ( status != noErr )
        {
            NSLog( @"WavePlayer: Failed to start audio queue: %d" , status );
            return NO;
        }

        _isPlaying = YES;
        return YES;

	}


	// stop playing audio

	- ( void ) stop
	{

        if ( !_isPlaying )
        {
            return;  // Already stopped
        }

        AudioQueueStop( audioQueue , YES );  // Immediate stop
        _isPlaying = NO;

	}


	// destructor

	- ( void ) dealloc
	{

        [ self stop ];
		AudioQueueDispose( audioQueue , true );

	}


    @end
