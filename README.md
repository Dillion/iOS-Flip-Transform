##iOS-Flip-Transform  

Animation component for the effect of flipping as in a news/clock ticker, or a page turn. 

Structured around the idea of a data object (i.e. headline in news, number in a clock, page in a book) as an animation frame, comprised of multiple CALayers.  

Supports 3 interaction modes:  

 - __Triggered__: as in a tap to flip  
 - __Auto__: as in a revolving flip that loops through data  
 - __Controlled__: as in a pan gesture that moves the flip layer according to touch  

Supports different types of content:  

 - _Blank_, with background color  
 - _With image_, whether from file or screenshot  
 - _With dynamic text_, either composited on background or on image  

###Basic Usage

 1. Create delegate object -  
`AnimationDelegate *animationDelegate = [[AnimationDelegate alloc] initWithSequenceType: directionType:];`  

 2. Create flip view (either vertical or horizontal flip animation type) and assign it to animation delegate -  
`FlipView *flipView = [[FlipView alloc] initWithAnimationType: animationDelegate: frame:];`  
`animationDelegate.transformView = flipView;`  

 3. Add flip view as subview and customize properties (refer below for configurable list)  

 4. Call `[flipView printText: usingImage: backgroundColor: textColor:]` to draw each frame (minimum of 2)  

 5. Call `[animationDelegate startAnimation:]` to start the animation. For using buttons or pan gesture, look at the animation controller example  

Note: To remove jagged edges during flipping, set __Renders with edge antialiasing__ in the project plist to YES. This may decrease performance.  

###Configurable Properties

####Animation Delegate

 - __repeatDelay__: Length of time to the next flip after the current flip completes (only for _auto interaction mode_)
 - __shadow__: Whether or not to display shadow
 - __repeat__: Whether or not to loop through animation frames (only for _auto interaction mode_)
 - __sensitivity__: Positive modifier for input to animation response. Higher the sensitivity, greater the response. (only for _controlled interaction mode_)
 - __gravity__: Positive modifier for speed of movement to nearest resting state after input is removed. Higher the gravity, faster the speed. (only for _controlled interaction mode_)
 - __perspectiveDepth__: Positive value for adjusting the perspective. Lower the value, greater the illusion of depth.
 - __nextDuration__: duration of the next flip animation

####FlipView

 - __textInset__: inset of text relative to the flip view, like border margin
 - __textOffset__: positioning of text relative to top left of the flip view
 - __fontSize__: font size
 - __font__: font string, can be custom or inbuilt, defaults to Helvetica
 - __fontAlignment__: left, center or right alignment
 - __textTruncationMode__: none, start, middle or end truncation
 - __sublayerCornerRadius__: corner radius to apply to each sub panel of the flip view  