Copyright 2009 Jake Wheat

The annotation data types and utilities for working with them.

Annotations are used to store source positions, types, errors,
warnings, environment deltas, information, and other stuff a client might
want to use when looking at an ast. Internal annotations which are
used in the type-checking/ annotation process use the attribute
grammar code and aren't exposed.

> {-# LANGUAGE ExistentialQuantification, DeriveDataTypeable #-}
> {-# OPTIONS_HADDOCK hide #-}

> module Database.HsSqlPpp.TypeChecking.AstAnnotation
>     (
>      Annotated(..)
>     ,Annotation
>     ,AnnotationElement(..)
>     ,stripAnnotations
>     ,getTopLevelTypes
>     ,getTopLevelInfos
>     ,getTopLevelEnvUpdates
>     ,getTypeAnnotation
>     --,getTypeErrors
>     ,pack
>     ,StatementInfo(..)
>     ,getSIAnnotation
>     ) where

> import Data.Generics

> import Database.HsSqlPpp.TypeChecking.TypeType
> import Database.HsSqlPpp.TypeChecking.EnvironmentInternal

> -- | Annotation type - one of these is attached to most of the
> -- data types used in the ast.
> type Annotation = [AnnotationElement]

> -- | the elements of an annotation. Source positions are generated by
> -- the parser, the rest come from the separate ast annotation process.
> data AnnotationElement = SourcePos String Int Int
>                        | TypeAnnotation Type
>                        | TypeErrorA TypeError
>                        | StatementInfoA StatementInfo
>                        | EnvUpdates [EnvironmentUpdate]
>                          deriving (Eq, Show,Typeable,Data)

> class Annotated a where
>     ann :: a -> Annotation
>     setAnn :: a -> Annotation -> a
>     changeAnn :: a -> (Annotation -> Annotation) -> a
>     changeAnn a = setAnn a . ($ ann a)
>     changeAnnRecurse :: (Annotation -> Annotation) -> a -> a
>     getAnnChildren :: a -> [Annotatable]

> data Annotatable = forall a . (Annotated a, Show a) => MkAnnotatable a

> instance Show Annotatable
>   where
>   showsPrec p (MkAnnotatable a) = showsPrec p a

> pack :: (Annotated a, Show a) => a -> Annotatable
> pack = MkAnnotatable

hack job, often not interested in the source positions when testing
the asts produced, so this function will reset all the source
positions to empty ("", 0, 0) so we can compare them for equality, etc.
without having to get the positions correct.

> -- | strip all the annotations from a tree. E.g. can be used to compare
> -- two asts are the same, ignoring any source position annotation differences.

> stripAnnotations :: Annotated a => a -> a
> stripAnnotations = changeAnnRecurse (const [])

 > stripAnnotations :: Statement -> Statement
 > stripAnnotations = everywhere (mkT (stripAnn))

 > stripAnn :: [Annotation] -> [Annotation]
 > incS (S s) = S (s * (1+k))




> -- | run through the ast, and pull the type annotation from each
> -- of the top level items.
> getTopLevelTypes :: Annotated a =>
>                     [a] -- ^ the ast items
>                  -> [Type] -- ^ the type annotations, this list should be the same
>                            -- length as the argument
> getTopLevelTypes = map getTypeAnnotation

> getTypeAnnotation :: Annotated a => a  -> Type
> getTypeAnnotation at = let as = ann at
>                        in gta as
>                        where
>                          gta (x:xs) = case x of
>                                         TypeAnnotation t -> t
>                                         _ -> gta xs
>                          gta _ = TypeCheckFailed -- error "couldn't find type annotation"

> getSIAnnotation :: Annotated a => a  -> Maybe StatementInfo
> getSIAnnotation at = let as = ann at
>                        in gta as
>                        where
>                          gta (x:xs) = case x of
>                                         StatementInfoA t -> Just t
>                                         _ -> gta xs
>                          gta _ = Nothing

> getEuAnnotation :: Annotated a => a  -> [EnvironmentUpdate]
> getEuAnnotation at = let as = ann at
>                        in gta as
>                        where
>                          gta (x:xs) = case x of
>                                         EnvUpdates t -> t
>                                         _ -> gta xs
>                          gta _ = []


> -- | Run through the ast given and return a list of statementinfos
> -- from the top level items.
> getTopLevelInfos :: Annotated a =>
>                     [a] -- ^ the ast to check
>                  -> [Maybe StatementInfo]
> getTopLevelInfos = map getSIAnnotation

> getTopLevelEnvUpdates :: Annotated a =>
>                     [a] -- ^ the ast to check
>                  -> [[EnvironmentUpdate]]
> getTopLevelEnvUpdates = map getEuAnnotation


> data StatementInfo = DefaultStatementInfo Type
>                    | SelectInfo Type
>                    | InsertInfo String Type
>                    | UpdateInfo String Type
>                    | DeleteInfo String
>                      deriving (Eq,Show,Typeable,Data)

todo:
add environment deltas to statementinfo

question:
if a node has no source position e.g. the all in select all or select
   distinct may correspond to a token or may be synthesized as the
   default if neither all or distinct is present. Should this have the
   source position of where the token would have appeared, should it
   inherit it from its parent, should there be a separate ctor to
   represent a fake node with no source position?
