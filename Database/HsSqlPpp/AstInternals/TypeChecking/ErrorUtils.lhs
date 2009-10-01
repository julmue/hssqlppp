Copyright 2009 Jake Wheat

This file contains a bunch of small low level utilities to help with
type checking.

> {-# OPTIONS_HADDOCK hide #-}

> module Database.HsSqlPpp.AstInternals.TypeChecking.ErrorUtils
>     (
>      chainTypeCheckFailed
>     ,ctcf
>     ,dependsOn
>     ,dependsOnTpe
>     ,dependsOnT
>     ,tpeToT
>     ,liftErrors
>     ,errorToTypeFail
>     ,errorToTypeFailF
>     ,checkErrorList
>     ,getErrors
>     ) where

> import Data.List

> import Database.HsSqlPpp.AstInternals.TypeType

================================================================================

= type checking utils

== checkErrors

if we find a typecheckfailed in the list, then propagate that, else
use the final argument.

> chainTypeCheckFailed :: [Type] -> Either a Type -> Either a Type
> chainTypeCheckFailed a b =
>   if any (==TypeCheckFailed) a
>     then Right TypeCheckFailed
>     else b

> ctcf :: [Type] -> Either a Type -> Either a Type
> ctcf = chainTypeCheckFailed

> dependsOn :: [Type] -> t -> t -> t
> dependsOn ts bad ok =
>   if any (==TypeCheckFailed) ts
>     then bad
>     else ok

> dependsOnTpe :: [Type] -> Either a Type -> Either a Type
> dependsOnTpe ts = dependsOn ts (Right TypeCheckFailed)

> dependsOnT :: [Type] -> Type -> Type
> dependsOnT ts = dependsOn ts TypeCheckFailed



convert an 'either [typeerror] type' to a type

> errorToTypeFail :: Either [TypeError] Type -> Type
> errorToTypeFail tpe = case tpe of
>                         Left _ -> TypeCheckFailed
>                         Right t -> t

> tpeToT :: Either [TypeError] Type -> Type
> tpeToT = errorToTypeFail

convert an 'either [typeerror] x' to a type, using an x->type function

> errorToTypeFailF :: (t -> Type) -> Either [TypeError] t -> Type
> errorToTypeFailF f tpe = case tpe of
>                                   Left _ -> TypeCheckFailed
>                                   Right t -> f t

used to pass a regular type on iff the list of errors is null

> checkErrorList :: [TypeError] -> Type -> Either [TypeError] Type
> checkErrorList es t = if null es
>                         then Right t
>                         else Left es

> liftErrors :: [TypeError] -> Either [TypeError] ()
> liftErrors es = if null es
>                   then Right ()
>                   else Left es


extract errors from an either, gives empty list if right

> getErrors :: Either [TypeError] Type -> [TypeError]
> getErrors = either id (const [])

