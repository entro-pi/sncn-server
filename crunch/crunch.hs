module Main where

import Graphics.UI.Gtk

where Main = do
	initGUI

	builder <- builderNew
	builderAddFromFile builder "server.glade"
	window <- builderGetObject builder castToWindow "mainwindow"
	exitbutton <- builderGetObject builder castToButton "b2"

	on exitButton buttonActivated $ do
					putStrLn "Button Pressed"
					objectDestroy window
	widgetShowAll window

