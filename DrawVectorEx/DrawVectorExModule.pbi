﻿;/ ===================================
;/ =    DrawVectorEx - Module.pbi    =
;/ ===================================
;/
;/ [ PB V5.7x / 64Bit / All OS / DPI ]
;/
;/ Simplified use of the VectorDrawing library 
;/
;/ © 2020 Thorsten1867 (06/2019)
;/

; Last Update: 18.03.2020
;
; Added: SetDotPattern(LineWidth.d, Array Pattern.d(1), Flags.i=#False, StartOffset.d=0)
; Added: DisableDotPattern(State.i=#True)
;

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


;{ _____ DrawEx - Commands _____

; Draw::AlphaColor_()   - similar to RGBA()
; Draw::Box_()          - similar to Box()
; Draw::Circle_()       - similar to Circle()
; Draw::CircleArc_()    - draws a arc of a circle
; Draw::CircleSector_() - draws a circle sector
; Draw::Ellipse_()      - similar to Ellipse()
; Draw::EllipseArc_()   - draws a arc of a ellipse
; Draw::Font_()         - similar to DrawingFont()
; Draw::Line_()         - similar to Line()
; Draw::HLine_()        - draws a horizontal line
; Draw::VLine_()        - draws a vertical line
; Draw::LineXY_()       - similar to LineXY()
; Draw::MixColor_()     - mixes 2 colours in a mixing ratio of 1% - 99%
; Draw::SetStroke_()    - changes the stroke width
; Draw::StartVector_()  - similar to StartVectorDrawing()
; Draw::StopVector_()   - similar to StopVectorDrawing()
; Draw::Text_()         - similar to DrawText()
; Draw::TextHeight_()   - similar to TextHeight()
; Draw::TextWidth_()    - similar to TextWidth()

;}


DeclareModule Draw
  
  #Version = 20031800
  
  EnumerationBinary
    #Text_Default  = #PB_VectorText_Default 
    #Text_Visible  = #PB_VectorText_Visible
    #Text_Offset   = #PB_VectorText_Offset
    #Text_Baseline = #PB_VectorText_Baseline
    #Vertical
    #Horizontal
    #Diagonal
    #Window
    #Image
    #Printer
    #Canvas
    #DPI
  EndEnumeration
  
  #RoundEnd       = #PB_Path_RoundEnd
  #SquareEnd      = #PB_Path_SquareEnd
  #RoundCorner    = #PB_Path_RoundCorner
  #DiagonalCorner = #PB_Path_DiagonalCorner
  
  ;- ===========================================================================
  ;-   DeclareModule
  ;- ===========================================================================  
  
  Declare.q AlphaColor_(Color.i, Alpha.i)
  Declare.q MixColor_(Color1.i, Color2.i, Factor.i=50)
  
  Declare   Box_(X.i, Y.i, Width.i, Height.i, Color.q, FillColor.q=#PB_Default, GradientColor.q=#PB_Default, Rotate.i=0, Flags.i=#False)
  Declare   Circle_(X.i, Y.i, Radius.i, Color.q, FillColor.q=#PB_Default, GradientColor.q=#PB_Default, Flags.i=#False)
  Declare   CircleArc_(X.i, Y.i, Radius.i, startAngle.i, endAngle.i, Color.q, Flags.i=#False)
  Declare   CircleSector_(X.i, Y.i, Radius.i, startAngle.i, endAngle.i, Color.q, FillColor.q=#PB_Default, GradientColor.q=#PB_Default, Flags.i=#False)
  Declare   DisableDotPattern(State.i=#True)
  Declare   Ellipse_(X.i, Y.i, RadiusX.i, RadiusY.i, Color.q, FillColor.q=#PB_Default, GradientColor.q=#PB_Default, Rotate.i=0, Flags.i=#False)
  Declare   EllipseArc_(X.i, Y.i, RadiusX.i, RadiusY.i, startAngle.i, endAngle.i, Color.q, Flags.i=#False)
  Declare   Font_(FontID.i, Size.i=#PB_Default, Flags.i=#False)
  Declare   Line_(X.i, Y.i, Width.i, Height.i, Color.q, Flags.i=#False)
  Declare   LinesArc_(X1.d, Y1.d, X2.d, Y2.d, X3.d, Y3.d, Radius.i, Color.q, Flags.i=#False)
  Declare   HLine_(X.i, Y.i, Width.i, Color.q, Flags.i=#False)
  Declare   VLine_(X.i, Y.i, Height.i, Color.q, Flags.i=#False)
  Declare   LineXY_(X1.i, Y1.i, X2.i, Y2.i, Color.q, Flags.i=#False)
  Declare.i StartVector_(PB_Num.i, Type.i=#Canvas, Unit.i=#PB_Unit_Pixel)
  Declare   StopVector_() 
  Declare   SetDotPattern(LineWidth.d, Array Pattern.d(1), Flags.i=#False, StartOffset.d=0)
  Declare   SetStroke_(LineWidth.d=1)
  Declare   TangentsArc_(X1.i, Y1.i, X2.i, Y2.i, X3.i, Y3.i, X4.i, Y4.i, Color.q, Flags.i=#False)
  Declare   Text_(X.i, Y.i, Text$, Color.q, Angle.i=0, Flags.i=#False)
  Declare.f TextHeight_(Text.s, Flags.i=#PB_VectorText_Default) ; [ #Text_Default / #Text_Visible / #Text_Offset / #Text_Baseline ]
  Declare.f TextWidth_(Text.s,  Flags.i=#PB_VectorText_Default) ; [ #Text_Default / #Text_Visible / #Text_Offset ]

EndDeclareModule


Module Draw
  
  EnableExplicit

  Structure Line_Structure
    Width.d
    State.i
    Flags.i
    Offset.i
    Array Pattern.d(1)
  EndStructure  
  
  Structure XY_Structure
    X.f
    Y.f
  EndStructure  
  
  Global Stroke.i, Line.Line_Structure
  
  ;- ============================================================================
  ;-   Module - Internal
  ;- ============================================================================ 
  
  Procedure.f dpiX(Num.d)
    ProcedureReturn DesktopScaledX(Num)
  EndProcedure
  
  Procedure.f dpiY(Num.d)
    ProcedureReturn DesktopScaledY(Num)
  EndProcedure
  
  
  Procedure.i BlendColor_(Color1.i, Color2.i, Factor.i=50)
    Define.i Red1, Green1, Blue1, Red2, Green2, Blue2
    Define.f Blend = Factor / 100
    
    Red1 = Red(Color1): Green1 = Green(Color1): Blue1 = Blue(Color1)
    Red2 = Red(Color2): Green2 = Green(Color2): Blue2 = Blue(Color2)
    
    ProcedureReturn RGB((Red1 * Blend) + (Red2 * (1 - Blend)), (Green1 * Blend) + (Green2 * (1 - Blend)), (Blue1 * Blend) + (Blue2 * (1 - Blend)))
  EndProcedure

  Procedure   _LineXY(X1.f, Y1.f, X2.f, Y2.f, Color.q)
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    MovePathCursor(X1, Y1)
    AddPathLine(X2, Y2)
    VectorSourceColor(Color)
    
    If Line\State And Line\Width > 0
      CustomDashPath(Line\Width, Line\Pattern(), Line\Flags, Line\Offset)
    Else
      StrokePath(Stroke)
    EndIf  
    
  EndProcedure
  
  
  Procedure.i FindIntersection(X1.i, Y1.i, X2.i, Y2.i, X3.i, Y3.i, X4.i, Y4.i, *isP.XY_Structure)
    Define.f dX12, dY12, dX34, dY34, Denominator, T1, T2
    
    dX12 = X2 - X1
    dY12 = Y2 - Y1
    dX34 = X4 - X3
    dY34 = Y4 - Y3
  
    Denominator = (dY12 * dX34 - dX12 * dY34)
    T1 = ((X1 - X3) * dY34 + (Y3 - Y1) * dX34) / Denominator
  
    If IsInfinity(T1) : ProcedureReturn #False : EndIf
  
    T2 = ((X3 - X1) * dY12 + (Y1 - Y3) * dX12) / Denominator
    
    *isP\X = X1 + dX12 * T1
    *isP\Y = Y1 + dY12 * T1
  
    ProcedureReturn #True
  EndProcedure
  
  Procedure.i FindArcFromTangents(X1.i, Y1.i, X2.i, Y2.i, X3.i, Y3.i, X4.i, Y4.i, *isPoint.XY_Structure)
    Define.f dX, dY, dX1, dY1, dX2, dY2, Radius
    Define.XY_Structure sPoint, pPoint1, pPoint2, isCircle
   
    If FindIntersection(X1, Y1, X2, Y2, X3, Y3, X4, Y4, *isPoint)
    
      dX1 = X2 - X1
      dY1 = Y2 - Y1
  
      pPoint1\X = X2 - dY1
      pPoint1\Y = X2 + dX1
      
      dX2 = X3 - X4
      dY2 = Y3 - Y4
      
      pPoint2\X = X3 - dY2
      pPoint2\Y = Y3 + dX2
      
      If FindIntersection(X2, Y2, pPoint1\X, pPoint1\Y, X3, Y3, pPoint2\X, pPoint2\Y, @isCircle)
    
        dX = X2 - isCircle\X
        dY = Y2 - isCircle\Y
      
        Radius = Sqr(dX * dX + dY * dY)
        
        ProcedureReturn Radius
      EndIf
    
    EndIf
  
  EndProcedure  

  ;- ==========================================================================
  ;-   Module - Declared Procedures
  ;- ========================================================================== 
  
  Procedure.q AlphaColor_(Color.i, Alpha.i) 
    ProcedureReturn RGBA(Red(Color), Green(Color), Blue(Color), Alpha)
  EndProcedure
  
  Procedure.q MixColor_(Color1.i, Color2.i, Factor.i=50)
    
    ProcedureReturn BlendColor_(Color1, Color2, Factor)
    
  EndProcedure
 
  Procedure Box_(X.i, Y.i, Width.i, Height.i, Color.q, FillColor.q=#PB_Default, GradientColor.q=#PB_Default, Rotate.i=0, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
      Width  = dpiX(Width)
      Height = dpiY(Height)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    If Rotate : RotateCoordinates(X, Y, Rotate) : EndIf
    
    AddPathBox(X, Y, Width, Height)
    VectorSourceColor(Color)
    
    If FillColor <> #PB_Default
      
      If Alpha(FillColor) = #False : FillColor = RGBA(Red(FillColor), Green(FillColor), Blue(FillColor), 255) : EndIf
      
      If GradientColor <> #PB_Default
        If Alpha(GradientColor) = #False : GradientColor = RGBA(Red(GradientColor), Green(GradientColor), Blue(GradientColor), 255) : EndIf
        If Flags & #Horizontal
          VectorSourceLinearGradient(X, Y, X + Width, Y)
        ElseIf Flags & #Diagonal
          VectorSourceLinearGradient(X, Y, X + Width, Y + Height)
        Else
          VectorSourceLinearGradient(X, Y, X, Y + Height)
        EndIf
        VectorSourceGradientColor(FillColor, 1.0)
        VectorSourceGradientColor(GradientColor, 0.0)
        FillPath(#PB_Path_Preserve)
      Else
        VectorSourceColor(FillColor)
        FillPath(#PB_Path_Preserve)
      EndIf
      
    EndIf
    
    VectorSourceColor(Color)
    
    If Line\State And Line\Width > 0
      CustomDashPath(Line\Width, Line\Pattern(), Line\Flags, Line\Offset)
    Else
      StrokePath(Stroke)
    EndIf  
    
    If Rotate : RotateCoordinates(X, Y, -Rotate) : EndIf
    
  EndProcedure
  
  Procedure Circle_(X.i, Y.i, Radius.i, Color.q, FillColor.q=#PB_Default, GradientColor.q=#PB_Default, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
      Radius = dpiX(Radius)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    AddPathCircle(X, Y, Radius)
    
    If FillColor <> #PB_Default
      
      If Alpha(FillColor) = #False : FillColor = RGBA(Red(FillColor), Green(FillColor), Blue(FillColor), 255) : EndIf
      
      If GradientColor <> #PB_Default
        If Alpha(GradientColor) = #False : GradientColor = RGBA(Red(GradientColor), Green(GradientColor), Blue(GradientColor), 255) : EndIf
        VectorSourceCircularGradient(X, Y, Radius)
        VectorSourceGradientColor(FillColor, 1.0)
        VectorSourceGradientColor(GradientColor, 0.0)
        FillPath(#PB_Path_Preserve)
      Else
        VectorSourceColor(FillColor)
        FillPath(#PB_Path_Preserve)
      EndIf
      
    EndIf
    
    VectorSourceColor(Color)
    
    If Line\State And Line\Width > 0
      CustomDashPath(Line\Width, Line\Pattern(), Line\Flags, Line\Offset)
    Else
      StrokePath(Stroke)
    EndIf  
  
  EndProcedure
  
  Procedure CircleArc_(X.i, Y.i, Radius.i, startAngle.i, endAngle.i, Color.q, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
      Radius = dpiX(Radius)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    AddPathCircle(X, Y, Radius, startAngle, endAngle)
    
    VectorSourceColor(Color)
    
    If Line\State And Line\Width > 0
      CustomDashPath(Line\Width, Line\Pattern(), Line\Flags, Line\Offset)
    Else
      StrokePath(Stroke)
    EndIf  
    
  EndProcedure
  
  Procedure CircleSector_(X.i, Y.i, Radius.i, startAngle.i, endAngle.i, Color.q, FillColor.q=#PB_Default, GradientColor.q=#PB_Default, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
      Radius = dpiX(Radius)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf

    MovePathCursor(X, Y)
    AddPathCircle(X, Y, Radius, startAngle, endAngle, #PB_Path_Connected)
    ClosePath()
    
    If FillColor <> #PB_Default
      
      If Alpha(FillColor) = #False : FillColor = RGBA(Red(FillColor), Green(FillColor), Blue(FillColor), 255) : EndIf
      
      If GradientColor <> #PB_Default
        If Alpha(GradientColor) = #False : GradientColor = RGBA(Red(GradientColor), Green(GradientColor), Blue(GradientColor), 255) : EndIf
        VectorSourceCircularGradient(X, Y, Radius)
        VectorSourceGradientColor(FillColor, 0.0)
        VectorSourceGradientColor(GradientColor, 1.0)
        FillPath(#PB_Path_Preserve)
      Else
        VectorSourceColor(FillColor)
        FillPath(#PB_Path_Preserve)
      EndIf
      
    EndIf
    
    VectorSourceColor(Color)
    
    If Line\State And Line\Width > 0
      CustomDashPath(Line\Width, Line\Pattern(), Line\Flags, Line\Offset)
    Else
      StrokePath(Stroke)
    EndIf  
    
  EndProcedure
  
  Procedure DisableDotPattern(State.i=#True)
    
    If State
      Line\State = #False
    Else  
      Line\State = #True
    EndIf
    
  EndProcedure  
  
  Procedure Ellipse_(X.i, Y.i, RadiusX.i, RadiusY.i, Color.q, FillColor.q=#PB_Default, GradientColor.q=#PB_Default, Rotate.i=0, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
      RadiusX = dpiX(RadiusX)
      RadiusY = dpiY(RadiusY)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    If Rotate : RotateCoordinates(X, Y, Rotate) : EndIf
    
    AddPathEllipse(X, Y, RadiusX, RadiusY)
    
    If FillColor <> #PB_Default
      
      If Alpha(FillColor) = #False : FillColor = RGBA(Red(FillColor), Green(FillColor), Blue(FillColor), 255) : EndIf
      
      If GradientColor <> #PB_Default
        If Alpha(GradientColor) = #False : GradientColor = RGBA(Red(GradientColor), Green(GradientColor), Blue(GradientColor), 255) : EndIf
        If RadiusX > RadiusY
          VectorSourceCircularGradient(X, Y, RadiusX)
        Else
          VectorSourceCircularGradient(X, Y, RadiusY)
        EndIf 
        VectorSourceGradientColor(FillColor, 1.0)
        VectorSourceGradientColor(GradientColor, 0.0)
        FillPath(#PB_Path_Preserve)
      Else
        VectorSourceColor(FillColor)
        FillPath(#PB_Path_Preserve)
      EndIf
      
    EndIf
    
    VectorSourceColor(Color)
    
    If Line\State And Line\Width > 0
      CustomDashPath(Line\Width, Line\Pattern(), Line\Flags, Line\Offset)
    Else
      StrokePath(Stroke)
    EndIf  
    
    If Rotate : RotateCoordinates(X, Y, -Rotate) : EndIf
    
  EndProcedure
  
  Procedure EllipseArc_(X.i, Y.i, RadiusX.i, RadiusY.i, startAngle.i, endAngle.i, Color.q, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
      RadiusX = dpiX(RadiusX)
      RadiusY = dpiY(RadiusY)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    AddPathEllipse(X, Y, RadiusX, RadiusY, startAngle, endAngle)
    VectorSourceColor(Color)
    
    If Line\State And Line\Width > 0
      CustomDashPath(Line\Width, Line\Pattern(), Line\Flags, Line\Offset)
    Else
      StrokePath(Stroke)
    EndIf  
    
  EndProcedure

  Procedure Line_(X.i, Y.i, Width.i, Height.i, Color.q, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
      Width  = dpiX(Width)
      Height = dpiY(Height)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    If Width And Height
      
      If Width > 1
        
        _LineXY(X, Y, X + Width, Y, Color)
        
      Else
        
        _LineXY(X, Y, X, Y + Height, Color)
        
      EndIf
      
    EndIf
  EndProcedure
  
  Procedure VLine_(X.i, Y.i, Height.i, Color.q, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
      Height = dpiY(Height)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    If Height
      _LineXY(X, Y, X, Y + Height, Color)
    EndIf
      
  EndProcedure
  
  Procedure HLine_(X.i, Y.i, Width.i, Color.q, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
      Width  = dpiX(Width)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    If Width 
      _LineXY(X, Y, X + Width, Y, Color)
    EndIf    

  EndProcedure
  
  Procedure LineXY_(X1.i, Y1.i, X2.i, Y2.i, Color.q, Flags.i=#False)
    
    If Flags & #DPI
      X1 = dpiX(X1)
      Y1 = dpiY(Y1)
      X2 = dpiX(X2)
      Y2 = dpiY(Y2)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf

    _LineXY(X1, Y1, X2, Y2, Color)
    
  EndProcedure
  
  Procedure Font_(FontID.i, Size.i=#PB_Default, Flags.i=#False)
    
    If Flags & #DPI
      Size = dpiY(Size)
    EndIf
    
    If Size <= 0
      VectorFont(FontID)
    Else
      VectorFont(FontID, Size)
    EndIf

  EndProcedure
  
  Procedure LinesArc_(X1.d, Y1.d, X2.d, Y2.d, X3.d, Y3.d, Radius.i, Color.q, Flags.i=#False)
    
    If Flags & #DPI
      X1 = dpiX(X1)
      Y1 = dpiY(Y1)
      X2 = dpiX(X2)
      Y2 = dpiY(Y2)
      X3 = dpiX(X3)
      Y3 = dpiY(Y3)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    MovePathCursor(X1, Y1)
    AddPathArc(X2, Y2, X3, Y3, Radius)
    AddPathLine(X3, Y3)
    
    VectorSourceColor(Color)
    
    If Line\State And Line\Width > 0
      CustomDashPath(Line\Width, Line\Pattern(), Line\Flags, Line\Offset)
    Else
      StrokePath(Stroke)
    EndIf  

  EndProcedure
  
  Procedure TangentsArc_(X1.i, Y1.i, X2.i, Y2.i, X3.i, Y3.i, X4.i, Y4.i, Color.q, Flags.i=#False)
    Define.i Angle
    Define   isP.XY_Structure
    
    If Flags & #DPI
      X1 = dpiX(X1)
      Y1 = dpiY(Y1)
      X2 = dpiX(X2)
      Y2 = dpiY(Y2)
      X3 = dpiX(X3)
      Y3 = dpiY(Y3)
      X4 = dpiX(X4)
      Y4 = dpiY(Y4)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    Angle = FindArcFromTangents(X1, Y1, X2, Y2, X3, Y3, X4, Y4, @isP)
    
    MovePathCursor(X1, Y1)
    AddPathLine(X2, Y2)
    AddPathArc(isP\X, isP\Y, X3, Y3, Angle)
    AddPathLine(X4, Y4)

    VectorSourceColor(Color)
    
    If Line\State And Line\Width > 0
      CustomDashPath(Line\Width, Line\Pattern(), Line\Flags, Line\Offset)
    Else
      StrokePath(Stroke)
    EndIf  
    
  EndProcedure
  
  Procedure Text_(X.i, Y.i, Text$, Color.q, Rotate.i=0, Flags.i=#False)
    
    If Flags & #DPI
      X = dpiX(X)
      Y = dpiY(Y)
    EndIf
    
    If Alpha(Color) = #False : Color = RGBA(Red(Color), Green(Color), Blue(Color), 255) : EndIf
    
    If Rotate : RotateCoordinates(X, Y, Rotate) : EndIf
    
    MovePathCursor(X, Y)
    VectorSourceColor(Color)
    DrawVectorText(Text$)

    If Rotate : RotateCoordinates(X, Y, -Rotate) : EndIf
    
  EndProcedure
  
  Procedure.f TextWidth_(Text.s, Flags.i=#PB_VectorText_Default)
    
    ProcedureReturn VectorTextWidth(Text, Flags)

  EndProcedure
  
  Procedure.f TextHeight_(Text.s, Flags.i=#PB_VectorText_Default)
    
    ProcedureReturn VectorTextHeight(Text, Flags)
    
  EndProcedure
  
  Procedure   SetDotPattern(LineWidth.d, Array Pattern.d(1), Flags.i=#False, StartOffset.d=0)
    
    If Flags & #DPI
      Line\Width = dpiX(LineWidth)
      Flags & ~#DPI
    Else
      Line\Width = LineWidth
    EndIf 
    
    CopyArray(Pattern(), Line\Pattern())
    
    Line\Flags     = Flags
    Line\Offset    = StartOffset
    
    If LineWidth
      Line\State = #True
    Else
      Line\State = #False
    EndIf
    
  EndProcedure
  
  Procedure   SetStroke_(LineWidth.d=1)
    Stroke = LineWidth
  EndProcedure
  
  Procedure.i StartVector_(PB_Num.i, Type.i=#Canvas, Unit.i=#PB_Unit_Pixel) 
    
    Stroke = 1
    
    Select Type
      Case #Canvas
        ProcedureReturn StartVectorDrawing(CanvasVectorOutput(PB_Num, Unit))
      Case #Image
        ProcedureReturn StartVectorDrawing(ImageVectorOutput(PB_Num, Unit))
      Case #Window
        ProcedureReturn StartVectorDrawing(WindowVectorOutput(PB_Num, Unit))
      Case #Printer
        ProcedureReturn StartVectorDrawing(PrinterVectorOutput(Unit))
    EndSelect

  EndProcedure
  
  Procedure   StopVector_() 
    
    Stroke = #False
    StopVectorDrawing()

  EndProcedure
  
  
EndModule

;- ========  Module - Example ========

CompilerIf #PB_Compiler_IsMainFile
  
  #Window = 0
  #Gadget = 1
  #Font   = 2
  
  LoadFont(#Font, "Arial", 16, #PB_Font_Bold)
  
  Dim Pattern.d(3)
  
  Pattern(0) = 0
  Pattern(1) = 5
  Pattern(2) = 6
  Pattern(3) = 5
  
  If OpenWindow(#Window, 0, 0, 200, 200, "VectorDrawing Example", #PB_Window_SystemMenu|#PB_Window_Tool|#PB_Window_ScreenCentered)
    
    CanvasGadget(#Gadget, 10, 10, 180, 180)

    If Draw::StartVector_(#Gadget, Draw::#Canvas)
      
      Draw::Font_(FontID(#Font))
      
      Draw::Box_(2, 2, 176, 176, $CD0000, $FACE87, $FFF8F0, 0, Draw::#DPI) ; Draw::#Horizontal / Draw::#Diagonal
      Draw::Text_(65, 65, "Text", $701919, #False, Draw::#DPI)
      
      ;Draw::SetDotPattern(2, Pattern())
      
      Draw::CircleSector_(90, 90, 70, 40, 90, $800000, $00D7FF, $008CFF, Draw::#DPI)
      Draw::SetStroke_(2)
      Draw::LineXY_(90, 90, 90 + 80 * Cos(Radian(150)), 90 + 80 * Sin(Radian(150)), $228B22, Draw::#DPI)
      Draw::Circle_(90, 90, 80, $800000, #PB_Default, #PB_Default, Draw::#DPI)
      ;Draw::Ellipse_(90, 90, 80, 60, $800000, $FACE87, $FFF8F0, 30, Draw::#DPI)
      Draw::SetStroke_(4)
      Draw::EllipseArc_(90, 90, 70, 45, 160, 240, $CC3299, Draw::#DPI)
      Draw::SetStroke_(1)
      Draw::CircleArc_(90, 90, 70, 250, 340, $008CFF, Draw::#DPI)
      
      ;Draw::DisableDotPattern(#True)
      
      Draw::Line_(10, 90, 160, 1, $8515C7, Draw::#DPI)
      
      Draw::StopVector_()
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
    
  EndIf

  
CompilerEndIf  
; IDE Options = PureBasic 5.71 LTS (Windows - x64)
; CursorPosition = 13
; FirstLine = 3
; Folding = MC-BD5
; EnableXP
; DPIAware