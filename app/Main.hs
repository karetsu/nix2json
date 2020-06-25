{-# LANGUAGE FlexibleContexts #-}
module Main where

-- Libraries --------------------------------------------------------------------
import           System.Environment             ( getArgs )
import           Text.Regex.PCRE
import           Data.List.Split                ( splitOn )
import           Control.Lens


-- Functions --------------------------------------------------------------------
nix2json :: Char -> Char
nix2json '=' = ':'
nix2json ';' = ','
nix2json x   = x


removeComments :: String -> String
removeComments s = s =~ "(.* = .*;|\\{|\\})" :: String


basename :: String -> String
basename = head . splitOn "."


keyFix :: String -> String
keyFix s = (unwords . map key . words) s
 where
  key s' = case head s' of
    '\"'      -> s'
    '='       -> s'
    '{'       -> s'
    '}'       -> s'
    otherwise -> concat ["\"", s', "\""]


fixLastEntry :: [String] -> [String]
fixLastEntry s = over (element (length s - 2)) init s


-- Main -------------------------------------------------------------------------
main :: IO ()
main = do
  args  <- getArgs
  theme <- readFile $ head args  -- cba dealing with multiple args
  let conversion =
        map nix2json
          . unlines
          . fixLastEntry
          . map (keyFix . removeComments)
          . lines
          $ theme
  let output = concat
        [ "/home/aloysius/.themes/x/"
        , basename . last . splitOn "/" . head $ args
        ]

  writeFile output conversion

  print ">>>  conversion complete"
