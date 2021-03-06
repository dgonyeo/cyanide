{-# LANGUAGE OverloadedStrings #-}

module Cyanide.UI.RecipeDeletionScreen where

import Lens.Micro ((^.))
import qualified Brick as B
import qualified Brick.Widgets.List as BL
import qualified Graphics.Vty as Vty
import qualified Data.Text as T
import qualified Data.Vector as V
import qualified Brick.Widgets.Center as BC
import qualified Brick.Widgets.Border as BB
import Data.Monoid
import Control.Monad.IO.Class

import Cyanide.UI.State
import Cyanide.UI.Util
import qualified Cyanide.Data.Types as Types
import qualified Cyanide.Data.Ingredients as Ingredients
import qualified Cyanide.Data.Recipes as Recipes
import qualified Cyanide.Data.Postgres as Postgres

attrMap :: [(B.AttrName, Vty.Attr)]
attrMap = []

handleEvent :: CyanideState -> B.BrickEvent Name () -> B.EventM Name (B.Next CyanideState)
handleEvent s@(CyanideState conn _ (RecipeDeletionScreen r prev)) (B.VtyEvent e) =
    case e of
        Vty.EvKey (Vty.KEsc) [] -> do
            newScr <- liftIO $ prev False
            B.continue $ s { stateScreen = newScr }

        Vty.EvKey (Vty.KChar 'n') [] -> do
            newScr <- liftIO $ prev False
            B.continue $ s { stateScreen = newScr }

        Vty.EvKey (Vty.KChar 'y') [] -> do
            newScr <- liftIO $ prev True
            liftIO $ Recipes.deleteRecipe conn r
            B.continue $ s { stateScreen = newScr }

        _ -> B.continue s
handleEvent s _ = B.continue s

drawUI :: CyanideState -> [B.Widget Name]
drawUI (CyanideState conn _ (RecipeDeletionScreen r _)) = [ui]
    where handleRecipeName (Right i) = "the recipe for " `T.append` Types.ingredientName i
          handleRecipeName (Left n) = n

          ui = B.vBox [ BC.hCenter $ B.txt "Are you sure you want to delete the following recipe?"
                      , BC.hCenter $ B.padAll 1 $ B.txt $ handleRecipeName (Types.recipeName r)
                      , renderInstructions [ ("y","Yes")
                                           , ("n","No")
                                           ]
                      ]
