{--------------------------------------------------------------------------------
   Controls demo.
--------------------------------------------------------------------------------}
module Main where

import Graphics.UI.WX
import Graphics.UI.WXH -- ( textCtrlAppendText, (.+.), wxTE_MULTILINE, wxTE_LINEWRAP)

main :: IO ()
main
  = start gui

gui :: IO ()
gui
  = do -- main gui elements: frame, panel, text control, and the notebook
       f       <- frame [text := "Controls"]
       p       <- panel f []
       nb      <- notebook p []
       textlog <- textCtrl p WrapLine [enable := False]

       -- use text control as logger
       log  <- logTextCtrlCreate textlog
       logSetActiveTarget log
       logMessage "logging enabled"

       -- button page
       p1   <- panel  nb [text := "buttons"]
       ok   <- button p1 [text := "Ok", on command := logMessage "ok button pressed"]
       quit <- button p1 [text := "Quit", on command := close f]

       -- radio box page
       p2   <- panel  nb [text := "radio box"]
       let rlabels = map (\(i,s) -> (s,logMessage ("selected: index " ++ show i ++ ": text " ++ show s))) $
                     zip [0..] ["first", "second", "third"]
       r1   <- radioBox p2 Vertical rlabels   [text := "radio box"]
       r2   <- radioBox p2 Horizontal rlabels [tooltip := "radio group two"]
       rb1  <- button   p2 [text := "disable", on command ::= onEnable r1]

       -- choice
       p3   <- panel nb [text := "choice box"]
       let clabels = map (\s -> (s,logMessage ("selected: " ++ show s)))
                     ["noot","mies","aap"]
       c1   <- choice p3 False clabels [tooltip := "unsorted choices"]
       c2   <- choice p3 True  clabels [tooltip := "sorted choices"]
       cb1  <- button p3 [text := "disable", on command ::= onEnable c1]

       -- list box page
       p4   <- panel nb [text := "list box"]
       sl1  <- singleListBox p4 False clabels [tooltip := "unsorted single-selection listbox"]
       sl2  <- singleListBox p4 True  clabels [tooltip := "sorted listbox"]
       sc1  <- checkBox p4 [text := "enable the listbox", checked := True, on command := set sl1 [enable :~ not]]


       -- specify layout
       set f [layout :=
                container p $
                column 0
                 [ tabs nb
                    [container p1 $ margin 10 $ floatCentre $ row 5 [widget ok, widget quit]
                    ,container p2 $ margin 10 $ column 5 [ hstretch $ widget rb1
                                                         , row 0 [floatLeft $ widget r1
                                                                 ,floatRight $ widget r2]]
                    ,container p3 $ margin 10 $ column 5 [ hstretch $ widget cb1
                                                         , row 0 [floatLeft $ widget c1
                                                                 ,floatRight $ row 5 [label "sorted: ", widget c2]]]
                    ,container p4 $ margin 10 $ column 5 [ hstretch  $ widget sc1
                                                         , floatLeft $
                                                           row 0 [widget sl1, widget sl2]]
                    ]
                 , hfill $ widget textlog
                 ]
             , clientSize := sz 400 300 ]
       return ()

  where
    onEnable w b
      = do set w [enable :~ not]
           enabled <- get w enable
           set b [text := (if enabled then "disable" else "enable")]