{-# LANGUAGE OverloadedStrings #-}

module Cyanide.UI.PurchaseDeletionScreen where

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
import qualified Cyanide.Data.Purchases as Purchases
import qualified Cyanide.Data.Postgres as Postgres

attrMap :: [(B.AttrName, Vty.Attr)]
attrMap = []

handleEvent :: CyanideState -> B.BrickEvent Name () -> B.EventM Name (B.Next CyanideState)
handleEvent s@(CyanideState conn (PurchaseDeletionScreen i ps rs mr l f)) (B.VtyEvent e) =
    case e of
        Vty.EvKey (Vty.KEsc) [] ->
            B.continue $ CyanideState conn (IngredientDetailScreen i ps rs mr l f)

        Vty.EvKey (Vty.KChar 'n') [] ->
            B.continue $ CyanideState conn (IngredientDetailScreen i ps rs mr l f)

        Vty.EvKey (Vty.KChar 'y') [] -> do
            let Just (j,purchase) = BL.listSelectedElement ps
                newList = BL.listRemove j ps
            liftIO $ Purchases.deletePurchase conn purchase
            B.continue $ CyanideState conn (IngredientDetailScreen i newList rs mr l f)

        _ -> B.continue s
handleEvent s _ = B.continue s

drawUI :: CyanideState -> [B.Widget Name]
drawUI (CyanideState conn (PurchaseDeletionScreen i ps _ _ _ _)) = [ui]
    where Just (_,(Types.Purchase t l p)) = BL.listSelectedElement ps
          ui = BC.center
               $ B.hLimit 80
               $ B.vLimit 25 $ B.vBox
                            [ BC.hCenter $ B.txt $ "Are you sure you want to delete the following purchase?"
                            , BC.hCenter
                                $ B.padAll 1
                                $ BB.borderWithLabel (B.txt "Purchase")
                                $ B.padAll 1
                                $ B.vBox
                                     [ addRow 12 "Name" [Types.ingredientName i]
                                     , addRow 12 "Timestamp" [T.pack $ show t]
                                     , addRow 12 "Location" [l]
                                     , addRow 12 "Amount" [formatMoney p]
                                     ]
                            , renderInstructions [ ("y","Yes")
                                                 , ("n","No")
                                                 ]
                            ]