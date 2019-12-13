
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Data.Maybe (fromJust)
import qualified Data.Text as T (unpack)
import Data.GI.Base.ManagedPtr (unsafeCastTo)
import Data.GI.Base.GError (gerrorMessage, GError(..))
import Control.Exception (catch)
import qualified GI.Gtk as Gtk (init, main)
import GI.Gdk
	(displayGetDefault)

import GI.Gtk
       (widgetShowAll, mainQuit, onWidgetDestroy, onButtonClicked, Button(..),
        Window(..),styleContextAddClass,cssProviderNew, styleContextAddProvider, cssProviderLoadFromPath, widgetGetStyleContext, builderGetObject, builderAddFromFile, builderNew)

main = (do
    Gtk.init Nothing

    -- Create the builder, and load the UI file
    builder <- builderNew
    builderAddFromFile builder "../../../src/server.glade"

    -- Retrieve some objects from the UI
    window <- builderGetObject builder "mainwindow" >>= unsafeCastTo Window . fromJust
    button <- builderGetObject builder "b1" >>= unsafeCastTo Button . fromJust

    -- Set the style provider
    display <- displayGetDefault
    provider <- cssProviderNew
    winStyle <- widgetGetStyleContext window
    cssProviderLoadFromPath provider "../../../src/design.css"
    styleContextAddProvider winStyle provider 0
    -- Basic user interation
    onButtonClicked button mainQuit
    onWidgetDestroy window mainQuit

    -- Display the window
    widgetShowAll window
    Gtk.main)
  `catch` (\(e::GError) -> gerrorMessage e >>= putStrLn . T.unpack)
