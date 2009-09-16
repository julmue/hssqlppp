Copyright 2009 Jake Wheat

This file contains some utility functions for working with types and
type checking.

> module Database.HsSqlPpp.TypeCheckingH where

> import Data.Maybe
> import Data.List
> import Debug.Trace
> import Data.Either

> import Database.HsSqlPpp.TypeType
> import Database.HsSqlPpp.Scope
> import Database.HsSqlPpp.AstUtils
> import Database.HsSqlPpp.TypeConversion


> checkEither :: [Either a b] -> Either a b
> checkEither ((Left e):_) = Left e
> checkEither (e:[]) = e
> checkEither (_:es) = checkEither es
> checkEither [] = error "empty list for checkEither"

> unsafeRight :: Either a b -> b
> unsafeRight (Right r) = r
> unsafeRight (Left _) = error "tried to get unsafe right on left"

================================================================================

= type check code

idea is to move these here from TypeChecking.ag if they get a bit big,
not very consistently applied at the moment.

> typeCheckFunCall :: Scope ->String -> [Type] -> Either TypeError Type
> typeCheckFunCall scope fnName argsType =
>     checkTypes argsType ret
>     where
>       ret = case fnName of

do the special cases first, some of these will use the variadic support
when it is done and no longer be special cases.

>           "!arrayCtor" -> case resolveResultSetType scope argsType of
>                             Left e -> Left e
>                             Right t -> Right $ ArrayType t
>           "!between" -> let f1 = lookupFn ">=" [argsType !! 0, argsType !! 1]
>                             f2 = lookupFn "<=" [argsType !! 0, argsType !! 2]
>                             f3 = lookupFn "!and" [unsafeRight f1,unsafeRight f2]
>                         in checkEither [f1,f2,f3]
>           "coalesce" -> resolveResultSetType scope argsType
>           "greatest" -> let t = resolveResultSetType scope argsType
>                             f1 = lookupFn ">=" [unsafeRight t,unsafeRight t]
>                         in checkEither [t, f1, t]
>           "least" -> let t :: Either TypeError Type
>                          t = resolveResultSetType scope argsType
>                          f1 = lookupFn "<=" [unsafeRight t,unsafeRight t]
>                      in checkEither [t, f1, t]
>           "!rowCtor" -> Right $ RowCtor argsType

special case the row comparison ops

>           _ | let isRowCtor t = case t of
>                                   RowCtor _ -> True
>                                   _ -> False
>               in fnName `elem` ["=", "<>", "<=", ">=", "<", ">"]
>                      && length argsType == 2
>                      && all isRowCtor argsType ->
>                 checkRowTypesMatch (head argsType) (head $ tail argsType)

>           s ->  lookupFn s argsType
>       lookupFn :: String -> [Type] -> Either TypeError Type
>       lookupFn s1 args = case findCallMatch scope
>                                 (if s1 == "u-" then "-" else s1) args of
>                                Left te -> Left te
>                                Right (_,_,r) -> Right r
>       checkRowTypesMatch (RowCtor t1s) (RowCtor t2s) =
>         if length t1s /= length t2s
>           then Left ValuesListsMustBeSameLength
>           else let ts = map (resolveResultSetType scope . (\(a,b) -> [a,b])) $ zip t1s t2s
>                in checkEither $ ts ++ [Right typeBool]
>       checkRowTypesMatch x y  =
>         error $ "internal error: checkRowTypesMatch called with " ++ show x ++ "," ++ show y


> typeCheckValuesExpr :: Scope -> [[Type]] -> Either TypeError Type
> typeCheckValuesExpr scope rowsTs =
>         let --convert into [[Type]]
>             --rowsTs = map unwrapTypeList rowsTs1
>             colNames = zipWith (++)
>                            (repeat "column")
>                            (map show [1..length $ head rowsTs])
>         in unionRelTypes scope rowsTs colNames

> typeCheckCombineSelect :: Scope -> Type -> Type -> Either TypeError Type
> typeCheckCombineSelect scope v1 v2 =
>     let colNames = map fst $ unwrapComposite $ unwrapSetOf v1
>     in unionRelTypes scope
>                   (map (map snd . unwrapComposite . unwrapSetOf) [v1,v2])
>                   colNames

> unionRelTypes :: Scope -> [[Type]] -> [String] -> Either TypeError Type
> unionRelTypes scope rowsTs colNames =
>   let lengths = map length rowsTs
>   in case () of
>              _ | null rowsTs ->
>                    Left NoRowsGivenForValues
>                | not (all (==head lengths) lengths) ->
>                    Left ValuesListsMustBeSameLength
>                | otherwise ->
>                    let colTypeLists = transpose rowsTs
>                        colTypes = map (resolveResultSetType scope ) colTypeLists
>                        ty = Right $ SetOfType $ UnnamedCompositeType $ zip colNames $ rights colTypes
>                    in checkEither $ colTypes ++ [ty]

================================================================================

= utils

lookup a composite type name, restricting it to only certain kinds of
composite type, returns the composite definition which you can get the
attributes out of which is a pair with the normal columns first, then
the system columns second

> getAttrs :: Scope -> [CompositeFlavour] -> String -> Maybe (CompositeDef, CompositeDef)
> getAttrs scope f n =
>   let a = find (\(nm,fl,_) -> fl `elem` f && nm == n)
>             (scopeAttrDefs scope)
>       b = find (\(nm,_,_) -> nm == n)
>             (scopeAttrSystemColumns scope)
>   in case (a,b) of
>      (Nothing,_) -> Nothing
>      (Just x,Nothing) -> Just (x, (n,TableComposite,UnnamedCompositeType []))
>      (Just x,Just y) -> Just (x,y)

combine two relvar types when being joined, pass in a using list and
it checks the types in the using list are compatible, and eliminates
duplicate columns of the attrs in the using list, returns the relvar
type of the joined tables.

> combineTableTypesWithUsingList :: Scope -> [String] -> Type -> Type -> Either TypeError Type
> combineTableTypesWithUsingList scope l t1c t2c =
>     --check t1 and t2 have l
>     let t1 = unwrapComposite t1c
>         t2 = unwrapComposite t2c
>         names1 = getNames t1
>         names2 = getNames t2
>         error1 = if not (contained l names1) ||
>                     not (contained l names2)
>                    then Just MissingJoinAttribute
>                    else Nothing
>         --check the types
>         joinColumnTypes = map (getColumnType t1 t2) l
>         nonJoinColumns =
>             let notJoin = (\(s,_) -> s `notElem` l)
>             in filter notJoin t1 ++ filter notJoin t2
>         checkColumns :: Either TypeError Type
>         checkColumns =
>           case catEither joinColumnTypes of
>             Left e -> Left e
>             Right cols -> Right (UnnamedCompositeType $ zip l cols ++ nonJoinColumns)

>     in case error1 of
>          Just e -> Left e
>          Nothing -> checkColumns
>     where
>       getNames :: [(String,Type)] -> [String]
>       getNames = map fst
>       contained l1 l2 = all (`elem` l2) l1
>       getColumnType :: [(String,Type)] -> [(String,Type)] -> String -> Either TypeError Type
>       getColumnType t1 t2 f =
>           let ct1 = getFieldType t1 f
>               ct2 = getFieldType t2 f
>           in resolveResultSetType scope [ct1,ct2]
>       getFieldType t f = snd $ fromJust $ find (\(s,_) -> s == f) t

> catEither :: [Either a b] -> Either a [b]
> catEither l =
>   catEither' l []
>   where
>     catEither' (Left a:_) _ = Left a
>     catEither' (Right b:es) bs = catEither' es (b:bs)
>     catEither' [] bs = Right $ reverse bs
