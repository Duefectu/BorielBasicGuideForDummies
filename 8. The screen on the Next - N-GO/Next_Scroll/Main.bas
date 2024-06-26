' - Next Scroll -------------------------------------------
' http://tinyurl.com/224u55ph

Main()
DO
LOOP


' - Includes ----------------------------------------------
#INCLUDE <retrace.bas>
#INCLUDE "NextLibLite.bas"


' - Main subroutine ---------------------------------------
SUB Main()
    ' Initialize the system
    Initialize()
    ' Layer 2 demo, 256x192
    Layer2_256x192()
    ' Sprite demo
    SpriteDemo()
END SUB


' - Initialize the system ---------------------------------
SUB Initialize()
    ' Yellow border, transparent paper, and yellow ink
    BORDER 6
    PAPER 3
    BRIGHT 1
    INK 6
    CLS
    
    ' Initializes NextLibLite
    NextInit()
    
    ' Set the clock to 28MHz
    NextReg($07,3)
    ' Set priorities: Sprites -> ULA -> Layer2
    NextReg($15,%00001001)
    ' Transparent colour for the ULA (magenta with brightness)
    NextReg($14,231)
    
    ' Print on the ULA layer
    PRINT AT 0,0;"This is the ULA layer";
    
    ' Load the sprites
    LoadSD("Ingrid.nspr",$c000,$4000,0)
    ' Define the sprites
    InitSprites(4,$c000)
        
    ' Load the tiles (16x16x20)
    LoadSD("Tiles.ntil",$c000,$1500,0) 
    ' Load the map definition (16x12)
    LoadSD("Map.nmap",$d500,192,0)
END SUB


' - Layer 2 demo, 256x192 at 256 colours ------------------
SUB Layer2_256x192()
    DIM x, y as UInteger
    DIM t AS UByte
    
    ' Show Layer 2
    ShowLayer2(1)
    
    ' Print the layer name on the ULA
    PRINT AT 23,0;"Layer 2: 256x192, 256 colours";

    ' Fill the screen with colour 2 (blue)
    CLS256(2)
    ' Draw 16 tiles wide
    FOR x = 0 TO 15
        ' By 12 tiles high
        FOR y = 0 TO 11
            ' Read the tile value in the map
            t = PEEK($d500+(y*16)+x)
            ' Draw tile "t" at "x","y"
            DoTile(x,y,t)
        NEXT y
    NEXT x
END SUB


' - Sprite demo -------------------------------------------
SUB SpriteDemo()
    DIM scrX AS UByte
    DIM pattern, n AS UByte
    
    ' Infinite loop
    DO
        ' Pause for synchronization with the beam
        waitretrace
        ' Update the position and frame of sprite 0
        UpdateSprite(120,120,0,pattern,0,0)
        
        ' Scroll on the X coordinate
        ScrollLayer(scrX,0)
        ' Increase the X scroll coordinate by 2
        scrX = scrX + 2
            
        ' The frame (pattern) goes from 0 to 3
        IF pattern = 3 THEN
            pattern = 0
        ELSE
            pattern = pattern + 1
        END IF
    LOOP
END SUB
