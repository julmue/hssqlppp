#!/usr/bin/env runghc

Copyright 2009 Jake Wheat

================================================================================

Executable to parse sql from a file and run some attributizing on the ast

> import System

> import Parser
> import Ast

> main :: IO ()
> main = getArgs >>= mapM_ parseFile
>   where
>     parseFile f = do
>       putStrLn $ "parsing " ++ show f
>       x <- parseSqlFileWithState f
>       case x of
>            Left er -> print er
>            Right st -> do
>                mapM_ print st
>                putStrLn "\nchecking ast"
>                let y = checkAst st
>                print y
>       return ()
