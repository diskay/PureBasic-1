﻿;/ ============================
;/ =   ToolBarExModule.pbi    =
;/ ============================
;/
;/ [ PB V5.7x / 64Bit / All OS / DPI ]
;/
;/ Extended ToolBar Gadget
;/
;/ © 2019 Thorsten1867 (03/2019)
;/

; Last Update: 2.4.2019


;{ ===== MIT License =====
;
; Copyright (c) 2019 Thorsten Hoeppner
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
; 
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;}


;{ _____ ListEx - Commands _____

; ToolBar::AddItem()              - similar to 'AddGadgetItem()'
; ToolBar::AttachPopupMenu()      - attachs a popup menu to the button
; ToolBar::ButtonText()           - similar to 'ToolBarButtonText()'
; ToolBar::ComboBox()             - adds a ComboBox to the toolbar
; ToolBar::DisableButton()        - similar to 'DisableToolBarButton()'
; ToolBar::DisableReDraw()        - disable/enable redrawing
; ToolBar::Separator()            - similar to 'ToolBarSeparator()'
; ToolBar::EventNumber()          - returns the event number (integer) of the toolbar button
; ToolBar::EventID()              - returns the event ID (string) of the toolbar button
; ToolBar::EventState()           - returns the state of a toolbar gadget (e.g. ComboBox)
; ToolBar::Free()                 - similar to 'FreeToolBar()'
; ToolBar::Gadget()               - similar to 'CreateToolBar()'
; ToolBar::GetAttribute()         - similar to 'GetGadgetAttribute()'
; ToolBar::GetIndex()             - returns item index of the corresponding event number
; ToolBar::GetIndexFromID()       - returns item index of the corresponding event ID
; ToolBar::GetGadgetNumber()      - returns the gadget number of the gadget at index position
; ToolBar::GetState()             - similar to 'GetGadgetState()'
; ToolBar::GetText()              - similar to 'GetGadgetText()'
; ToolBar::ImageButton()          - similar to 'ToolBarImageButton()'
; ToolBar::HideButton()           - hide button
; ToolBar::Height()               - similar to 'ToolBarHeight()'
; ToolBar::SetAutoResizeFlags()   - [#MoveX|#MoveY|#ResizeWidth|#ResizeHeight]
; ToolBar::SetAttribute()         - similar to 'SetGadgetColor()'
; ToolBar::SetColor()             - similar to 'SetGadgetAttribute()'
; ToolBar::SetFont()              - similar to 'SetGadgetFont()'
; ToolBar::SetGadgetFlags()       - [#Top/#Bottom]
; ToolBar::SetPostEvent()         - changes PostEvent [#PB_Event_Gadget/#PB_Event_Menu]
; ToolBar::SetSpinAttribute()     - similar to 'SetGadgetAttribute()' for the SpinGadget [#PB_Spin_Minimum/#PB_Spin_Maximum]
; ToolBar::SetState()             - similar to 'SetGadgetState()'
; ToolBar::SetText()              - similar to 'SetGadgetText()'
; ToolBar::Spacer()               - inserts available space between buttons
; ToolBar::SpinBox()              - adds a SpinGadget to the toolbar
; ToolBar::ToolTip()              - similar to 'ToolBarToolTip()'
; ToolBar::TextButton()           - similar to 'ButtonGadget()'

;} -----------------------------

DeclareModule ToolBar
  
  #EnableToolBarGadgets = #True
  
  ;- ===========================================================================
  ;-   DeclareModule - Constants
  ;- ===========================================================================  

  ;{ ____ Constants_____
  #Top    = 1
  #Bottom = 2
  
  EnumerationBinary Gadget
    #ImageSize_16 = #PB_ToolBar_Small
    #ImageSize_24 = #PB_ToolBar_Large
    #ButtonText   = #PB_ToolBar_Text
    #InlineText   = #PB_ToolBar_InlineText ; [not all OS!]
    #ImageSize_32
    #AutoResize
    #AdjustHeight
    #AdjustButtons
    #AdjustAllButtons
    #RoundFocus
    #Border
    #PopupArrows
    #ToolTips
  EndEnumeration
  
  Enumeration Attribute 1
    #Height
    #Spacing
    #ButtonHeight
    #ButtonWidth
    #ButtonSpacing
  EndEnumeration

  EnumerationBinary Resize
    #MoveX
    #MoveY
    #ResizeWidth
    #ResizeHeight
  EndEnumeration 
  
  Enumeration Color 1 
    #FrontColor
    #BackColor
    #FocusColor
    #SeparatorColor
    #BorderColor
  EndEnumeration


  #Event_Menu   = #PB_Event_Menu 
  
  CompilerIf Defined(ModuleEx, #PB_Module)
    
    #EventType_ImageButton = ModuleEx::#EventType_ImageButton
    #EventType_ComboBox    = ModuleEx::#EventType_ComboBox
    #EventType_SpinBox     = ModuleEx::#EventType_SpinBox
    #EventType_Button      = ModuleEx::#EventType_Button
    #Event_Gadget          = ModuleEx::#Event_Gadget
    
  CompilerElse
    
    Enumeration #PB_Event_FirstCustomValue
      #Event_Gadget
    EndEnumeration

    Enumeration #PB_EventType_FirstCustomValue
      #EventType_ImageButton
      #EventType_ComboBox
      #EventType_SpinBox
      #EventType_Button
    EndEnumeration
    
  CompilerEndIf
  ;}
  
  ;- ===========================================================================
  ;-   DeclareModule - Procedures
  ;- ===========================================================================
  
  Declare   AttachPopupMenu(GNum.i, TB_Index.i, MenuNum.i)  
  Declare   DisableButton(GNum.i, TB_Index.i, State.i)
  Declare   DisableRedraw(GNum.i, State.i=#False)
  Declare.s EventID(GNum.i)
  Declare.i EventNumber(GNum.i)
  Declare.i EventState(GNum.i)
  Declare   Free(GNum.i)
  Declare.i Gadget(GNum.i, X.i=#PB_Ignore, Y.i=#PB_Ignore, Width.i=#PB_Ignore, Height.i=#PB_Ignore, Flags.i=#False, WindowNum.i=#PB_Default)
  Declare.i GetAttribute(GNum.i, Attribute.i)
  Declare.i GetGadgetNumber(GNum.i, TB_Index.i)
  Declare.i GetIndex(GNum.i, EventNum.i)
  Declare.i GetIndexFromID(GNum.i, EventID.s) 
  Declare   Height(GNum.i)
  Declare   HideButton(GNum.i, TB_Index.i, State.i)
  Declare   ImageButton(GNum.i, ImageNum.i, EventNum.i=#False, Text.s="", EventID.s="", Flags.i=#False)
  Declare   Separator(GNum.i, Width.i=#PB_Default)
  Declare   SetAutoResizeFlags(GNum.i, Flags.i)
  Declare   SetAttribute(GNum.i, Attribute.i, Value.i)
  Declare   SetColor(GNum.i, ColorType.i, Color.i)
  Declare   SetFont(GNum.i, FontID.i)
  Declare   SetPostEvent(GNum.i, Event.i=#Event_Gadget) 
  Declare   Spacer(GNum.i)
  Declare   ToolTip(GNum.i, TB_Index.i, Text.s)
  
  CompilerIf #EnableToolBarGadgets
    
    Declare   AddItem(GNum.i, TB_Index.i, Position, Text.s, ImageID.i=#False)
    Declare   ButtonText(GNum.i, TB_Index.i, Text.s)
    Declare   ComboBox(GNum.i, Width.i, Height.i, EventNum.i=#PB_Ignore, Text.s="", EventID.s="", Flags.i=#False)
    Declare.i GetState(GNum.i, TB_Index.i)
    Declare.s GetText(GNum.i, TB_Index.i)
    Declare   SetGadgetFlags(GNum.i, TB_Index.i, Flags.i)
    Declare   SetSpinAttribute(GNum.i, TB_Index.i, Attribute.i, Value.i)
    Declare   SetState(GNum.i, TB_Index.i, State.i)
    Declare   SetText(GNum.i, TB_Index.i, Text.s)
    Declare.i SpinBox(GNum.i, Width.i, Height.i, Minimum.i, Maximum.i, EventNum.i=#PB_Ignore, Text.s="", EventID.s="", Flags.i=#False)
    Declare.i TextButton(GNum.i, Width.i, Height.i, Text.s, EventNum.i=#PB_Ignore, EventID.s="", Flags.i=#False)
    
  CompilerEndIf
  
EndDeclareModule

Module ToolBar
  
  EnableExplicit
  
  UsePNGImageDecoder()
  
  ;- ===========================================================================
  ;-   Module - Constants / Structures
  ;- ===========================================================================  
  
  #NoFocus  = -1
  #NoIndex  = -1
  #NotSelected = -1
  #NotValid    = -1
  #Round = 7
  
  #PopupOpen  = 1
  #PopupClosed = 0
  
  EnumerationBinary ItemFlags
    #Top    = 1 ; must be 1
    #Bottom = 2 ; must be 2
    #Click
    #Disable
    #Hide
    #FocusLost
  EndEnumeration
  
  Enumeration Items 1
    #ComboBox
    #ImageButton
    #Separator
    #Spacer
    #SpinGadget
    #TextButton
  EndEnumeration
  
  Structure TBEx_Event_Structure     ;{ TBEx()\Event\...
    Type.i
    btIndex.i
    Num.i
    ID.s
    State.i
  EndStructure ;}
  
  Structure TBEx_Color_Structure     ;{ TBEx()\Color\...
    Front.i
    Back.i
    Focus.i
    Border.i
    GrayText.i
    Separator.i
  EndStructure ;}
  
  Structure TBEx_Window_Structure    ;{ TBEx()\Window\...
    Num.i
    Width.f
    Height.i
  EndStructure ;}
  
  Structure TBEx_Size_Structure      ;{ TBEx()\Size\...
    X.f
    Y.f
    Width.f
    Height.f
    Spacing.f
    Items.f
    Flags.i
  EndStructure ;}
  
  Structure TBEx_Images_Structure    ;{ TBEx()\Images\...
    Width.i
    Height.i
  EndStructure ;}
  
  Structure TBEx_Items_Structure     ;{ TBEx()\Items\...
    Num.i
    Type.i
    X.i
    Width.i
    Height.i
    Text.s
    ToolTip.s
    Event.i
    EventID.s
    PopupMenu.i
    Flags.i
    ImageNum.i
    Image.TBEx_Images_Structure
  EndStructure ;}
  
  Structure TBEx_Button_Structure    ;{ TBEx()\Buttons\...
    X.i
    Y.i
    Width.i
    Height.i
    Spacing.i
    LastX.f
    txtHeight.f
    Focus.i
  EndStructure ;}
  
  
  Structure ToolBarEx_Structure   ;{ TBEx()\...
    
    CanvasNum.i
    
    FontID.i
    Focus.i
    LastFocus.i 
    ReDraw.i    ; #True/#False
    Spacer.i    ; Number of spaacer

    ToolTip.i
    
    PostEvent.i
    
    Event.TBEx_Event_Structure
    Color.TBEx_Color_Structure
    Window.TBEx_Window_Structure
    Size.TBEx_Size_Structure
    Buttons.TBEx_Button_Structure
    Images.TBEx_Images_Structure
    
    Flags.i
    
    List Items.TBEx_Items_Structure()

  EndStructure ;}  
  Global NewMap TBEx.ToolBarEx_Structure()
  
  ;- ============================================================================
  ;-   Module - Internal
  ;- ============================================================================ 
  
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ; Addition of mk-soft
    
    Procedure OSX_NSColorToRGBA(NSColor)
      Protected.cgfloat red, green, blue, alpha
      Protected nscolorspace, rgba
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        CocoaMessage(@alpha, nscolorspace, "alphaComponent")
        rgba = RGBA(red * 255.9, green * 255.9, blue * 255.9, alpha * 255.)
        ProcedureReturn rgba
      EndIf
    EndProcedure
    
    Procedure OSX_NSColorToRGB(NSColor)
      Protected.cgfloat red, green, blue
      Protected r, g, b, a
      Protected nscolorspace, rgb
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
        ProcedureReturn rgb
      EndIf
    EndProcedure
    
  CompilerEndIf
  
  
  Procedure.f dpiX(Num.i)
    ProcedureReturn DesktopScaledX(Num)
  EndProcedure
  
  Procedure.f dpiY(Num.i)
    ProcedureReturn DesktopScaledY(Num)
  EndProcedure
  
  Procedure.f GetAvailableSpace_()
    Define.f Space
    
    PushListPosition(TBEx()\Items())
    
    Space = TBEx()\Size\Spacing * 2
    
    ForEach TBEx()\Items()
      
      Select TBEx()\Items()\Type
        Case #ImageButton
          Space + TBEx()\Items()\Width + TBEx()\Buttons\Spacing
        Case #ComboBox
          Space + TBEx()\Items()\Width + dpiX(8) + TBEx()\Buttons\Spacing
        Case #SpinGadget
          Space + TBEx()\Items()\Width + dpiX(8) + TBEx()\Buttons\Spacing
        Case #TextButton
          Space + TBEx()\Items()\Width + dpiX(8) + TBEx()\Buttons\Spacing  
        Case #Separator
          Space + TBEx()\Items()\Width + TBEx()\Buttons\Spacing
      EndSelect    
    
    Next
    
    PopListPosition(TBEx()\Items())
    
    ProcedureReturn TBEx()\Size\Width - Space
  EndProcedure
  
  Procedure.f GetButtonY_(Bottom.i=#False)
    Define.f OffsetY
    
    OffSetY = (TBEx()\Size\Height - TBEx()\Buttons\Height - TBEx()\Buttons\txtHeight) / 2
    
    If Bottom
      ProcedureReturn OffsetY + TBEx()\Buttons\Height
    Else
      ProcedureReturn OffsetY
    EndIf
    
  EndProcedure
  
  Procedure   DisableToolTip_()
    
    If TBEx()\ToolTip
      TBEx()\ToolTip = #False
      GadgetToolTip(TBEx()\CanvasNum, "")
    EndIf

  EndProcedure
  
  ;- __________ Drawing __________
  
  Procedure.i BlendColor_(Color1.i, Color2.i, Scale.i=50)
    Define.i R1, G1, B1, R2, G2, B2
    Define.f Blend = Scale / 100
    
    R1 = Red(Color1): G1 = Green(Color1): B1 = Blue(Color1)
    R2 = Red(Color2): G2 = Green(Color2): B2 = Blue(Color2)
    
    ProcedureReturn RGB((R1*Blend) + (R2 * (1-Blend)), (G1*Blend) + (G2 * (1-Blend)), (B1*Blend) + (B2 * (1-Blend)))
  EndProcedure
  
  Procedure.i Arrow_(X.i, Y.i, Width.i, Height.i, Direction.i, Color.i=#PB_Default)
    Define.i aX, aY, aWidth, aHeight

    aWidth  = dpiX(8)
    aHeight = dpiX(4)
    
    If TBEx()\Flags & #RoundFocus
      aX = X + Width  - aWidth - dpiX(4)
    Else
      aX = X + Width  - aWidth - dpiX(3)
    EndIf
    
    If TBEx()\Flags & #RoundFocus
      aY = Y + Height - aHeight - dpiX(4)
    Else
      aY = Y + Height - aHeight - dpiX(3)
    EndIf
    
    If aWidth < Width And aHeight < Height 
    
      If Direction = #PopupOpen
        
        If Color = #PB_Default : Color = BlendColor_($000000, TBEx()\Color\Focus) : EndIf
        
        DrawingMode(#PB_2DDrawing_Default)
        Line(aX, aY, aWidth, 1, Color)
        LineXY(aX, aY, aX + (aWidth / 2), aY + aHeight, Color)
        LineXY(aX + (aWidth / 2), aY + aHeight, aX + aWidth, aY, Color)
        FillArea(aX + (aWidth / 2), aY + dpiY(2), Color, BlendColor_($000000, TBEx()\Color\Focus, 16))

      Else
        
        If Color = #PB_Default : Color = BlendColor_($000000, TBEx()\Color\Back, 90) : EndIf
        
        DrawingMode(#PB_2DDrawing_Default)
        Line(aX, aY + aHeight, aWidth, 1, Color)
        LineXY(aX, aY + aHeight, aX + (aWidth / 2), aY, Color)
        LineXY(aX + (aWidth / 2), aY, aX + aWidth, aY + aHeight, Color)
        FillArea(aX + (aWidth / 2), aY + aHeight - dpiY(2), Color, BlendColor_($000000, TBEx()\Color\Back))
        
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure   DrawSingleButton_(btIndex.i, Flags.i)
    Define.i ImageID
    Define.f X, Y, btY, imgY, imgX, txtHeight
    
    If StartDrawing(CanvasOutput(TBEx()\CanvasNum))
      
      If TBEx()\FontID : DrawingFont(TBEx()\FontID) : EndIf
      If TBEx()\Flags & #ButtonText : txtHeight = TextHeight("ABC") : EndIf
     
      btY  = (TBEx()\Size\Height - TBEx()\Buttons\Height - txtHeight)   / 2
      imgY = (TBEx()\Buttons\Height - TBEx()\Images\Height) / 2 + btY
      
      If SelectElement(TBEx()\Items(), btIndex)
        
        If TBEx()\Items()\Flags & #Hide = #False
          
          X = TBEx()\Items()\X

          If Flags & #Click
            If TBEx()\Flags & #RoundFocus
              DrawingMode(#PB_2DDrawing_Default)
              RoundBox(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height, #Round, #Round, BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back, 32))
              DrawingMode(#PB_2DDrawing_Outlined)
              RoundBox(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height, #Round, #Round, BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back))
            Else
              DrawingMode(#PB_2DDrawing_Default)
              Box(X, btY,  TBEx()\Items()\Width, TBEx()\Buttons\Height, BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back, 32))
              DrawingMode(#PB_2DDrawing_Outlined)
              Box(X, btY,  TBEx()\Items()\Width, TBEx()\Buttons\Height, BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back))
            EndIf
          ElseIf Flags & #FocusLost 
            DrawingMode(#PB_2DDrawing_Default)
            Box(X, btY,  TBEx()\Items()\Width, TBEx()\Buttons\Height, TBEx()\Color\Back)
          EndIf 
          
          imgX = (TBEx()\Items()\Width - TBEx()\Images\Width) / 2
          
          If IsImage(TBEx()\Items()\ImageNum)
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            If TBEx()\Items()\Flags & #Disable
              ImageID = ResizeImage(TBEx()\Items()\ImageNum, TBEx()\Images\Width, TBEx()\Images\Height, #PB_Image_Smooth)
              DrawAlphaImage(ImageID, X + imgX, imgY, 128)
            Else
              DrawImage(ImageID(TBEx()\Items()\ImageNum), X + imgX, imgY, TBEx()\Images\Width, TBEx()\Images\Height)
            EndIf
          EndIf
          
          If TBEx()\Items()\PopupMenu <> #NotValid And TBEx()\Flags & #PopupArrows
            DrawingMode(#PB_2DDrawing_Default)
            If Flags & #PopupOpen
              Arrow_(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height, #PopupOpen)
            Else
              Arrow_(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height, #PopupClosed)
            EndIf 
          EndIf
         
        EndIf  
          
      EndIf 

      StopDrawing()
    EndIf  
   
  EndProcedure
  
  Procedure   Draw_(Flags.i=#False)
    Define.f X, Y, btY, btX, imgY, imgX, txtX, txtY, cbY
    Define.i Width, Height
    Define.i ImageID
    
    If StartDrawing(CanvasOutput(TBEx()\CanvasNum))
      
      If TBEx()\FontID : DrawingFont(TBEx()\FontID) : EndIf
      
      If Flags & #AdjustButtons        ;{ Adjust single buttons width to text
        ForEach TBEx()\Items()
          If TBEx()\Items()\Type = #ImageButton
            If TextWidth(TBEx()\Items()\Text) > TBEx()\Items()\Width
              TBEx()\Items()\Width = TextWidth(TBEx()\Items()\Text)
            EndIf
          EndIf  
        Next ;}
      ElseIf Flags & #AdjustAllButtons ;{ Adjust all buttons width to text
        Width = 0
        ForEach TBEx()\Items()
          If TBEx()\Items()\Type = #ImageButton
            If TextWidth(TBEx()\Items()\Text) > Width
              Width = TextWidth(TBEx()\Items()\Text)
            EndIf
          EndIf
        Next
        If TBEx()\Buttons\Width < Width
          TBEx()\Buttons\Width = Width
          ForEach TBEx()\Items()
            If TBEx()\Items()\Type = #ImageButton
              TBEx()\Items()\Width = Width
            EndIf
          Next
        EndIf ;}
      EndIf
 
      If Flags & #AdjustHeight         ;{ Adjust toolbar height (#ButtonText)
        If TBEx()\Flags & #ButtonText
          Height = TextHeight("ABC") + TBEx()\Buttons\Height + (TBEx()\Size\Spacing * 2)
        Else
          Height = TBEx()\Buttons\Height + (TBEx()\Size\Spacing * 2)
        EndIf
        If Height > TBEx()\Size\Height : TBEx()\Size\Height = Height : EndIf
        ;}
      EndIf
      
      If TBEx()\Flags & #ButtonText : TBEx()\Buttons\txtHeight = TextHeight("ABC") : EndIf
      
      X    = TBEx()\Size\Spacing
      btY  = (TBEx()\Size\Height - TBEx()\Buttons\Height - TBEx()\Buttons\txtHeight) / 2
      imgY = (TBEx()\Buttons\Height - TBEx()\Images\Height) / 2 + btY
      
      If TBEx()\Flags & #ButtonText
        txtY = btY + TBEx()\Buttons\Height
      EndIf
      
      ;{ _____ Background _____
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, TBEx()\Size\Width, TBEx()\Size\Height, TBEx()\Color\Back)
      ;}
      
      ForEach TBEx()\Items()
        
        ;{ _____ Focus _____
        If TBEx()\Items()\Flags & #Hide = #False
          If TBEx()\Buttons\Focus = ListIndex(TBEx()\Items())
            If TBEx()\Flags & #RoundFocus
              DrawingMode(#PB_2DDrawing_Default)
              RoundBox(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height, #Round, #Round, BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back, 20))
              DrawingMode(#PB_2DDrawing_Outlined)
              RoundBox(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height, #Round, #Round, BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back))
            Else
              DrawingMode(#PB_2DDrawing_Default)
              Box(X, btY,  TBEx()\Items()\Width, TBEx()\Buttons\Height, BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back, 20))
              DrawingMode(#PB_2DDrawing_Outlined)
              Box(X, btY,  TBEx()\Items()\Width, TBEx()\Buttons\Height, BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back))
            EndIf
          EndIf
        EndIf
        ;}
      
        ;{ _____ Items _____
        If TBEx()\Items()\Flags & #Hide = #False
          
          Select TBEx()\Items()\Type
            Case #ImageButton ;{ ImageButton
              
              TBEx()\Items()\X = X
              
              imgX = (TBEx()\Items()\Width - TBEx()\Images\Width) / 2
              
              If IsImage(TBEx()\Items()\ImageNum)
                DrawingMode(#PB_2DDrawing_AlphaBlend)
                If TBEx()\Items()\Flags & #Disable
                  ImageID = CopyImage(TBEx()\Items()\ImageNum, #PB_Any)
                  If ResizeImage(ImageID, TBEx()\Images\Width, TBEx()\Images\Height, #PB_Image_Smooth)
                    DrawAlphaImage(ImageID(ImageID), X + imgX, imgY, 128)
                  EndIf
                Else
                  DrawImage(ImageID(TBEx()\Items()\ImageNum), X + imgX, imgY, TBEx()\Images\Width, TBEx()\Images\Height)
                EndIf
              EndIf
              
              If TBEx()\Items()\PopupMenu <> #NotValid And TBEx()\Flags & #PopupArrows
                DrawingMode(#PB_2DDrawing_Default)
                Arrow_(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height, #PopupClosed)
              EndIf
              
              If TBEx()\Flags & #ButtonText
                txtX = (TBEx()\Items()\Width - TextWidth(TBEx()\Items()\Text)) / 2
                If txtX < 0 : txtX = 0 : EndIf
                CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS : ClipOutput(X, txtY, TBEx()\Items()\Width, TBEx()\Buttons\txtHeight) : CompilerEndIf
                DrawingMode(#PB_2DDrawing_Transparent)
                If TBEx()\Items()\Flags & #Disable
                  DrawText(X + txtX, txtY, TBEx()\Items()\Text, BlendColor_(TBEx()\Color\Front, TBEx()\Color\Back))
                Else
                  DrawText(X + txtX, txtY, TBEx()\Items()\Text, TBEx()\Color\Front)
                EndIf
                CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS : UnclipOutput() : CompilerEndIf
              EndIf
              
              X + TBEx()\Items()\Width + TBEx()\Buttons\Spacing
              ;}
            Case #ComboBox, #SpinGadget, #TextButton ;{ ComboBox / SpinGadget / TextButton
 
              If IsGadget(TBEx()\Items()\Num)
                
                X + dpiX(4)
                
                TBEx()\Items()\X = X
                
                If TBEx()\Items()\Flags & #Top
                  cbY = btY + dpiX(4)
                ElseIf TBEx()\Items()\Flags & #Bottom
                  cbY = btY + TBEx()\Buttons\Height - TBEx()\Items()\Height - dpiX(4)
                Else
                  cbY = (TBEx()\Size\Height - TBEx()\Items()\Height - TBEx()\Buttons\txtHeight) / 2
                EndIf

                If X <> GadgetX(TBEx()\Items()\Num) Or Y + cbY <> GadgetY(TBEx()\Items()\Num)
                  ResizeGadget(TBEx()\Items()\Num,  DesktopUnscaledX(X),  DesktopUnscaledY(Y + cbY), DesktopUnscaledX(TBEx()\Items()\Width), DesktopUnscaledY(TBEx()\Items()\Height))
                EndIf
              
                X + TBEx()\Items()\Width + dpiX(4) + TBEx()\Buttons\Spacing
              EndIf
              ;}
            Case #Separator   ;{ Separator
              
              TBEx()\Items()\X = X
              
              btX = (TBEx()\Items()\Width - dpiX(2)) / 2
              If btX < 0 : btX = 0 : EndIf
              
              DrawingMode(#PB_2DDrawing_Default)
              Box(X + btX + 1, btY + dpiY(4), dpiX(1), TBEx()\Buttons\Height - dpiY(8), BlendColor_(TBEx()\Color\Separator, TBEx()\Color\Back))
              Box(X + btX,     btY + dpiY(4), dpiX(1), TBEx()\Buttons\Height - dpiY(8), TBEx()\Color\Separator)
              
              X + TBEx()\Items()\Width + TBEx()\Buttons\Spacing
              ;}
            Case #Spacer      ;{ Spacer
              
              TBEx()\Items()\X = X
              TBEx()\Items()\Width = GetAvailableSpace_()
              
              If TBEx()\Spacer
                X + (TBEx()\Items()\Width / TBEx()\Spacer)
              EndIf 
              ;}
          EndSelect
          
        Else
          TBEx()\Items()\X = #PB_Ignore
        EndIf
        ;}
        
      Next
      
      TBEx()\Buttons\LastX = X
      
      ;{ _____ Border _____
      If TBEx()\Flags & #Border
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(0, 0, TBEx()\Size\Width, TBEx()\Size\Height, TBEx()\Color\Border)
      EndIf
      ;}
      
      StopDrawing()
    EndIf
    
  EndProcedure
  
  ;- __________ Events __________
  
  CompilerIf #EnableToolBarGadgets
    
    Procedure _GadgetHandler()
      Define.i GadgetNum = EventGadget()
      Define.i GNum = GetGadgetData(GadgetNum)
      
      If FindMapElement(TBEx(), Str(GNum))
        
        ForEach TBEx()\Items()
          
          If TBEx()\Items()\Num = GadgetNum
            
            TBEx()\Event\Num     = TBEx()\Items()\Event
            TBEx()\Event\ID      = TBEx()\Items()\EventID
            
            If IsWindow(TBEx()\Window\Num)
              
              Select TBEx()\Items()\Type
                Case #ComboBox   ;{ ComboBox changed
                  
                  TBEx()\Event\Type  = #EventType_ComboBox
                  TBEx()\Event\State = GetGadgetState(GadgetNum)
                  
                  If TBEx()\Items()\Event = #PB_Ignore
                    PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_ComboBox, ListIndex(TBEx()\Items()))
                    PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_ComboBox, ListIndex(TBEx()\Items()))
                  Else
                    PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_ComboBox, TBEx()\Event\State)
                    PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_ComboBox, TBEx()\Event\State)
                  EndIf
                  ;}
                Case #SpinGadget ;{ SpinGadget changed
                  
                  If TBEx()\Event\State <> GetGadgetState(GadgetNum)
                    
                    TBEx()\Event\Type  = #EventType_SpinBox
                    TBEx()\Event\State = GetGadgetState(GadgetNum)
                    SetGadgetText(GadgetNum, Str(GetGadgetState(GadgetNum)))
                    
                    If TBEx()\Items()\Event = #PB_Ignore
                      PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_SpinBox, ListIndex(TBEx()\Items()))
                      PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_SpinBox, ListIndex(TBEx()\Items()))
                    Else
                      PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_SpinBox, TBEx()\Event\State)
                      PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_SpinBox, TBEx()\Event\State)
                    EndIf
                    
                  EndIf
                  ;}
                Case #TextButton ;{ Textbutton clicked
                  
                  TBEx()\Event\Type  = #EventType_Button
                  TBEx()\Event\State = GetGadgetState(GadgetNum)
                  
                  If TBEx()\Items()\Event = #PB_Ignore
                    PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, ListIndex(TBEx()\Items()))
                    PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, ListIndex(TBEx()\Items()))
                  Else
                    PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_Button, TBEx()\Event\State)
                    PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_Button, TBEx()\Event\State)
                  EndIf
                  ;}
              EndSelect
              
            EndIf
            
          EndIf
        
        Next
        
      EndIf
      
    EndProcedure
    
  CompilerEndIf
  
  Procedure _LeftButtonDownHandler()
    Define.f X, Y, minY, maxY, btIndex
    Define.i GNum = EventGadget()
    
    If FindMapElement(TBEx(), Str(GNum))
      
      X = GetGadgetAttribute(GNum, #PB_Canvas_MouseX)
      Y = GetGadgetAttribute(GNum, #PB_Canvas_MouseY)
      
      TBEx()\Event\Type    = #False
      TBEx()\Event\btIndex = #NoIndex
      
      ForEach TBEx()\Items()
        
        If TBEx()\Items()\X = #PB_Ignore : Continue : EndIf
        
        If X > TBEx()\Items()\X And X < TBEx()\Items()\X + TBEx()\Items()\Width
          
          If TBEx()\Items()\Flags & #Disable = #False
            
            btIndex = ListIndex(TBEx()\Items())
            
            Select TBEx()\Items()\Type
              Case #ImageButton
                
                TBEx()\Event\Type    = #EventType_ImageButton
                TBEx()\Event\btIndex = btIndex
                
                If TBEx()\Event\btIndex > #NoFocus
                  DrawSingleButton_(btIndex, #Click)
                EndIf
                
            EndSelect  
            
          EndIf
          
          Break
        EndIf
        
      Next
      
    EndIf 
    
  EndProcedure
  
  Procedure _LeftButtonUpHandler()
    Define.f X, Y
    Define.i btIndex
    Define.i GNum = EventGadget()
    
    If FindMapElement(TBEx(), Str(GNum))
      
      X = GetGadgetAttribute(GNum, #PB_Canvas_MouseX)
      Y = GetGadgetAttribute(GNum, #PB_Canvas_MouseY)
      
      ForEach TBEx()\Items()
        
        If TBEx()\Items()\X = #PB_Ignore : Continue : EndIf
        
        If X > TBEx()\Items()\X And X < TBEx()\Items()\X + TBEx()\Items()\Width
          
          btIndex = ListIndex(TBEx()\Items())
          
          Select TBEx()\Event\Type
            Case #EventType_ImageButton ;{ Button clicked & released
              If TBEx()\Buttons\Focus = btIndex And TBEx()\Event\btIndex = btIndex
                
                If TBEx()\Items()\PopupMenu = #NotValid
                  TBEx()\Event\Num = TBEx()\Items()\Event
                  TBEx()\Event\ID  = TBEx()\Items()\EventID
                  If IsWindow(TBEx()\Window\Num)
                    If TBEx()\PostEvent = #Event_Menu
                      PostEvent(#PB_Event_Menu, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_ImageButton, btIndex)
                    Else
                      PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_ImageButton, btIndex)
                      PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_ImageButton, btIndex)
                    EndIf 
                  EndIf
                Else
                  
                  If IsMenu(TBEx()\Items()\PopupMenu) And IsWindow(TBEx()\Window\Num)
                    TBEx()\Buttons\Focus = #NoFocus
                    DisableToolTip_()
                    If TBEx()\Flags & #PopupArrows
                      DrawSingleButton_(TBEx()\LastFocus, #Click|#PopupOpen)
                    Else
                      DrawSingleButton_(TBEx()\LastFocus, #Click)
                    EndIf 
                    X = WindowX(TBEx()\Window\Num, #PB_Window_InnerCoordinate) + TBEx()\Size\X + TBEx()\Items()\X
                    Y = WindowY(TBEx()\Window\Num, #PB_Window_InnerCoordinate) + TBEx()\Size\Y + GetButtonY_(#True) + TBEx()\Buttons\Spacing
                    DisplayPopupMenu(TBEx()\Items()\PopupMenu, WindowID(TBEx()\Window\Num), dpiX(X), dpiY(Y))
                    DrawSingleButton_(TBEx()\LastFocus, #FocusLost)
                  EndIf
                  
                EndIf
                
              Else
                TBEx()\Event\Type    = #False
                TBEx()\Event\btIndex = #NoIndex
              EndIf
              ;}
          EndSelect  
          
          Break
        EndIf
        
      Next
    EndIf
    
  EndProcedure    
  
  Procedure _LostFocusHandler()
    Define.i GNum = EventGadget()
    
    If FindMapElement(TBEx(), Str(GNum))
      DrawSingleButton_(TBEx()\LastFocus, #FocusLost)
    EndIf  
    
  EndProcedure
  
  Procedure _MouseMoveHandler()
    Define.i X, Y, minY, maxY, LastButtonFocus, ItemIndex
    Define.i GNum = EventGadget()
    
    If FindMapElement(TBEx(), Str(GNum))
      
      X = GetGadgetAttribute(GNum, #PB_Canvas_MouseX)
      Y = GetGadgetAttribute(GNum, #PB_Canvas_MouseY)

      minY  = (TBEx()\Size\Height - TBEx()\Buttons\Height) / 2
      maxY  = minY + TBEx()\Buttons\Height
      
      LastButtonFocus = TBEx()\Buttons\Focus
      
      If X > TBEx()\Size\Spacing And X < TBEx()\Buttons\LastX And Y > minY And Y < maxY
        
        ForEach TBEx()\Items()
          
          If TBEx()\Buttons\Focus <> ListIndex(TBEx()\Items())
            
            If TBEx()\Items()\X <> #PB_Ignore
            
              If X > TBEx()\Items()\X And X < TBEx()\Items()\X + TBEx()\Items()\Width
              
                Select TBEx()\Items()\Type
                  Case #ImageButton ;{ Mouse over ImageButton
                    If TBEx()\Items()\Flags & #Disable
                      TBEx()\Buttons\Focus = #NoFocus
                      DisableToolTip_()
                    Else
                      TBEx()\Buttons\Focus = ListIndex(TBEx()\Items())
                      TBEx()\LastFocus     = TBEx()\Buttons\Focus
                      If TBEx()\Items()\ToolTip ;{ ToolTips
                        TBEx()\ToolTip = #True
                        GadgetToolTip(TBEx()\CanvasNum, TBEx()\Items()\ToolTip)
                      Else 
                        DisableToolTip_() ;}
                      EndIf
                      Draw_()
                    EndIf ;}
                  Default
                    DisableToolTip_()
                    TBEx()\Buttons\Focus = #NoFocus
                EndSelect
              
              EndIf
              
            EndIf
            
            TBEx()\Focus = ListIndex(TBEx()\Items())
            
          EndIf
          
        Next
        
      Else 
        TBEx()\Buttons\Focus = #NoFocus
      EndIf
      
      If TBEx()\Buttons\Focus = #NoFocus And LastButtonFocus <> #NoFocus
        DisableToolTip_()
        DrawSingleButton_(TBEx()\LastFocus, #FocusLost)
      EndIf
      
    EndIf
    
  EndProcedure  
  
  Procedure _ResizeHandler()
    Define.i GNum = EventGadget()
    
    If FindMapElement(TBEx(), Str(GNum))
      
      TBEx()\Size\Width  = dpiX(GadgetWidth(GNum))
      TBEx()\Size\Height = dpiY(GadgetHeight(GNum))
      
      Draw_()
    EndIf  
 
  EndProcedure
  
  Procedure _ResizeWindowHandler()
    Define.f X, Y, Width, Height
    Define.f OffSetX, OffSetY
    
    ForEach TBEx()
      
      If IsGadget(TBEx()\CanvasNum)
        
        If TBEx()\Flags & #AutoResize
          
          If IsWindow(TBEx()\Window\Num)
            
            OffSetX = WindowWidth(TBEx()\Window\Num)  - TBEx()\Window\Width
            OffsetY = WindowHeight(TBEx()\Window\Num) - TBEx()\Window\Height

            TBEx()\Window\Width  = WindowWidth(TBEx()\Window\Num)
            TBEx()\Window\Height = WindowHeight(TBEx()\Window\Num)
            
            If TBEx()\Size\Flags
              
              X = #PB_Ignore : Y = #PB_Ignore : Width = #PB_Ignore : Height = #PB_Ignore
              
              If TBEx()\Size\Flags & #MoveX : X = GadgetX(TBEx()\CanvasNum) + OffSetX : EndIf
              If TBEx()\Size\Flags & #MoveY : Y = GadgetY(TBEx()\CanvasNum) + OffSetY : EndIf
              If TBEx()\Size\Flags & #ResizeWidth  : Width  = GadgetWidth(TBEx()\CanvasNum)  + OffSetX : EndIf
              If TBEx()\Size\Flags & #ResizeHeight : Height = GadgetHeight(TBEx()\CanvasNum) + OffSetY : EndIf
              
              ResizeGadget(TBEx()\CanvasNum, X, Y, Width, Height)
              
            Else
              ResizeGadget(TBEx()\CanvasNum, #PB_Ignore, #PB_Ignore, GadgetWidth(TBEx()\CanvasNum) + OffSetX,  #PB_Ignore)
            EndIf
            
            If OffSetX Or OffsetY : Draw_() : EndIf
          EndIf
          
        EndIf
        
      EndIf
      
    Next
    
  EndProcedure
  
  ;- ==========================================================================
  ;-   Module - Declared Procedures
  ;- ==========================================================================    
  
  CompilerIf #EnableToolBarGadgets
    
    Procedure   AddItem(GNum.i, TB_Index.i, Position, Text.s, ImageID.i=#False)
    
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            AddGadgetItem(TBEx()\Items()\Num, Position, Text, ImageID)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
  
    
    Procedure.i ComboBox(GNum.i, Width.i, Height.i, EventNum.i=#PB_Ignore, Text.s="", EventID.s="", Flags.i=#False)
      Define.i GadgetList
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If AddElement(TBEx()\Items())
          
          OpenGadgetList(TBEx()\CanvasNum)

          TBEx()\Items()\Type    = #ComboBox
          TBEx()\Items()\Num     = ComboBoxGadget(#PB_Any, 0, 0, Width, Height, Flags)
          TBEx()\Items()\Event   = EventNum
          TBEx()\Items()\EventID = EventID
          TBEx()\Items()\Text    = Text
          TBEx()\Items()\Width   = dpiX(Width)
          TBEx()\Items()\Height  = dpiY(Height)
  
          CloseGadgetList()
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetData(TBEx()\Items()\Num, TBEx()\CanvasNum)
            BindGadgetEvent(TBEx()\Items()\Num, @_GadgetHandler(), #PB_EventType_Change)
          EndIf
  
          If TBEx()\ReDraw : Draw_() : EndIf
          
          ProcedureReturn TBEx()\Items()\Num
        EndIf
        
      EndIf   
      
    EndProcedure
    
    Procedure.i SpinBox(GNum.i, Width.i, Height.i, Minimum.i, Maximum.i, EventNum.i=#PB_Ignore, Text.s="", EventID.s="", Flags.i=#False)
      Define.i GadgetList
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If AddElement(TBEx()\Items())
          
          OpenGadgetList(TBEx()\CanvasNum)
  
          TBEx()\Items()\Type    = #SpinGadget
          TBEx()\Items()\Num     = SpinGadget(#PB_Any, 0, 0, Width, Height, Minimum, Maximum, Flags)
          TBEx()\Items()\Event   = EventNum
          TBEx()\Items()\EventID = EventID
          TBEx()\Items()\Text    = Text
          TBEx()\Items()\Width   = dpiX(Width)
          TBEx()\Items()\Height  = dpiY(Height)
  
          CloseGadgetList()
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetData(TBEx()\Items()\Num, TBEx()\CanvasNum)
            BindGadgetEvent(TBEx()\Items()\Num, @_GadgetHandler())
          EndIf
  
          If TBEx()\ReDraw : Draw_() : EndIf
          
          ProcedureReturn TBEx()\Items()\Num
        EndIf
        
      EndIf   
      
    EndProcedure
    
    Procedure.i TextButton(GNum.i, Width.i, Height.i, Text.s, EventNum.i=#PB_Ignore, EventID.s="", Flags.i=#False)
      Define.i GadgetList
  
      If FindMapElement(TBEx(), Str(GNum))
        
        If AddElement(TBEx()\Items())
          
          OpenGadgetList(TBEx()\CanvasNum)
  
          TBEx()\Items()\Type    = #TextButton
          TBEx()\Items()\Num     = ButtonGadget(#PB_Any, 0, 0, Width, Height, Text, Flags)
          TBEx()\Items()\Event   = EventNum
          TBEx()\Items()\EventID = EventID
          TBEx()\Items()\Width   = dpiX(Width)
          TBEx()\Items()\Height  = dpiY(Height)
  
          CloseGadgetList()
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetData(TBEx()\Items()\Num, TBEx()\CanvasNum)
            BindGadgetEvent(TBEx()\Items()\Num, @_GadgetHandler())
          EndIf
  
          If TBEx()\ReDraw : Draw_() : EndIf
          
          ProcedureReturn TBEx()\Items()\Num
        EndIf
        
      EndIf   
      
    EndProcedure

    
    Procedure.i GetState(GNum.i, TB_Index.i)
    
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            ProcedureReturn GetGadgetState(TBEx()\Items()\Num)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
    
    Procedure.s GetText(GNum.i, TB_Index.i)
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            ProcedureReturn GetGadgetText(TBEx()\Items()\Num)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
    
    Procedure   SetGadgetFlags(GNum.i, TB_Index.i, Flags.i)
      ; #Top / #Bottom 
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            TBEx()\Items()\Flags | Flags
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
    
    Procedure   SetSpinAttribute(GNum.i, TB_Index.i, Attribute.i, Value.i)
    
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetAttribute(TBEx()\Items()\Num, Attribute, Value)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure

    Procedure   SetState(GNum.i, TB_Index.i, State.i)
    
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            
            Select TBEx()\Items()\Type
              Case #SpinGadget
                SetGadgetState(TBEx()\Items()\Num, State)
                SetGadgetText(TBEx()\Items()\Num, Str(State))
              Default
                SetGadgetState(TBEx()\Items()\Num, State)
            EndSelect
            
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
  
    Procedure   SetText(GNum.i, TB_Index.i, Text.s)
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetText(TBEx()\Items()\Num, Text)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
    
    
  CompilerEndIf  
  
  Procedure   AttachPopupMenu(GNum.i, TB_Index.i, MenuNum.i) 
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), TB_Index)
        
        TBEx()\Items()\PopupMenu = MenuNum
        
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf
      
    EndIf  
    
  EndProcedure  
  
  Procedure   ButtonText(GNum.i, TB_Index.i, Text.s)
    Define.i Flags
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), TB_Index)

        TBEx()\Items()\Text = Text
        
      If TBEx()\Flags & #AdjustHeight Or TBEx()\Flags & #AdjustAllButtons Or TBEx()\Flags & #AdjustButtons
        
        If TBEx()\Flags & #AdjustHeight     : Flags | #AdjustHeight    : EndIf
        If TBEx()\Flags & #AdjustButtons    : Flags | #AdjustButtons    : EndIf
        If TBEx()\Flags & #AdjustAllButtons : Flags | #AdjustAllButtons : EndIf
        Draw_(Flags)
        
      Else
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf
        
      EndIf
      
    EndIf
    
  EndProcedure
   
  Procedure   DisableButton(GNum.i, TB_Index.i, State.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), TB_Index)
        
        If State
          TBEx()\Items()\Flags | #Disable
        Else
          TBEx()\Items()\Flags & ~#Disable
        EndIf
        
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf
      
    EndIf  
    
  EndProcedure  
  
  Procedure   DisableRedraw(GNum.i, State.i=#False)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If State
        TBEx()\ReDraw = #False
      Else
        TBEx()\ReDraw = #True
        Draw_()
      EndIf
      
    EndIf
    
  EndProcedure   
  
  
  Procedure.i EventNumber(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      ProcedureReturn TBEx()\Event\Num
    EndIf
    
  EndProcedure
  
  Procedure.s EventID(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      ProcedureReturn TBEx()\Event\ID
    EndIf
    
  EndProcedure
  
  Procedure.i EventState(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      ProcedureReturn TBEx()\Event\State
    EndIf
    
  EndProcedure
  
  Procedure   Free(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      DeleteMapElement(TBEx())
      
    EndIf
    
  EndProcedure
  
  
  Procedure.i Gadget(GNum.i, X.i=#PB_Ignore, Y.i=#PB_Ignore, Width.i=#PB_Ignore, Height.i=#PB_Ignore, Flags.i=#False, WindowNum.i=#PB_Default)
    ; #ImageSize_16|#ImageSize_24|#ImageSize_32|#ButtonText|#Border|#PopupArrows
    ; #AutoResize|#AdjustButtons|#AdjustAllButtons|#AdjustHeight
    Define Result.i, ImageSize .f
    
    CompilerIf Defined(ModuleEx, #PB_Module)
      If WindowNum = #PB_Default
        WindowNum = ModuleEx::GetGadgetWindow()
      EndIf
    CompilerElse
      If WindowNum = #PB_Default
        WindowNum = GetActiveWindow()
      EndIf
    CompilerEndIf   
    
    ;{ ImageSize
    If Flags & #ImageSize_16
      ImageSize = 16
    ElseIf Flags & #ImageSize_24
      ImageSize = 24
    Else
      ImageSize = 32
    EndIf ;}
    
    ;{ Default gadget size
    If IsWindow(WindowNum)
      If X = #PB_Ignore : X = 0 : EndIf
      If Y = #PB_Ignore : Y = 0 : EndIf
      If Width  = #PB_Ignore : Width = WindowWidth(WindowNum, #PB_Window_InnerCoordinate) : EndIf
      If Height = #PB_Ignore
        Height = ImageSize + dpiY(10)
        If Flags & #Border :  Height + dpiY(2) : EndIf
      EndIf
    EndIf ;}

    Result = CanvasGadget(GNum, X, Y, Width, Height, #PB_Canvas_Container)
    If Result
      
      If GNum = #PB_Any : GNum = Result : EndIf
      
      X = dpiX(X)
      Y = dpiY(Y)
      Width     = dpiX(Width) 
      Height    = dpiY(Height)
      ImageSize = dpiY(ImageSize)
      
      If AddMapElement(TBEx(), Str(GNum))
        
        TBEx()\CanvasNum  = GNum
        TBEx()\Window\Num = WindowNum
        
        CompilerIf Defined(ModuleEx, #PB_Module)
          If ModuleEx::AddWindow(TBEx()\Window\Num, ModuleEx::#Tabulator)
            ModuleEx::AddGadget(GNum, TBEx()\Window\Num, ModuleEx::#IgnoreTabulator)
          EndIf
        CompilerEndIf
        
        TBEx()\Size\X = X
        TBEx()\Size\Y = Y
        TBEx()\Size\Width  = Width
        TBEx()\Size\Height = Height
        
        TBEx()\Size\Spacing = dpiX(2)
       
        TBEx()\LastFocus = #NoFocus
        
        TBEx()\Buttons\Focus   = #NoFocus
        TBEx()\Buttons\Width   = ImageSize + dpiX(8)
        TBEx()\Buttons\Height  = ImageSize + dpiY(8)
        TBEx()\Buttons\Spacing = dpiX(2)
        
        TBEx()\Images\Width    = ImageSize
        TBEx()\Images\Height   = ImageSize
        
        TBEx()\Color\Front     = $000000
        TBEx()\Color\Back      = $EDEDED
        TBEx()\Color\Separator = $A0A0A0
        TBEx()\Color\Focus     = $FF8000
        TBEx()\Color\Border    = $C7C7C7
        
        CompilerSelect #PB_Compiler_OS ;{ window background color (if possible)
          CompilerCase #PB_OS_Windows
            TBEx()\Color\Back      = GetSysColor_(#COLOR_MENU)
            TBEx()\Color\Separator = GetSysColor_(#COLOR_3DSHADOW)
            TBEx()\Color\Focus     = GetSysColor_(#COLOR_MENUHILIGHT)
          CompilerCase #PB_OS_MacOS
            TBEx()\Color\Back      = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
            TBEx()\Color\Separator = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor separatorColor"))
            TBEx()\Color\Focus     = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedControlColor"))
            TBEx()\Color\Border    = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
          CompilerCase #PB_OS_Linux

        CompilerEndSelect ;}
        
        TBEx()\Flags  = Flags
        
        BindGadgetEvent(TBEx()\CanvasNum,  @_ResizeHandler(), #PB_EventType_Resize)
        
        If Flags & #AutoResize
          If IsWindow(WindowNum)
            TBEx()\Window\Width  = WindowWidth(WindowNum)
            TBEx()\Window\Height = WindowHeight(WindowNum)
            BindEvent(#PB_Event_SizeWindow, @_ResizeWindowHandler(), WindowNum)
          EndIf  
        EndIf
        
        BindGadgetEvent(GNum,  @_MouseMoveHandler(),      #PB_EventType_MouseMove)
        BindGadgetEvent(GNum,  @_LeftButtonDownHandler(), #PB_EventType_LeftButtonDown)
        BindGadgetEvent(GNum,  @_LeftButtonUpHandler(),   #PB_EventType_LeftButtonUp)
        BindGadgetEvent(GNum,  @_ResizeHandler(),         #PB_EventType_Resize)
        BindGadgetEvent(GNum,  @_LostFocusHandler(),      #PB_EventType_LostFocus)
        
        TBEx()\ReDraw = #True
        
        If Flags & #AdjustHeight
          Draw_(#AdjustHeight)
          If TBEx()\Size\Height > GadgetHeight(GNum) : ResizeGadget(GNum, #PB_Ignore, #PB_Ignore, #PB_Ignore, TBEx()\Size\Height) : EndIf
        Else
          Draw_()
        EndIf  
        
      EndIf
      
      CloseGadgetList()

    EndIf
    
    ProcedureReturn GNum
  EndProcedure    
  
  
  Procedure.i GetAttribute(GNum.i, Attribute.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      Select Attribute
        Case #Height
          ProcedureReturn DesktopUnscaledY(TBEx()\Size\Height)
        Case #Spacing
          ProcedureReturn DesktopUnscaledX(TBEx()\Size\Spacing)
        Case #ButtonHeight
          ProcedureReturn DesktopUnscaledY(TBEx()\Buttons\Height)
        Case #ButtonWidth
          ProcedureReturn DesktopUnscaledX(TBEx()\Buttons\Width)
        Case #ButtonSpacing
          ProcedureReturn DesktopUnscaledX(TBEx()\Buttons\Spacing)
      EndSelect
      
      If TBEx()\ReDraw : Draw_() : EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i GetGadgetNumber(GNum.i, TB_Index.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), TB_Index)
        If IsGadget(TBEx()\Items()\Num)
          ProcedureReturn TBEx()\Items()\Num
        EndIf
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure.i GetIndex(GNum.i, EventNum.i) 
    
    If FindMapElement(TBEx(), Str(GNum))
      
      ForEach TBEx()\Items()
        If TBEx()\Items()\Event = EventNum
          
          ProcedureReturn ListIndex(TBEx()\Items())
          
        EndIf  
      Next
      
    EndIf
    
  EndProcedure  
  
  Procedure.i GetIndexFromID(GNum.i, EventID.s) 
    
    If FindMapElement(TBEx(), Str(GNum))
      
      ForEach TBEx()\Items()
        If TBEx()\Items()\EventID = EventID
          
          ProcedureReturn ListIndex(TBEx()\Items())
          
        EndIf  
      Next
      
    EndIf
    
  EndProcedure 
  
  
  Procedure.i Height(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      ProcedureReturn TBEx()\Size\Height
      
    EndIf
    
  EndProcedure
  
  Procedure   HideButton(GNum.i, Index.i, State.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), Index)
        
        If State
          TBEx()\Items()\Flags | #Hide
        Else
          TBEx()\Items()\Flags & ~#Hide
        EndIf
        
        If TBEx()\ReDraw : Draw_() : EndIf  
      EndIf
      
    EndIf  
    
  EndProcedure
  
  Procedure   ImageButton(GNum.i, ImageNum.i, EventNum.i=#False, Text.s="", EventID.s="", Flags.i=#False)
 
    If FindMapElement(TBEx(), Str(GNum))
      
      If AddElement(TBEx()\Items())
        
        TBEx()\Items()\Type       = #ImageButton
        TBEx()\Items()\Event      = EventNum
        TBEx()\Items()\EventID    = EventID
        TBEx()\Items()\Text       = Text
        TBEx()\Items()\ImageNum   = ImageNum
        TBEx()\Items()\Width      = TBEx()\Buttons\Width
        TBEx()\Items()\PopupMenu = #NotValid
        TBEx()\Items()\Flags      = Flags
        
        If TBEx()\Flags & #ToolTips
          TBEx()\Items()\ToolTip = Text
        EndIf
        
        If TBEx()\Flags & #AdjustAllButtons
          Draw_(#AdjustAllButtons)
        ElseIf TBEx()\Flags & #AdjustButtons
          Draw_(#AdjustButtons)
        Else
          If TBEx()\ReDraw : Draw_() : EndIf
        EndIf

      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure   Separator(GNum.i, Width.i=#PB_Default)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If Width = #PB_Default : Width = 10 : EndIf
      
      If AddElement(TBEx()\Items())
        
        TBEx()\Items()\Type  = #Separator
        TBEx()\Items()\Width = dpiX(Width)
        
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf 
      
    EndIf  
    
  EndProcedure  
  
  
  Procedure   SetAutoResizeFlags(GNum.i, Flags.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      TBEx()\Size\Flags = Flags
      
    EndIf  
   
  EndProcedure
  
  Procedure   SetAttribute(GNum.i, Attribute.i, Value.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      Select Attribute
        Case #Height
          TBEx()\Size\Height     = dpiX(Value)
        Case #Spacing
          TBEx()\Size\Spacing    = dpiX(Value)
        Case #ButtonHeight
          TBEx()\Buttons\Height  = dpiX(Value)
        Case #ButtonWidth
          TBEx()\Buttons\Width   = dpiX(Value)
        Case #ButtonSpacing
          TBEx()\Buttons\Spacing = dpiX(Value)
      EndSelect
      
      If TBEx()\ReDraw : Draw_() : EndIf
    EndIf
    
  EndProcedure
  
  Procedure   SetColor(GNum.i, ColorType.i, Color.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      Select ColorType
        Case #FrontColor
          TBEx()\Color\Front     = Color
        Case #BackColor
          TBEx()\Color\Back      = Color
        Case #FocusColor
          TBEx()\Color\Focus     = Color
        Case #SeparatorColor
          TBEx()\Color\Separator = Color
        Case #BorderColor
          TBEx()\Color\Border    = Color
      EndSelect
      
      If TBEx()\ReDraw : Draw_() : EndIf
    EndIf
    
  EndProcedure
  
  Procedure   SetFont(GNum.i, FontID.i)
    Define.i Flags
    
    If FindMapElement(TBEx(), Str(GNum))
      
      TBEx()\FontID = FontID
      
      CompilerIf #EnableToolBarGadgets
        
        ForEach TBEx()\Items()
          Select TBEx()\Items()\Type
            Case #ComboBox   ;{ ComboBox Font
              If IsGadget(TBEx()\Items()\Num)
                SetGadgetFont(TBEx()\Items()\Num, FontID)
              EndIf ;}
            Case #SpinGadget ;{ SpinGadget Font
              If IsGadget(TBEx()\Items()\Num)
                SetGadgetFont(TBEx()\Items()\Num, FontID)
              EndIf ;}
            Case #TextButton ;{ TextButton Font
              If IsGadget(TBEx()\Items()\Num)
                SetGadgetFont(TBEx()\Items()\Num, FontID)
              EndIf ;}  
          EndSelect
        Next
        
      CompilerEndIf
      
      If TBEx()\Flags & #AdjustHeight Or TBEx()\Flags & #AdjustAllButtons Or TBEx()\Flags & #AdjustButtons
        
        If TBEx()\Flags & #AdjustHeight     : Flags | #AdjustHeight    : EndIf
        If TBEx()\Flags & #AdjustButtons    : Flags | #AdjustButtons    : EndIf
        If TBEx()\Flags & #AdjustAllButtons : Flags | #AdjustAllButtons : EndIf
        
        Draw_(Flags)
        
      Else
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure   SetPostEvent(GNum.i, Event.i=#Event_Gadget)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      TBEx()\PostEvent = Event

    EndIf
    
  EndProcedure
  
  
  Procedure   Spacer(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If AddElement(TBEx()\Items())
        
        TBEx()\Items()\Type  = #Spacer
        TBEx()\Spacer + 1
        
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf 
      
    EndIf  
    
  EndProcedure
  
  Procedure   ToolTip(GNum.i, TB_Index.i, Text.s) 
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), TB_Index)
        If TBEx()\Items()\Type = #ComboBox Or TBEx()\Items()\Type = #SpinGadget Or TBEx()\Items()\Type = #TextButton
          If IsGadget(TBEx()\Items()\Num) : GadgetToolTip(TBEx()\Items()\Num, Text) : EndIf
        Else
          TBEx()\Items()\ToolTip = Text
        EndIf
      EndIf
      
    EndIf
    
  EndProcedure
  
EndModule

;- ========  Module - Example ========

CompilerIf #PB_Compiler_IsMainFile
  
  Enumeration 1
    #Window
    #ToolBar
    #Font
    #Popup
    #ComboBox
    #SpinBox
    #TextButton
  EndEnumeration
  
  Enumeration 1
    #IMG_New
    #IMG_Save
    #IMG_Copy
    #IMG_Cut
    #IMG_Paste
    #IMG_Help
    #IMG_Star
    #IMG_World
  EndEnumeration
  
  Enumeration 10
    #Menu_Item1
    #Menu_Item2
    #TB_New
    #TB_Save
    #TB_Copy
    #TB_Cut
    #TB_Paste
    #TB_Help
  EndEnumeration
  
  LoadImage(#IMG_New,   "New.png")
  LoadImage(#IMG_Save,  "Save.png")
  LoadImage(#IMG_Copy,  "Copy.png")
  LoadImage(#IMG_Cut,   "Cut.png")
  LoadImage(#IMG_Paste, "Paste.png")
  LoadImage(#IMG_Help,  "Help.png")
  LoadImage(#IMG_Star,  "Star16.png")
  LoadImage(#IMG_World, "World16.png")
  
  LoadFont(#Font, "Arial", 9)
  
  If OpenWindow(#Window, 0, 0, 600, 300, "Example", #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)
    
    If CreatePopupImageMenu(#Popup)
      MenuItem(#Menu_Item1, "Star", ImageID(#IMG_Star))
      MenuItem(#Menu_Item2, "World", ImageID(#IMG_World))
    EndIf
    
    ToolBar::Gadget(#ToolBar, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, ToolBar::#Border|ToolBar::#AutoResize|ToolBar::#ButtonText|ToolBar::#AdjustButtons|ToolBar::#AdjustHeight|ToolBar::#RoundFocus|ToolBar::#PopupArrows|ToolBar::#ToolTips, #Window)
    
    ToolBar::DisableRedraw(#ToolBar, #True)
    
    ToolBar::ImageButton(#ToolBar, #IMG_New,   #TB_New,   "New",   "newID")
    ToolBar::ImageButton(#ToolBar, #IMG_Save,  #TB_Save,  "Save",  "saveID")
    ToolBar::Separator(#ToolBar)
    ToolBar::ImageButton(#ToolBar, #IMG_Copy,  #TB_Copy,  "Copy",  "copyID")
    ToolBar::ImageButton(#ToolBar, #IMG_Cut,   #TB_Cut,   "Cut",   "cutID")
    ToolBar::ImageButton(#ToolBar, #IMG_Paste, #TB_Paste, "Paste", "pasteID")
    ToolBar::Separator(#ToolBar)
    CompilerIf ToolBar::#EnableToolBarGadgets
      ToolBar::ComboBox(#ToolBar, 80, 24, #ComboBox, "", "comboID")
      ToolBar::Separator(#ToolBar)
      ToolBar::SpinBox(#ToolBar,  40, 24, 1, 18, #SpinBox, "", "spinID", #PB_Spin_ReadOnly)
      ToolBar::Separator(#ToolBar)
      ToolBar::TextButton(#ToolBar, 60, 24, "Button", #TextButton, "buttonID", #PB_Button_Toggle)
    CompilerEndIf
    ToolBar::Spacer(#ToolBar)
    ToolBar::ImageButton(#ToolBar, #IMG_Help,  #TB_Help,  "Help",  "helpID")
    
    ToolBar::SetFont(#ToolBar, FontID(#Font))
    
    ToolBar::ToolTip(#ToolBar, 7, "ComboBox")
    ToolBar::ToolTip(#ToolBar, 9, "SpinBox")
    ToolBar::ToolTip(#ToolBar, 11, "TextButton")
    
    ;ToolBar::SetGadgetFlags(#ToolBar, 7, ToolBar::#Bottom)
    ;ToolBar::SetGadgetFlags(#ToolBar, 9, ToolBar::#Bottom)
    ;ToolBar::SetGadgetFlags(#ToolBar, 11, ToolBar::#Bottom)
    
    ToolBar::DisableRedraw(#ToolBar, #False)
    
    ToolBar::AttachPopupMenu(#ToolBar, 7, #Popup) 
    
    ;ToolBar::ButtonText(#ToolBar, 0, "Document")
    
    ToolBar::SetColor(#ToolBar, ToolBar::#FrontColor, $571313)
    
    ToolBar::DisableButton(#ToolBar, 3, #True)
    ;ToolBar::HideButton(#ToolBar, 3, #True)
    
    ToolBar::SetPostEvent(#ToolBar, #PB_Event_Menu)
    
    CompilerIf ToolBar::#EnableToolBarGadgets
      ; ---ComboBox---
      ToolBar::AddItem(#ToolBar, 7, -1, "Item 1")
      ToolBar::AddItem(#ToolBar, 7, -1, "Item 2")
      ToolBar::AddItem(#ToolBar, 7, -1, "Item 3")
      ToolBar::SetState(#ToolBar, 7, 0)
      
      ; --- SpinBox ---
      ToolBar::SetState(#ToolBar, 9, 9)
    CompilerEndIf
  
    Repeat
      Event = WaitWindowEvent()
      Select Event
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #ToolBar    ;{ ToolBar-Gadget
              Select EventType()
                Case ToolBar::#EventType_ImageButton
                  Debug "ImageButton clicked: " + Str(EventData()) + " [ Number: " +Str(ToolBar::EventNumber(#ToolBar))+" / ID: '"+ToolBar::EventID(#ToolBar)+ "' ]"
                Case ToolBar::#EventType_ComboBox ; EventNum = #PB_Ignore
                  Debug "ComboBox changed: " + Str(ToolBar::EventState(#ToolBar)) + " [ Index: " +Str(EventData())+" / ID: '"+ToolBar::EventID(#ToolBar)+ "' ]"
                Case ToolBar::#EventType_SpinBox  ; EventNum = #PB_Ignore
                  Debug "SpinBox changed: " + Str(ToolBar::EventState(#ToolBar))  + " [ Index: " +Str(EventData())+" / ID: '"+ToolBar::EventID(#ToolBar)+ "' ]" 
                Case ToolBar::#EventType_Button
                  Debug "TextButton clicked: " + Str(EventData()) + " [ Number: " +Str(ToolBar::EventNumber(#ToolBar))+" / ID: '"+ToolBar::EventID(#ToolBar)+ "' ]"  
              EndSelect ;}
            Case #ComboBox   ;{ ComboBox (Toolbar)
              Debug "ComboBox State: " + Str(EventData())
            Case #SpinBox  
              Debug "SpinBox State: " + Str(EventData())
            Case #TextButton
              If EventData() = #True
                Debug "Textbutton: pressed" 
              Else
                Debug "Textbutton: not pressed" 
              EndIf 
              ;}
          EndSelect
        Case #PB_Event_Menu  ;{ Menu Events
          Select EventMenu()
            Case #TB_New
              Debug "Menu Item: 'New' ("   + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Save 
              Debug "Menu Item: 'Save' ("  + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Copy 
              Debug "Menu Item: 'Copy' ("  + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Cut  
              Debug "Menu Item: 'Cut' ("   + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Paste
              Debug "Menu Item: 'Paste' (" + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Help
              Debug "Menu Item: 'Help' ("  + Str(ToolBar::EventNumber(#ToolBar)) + ")"
          EndSelect ;}
      EndSelect
     Until Event = #PB_Event_CloseWindow
    
  EndIf
  
CompilerEndIf  
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 893
; FirstLine = 437
; Folding = +BIAE134ABAA3BAqs0
; EnableXP
; DPIAware