

-- UUAGC 0.9.14 (AstInternal.ag)
module Database.HsSqlPpp.AstInternals.AstInternal(
    -- {-# LANGUAGE DeriveDataTypeable,RankNTypes,ScopedTypeVariables #-}
    --from the ag files:
    --ast nodes
    Statement (..)
   ,SelectExpression (..)
   ,WithQueryList
   ,WithQuery(..)
   ,FnBody (..)
   --,SetClause (..)
   ,TableRef (..)
   ,TableAlias(..)
   ,JoinExpression (..)
   ,JoinType (..)
   ,SelectList (..)
   ,SelectItem (..)
   ,CopySource (..)
   ,AttributeDef (..)
   ,RowConstraint (..)
   ,AlterTableAction(..)
   ,Constraint (..)
   ,TypeAttributeDef (..)
   ,ParamDef (..)
   ,VarDef (..)
   ,RaiseType (..)
   ,CombineType (..)
   ,Volatility (..)
   ,Language (..)
   ,TypeName (..)
   ,DropType (..)
   ,Cascade (..)
   ,Direction (..)
   ,Distinct (..)
   ,Natural (..)
   ,IfExists (..)
   ,Replace(..)
   ,RestartIdentity (..)
   ,Expression (..)
   ,FrameClause(..)
   ,InList (..)
   ,LiftFlavour(..)
   ,TriggerWhen(..)
   ,TriggerEvent(..)
   ,TriggerFire(..)
   ,StatementList
   ,ExpressionListStatementListPairList
   ,ExpressionListStatementListPair
   ,ExpressionList
   ,ParamDefList
   ,AttributeDefList
   ,ConstraintList
   ,TypeAttributeDefList
   ,TypeNameList
   ,StringTypeNameListPair
   ,StringTypeNameListPairList
   ,ExpressionStatementListPairList
   --,SetClauseList
   ,CaseExpressionListExpressionPairList
   ,MaybeExpression
   ,TableRefList
   ,ExpressionListList
   ,SelectItemList
   ,OnExpr
   ,RowConstraintList
   ,VarDefList
   ,ExpressionStatementListPair
   ,CaseExpressionListExpressionPair
   ,CaseExpressionList
   ,ExpressionDirectionPair
   ,ExpressionDirectionPairList
   ,MaybeBoolExpression
   ,MaybeSelectList
   ,SetValue(..)
   ,AlterTableActionList
   -- typechecking
   ,typeCheck
   ,typeCheckPS
   ,typeCheckExpression
) where

import Data.Maybe
import Data.List
import Debug.Trace
import Data.Either
import Control.Applicative
import Control.Arrow
import Data.Generics
import Data.Char
import Control.Monad.State

import Data.Generics.PlateData

import Database.HsSqlPpp.AstInternals.TypeType
import Database.HsSqlPpp.AstInternals.TypeChecking.TypeConversion
import Database.HsSqlPpp.AstInternals.AstAnnotation
import Database.HsSqlPpp.AstInternals.Catalog.CatalogInternal
import Database.HsSqlPpp.AstInternals.TypeChecking.LocalBindings
import Database.HsSqlPpp.Utils.Utils
import Database.HsSqlPpp.AstInternals.TypeChecking.ErrorUtils


{-# LINE 363 "AstInternal.ag" #-}

data TableAlias = NoAlias
                | TableAlias String --alias:String
                | FullAlias String [String] -- alias:String cols:{[String]}
                  deriving (Show,Eq,Typeable,Data)
{-# LINE 112 "AstInternal.hs" #-}

{-# LINE 373 "AstInternal.ag" #-}

data JoinType = Inner | LeftOuter| RightOuter | FullOuter | Cross
                deriving (Show,Eq,Typeable,Data)
{-# LINE 118 "AstInternal.hs" #-}

{-# LINE 385 "AstInternal.ag" #-}

data CopySource = CopyFilename String
                | Stdin
                  deriving (Show,Eq,Typeable,Data)
{-# LINE 125 "AstInternal.hs" #-}

{-# LINE 434 "AstInternal.ag" #-}

data SetValue
    = SetStr Annotation String
    | SetId Annotation String
    | SetNum Annotation Double
      deriving (Show,Eq,Typeable,Data)


data TriggerWhen = TriggerBefore | TriggerAfter
                   deriving (Show,Eq,Typeable,Data)
data TriggerEvent = TInsert| TUpdate | TDelete
                    deriving (Show,Eq,Typeable,Data)
data TriggerFire = EachRow | EachStatement
                   deriving (Show,Eq,Typeable,Data)
{-# LINE 142 "AstInternal.hs" #-}

{-# LINE 457 "AstInternal.ag" #-}

data RaiseType = RNotice | RException | RError
                 deriving (Show,Eq,Typeable,Data)

data CombineType = Except | Union | Intersect | UnionAll
                   deriving (Show,Eq,Typeable,Data)

data Volatility = Volatile | Stable | Immutable
                  deriving (Show,Eq,Typeable,Data)

data Language = Sql | Plpgsql
                deriving (Show,Eq,Typeable,Data)
{-# LINE 157 "AstInternal.hs" #-}

{-# LINE 475 "AstInternal.ag" #-}

data DropType = Table
              | Domain
              | View
              | Type
                deriving (Show,Eq,Typeable,Data)

data Cascade = Cascade | Restrict
               deriving (Show,Eq,Typeable,Data)

data Direction = Asc | Desc
                 deriving (Show,Eq,Typeable,Data)

data Distinct = Distinct | Dupes
                deriving (Show,Eq,Typeable,Data)

data Natural = Natural | Unnatural
               deriving (Show,Eq,Typeable,Data)

data IfExists = Require | IfExists
                deriving (Show,Eq,Typeable,Data)

data Replace = Replace | NoReplace
               deriving (Show,Eq,Typeable,Data)

data RestartIdentity = RestartIdentity | ContinueIdentity
                       deriving (Show,Eq,Typeable,Data)
{-# LINE 187 "AstInternal.hs" #-}

{-# LINE 555 "AstInternal.ag" #-}

data LiftFlavour = LiftAny | LiftAll
                   deriving (Show,Eq,Typeable,Data)
{-# LINE 193 "AstInternal.hs" #-}

{-# LINE 564 "AstInternal.ag" #-}

data FrameClause = FrameUnboundedPreceding
                 | FrameUnboundedFull
                 | FrameRowsUnboundedPreceding
                   deriving (Show,Eq,Typeable,Data)
{-# LINE 201 "AstInternal.hs" #-}

{-# LINE 732 "AstInternal.ag" #-}

{-
-- | Type check multiple asts, allowing type checking references in
--   later files to definitions in earlier files. This is probably
--   more straightforward if you parse the files then concatenate the
--   statementlists together before type checking rather than using
--   this function
typeCheckMany :: Catalog -> [StatementList] -> [StatementList]
typeCheckMany cat sts =
    annInt cat sts []
    where
      annInt e (s:ss) ress =
          let (e1,res) = typeCheck e s
          in annInt e1 ss (res:ress)
      annInt _ [] ress = reverse ress
-}

-- | Takes an ast, checks against catalog passed, and adds
--   annotations, including types, type errors, and statement info.
--   Returns the updated catalog as well as the annotated ast.
typeCheck :: Catalog -> StatementList -> (Catalog,StatementList)
typeCheck cat sts =
    let t = sem_Root (Root (fixupImplicitJoins sts))
        ta = wrap_Root t Inh_Root {cat_Inh_Root = cat
                                  ,lib_Inh_Root = emptyBindings}
        tl = annotatedTree_Syn_Root ta
        cat1 = producedCat_Syn_Root ta
    in case tl of
         Root r -> (cat1,r)

-- | Unfinished version of type check which can type check an
-- individual statement with ? or positional arg placeholders in
-- it. Will error if the statement isn't select, update, insert or
-- delete. For use in type checking embedded parameterized
-- statements. Does all typechecking and annotation that the regular
-- typecheck does.
typeCheckPS :: Catalog -> Statement -> Either String Statement
typeCheckPS cat st =
    case st of
      SelectStatement _ _ -> tc
      Insert _ _ _ _ _ -> tc
      Update _ _ _ _ _ _ -> tc
      Delete _ _ _ _ _ -> tc
      _ -> Left "requires select, update, insert or delete statement"
    where
      tc = let t = sem_Root (Root (fixupImplicitJoins [st]))
               ta = wrap_Root t Inh_Root {cat_Inh_Root = cat
                                         ,lib_Inh_Root = emptyBindings}
               tl = annotatedTree_Syn_Root ta
               --cat1 = producedCat_Syn_Root ta
           in case tl of
                Root [st1] -> Right st1
                _ -> error "impossible happened in typeCheckPS!"


-- | Testing utility, mainly used to check an expression for type errors
-- or to get its type.
typeCheckExpression :: Catalog -> Expression -> Expression
typeCheckExpression cat ex =
    let t = sem_ExpressionRoot (ExpressionRoot (fixupImplicitJoins ex))
        rt = (annotatedTree_Syn_ExpressionRoot
              (wrap_ExpressionRoot t Inh_ExpressionRoot {cat_Inh_ExpressionRoot = cat
                                                        ,lib_Inh_ExpressionRoot = emptyBindings}))
    in case rt of
         ExpressionRoot e -> e

{-
bit of a hack, to avoid rewriting the tableref type checking to be
able to do implicit joins, we just convert them in to the equivalent
explicit join
-}

fixupImplicitJoins :: Data a => a -> a
fixupImplicitJoins =
    transformBi $ \x ->
            case x of
              -- alter asts to change implicit joins into explicit joins
              Select an dis sl trs@(_:_:_) whr grp hav od lim off
                  -> Select an dis sl [convTrefs trs] whr grp hav od lim off
              x1 -> x1
    where
      convTrefs (tr:tr1:trs) = JoinedTref emptyAnnotation tr Unnatural Cross (convTrefs (tr1:trs)) Nothing NoAlias
      convTrefs (tr:[]) = tr
      convTrefs _ = error "failed doing implicit join fixup hack"

{-# LINE 289 "AstInternal.hs" #-}

{-# LINE 76 "./TypeChecking/Misc.ag" #-}

{-
================================================================================

= some small utils

I think this should be alright, an identifier referenced in an
expression can only have zero or one dot in it.
-}

splitIdentifier :: String -> (String,String)
splitIdentifier s = let (a,b) = span (/= '.') s
                    in if b == ""
                         then ("", a)
                         else (a,tail b)

addTypeErrors :: Data a => [TypeError] -> a -> a
addTypeErrors es el = updateAnnotation u el
                      where
                        u a = a {errs = errs a ++ es}

setTypeAddErrors :: Data a => Et -> a -> a
setTypeAddErrors et el = updateAnnotation (setTypeAddErrorsA et) el

setTypeAddErrorsA :: Et -> Annotation -> Annotation
setTypeAddErrorsA et a =
    let a1 = a {errs = errs a ++ tes et}
    in case atype a1 of
         Just _ -> a1 {errs = errs a
                             ++ [InternalError $ "tried to set type a second time - " ++ show (etmt et)]}
         Nothing -> a1 {atype = etmt et}

keepValid :: [(String,Maybe Type)] -> [(String,Type)]
keepValid = mapMaybe f
            where
              f (a,Just b) = Just (a,b)
              f (_,Nothing) = Nothing

allJust :: [Maybe a] -> Maybe [a]
allJust ts = sequence ts

{-
================================================================================

proper dodgy:
1st pass is to add inferred types to the tree. This is done only for
expressions in a funcall argument list atm. Then we pull out the
placeholders after they've had this information added. Only the
placeholders in funcall argument lists will have their type inferred
in this way, to be expanded. Insert also does this currently, but in Dml.ag

This should probably be done during the typechecking phase instead,
but probably needs a proper type inferencing algorithm to be used, is
done like this for development expediency.

-}
getPlaceholders :: Data a => a -> [Expression]
getPlaceholders st =
    filter isPlaceholder $ everything (++) (mkQ [] ga) (setInferredTypes st)
    where
      ga :: Expression -> [Expression]
      ga s = [s]
      isPlaceholder e = case e of
                          PositionalArg _ _ -> True
                          Placeholder _ -> True
                          _ -> False

getPlaceholderTypes :: Data a => a -> [Maybe Type]
getPlaceholderTypes ex = map (infType . getAnnotation) $ getPlaceholders ex


setInferredTypes :: Data a => a -> a
setInferredTypes =
  transformBi $ \x ->
    case x of
      FunCall an op exprs -> FunCall an op (addInferredTypes an exprs)
      x1 -> x1
  where
    addInferredTypes :: Annotation -> [Expression] -> [Expression]
    addInferredTypes an exprs =
           let args :: [Maybe Type]
               args = map Just $ maybe [] (\(_,a,_,_) -> a) $ fnProt an
           in map setInfType $ zip (args ++ repeat Nothing) exprs
           where
             setInfType :: (Maybe Type,Expression) -> Expression
             setInfType (t,a) = updateAnnotation (\i -> i {infType = t}) a

{-# LINE 379 "AstInternal.hs" #-}

{-# LINE 104 "./TypeChecking/Expressions.ag" #-}

{-

small shim in front of findCallMatch in the type conversion code, to
handle some special cases.

Some of the special cases will no longer be needed when variadic
support is added.

between, greatest and least are treated as syntactic sugar so we
delegate the function lookups to the <=/>= operators.

the row comparison should be more general than this, since it supports
any operator satisfying some properties


TODO: move all of this into find call match. Don't know why it's separate
-}
typeCheckFunCall :: Catalog -> String -> [Type] -> Either [TypeError] FunctionPrototype
typeCheckFunCall cat fnName' argsType =
    {-trace ("typecheckfncall " ++ fnName' ++ show argsType) $-}
    --dependsOnRTpe argsType $
      case fnName of
              "count" -> -- not quite sure how this is suppose to work,
                         -- the counts in the pg catalog accept either
                         -- no args, or one arg of type any, but you can call
                         -- count with multiple arguments?
                         return ("count", argsType, typeBigInt, False)
              "!between" -> do
                    f1 <- lookupReturnType ">=" [argsType !! 0, argsType !! 1]
                    f2 <- lookupReturnType "<=" [argsType !! 0, argsType !! 2]
                    lookupFn "!and" [f1,f2]
              "greatest" -> do
                    fp@(_,_,t,_) <- lookupFn fnName argsType
                    _ <- lookupFn ">=" [t,t]
                    return fp
              "least" -> do
                    fp@(_,_,t,_) <- lookupFn fnName argsType
                    _ <- lookupFn "<=" [t,t]
                    return fp
              "!rowctor" -> return $ ("!rowCtor", argsType, AnonymousRecordType argsType, False)
                    -- special case the row comparison ops
                    -- this needs to be fixed: we want to match
                    -- any implicit casts to functions on composite types
                    -- first, then we can use the anonymous record type on
                    -- any composite
              _ | fnName `elem` ["=", "<>", "<=", ">=", "<", ">"]
                         && length argsType == 2
                         && all isCompositeOrSetOfCompositeType argsType
                         && compositesCompatible cat (head argsType) (head $ tail argsType) -> return (fnName, argsType, typeBool, False)
              --checked for all special cases, so run general case now
              s -> lookupFn s argsType
    where
      lookupReturnType :: String -> [Type] -> Either [TypeError] Type
      lookupReturnType s1 args = fmap (\(_,_,r,_) -> r) $ lookupFn s1 args
      lookupFn :: String -> [Type] -> Either [TypeError] FunctionPrototype
      lookupFn s1 args = findCallMatch cat
                             (if s1 == "u-" then "-" else s1) args
      fnName = map toLower fnName'
{-# LINE 441 "AstInternal.hs" #-}

{-# LINE 147 "./TypeChecking/SelectStatement.ag" #-}


typeCheckValuesExpr :: Catalog -> [[Maybe Type]] -> Either [TypeError] Type
typeCheckValuesExpr cat rowsTs = do
        rts <- lmt $ allJust $ map allJust rowsTs
        let colNames = zipWith (++)
                           (repeat "column")
                           (map show [1..length $ head rowsTs])
        unionRelTypes cat rts colNames


typeCheckCombineSelect :: Catalog -> Type -> Type -> Either [TypeError] Type
typeCheckCombineSelect cat v1 v2 = do
    u1 <- unwrapSetOfComposite v1
    let colNames = map fst u1
    u2 <- unwrapSetOfComposite v2
    let colTypes1 = map snd u1
    let colTypes2 = map snd u2
    unionRelTypes cat [colTypes1,colTypes2] colNames

unionRelTypes :: Catalog -> [[Type]] -> [String] -> Either [TypeError] Type
unionRelTypes cat rowsTs colNames =
  let lengths = map length rowsTs
  in case () of
             _ | null rowsTs ->
                   Left [NoRowsGivenForValues]
               | not (all (==head lengths) lengths) ->
                   Left [ValuesListsMustBeSameLength]
               | otherwise ->
                   --i don't think this propagates all the errors, just the first set
                   mapM (resolveResultSetType cat) (transpose rowsTs) >>=
                     (return . SetOfType . CompositeType . zip colNames)

{-# LINE 477 "AstInternal.hs" #-}

{-# LINE 209 "./TypeChecking/TableRefs.ag" #-}




{-
convert a function call into a [String,[(string,type)]] list for use
in a tableref context
first consideration is the alias: if there is an alias in the select,
e.g. select * from generate_series(1,2) x;  (alias is x)
we use that, otherwise we use the name of the function
second consideration is the attributes coming out, roughly speaking
we have to convert an arbitrary type to a relation type
if we have a relation valued function, we don't need to do anything
if we have a setof non composite, we lift the single type to an
attribute, using the function name for the attribute name
if we have a non setof, we lift the single type to an attribute and
then relation, using the function name for the attribute name
need to check to see what should happen with arrayof

-}
funIdens :: Catalog -> String -> Expression -> Either [TypeError] (String,[(String,Type)])
funIdens cat alias fnVal = do
   errorWhen (case fnVal of
                FunCall _ _ _ -> False
                _ -> True)
             [ContextError "FunCall"]
   let (FunCall _ fnName _) = fnVal
       cn = if alias /= ""
                           then alias
                           else fnName
   attrs <- do
     fnt <- lmt $ getTypeAnnotation fnVal
     case fnt of
       SetOfType (NamedCompositeType t) -> catCompositePublicAttrs cat [] t
       SetOfType x -> return [(cn,x)]
       y -> return [(cn,y)]
   return (cn, attrs)

getAlias :: String -> TableAlias -> String
getAlias def alias =
  case alias of
    NoAlias -> def
    TableAlias t -> t
    FullAlias t _ -> t

{-# LINE 525 "AstInternal.hs" #-}

{-# LINE 18 "./TypeChecking/SelectLists.ag" #-}

{-data SiType = SiType (String,Maybe Type)
            | SiStarType [(String,Maybe Type)]-}
{-# LINE 531 "AstInternal.hs" #-}

{-# LINE 51 "./TypeChecking/CreateTable.ag" #-}

defaultSystemColumns :: [(String,Type)]
defaultSystemColumns = [("tableoid", ScalarType "oid")
                       ,("cmax", ScalarType "cid")
                       ,("xmax", ScalarType "xid")
                       ,("cmin", ScalarType "cid")
                       ,("xmin", ScalarType "xid")
                       ,("ctid", ScalarType "tid")]
{-# LINE 542 "AstInternal.hs" #-}

{-# LINE 31 "./TypeChecking/CreateFunction.ag" #-}

data ParamName = NamedParam Int String
               | UnnamedParam Int
{-# LINE 548 "AstInternal.hs" #-}
-- AlterTableAction --------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative AddConstraint:
         child ann            : {Annotation}
         child con            : Constraint 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative AlterColumnDefault:
         child ann            : {Annotation}
         child nm             : {String}
         child def            : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data AlterTableAction  = AddConstraint (Annotation) (Constraint) 
                       | AlterColumnDefault (Annotation) (String) (Expression) 
                       deriving ( Data,Eq,Show,Typeable)
-- cata
sem_AlterTableAction :: AlterTableAction  ->
                        T_AlterTableAction 
sem_AlterTableAction (AddConstraint _ann _con )  =
    (sem_AlterTableAction_AddConstraint _ann (sem_Constraint _con ) )
sem_AlterTableAction (AlterColumnDefault _ann _nm _def )  =
    (sem_AlterTableAction_AlterColumnDefault _ann _nm (sem_Expression _def ) )
-- semantic domain
type T_AlterTableAction  = Catalog ->
                           LocalBindings ->
                           ( AlterTableAction,AlterTableAction)
data Inh_AlterTableAction  = Inh_AlterTableAction {cat_Inh_AlterTableAction :: Catalog,lib_Inh_AlterTableAction :: LocalBindings}
data Syn_AlterTableAction  = Syn_AlterTableAction {annotatedTree_Syn_AlterTableAction :: AlterTableAction,originalTree_Syn_AlterTableAction :: AlterTableAction}
wrap_AlterTableAction :: T_AlterTableAction  ->
                         Inh_AlterTableAction  ->
                         Syn_AlterTableAction 
wrap_AlterTableAction sem (Inh_AlterTableAction _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_AlterTableAction _lhsOannotatedTree _lhsOoriginalTree ))
sem_AlterTableAction_AddConstraint :: Annotation ->
                                      T_Constraint  ->
                                      T_AlterTableAction 
sem_AlterTableAction_AddConstraint ann_ con_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: AlterTableAction
              _lhsOoriginalTree :: AlterTableAction
              _conOcat :: Catalog
              _conOlib :: LocalBindings
              _conIannotatedTree :: Constraint
              _conIoriginalTree :: Constraint
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  AddConstraint ann_ _conIannotatedTree
                  {-# LINE 612 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  AddConstraint ann_ _conIoriginalTree
                  {-# LINE 617 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 622 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 627 "AstInternal.hs" #-}
              -- copy rule (down)
              _conOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 632 "AstInternal.hs" #-}
              -- copy rule (down)
              _conOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 637 "AstInternal.hs" #-}
              ( _conIannotatedTree,_conIoriginalTree) =
                  (con_ _conOcat _conOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_AlterTableAction_AlterColumnDefault :: Annotation ->
                                           String ->
                                           T_Expression  ->
                                           T_AlterTableAction 
sem_AlterTableAction_AlterColumnDefault ann_ nm_ def_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: AlterTableAction
              _lhsOoriginalTree :: AlterTableAction
              _defOcat :: Catalog
              _defOlib :: LocalBindings
              _defIannotatedTree :: Expression
              _defIntAnnotatedTree :: Expression
              _defIntType :: ([(String,Type)])
              _defIoriginalTree :: Expression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  AlterColumnDefault ann_ nm_ _defIannotatedTree
                  {-# LINE 660 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  AlterColumnDefault ann_ nm_ _defIoriginalTree
                  {-# LINE 665 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 670 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 675 "AstInternal.hs" #-}
              -- copy rule (down)
              _defOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 680 "AstInternal.hs" #-}
              -- copy rule (down)
              _defOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 685 "AstInternal.hs" #-}
              ( _defIannotatedTree,_defIntAnnotatedTree,_defIntType,_defIoriginalTree) =
                  (def_ _defOcat _defOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- AlterTableActionList ----------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : AlterTableAction 
         child tl             : AlterTableActionList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type AlterTableActionList  = [(AlterTableAction)]
-- cata
sem_AlterTableActionList :: AlterTableActionList  ->
                            T_AlterTableActionList 
sem_AlterTableActionList list  =
    (Prelude.foldr sem_AlterTableActionList_Cons sem_AlterTableActionList_Nil (Prelude.map sem_AlterTableAction list) )
-- semantic domain
type T_AlterTableActionList  = Catalog ->
                               LocalBindings ->
                               ( AlterTableActionList,AlterTableActionList)
data Inh_AlterTableActionList  = Inh_AlterTableActionList {cat_Inh_AlterTableActionList :: Catalog,lib_Inh_AlterTableActionList :: LocalBindings}
data Syn_AlterTableActionList  = Syn_AlterTableActionList {annotatedTree_Syn_AlterTableActionList :: AlterTableActionList,originalTree_Syn_AlterTableActionList :: AlterTableActionList}
wrap_AlterTableActionList :: T_AlterTableActionList  ->
                             Inh_AlterTableActionList  ->
                             Syn_AlterTableActionList 
wrap_AlterTableActionList sem (Inh_AlterTableActionList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_AlterTableActionList _lhsOannotatedTree _lhsOoriginalTree ))
sem_AlterTableActionList_Cons :: T_AlterTableAction  ->
                                 T_AlterTableActionList  ->
                                 T_AlterTableActionList 
sem_AlterTableActionList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: AlterTableActionList
              _lhsOoriginalTree :: AlterTableActionList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: AlterTableAction
              _hdIoriginalTree :: AlterTableAction
              _tlIannotatedTree :: AlterTableActionList
              _tlIoriginalTree :: AlterTableActionList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 749 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 754 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 759 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 764 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 769 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 774 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 779 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 784 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_AlterTableActionList_Nil :: T_AlterTableActionList 
sem_AlterTableActionList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: AlterTableActionList
              _lhsOoriginalTree :: AlterTableActionList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 800 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 805 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 810 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 815 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- AttributeDef ------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         attrName             : String
         namedType            : Maybe Type
         originalTree         : SELF 
   alternatives:
      alternative AttributeDef:
         child ann            : {Annotation}
         child name           : {String}
         child typ            : TypeName 
         child def            : MaybeExpression 
         child cons           : RowConstraintList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data AttributeDef  = AttributeDef (Annotation) (String) (TypeName) (MaybeExpression) (RowConstraintList) 
                   deriving ( Data,Eq,Show,Typeable)
-- cata
sem_AttributeDef :: AttributeDef  ->
                    T_AttributeDef 
sem_AttributeDef (AttributeDef _ann _name _typ _def _cons )  =
    (sem_AttributeDef_AttributeDef _ann _name (sem_TypeName _typ ) (sem_MaybeExpression _def ) (sem_RowConstraintList _cons ) )
-- semantic domain
type T_AttributeDef  = Catalog ->
                       LocalBindings ->
                       ( AttributeDef,String,(Maybe Type),AttributeDef)
data Inh_AttributeDef  = Inh_AttributeDef {cat_Inh_AttributeDef :: Catalog,lib_Inh_AttributeDef :: LocalBindings}
data Syn_AttributeDef  = Syn_AttributeDef {annotatedTree_Syn_AttributeDef :: AttributeDef,attrName_Syn_AttributeDef :: String,namedType_Syn_AttributeDef :: Maybe Type,originalTree_Syn_AttributeDef :: AttributeDef}
wrap_AttributeDef :: T_AttributeDef  ->
                     Inh_AttributeDef  ->
                     Syn_AttributeDef 
wrap_AttributeDef sem (Inh_AttributeDef _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOattrName,_lhsOnamedType,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_AttributeDef _lhsOannotatedTree _lhsOattrName _lhsOnamedType _lhsOoriginalTree ))
sem_AttributeDef_AttributeDef :: Annotation ->
                                 String ->
                                 T_TypeName  ->
                                 T_MaybeExpression  ->
                                 T_RowConstraintList  ->
                                 T_AttributeDef 
sem_AttributeDef_AttributeDef ann_ name_ typ_ def_ cons_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOattrName :: String
              _lhsOnamedType :: (Maybe Type)
              _consOlib :: LocalBindings
              _lhsOannotatedTree :: AttributeDef
              _lhsOoriginalTree :: AttributeDef
              _typOcat :: Catalog
              _typOlib :: LocalBindings
              _defOcat :: Catalog
              _defOlib :: LocalBindings
              _consOcat :: Catalog
              _typIannotatedTree :: TypeName
              _typInamedType :: (Maybe Type)
              _typIoriginalTree :: TypeName
              _defIannotatedTree :: MaybeExpression
              _defIoriginalTree :: MaybeExpression
              _consIannotatedTree :: RowConstraintList
              _consIoriginalTree :: RowConstraintList
              -- "./TypeChecking/CreateTable.ag"(line 86, column 9)
              _lhsOattrName =
                  {-# LINE 86 "./TypeChecking/CreateTable.ag" #-}
                  map toLower name_
                  {-# LINE 889 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 87, column 9)
              _lhsOnamedType =
                  {-# LINE 87 "./TypeChecking/CreateTable.ag" #-}
                  _typInamedType
                  {-# LINE 894 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 101, column 9)
              _consOlib =
                  {-# LINE 101 "./TypeChecking/CreateTable.ag" #-}
                  either (const _lhsIlib) id $ do
                  t <- lmt _typInamedType
                  lbUpdate _lhsIcat
                           (LBIds "attribute def" ""
                                  [(name_, t)] []) _lhsIlib
                  {-# LINE 903 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  AttributeDef ann_ name_ _typIannotatedTree _defIannotatedTree _consIannotatedTree
                  {-# LINE 908 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  AttributeDef ann_ name_ _typIoriginalTree _defIoriginalTree _consIoriginalTree
                  {-# LINE 913 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 918 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 923 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 928 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 933 "AstInternal.hs" #-}
              -- copy rule (down)
              _defOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 938 "AstInternal.hs" #-}
              -- copy rule (down)
              _defOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 943 "AstInternal.hs" #-}
              -- copy rule (down)
              _consOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 948 "AstInternal.hs" #-}
              ( _typIannotatedTree,_typInamedType,_typIoriginalTree) =
                  (typ_ _typOcat _typOlib )
              ( _defIannotatedTree,_defIoriginalTree) =
                  (def_ _defOcat _defOlib )
              ( _consIannotatedTree,_consIoriginalTree) =
                  (cons_ _consOcat _consOlib )
          in  ( _lhsOannotatedTree,_lhsOattrName,_lhsOnamedType,_lhsOoriginalTree)))
-- AttributeDefList --------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         attrs                : [(String, Maybe Type)]
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : AttributeDef 
         child tl             : AttributeDefList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type AttributeDefList  = [(AttributeDef)]
-- cata
sem_AttributeDefList :: AttributeDefList  ->
                        T_AttributeDefList 
sem_AttributeDefList list  =
    (Prelude.foldr sem_AttributeDefList_Cons sem_AttributeDefList_Nil (Prelude.map sem_AttributeDef list) )
-- semantic domain
type T_AttributeDefList  = Catalog ->
                           LocalBindings ->
                           ( AttributeDefList,([(String, Maybe Type)]),AttributeDefList)
data Inh_AttributeDefList  = Inh_AttributeDefList {cat_Inh_AttributeDefList :: Catalog,lib_Inh_AttributeDefList :: LocalBindings}
data Syn_AttributeDefList  = Syn_AttributeDefList {annotatedTree_Syn_AttributeDefList :: AttributeDefList,attrs_Syn_AttributeDefList :: [(String, Maybe Type)],originalTree_Syn_AttributeDefList :: AttributeDefList}
wrap_AttributeDefList :: T_AttributeDefList  ->
                         Inh_AttributeDefList  ->
                         Syn_AttributeDefList 
wrap_AttributeDefList sem (Inh_AttributeDefList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOattrs,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_AttributeDefList _lhsOannotatedTree _lhsOattrs _lhsOoriginalTree ))
sem_AttributeDefList_Cons :: T_AttributeDef  ->
                             T_AttributeDefList  ->
                             T_AttributeDefList 
sem_AttributeDefList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOattrs :: ([(String, Maybe Type)])
              _lhsOannotatedTree :: AttributeDefList
              _lhsOoriginalTree :: AttributeDefList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: AttributeDef
              _hdIattrName :: String
              _hdInamedType :: (Maybe Type)
              _hdIoriginalTree :: AttributeDef
              _tlIannotatedTree :: AttributeDefList
              _tlIattrs :: ([(String, Maybe Type)])
              _tlIoriginalTree :: AttributeDefList
              -- "./TypeChecking/CreateTable.ag"(line 91, column 12)
              _lhsOattrs =
                  {-# LINE 91 "./TypeChecking/CreateTable.ag" #-}
                  (_hdIattrName, _hdInamedType) : _tlIattrs
                  {-# LINE 1021 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 1026 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 1031 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1036 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1041 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1046 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1051 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1056 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1061 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIattrName,_hdInamedType,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIattrs,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOattrs,_lhsOoriginalTree)))
sem_AttributeDefList_Nil :: T_AttributeDefList 
sem_AttributeDefList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOattrs :: ([(String, Maybe Type)])
              _lhsOannotatedTree :: AttributeDefList
              _lhsOoriginalTree :: AttributeDefList
              -- "./TypeChecking/CreateTable.ag"(line 92, column 11)
              _lhsOattrs =
                  {-# LINE 92 "./TypeChecking/CreateTable.ag" #-}
                  []
                  {-# LINE 1078 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 1083 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 1088 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1093 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1098 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOattrs,_lhsOoriginalTree)))
-- CaseExpressionList ------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : Expression 
         child tl             : CaseExpressionList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type CaseExpressionList  = [(Expression)]
-- cata
sem_CaseExpressionList :: CaseExpressionList  ->
                          T_CaseExpressionList 
sem_CaseExpressionList list  =
    (Prelude.foldr sem_CaseExpressionList_Cons sem_CaseExpressionList_Nil (Prelude.map sem_Expression list) )
-- semantic domain
type T_CaseExpressionList  = Catalog ->
                             LocalBindings ->
                             ( CaseExpressionList,CaseExpressionList)
data Inh_CaseExpressionList  = Inh_CaseExpressionList {cat_Inh_CaseExpressionList :: Catalog,lib_Inh_CaseExpressionList :: LocalBindings}
data Syn_CaseExpressionList  = Syn_CaseExpressionList {annotatedTree_Syn_CaseExpressionList :: CaseExpressionList,originalTree_Syn_CaseExpressionList :: CaseExpressionList}
wrap_CaseExpressionList :: T_CaseExpressionList  ->
                           Inh_CaseExpressionList  ->
                           Syn_CaseExpressionList 
wrap_CaseExpressionList sem (Inh_CaseExpressionList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_CaseExpressionList _lhsOannotatedTree _lhsOoriginalTree ))
sem_CaseExpressionList_Cons :: T_Expression  ->
                               T_CaseExpressionList  ->
                               T_CaseExpressionList 
sem_CaseExpressionList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: CaseExpressionList
              _lhsOoriginalTree :: CaseExpressionList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: Expression
              _hdIntAnnotatedTree :: Expression
              _hdIntType :: ([(String,Type)])
              _hdIoriginalTree :: Expression
              _tlIannotatedTree :: CaseExpressionList
              _tlIoriginalTree :: CaseExpressionList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 1162 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 1167 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1172 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1177 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1182 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1187 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1192 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1197 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIntAnnotatedTree,_hdIntType,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_CaseExpressionList_Nil :: T_CaseExpressionList 
sem_CaseExpressionList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: CaseExpressionList
              _lhsOoriginalTree :: CaseExpressionList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 1213 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 1218 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1223 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1228 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- CaseExpressionListExpressionPair ----------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Tuple:
         child x1             : CaseExpressionList 
         child x2             : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type CaseExpressionListExpressionPair  = ( (CaseExpressionList),(Expression))
-- cata
sem_CaseExpressionListExpressionPair :: CaseExpressionListExpressionPair  ->
                                        T_CaseExpressionListExpressionPair 
sem_CaseExpressionListExpressionPair ( x1,x2)  =
    (sem_CaseExpressionListExpressionPair_Tuple (sem_CaseExpressionList x1 ) (sem_Expression x2 ) )
-- semantic domain
type T_CaseExpressionListExpressionPair  = Catalog ->
                                           LocalBindings ->
                                           ( CaseExpressionListExpressionPair,CaseExpressionListExpressionPair)
data Inh_CaseExpressionListExpressionPair  = Inh_CaseExpressionListExpressionPair {cat_Inh_CaseExpressionListExpressionPair :: Catalog,lib_Inh_CaseExpressionListExpressionPair :: LocalBindings}
data Syn_CaseExpressionListExpressionPair  = Syn_CaseExpressionListExpressionPair {annotatedTree_Syn_CaseExpressionListExpressionPair :: CaseExpressionListExpressionPair,originalTree_Syn_CaseExpressionListExpressionPair :: CaseExpressionListExpressionPair}
wrap_CaseExpressionListExpressionPair :: T_CaseExpressionListExpressionPair  ->
                                         Inh_CaseExpressionListExpressionPair  ->
                                         Syn_CaseExpressionListExpressionPair 
wrap_CaseExpressionListExpressionPair sem (Inh_CaseExpressionListExpressionPair _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_CaseExpressionListExpressionPair _lhsOannotatedTree _lhsOoriginalTree ))
sem_CaseExpressionListExpressionPair_Tuple :: T_CaseExpressionList  ->
                                              T_Expression  ->
                                              T_CaseExpressionListExpressionPair 
sem_CaseExpressionListExpressionPair_Tuple x1_ x2_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: CaseExpressionListExpressionPair
              _lhsOoriginalTree :: CaseExpressionListExpressionPair
              _x1Ocat :: Catalog
              _x1Olib :: LocalBindings
              _x2Ocat :: Catalog
              _x2Olib :: LocalBindings
              _x1IannotatedTree :: CaseExpressionList
              _x1IoriginalTree :: CaseExpressionList
              _x2IannotatedTree :: Expression
              _x2IntAnnotatedTree :: Expression
              _x2IntType :: ([(String,Type)])
              _x2IoriginalTree :: Expression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (_x1IannotatedTree,_x2IannotatedTree)
                  {-# LINE 1288 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (_x1IoriginalTree,_x2IoriginalTree)
                  {-# LINE 1293 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1298 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1303 "AstInternal.hs" #-}
              -- copy rule (down)
              _x1Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1308 "AstInternal.hs" #-}
              -- copy rule (down)
              _x1Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1313 "AstInternal.hs" #-}
              -- copy rule (down)
              _x2Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1318 "AstInternal.hs" #-}
              -- copy rule (down)
              _x2Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1323 "AstInternal.hs" #-}
              ( _x1IannotatedTree,_x1IoriginalTree) =
                  (x1_ _x1Ocat _x1Olib )
              ( _x2IannotatedTree,_x2IntAnnotatedTree,_x2IntType,_x2IoriginalTree) =
                  (x2_ _x2Ocat _x2Olib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- CaseExpressionListExpressionPairList ------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : CaseExpressionListExpressionPair 
         child tl             : CaseExpressionListExpressionPairList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type CaseExpressionListExpressionPairList  = [(CaseExpressionListExpressionPair)]
-- cata
sem_CaseExpressionListExpressionPairList :: CaseExpressionListExpressionPairList  ->
                                            T_CaseExpressionListExpressionPairList 
sem_CaseExpressionListExpressionPairList list  =
    (Prelude.foldr sem_CaseExpressionListExpressionPairList_Cons sem_CaseExpressionListExpressionPairList_Nil (Prelude.map sem_CaseExpressionListExpressionPair list) )
-- semantic domain
type T_CaseExpressionListExpressionPairList  = Catalog ->
                                               LocalBindings ->
                                               ( CaseExpressionListExpressionPairList,CaseExpressionListExpressionPairList)
data Inh_CaseExpressionListExpressionPairList  = Inh_CaseExpressionListExpressionPairList {cat_Inh_CaseExpressionListExpressionPairList :: Catalog,lib_Inh_CaseExpressionListExpressionPairList :: LocalBindings}
data Syn_CaseExpressionListExpressionPairList  = Syn_CaseExpressionListExpressionPairList {annotatedTree_Syn_CaseExpressionListExpressionPairList :: CaseExpressionListExpressionPairList,originalTree_Syn_CaseExpressionListExpressionPairList :: CaseExpressionListExpressionPairList}
wrap_CaseExpressionListExpressionPairList :: T_CaseExpressionListExpressionPairList  ->
                                             Inh_CaseExpressionListExpressionPairList  ->
                                             Syn_CaseExpressionListExpressionPairList 
wrap_CaseExpressionListExpressionPairList sem (Inh_CaseExpressionListExpressionPairList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_CaseExpressionListExpressionPairList _lhsOannotatedTree _lhsOoriginalTree ))
sem_CaseExpressionListExpressionPairList_Cons :: T_CaseExpressionListExpressionPair  ->
                                                 T_CaseExpressionListExpressionPairList  ->
                                                 T_CaseExpressionListExpressionPairList 
sem_CaseExpressionListExpressionPairList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: CaseExpressionListExpressionPairList
              _lhsOoriginalTree :: CaseExpressionListExpressionPairList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: CaseExpressionListExpressionPair
              _hdIoriginalTree :: CaseExpressionListExpressionPair
              _tlIannotatedTree :: CaseExpressionListExpressionPairList
              _tlIoriginalTree :: CaseExpressionListExpressionPairList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 1389 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 1394 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1399 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1404 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1409 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1414 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1419 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1424 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_CaseExpressionListExpressionPairList_Nil :: T_CaseExpressionListExpressionPairList 
sem_CaseExpressionListExpressionPairList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: CaseExpressionListExpressionPairList
              _lhsOoriginalTree :: CaseExpressionListExpressionPairList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 1440 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 1445 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1450 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1455 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- Constraint --------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative CheckConstraint:
         child ann            : {Annotation}
         child name           : {String}
         child expression     : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative PrimaryKeyConstraint:
         child ann            : {Annotation}
         child name           : {String}
         child x              : {[String]}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative ReferenceConstraint:
         child ann            : {Annotation}
         child name           : {String}
         child atts           : {[String]}
         child table          : {String}
         child tableAtts      : {[String]}
         child onUpdate       : {Cascade}
         child onDelete       : {Cascade}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative UniqueConstraint:
         child ann            : {Annotation}
         child name           : {String}
         child x              : {[String]}
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data Constraint  = CheckConstraint (Annotation) (String) (Expression) 
                 | PrimaryKeyConstraint (Annotation) (String) ([String]) 
                 | ReferenceConstraint (Annotation) (String) ([String]) (String) ([String]) (Cascade) (Cascade) 
                 | UniqueConstraint (Annotation) (String) ([String]) 
                 deriving ( Data,Eq,Show,Typeable)
-- cata
sem_Constraint :: Constraint  ->
                  T_Constraint 
sem_Constraint (CheckConstraint _ann _name _expression )  =
    (sem_Constraint_CheckConstraint _ann _name (sem_Expression _expression ) )
sem_Constraint (PrimaryKeyConstraint _ann _name _x )  =
    (sem_Constraint_PrimaryKeyConstraint _ann _name _x )
sem_Constraint (ReferenceConstraint _ann _name _atts _table _tableAtts _onUpdate _onDelete )  =
    (sem_Constraint_ReferenceConstraint _ann _name _atts _table _tableAtts _onUpdate _onDelete )
sem_Constraint (UniqueConstraint _ann _name _x )  =
    (sem_Constraint_UniqueConstraint _ann _name _x )
-- semantic domain
type T_Constraint  = Catalog ->
                     LocalBindings ->
                     ( Constraint,Constraint)
data Inh_Constraint  = Inh_Constraint {cat_Inh_Constraint :: Catalog,lib_Inh_Constraint :: LocalBindings}
data Syn_Constraint  = Syn_Constraint {annotatedTree_Syn_Constraint :: Constraint,originalTree_Syn_Constraint :: Constraint}
wrap_Constraint :: T_Constraint  ->
                   Inh_Constraint  ->
                   Syn_Constraint 
wrap_Constraint sem (Inh_Constraint _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_Constraint _lhsOannotatedTree _lhsOoriginalTree ))
sem_Constraint_CheckConstraint :: Annotation ->
                                  String ->
                                  T_Expression  ->
                                  T_Constraint 
sem_Constraint_CheckConstraint ann_ name_ expression_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Constraint
              _lhsOoriginalTree :: Constraint
              _expressionOcat :: Catalog
              _expressionOlib :: LocalBindings
              _expressionIannotatedTree :: Expression
              _expressionIntAnnotatedTree :: Expression
              _expressionIntType :: ([(String,Type)])
              _expressionIoriginalTree :: Expression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CheckConstraint ann_ name_ _expressionIannotatedTree
                  {-# LINE 1548 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CheckConstraint ann_ name_ _expressionIoriginalTree
                  {-# LINE 1553 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1558 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1563 "AstInternal.hs" #-}
              -- copy rule (down)
              _expressionOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1568 "AstInternal.hs" #-}
              -- copy rule (down)
              _expressionOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1573 "AstInternal.hs" #-}
              ( _expressionIannotatedTree,_expressionIntAnnotatedTree,_expressionIntType,_expressionIoriginalTree) =
                  (expression_ _expressionOcat _expressionOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_Constraint_PrimaryKeyConstraint :: Annotation ->
                                       String ->
                                       ([String]) ->
                                       T_Constraint 
sem_Constraint_PrimaryKeyConstraint ann_ name_ x_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Constraint
              _lhsOoriginalTree :: Constraint
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  PrimaryKeyConstraint ann_ name_ x_
                  {-# LINE 1590 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  PrimaryKeyConstraint ann_ name_ x_
                  {-# LINE 1595 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1600 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1605 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_Constraint_ReferenceConstraint :: Annotation ->
                                      String ->
                                      ([String]) ->
                                      String ->
                                      ([String]) ->
                                      Cascade ->
                                      Cascade ->
                                      T_Constraint 
sem_Constraint_ReferenceConstraint ann_ name_ atts_ table_ tableAtts_ onUpdate_ onDelete_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Constraint
              _lhsOoriginalTree :: Constraint
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ReferenceConstraint ann_ name_ atts_ table_ tableAtts_ onUpdate_ onDelete_
                  {-# LINE 1624 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ReferenceConstraint ann_ name_ atts_ table_ tableAtts_ onUpdate_ onDelete_
                  {-# LINE 1629 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1634 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1639 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_Constraint_UniqueConstraint :: Annotation ->
                                   String ->
                                   ([String]) ->
                                   T_Constraint 
sem_Constraint_UniqueConstraint ann_ name_ x_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Constraint
              _lhsOoriginalTree :: Constraint
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  UniqueConstraint ann_ name_ x_
                  {-# LINE 1654 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  UniqueConstraint ann_ name_ x_
                  {-# LINE 1659 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1664 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1669 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- ConstraintList ----------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : Constraint 
         child tl             : ConstraintList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ConstraintList  = [(Constraint)]
-- cata
sem_ConstraintList :: ConstraintList  ->
                      T_ConstraintList 
sem_ConstraintList list  =
    (Prelude.foldr sem_ConstraintList_Cons sem_ConstraintList_Nil (Prelude.map sem_Constraint list) )
-- semantic domain
type T_ConstraintList  = Catalog ->
                         LocalBindings ->
                         ( ConstraintList,ConstraintList)
data Inh_ConstraintList  = Inh_ConstraintList {cat_Inh_ConstraintList :: Catalog,lib_Inh_ConstraintList :: LocalBindings}
data Syn_ConstraintList  = Syn_ConstraintList {annotatedTree_Syn_ConstraintList :: ConstraintList,originalTree_Syn_ConstraintList :: ConstraintList}
wrap_ConstraintList :: T_ConstraintList  ->
                       Inh_ConstraintList  ->
                       Syn_ConstraintList 
wrap_ConstraintList sem (Inh_ConstraintList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ConstraintList _lhsOannotatedTree _lhsOoriginalTree ))
sem_ConstraintList_Cons :: T_Constraint  ->
                           T_ConstraintList  ->
                           T_ConstraintList 
sem_ConstraintList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ConstraintList
              _lhsOoriginalTree :: ConstraintList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: Constraint
              _hdIoriginalTree :: Constraint
              _tlIannotatedTree :: ConstraintList
              _tlIoriginalTree :: ConstraintList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 1731 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 1736 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1741 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1746 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1751 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1756 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 1761 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 1766 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_ConstraintList_Nil :: T_ConstraintList 
sem_ConstraintList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ConstraintList
              _lhsOoriginalTree :: ConstraintList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 1782 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 1787 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 1792 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 1797 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- Expression --------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         ntAnnotatedTree      : Expression 
         ntType               : [(String,Type)]
         originalTree         : SELF 
   alternatives:
      alternative BooleanLit:
         child ann            : {Annotation}
         child b              : {Bool}
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative Case:
         child ann            : {Annotation}
         child cases          : CaseExpressionListExpressionPairList 
         child els            : MaybeExpression 
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local whenTypes   : _
            local thenTypes   : _
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative CaseSimple:
         child ann            : {Annotation}
         child value          : Expression 
         child cases          : CaseExpressionListExpressionPairList 
         child els            : MaybeExpression 
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local whenTypes   : _
            local thenTypes   : _
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative Cast:
         child ann            : {Annotation}
         child expr           : Expression 
         child tn             : TypeName 
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative Exists:
         child ann            : {Annotation}
         child sel            : SelectExpression 
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local liftedColumnName : _
            local ntType      : _
            local tpe         : {Et}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative FloatLit:
         child ann            : {Annotation}
         child d              : {Double}
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative FunCall:
         child ann            : {Annotation}
         child funName        : {String}
         child args           : ExpressionList 
         visit 0:
            local _tup1       : _
            local tpe         : {Et}
            local prototype   : _
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative Identifier:
         child ann            : {Annotation}
         child i              : {String}
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local tpe         : {Et}
            local backTree    : _
            local ntType      : {E [(String,Type)]}
            local annotatedTree : _
            local originalTree : _
      alternative InPredicate:
         child ann            : {Annotation}
         child expr           : Expression 
         child i              : {Bool}
         child list           : InList 
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local liftedColumnName : _
            local ntType      : _
            local tpe         : {Et}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative IntegerLit:
         child ann            : {Annotation}
         child i              : {Integer}
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative LiftOperator:
         child ann            : {Annotation}
         child oper           : {String}
         child flav           : {LiftFlavour}
         child args           : ExpressionList 
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative NullLit:
         child ann            : {Annotation}
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative Placeholder:
         child ann            : {Annotation}
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local liftedColumnName : _
            local ntType      : _
            local tpe         : {Et}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative PositionalArg:
         child ann            : {Annotation}
         child p              : {Integer}
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local liftedColumnName : _
            local ntType      : _
            local tpe         : {Et}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative ScalarSubQuery:
         child ann            : {Annotation}
         child sel            : SelectExpression 
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local liftedColumnName : _
            local ntType      : _
            local tpe         : {Et}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative StringLit:
         child ann            : {Annotation}
         child value          : {String}
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
      alternative WindowFn:
         child ann            : {Annotation}
         child fn             : Expression 
         child partitionBy    : ExpressionList 
         child orderBy        : ExpressionList 
         child dir            : {Direction}
         child frm            : {FrameClause}
         visit 0:
            local prototype   : {Maybe FunctionPrototype}
            local tpe         : {Et}
            local backTree    : _
            local liftedColumnName : _
            local ntType      : _
            local annotatedTree : _
            local originalTree : _
-}
data Expression  = BooleanLit (Annotation) (Bool) 
                 | Case (Annotation) (CaseExpressionListExpressionPairList) (MaybeExpression) 
                 | CaseSimple (Annotation) (Expression) (CaseExpressionListExpressionPairList) (MaybeExpression) 
                 | Cast (Annotation) (Expression) (TypeName) 
                 | Exists (Annotation) (SelectExpression) 
                 | FloatLit (Annotation) (Double) 
                 | FunCall (Annotation) (String) (ExpressionList) 
                 | Identifier (Annotation) (String) 
                 | InPredicate (Annotation) (Expression) (Bool) (InList) 
                 | IntegerLit (Annotation) (Integer) 
                 | LiftOperator (Annotation) (String) (LiftFlavour) (ExpressionList) 
                 | NullLit (Annotation) 
                 | Placeholder (Annotation) 
                 | PositionalArg (Annotation) (Integer) 
                 | ScalarSubQuery (Annotation) (SelectExpression) 
                 | StringLit (Annotation) (String) 
                 | WindowFn (Annotation) (Expression) (ExpressionList) (ExpressionList) (Direction) (FrameClause) 
                 deriving ( Data,Eq,Show,Typeable)
-- cata
sem_Expression :: Expression  ->
                  T_Expression 
sem_Expression (BooleanLit _ann _b )  =
    (sem_Expression_BooleanLit _ann _b )
sem_Expression (Case _ann _cases _els )  =
    (sem_Expression_Case _ann (sem_CaseExpressionListExpressionPairList _cases ) (sem_MaybeExpression _els ) )
sem_Expression (CaseSimple _ann _value _cases _els )  =
    (sem_Expression_CaseSimple _ann (sem_Expression _value ) (sem_CaseExpressionListExpressionPairList _cases ) (sem_MaybeExpression _els ) )
sem_Expression (Cast _ann _expr _tn )  =
    (sem_Expression_Cast _ann (sem_Expression _expr ) (sem_TypeName _tn ) )
sem_Expression (Exists _ann _sel )  =
    (sem_Expression_Exists _ann (sem_SelectExpression _sel ) )
sem_Expression (FloatLit _ann _d )  =
    (sem_Expression_FloatLit _ann _d )
sem_Expression (FunCall _ann _funName _args )  =
    (sem_Expression_FunCall _ann _funName (sem_ExpressionList _args ) )
sem_Expression (Identifier _ann _i )  =
    (sem_Expression_Identifier _ann _i )
sem_Expression (InPredicate _ann _expr _i _list )  =
    (sem_Expression_InPredicate _ann (sem_Expression _expr ) _i (sem_InList _list ) )
sem_Expression (IntegerLit _ann _i )  =
    (sem_Expression_IntegerLit _ann _i )
sem_Expression (LiftOperator _ann _oper _flav _args )  =
    (sem_Expression_LiftOperator _ann _oper _flav (sem_ExpressionList _args ) )
sem_Expression (NullLit _ann )  =
    (sem_Expression_NullLit _ann )
sem_Expression (Placeholder _ann )  =
    (sem_Expression_Placeholder _ann )
sem_Expression (PositionalArg _ann _p )  =
    (sem_Expression_PositionalArg _ann _p )
sem_Expression (ScalarSubQuery _ann _sel )  =
    (sem_Expression_ScalarSubQuery _ann (sem_SelectExpression _sel ) )
sem_Expression (StringLit _ann _value )  =
    (sem_Expression_StringLit _ann _value )
sem_Expression (WindowFn _ann _fn _partitionBy _orderBy _dir _frm )  =
    (sem_Expression_WindowFn _ann (sem_Expression _fn ) (sem_ExpressionList _partitionBy ) (sem_ExpressionList _orderBy ) _dir _frm )
-- semantic domain
type T_Expression  = Catalog ->
                     LocalBindings ->
                     ( Expression,Expression,([(String,Type)]),Expression)
data Inh_Expression  = Inh_Expression {cat_Inh_Expression :: Catalog,lib_Inh_Expression :: LocalBindings}
data Syn_Expression  = Syn_Expression {annotatedTree_Syn_Expression :: Expression,ntAnnotatedTree_Syn_Expression :: Expression,ntType_Syn_Expression :: [(String,Type)],originalTree_Syn_Expression :: Expression}
wrap_Expression :: T_Expression  ->
                   Inh_Expression  ->
                   Syn_Expression 
wrap_Expression sem (Inh_Expression _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_Expression _lhsOannotatedTree _lhsOntAnnotatedTree _lhsOntType _lhsOoriginalTree ))
sem_Expression_BooleanLit :: Annotation ->
                             Bool ->
                             T_Expression 
sem_Expression_BooleanLit ann_ b_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2100 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 2105 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2112 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 2117 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 50, column 19)
              _tpe =
                  {-# LINE 50 "./TypeChecking/Expressions.ag" #-}
                  Right typeBool
                  {-# LINE 2122 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 62, column 9)
              _backTree =
                  {-# LINE 62 "./TypeChecking/Expressions.ag" #-}
                  BooleanLit ann_ b_
                  {-# LINE 2127 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 2132 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 2142 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  BooleanLit ann_ b_
                  {-# LINE 2147 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  BooleanLit ann_ b_
                  {-# LINE 2152 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 2157 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_Case :: Annotation ->
                       T_CaseExpressionListExpressionPairList  ->
                       T_MaybeExpression  ->
                       T_Expression 
sem_Expression_Case ann_ cases_ els_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              _casesOcat :: Catalog
              _casesOlib :: LocalBindings
              _elsOcat :: Catalog
              _elsOlib :: LocalBindings
              _casesIannotatedTree :: CaseExpressionListExpressionPairList
              _casesIoriginalTree :: CaseExpressionListExpressionPairList
              _elsIannotatedTree :: MaybeExpression
              _elsIoriginalTree :: MaybeExpression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2186 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 2191 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2198 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 2203 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 211, column 9)
              _whenTypes =
                  {-# LINE 211 "./TypeChecking/Expressions.ag" #-}
                  map getTypeAnnotation $ concatMap fst $
                  _casesIannotatedTree
                  {-# LINE 2209 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 213, column 9)
              _thenTypes =
                  {-# LINE 213 "./TypeChecking/Expressions.ag" #-}
                  map getTypeAnnotation $
                      (map snd $ _casesIannotatedTree) ++
                        maybeToList _elsIannotatedTree
                  {-# LINE 2216 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 219, column 9)
              _tpe =
                  {-# LINE 219 "./TypeChecking/Expressions.ag" #-}
                  do
                  wt <- mapM lmt _whenTypes
                  errorWhen (any (/= typeBool) wt)
                      [WrongTypes typeBool wt]
                  tt <- mapM lmt _thenTypes
                  resolveResultSetType _lhsIcat tt
                  {-# LINE 2226 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 227, column 9)
              _backTree =
                  {-# LINE 227 "./TypeChecking/Expressions.ag" #-}
                  Case ann_ _casesIannotatedTree _elsIannotatedTree
                  {-# LINE 2231 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 2236 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 2246 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Case ann_ _casesIannotatedTree _elsIannotatedTree
                  {-# LINE 2251 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Case ann_ _casesIoriginalTree _elsIoriginalTree
                  {-# LINE 2256 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 2261 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 2266 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 2271 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 2276 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 2281 "AstInternal.hs" #-}
              ( _casesIannotatedTree,_casesIoriginalTree) =
                  (cases_ _casesOcat _casesOlib )
              ( _elsIannotatedTree,_elsIoriginalTree) =
                  (els_ _elsOcat _elsOlib )
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_CaseSimple :: Annotation ->
                             T_Expression  ->
                             T_CaseExpressionListExpressionPairList  ->
                             T_MaybeExpression  ->
                             T_Expression 
sem_Expression_CaseSimple ann_ value_ cases_ els_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              _valueOcat :: Catalog
              _valueOlib :: LocalBindings
              _casesOcat :: Catalog
              _casesOlib :: LocalBindings
              _elsOcat :: Catalog
              _elsOlib :: LocalBindings
              _valueIannotatedTree :: Expression
              _valueIntAnnotatedTree :: Expression
              _valueIntType :: ([(String,Type)])
              _valueIoriginalTree :: Expression
              _casesIannotatedTree :: CaseExpressionListExpressionPairList
              _casesIoriginalTree :: CaseExpressionListExpressionPairList
              _elsIannotatedTree :: MaybeExpression
              _elsIoriginalTree :: MaybeExpression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2321 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 2326 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2333 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 2338 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 211, column 9)
              _whenTypes =
                  {-# LINE 211 "./TypeChecking/Expressions.ag" #-}
                  map getTypeAnnotation $ concatMap fst $
                  _casesIannotatedTree
                  {-# LINE 2344 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 213, column 9)
              _thenTypes =
                  {-# LINE 213 "./TypeChecking/Expressions.ag" #-}
                  map getTypeAnnotation $
                      (map snd $ _casesIannotatedTree) ++
                        maybeToList _elsIannotatedTree
                  {-# LINE 2351 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 232, column 9)
              _tpe =
                  {-# LINE 232 "./TypeChecking/Expressions.ag" #-}
                  do
                  wt <- mapM lmt _whenTypes
                  vt <- lmt $ getTypeAnnotation _valueIannotatedTree
                  _ <- resolveResultSetType _lhsIcat (vt : wt)
                  tt <- mapM lmt _thenTypes
                  resolveResultSetType _lhsIcat tt
                  {-# LINE 2361 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 239, column 9)
              _backTree =
                  {-# LINE 239 "./TypeChecking/Expressions.ag" #-}
                  CaseSimple ann_
                             _valueIannotatedTree
                             _casesIannotatedTree
                             _elsIannotatedTree
                  {-# LINE 2369 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 2374 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 2384 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CaseSimple ann_ _valueIannotatedTree _casesIannotatedTree _elsIannotatedTree
                  {-# LINE 2389 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CaseSimple ann_ _valueIoriginalTree _casesIoriginalTree _elsIoriginalTree
                  {-# LINE 2394 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 2399 "AstInternal.hs" #-}
              -- copy rule (down)
              _valueOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 2404 "AstInternal.hs" #-}
              -- copy rule (down)
              _valueOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 2409 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 2414 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 2419 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 2424 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 2429 "AstInternal.hs" #-}
              ( _valueIannotatedTree,_valueIntAnnotatedTree,_valueIntType,_valueIoriginalTree) =
                  (value_ _valueOcat _valueOlib )
              ( _casesIannotatedTree,_casesIoriginalTree) =
                  (cases_ _casesOcat _casesOlib )
              ( _elsIannotatedTree,_elsIoriginalTree) =
                  (els_ _elsOcat _elsOlib )
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_Cast :: Annotation ->
                       T_Expression  ->
                       T_TypeName  ->
                       T_Expression 
sem_Expression_Cast ann_ expr_ tn_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _tnOcat :: Catalog
              _tnOlib :: LocalBindings
              _exprIannotatedTree :: Expression
              _exprIntAnnotatedTree :: Expression
              _exprIntType :: ([(String,Type)])
              _exprIoriginalTree :: Expression
              _tnIannotatedTree :: TypeName
              _tnInamedType :: (Maybe Type)
              _tnIoriginalTree :: TypeName
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2467 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 2472 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2479 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 2484 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 75, column 12)
              _tpe =
                  {-# LINE 75 "./TypeChecking/Expressions.ag" #-}
                  lmt _tnInamedType
                  {-# LINE 2489 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 76, column 12)
              _backTree =
                  {-# LINE 76 "./TypeChecking/Expressions.ag" #-}
                  Cast ann_ _exprIannotatedTree _tnIannotatedTree
                  {-# LINE 2494 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 290, column 7)
              _liftedColumnName =
                  {-# LINE 290 "./TypeChecking/Expressions.ag" #-}
                  case _tnIannotatedTree of
                    SimpleTypeName _ tn -> tn
                    _ -> ""
                  {-# LINE 2501 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 2511 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Cast ann_ _exprIannotatedTree _tnIannotatedTree
                  {-# LINE 2516 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Cast ann_ _exprIoriginalTree _tnIoriginalTree
                  {-# LINE 2521 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 2526 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 2531 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 2536 "AstInternal.hs" #-}
              -- copy rule (down)
              _tnOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 2541 "AstInternal.hs" #-}
              -- copy rule (down)
              _tnOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 2546 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIntAnnotatedTree,_exprIntType,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
              ( _tnIannotatedTree,_tnInamedType,_tnIoriginalTree) =
                  (tn_ _tnOcat _tnOlib )
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_Exists :: Annotation ->
                         T_SelectExpression  ->
                         T_Expression 
sem_Expression_Exists ann_ sel_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              _selOcat :: Catalog
              _selOlib :: LocalBindings
              _selIannotatedTree :: SelectExpression
              _selIoriginalTree :: SelectExpression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2574 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 2579 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2586 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 2591 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 2596 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 2606 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 326, column 9)
              _tpe =
                  {-# LINE 326 "./TypeChecking/Expressions.ag" #-}
                  Right typeBool
                  {-# LINE 2611 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 327, column 9)
              _backTree =
                  {-# LINE 327 "./TypeChecking/Expressions.ag" #-}
                  Exists ann_ _selIannotatedTree
                  {-# LINE 2616 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Exists ann_ _selIannotatedTree
                  {-# LINE 2621 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Exists ann_ _selIoriginalTree
                  {-# LINE 2626 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 2631 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 2636 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 2641 "AstInternal.hs" #-}
              ( _selIannotatedTree,_selIoriginalTree) =
                  (sel_ _selOcat _selOlib )
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_FloatLit :: Annotation ->
                           Double ->
                           T_Expression 
sem_Expression_FloatLit ann_ d_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2663 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 2668 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2675 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 2680 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 49, column 17)
              _tpe =
                  {-# LINE 49 "./TypeChecking/Expressions.ag" #-}
                  Right typeNumeric
                  {-# LINE 2685 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 60, column 9)
              _backTree =
                  {-# LINE 60 "./TypeChecking/Expressions.ag" #-}
                  FloatLit ann_ d_
                  {-# LINE 2690 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 2695 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 2705 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  FloatLit ann_ d_
                  {-# LINE 2710 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  FloatLit ann_ d_
                  {-# LINE 2715 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 2720 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_FunCall :: Annotation ->
                          String ->
                          T_ExpressionList  ->
                          T_Expression 
sem_Expression_FunCall ann_ funName_ args_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              _argsOcat :: Catalog
              _argsOlib :: LocalBindings
              _argsIannotatedTree :: ExpressionList
              _argsIoriginalTree :: ExpressionList
              _argsItypeList :: ([Maybe Type])
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2745 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2752 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 2757 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 83, column 9)
              __tup1 =
                  {-# LINE 83 "./TypeChecking/Expressions.ag" #-}
                  either (\e -> (Left e, Nothing)) id $ do
                  args <- mapM lmt _argsItypeList
                  efp <- typeCheckFunCall _lhsIcat
                                          funName_
                                          args
                  let (_,_,r,_) = efp
                  return (Right r, Just efp)
                  {-# LINE 2768 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 83, column 9)
              (_tpe,_) =
                  {-# LINE 83 "./TypeChecking/Expressions.ag" #-}
                  __tup1
                  {-# LINE 2773 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 83, column 9)
              (_,_prototype) =
                  {-# LINE 84 "./TypeChecking/Expressions.ag" #-}
                  __tup1
                  {-# LINE 2778 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 93, column 9)
              _backTree =
                  {-# LINE 93 "./TypeChecking/Expressions.ag" #-}
                  FunCall ann_ funName_ _argsIannotatedTree
                  {-# LINE 2783 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 286, column 7)
              _liftedColumnName =
                  {-# LINE 286 "./TypeChecking/Expressions.ag" #-}
                  if isOperatorName funName_
                  then ""
                  else funName_
                  {-# LINE 2790 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 2800 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  FunCall ann_ funName_ _argsIannotatedTree
                  {-# LINE 2805 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  FunCall ann_ funName_ _argsIoriginalTree
                  {-# LINE 2810 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 2815 "AstInternal.hs" #-}
              -- copy rule (down)
              _argsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 2820 "AstInternal.hs" #-}
              -- copy rule (down)
              _argsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 2825 "AstInternal.hs" #-}
              ( _argsIannotatedTree,_argsIoriginalTree,_argsItypeList) =
                  (args_ _argsOcat _argsOlib )
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_Identifier :: Annotation ->
                             String ->
                             T_Expression 
sem_Expression_Identifier ann_ i_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _ntType :: (E [(String,Type)])
              _lhsOoriginalTree :: Expression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2848 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 2853 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2860 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 2865 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 272, column 9)
              _tpe =
                  {-# LINE 272 "./TypeChecking/Expressions.ag" #-}
                  lbLookupID _lhsIlib i_
                  {-# LINE 2870 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 273, column 9)
              _backTree =
                  {-# LINE 273 "./TypeChecking/Expressions.ag" #-}
                  Identifier ann_ i_
                  {-# LINE 2875 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 275, column 9)
              _ntType =
                  {-# LINE 275 "./TypeChecking/Expressions.ag" #-}
                  let (cor,iden) = splitIdentifier i_
                  in if iden == "*"
                     then lbExpandStar _lhsIlib cor
                     else do
                       t <- lbLookupID _lhsIlib i_
                       return [(iden, t)]
                  {-# LINE 2885 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Identifier ann_ i_
                  {-# LINE 2890 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Identifier ann_ i_
                  {-# LINE 2895 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 2900 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_InPredicate :: Annotation ->
                              T_Expression  ->
                              Bool ->
                              T_InList  ->
                              T_Expression 
sem_Expression_InPredicate ann_ expr_ i_ list_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _listOcat :: Catalog
              _listOlib :: LocalBindings
              _exprIannotatedTree :: Expression
              _exprIntAnnotatedTree :: Expression
              _exprIntType :: ([(String,Type)])
              _exprIoriginalTree :: Expression
              _listIannotatedTree :: InList
              _listIlistType :: (Either [TypeError] Type)
              _listIoriginalTree :: InList
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2933 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 2938 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 2945 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 2950 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 2955 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 2965 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 355, column 9)
              _tpe =
                  {-# LINE 355 "./TypeChecking/Expressions.ag" #-}
                  do
                  lt <- _listIlistType
                  expt <- lmt $ getTypeAnnotation _exprIannotatedTree
                  _ <- resolveResultSetType _lhsIcat [expt, lt]
                  return typeBool
                  {-# LINE 2974 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 360, column 9)
              _backTree =
                  {-# LINE 360 "./TypeChecking/Expressions.ag" #-}
                  InPredicate ann_
                              _exprIannotatedTree
                              i_
                              _listIannotatedTree
                  {-# LINE 2982 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  InPredicate ann_ _exprIannotatedTree i_ _listIannotatedTree
                  {-# LINE 2987 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  InPredicate ann_ _exprIoriginalTree i_ _listIoriginalTree
                  {-# LINE 2992 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 2997 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3002 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3007 "AstInternal.hs" #-}
              -- copy rule (down)
              _listOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3012 "AstInternal.hs" #-}
              -- copy rule (down)
              _listOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3017 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIntAnnotatedTree,_exprIntType,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
              ( _listIannotatedTree,_listIlistType,_listIoriginalTree) =
                  (list_ _listOcat _listOlib )
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_IntegerLit :: Annotation ->
                             Integer ->
                             T_Expression 
sem_Expression_IntegerLit ann_ i_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3041 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 3046 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3053 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 3058 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 47, column 19)
              _tpe =
                  {-# LINE 47 "./TypeChecking/Expressions.ag" #-}
                  Right typeInt
                  {-# LINE 3063 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 56, column 9)
              _backTree =
                  {-# LINE 56 "./TypeChecking/Expressions.ag" #-}
                  IntegerLit ann_ i_
                  {-# LINE 3068 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 3073 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 3083 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  IntegerLit ann_ i_
                  {-# LINE 3088 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  IntegerLit ann_ i_
                  {-# LINE 3093 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3098 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_LiftOperator :: Annotation ->
                               String ->
                               LiftFlavour ->
                               T_ExpressionList  ->
                               T_Expression 
sem_Expression_LiftOperator ann_ oper_ flav_ args_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              _argsOcat :: Catalog
              _argsOlib :: LocalBindings
              _argsIannotatedTree :: ExpressionList
              _argsIoriginalTree :: ExpressionList
              _argsItypeList :: ([Maybe Type])
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3125 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 3130 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3137 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 3142 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 177, column 9)
              _tpe =
                  {-# LINE 177 "./TypeChecking/Expressions.ag" #-}
                  do
                  args <- mapM lmt _argsItypeList
                  let args = _argsIannotatedTree
                  errorWhen (length args /= 2)
                            [AnyAllError $ "must have two args, got " ++ show args]
                  let [a,b] = args
                  aType <- lmt $ getTypeAnnotation a
                  bType <- lmt $ getTypeAnnotation b
                  errorWhen (not $ isArrayType bType)
                            [AnyAllError $ "second arg must be array, got " ++ show args]
                  elemType <- unwrapArray $ bType
                  resType <- fmap (\(_,_,r,_) -> r) $ typeCheckFunCall _lhsIcat
                                                                       oper_
                                                                       [aType,elemType]
                  errorWhen (resType /= typeBool)
                            [AnyAllError $ "operator must have bool return, got " ++ show resType]
                  return resType
                  {-# LINE 3163 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 194, column 9)
              _backTree =
                  {-# LINE 194 "./TypeChecking/Expressions.ag" #-}
                  LiftOperator ann_ oper_ flav_ _argsIannotatedTree
                  {-# LINE 3168 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 3173 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 3183 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  LiftOperator ann_ oper_ flav_ _argsIannotatedTree
                  {-# LINE 3188 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  LiftOperator ann_ oper_ flav_ _argsIoriginalTree
                  {-# LINE 3193 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3198 "AstInternal.hs" #-}
              -- copy rule (down)
              _argsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3203 "AstInternal.hs" #-}
              -- copy rule (down)
              _argsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3208 "AstInternal.hs" #-}
              ( _argsIannotatedTree,_argsIoriginalTree,_argsItypeList) =
                  (args_ _argsOcat _argsOlib )
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_NullLit :: Annotation ->
                          T_Expression 
sem_Expression_NullLit ann_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3229 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 3234 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3241 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 3246 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 52, column 16)
              _tpe =
                  {-# LINE 52 "./TypeChecking/Expressions.ag" #-}
                  Right UnknownType
                  {-# LINE 3251 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 64, column 9)
              _backTree =
                  {-# LINE 64 "./TypeChecking/Expressions.ag" #-}
                  NullLit ann_
                  {-# LINE 3256 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 3261 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 3271 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  NullLit ann_
                  {-# LINE 3276 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  NullLit ann_
                  {-# LINE 3281 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3286 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_Placeholder :: Annotation ->
                              T_Expression 
sem_Expression_Placeholder ann_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3305 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 3310 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3317 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 3322 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 3327 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 3337 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 320, column 9)
              _tpe =
                  {-# LINE 320 "./TypeChecking/Expressions.ag" #-}
                  Right UnknownType
                  {-# LINE 3342 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 321, column 9)
              _backTree =
                  {-# LINE 321 "./TypeChecking/Expressions.ag" #-}
                  Placeholder ann_
                  {-# LINE 3347 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Placeholder ann_
                  {-# LINE 3352 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Placeholder ann_
                  {-# LINE 3357 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3362 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_PositionalArg :: Annotation ->
                                Integer ->
                                T_Expression 
sem_Expression_PositionalArg ann_ p_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3382 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 3387 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3394 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 3399 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 3404 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 3414 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 314, column 9)
              _tpe =
                  {-# LINE 314 "./TypeChecking/Expressions.ag" #-}
                  lbLookupID _lhsIlib ('$':show p_)
                  {-# LINE 3419 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 315, column 9)
              _backTree =
                  {-# LINE 315 "./TypeChecking/Expressions.ag" #-}
                  PositionalArg ann_ p_
                  {-# LINE 3424 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  PositionalArg ann_ p_
                  {-# LINE 3429 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  PositionalArg ann_ p_
                  {-# LINE 3434 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3439 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_ScalarSubQuery :: Annotation ->
                                 T_SelectExpression  ->
                                 T_Expression 
sem_Expression_ScalarSubQuery ann_ sel_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              _selOcat :: Catalog
              _selOlib :: LocalBindings
              _selIannotatedTree :: SelectExpression
              _selIoriginalTree :: SelectExpression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3463 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 3468 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3475 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 3480 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 3485 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 3495 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 338, column 9)
              _tpe =
                  {-# LINE 338 "./TypeChecking/Expressions.ag" #-}
                  do
                  selType <- lmt $ getTypeAnnotation _selIannotatedTree
                  f <- map snd <$> unwrapSetOfComposite selType
                  case length f of
                    0 -> Left [InternalError "no columns in scalar subquery?"]
                    1 -> Right $ head f
                    _ -> Right $ AnonymousRecordType f
                  {-# LINE 3506 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 347, column 9)
              _backTree =
                  {-# LINE 347 "./TypeChecking/Expressions.ag" #-}
                  ScalarSubQuery ann_ _selIannotatedTree
                  {-# LINE 3511 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ScalarSubQuery ann_ _selIannotatedTree
                  {-# LINE 3516 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ScalarSubQuery ann_ _selIoriginalTree
                  {-# LINE 3521 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3526 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3531 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3536 "AstInternal.hs" #-}
              ( _selIannotatedTree,_selIoriginalTree) =
                  (sel_ _selOcat _selOlib )
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_StringLit :: Annotation ->
                            String ->
                            T_Expression 
sem_Expression_StringLit ann_ value_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3558 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 3563 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3570 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 3575 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 48, column 18)
              _tpe =
                  {-# LINE 48 "./TypeChecking/Expressions.ag" #-}
                  Right UnknownType
                  {-# LINE 3580 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 58, column 9)
              _backTree =
                  {-# LINE 58 "./TypeChecking/Expressions.ag" #-}
                  StringLit ann_ value_
                  {-# LINE 3585 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 3590 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 3600 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  StringLit ann_ value_
                  {-# LINE 3605 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  StringLit ann_ value_
                  {-# LINE 3610 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3615 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
sem_Expression_WindowFn :: Annotation ->
                           T_Expression  ->
                           T_ExpressionList  ->
                           T_ExpressionList  ->
                           Direction ->
                           FrameClause ->
                           T_Expression 
sem_Expression_WindowFn ann_ fn_ partitionBy_ orderBy_ dir_ frm_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Expression
              _prototype :: (Maybe FunctionPrototype)
              _lhsOntAnnotatedTree :: Expression
              _lhsOntType :: ([(String,Type)])
              _tpe :: Et
              _lhsOoriginalTree :: Expression
              _fnOcat :: Catalog
              _fnOlib :: LocalBindings
              _partitionByOcat :: Catalog
              _partitionByOlib :: LocalBindings
              _orderByOcat :: Catalog
              _orderByOlib :: LocalBindings
              _fnIannotatedTree :: Expression
              _fnIntAnnotatedTree :: Expression
              _fnIntType :: ([(String,Type)])
              _fnIoriginalTree :: Expression
              _partitionByIannotatedTree :: ExpressionList
              _partitionByIoriginalTree :: ExpressionList
              _partitionByItypeList :: ([Maybe Type])
              _orderByIannotatedTree :: ExpressionList
              _orderByIoriginalTree :: ExpressionList
              _orderByItypeList :: ([Maybe Type])
              -- "./TypeChecking/Expressions.ag"(line 14, column 9)
              _lhsOannotatedTree =
                  {-# LINE 14 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                    (setTypeAddErrorsA _tpe
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3655 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 24, column 9)
              _prototype =
                  {-# LINE 24 "./TypeChecking/Expressions.ag" #-}
                  Nothing
                  {-# LINE 3660 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 31, column 9)
              _lhsOntAnnotatedTree =
                  {-# LINE 31 "./TypeChecking/Expressions.ag" #-}
                  updateAnnotation
                     (setTypeAddErrorsA (either Left (Right . CompositeType) _ntType    )
                     . \a -> a {fnProt = _prototype    }) _backTree
                  {-# LINE 3667 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 34, column 9)
              _lhsOntType =
                  {-# LINE 34 "./TypeChecking/Expressions.ag" #-}
                  either (const []) id _ntType
                  {-# LINE 3672 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 97, column 9)
              _tpe =
                  {-# LINE 97 "./TypeChecking/Expressions.ag" #-}
                  lmt $ getTypeAnnotation _fnIannotatedTree
                  {-# LINE 3677 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 98, column 9)
              _backTree =
                  {-# LINE 98 "./TypeChecking/Expressions.ag" #-}
                  WindowFn ann_
                           _fnIannotatedTree
                           _partitionByIannotatedTree
                           _orderByIannotatedTree
                           dir_
                           frm_
                  {-# LINE 3687 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 297, column 7)
              _liftedColumnName =
                  {-# LINE 297 "./TypeChecking/Expressions.ag" #-}
                  ""
                  {-# LINE 3692 "AstInternal.hs" #-}
              -- "./TypeChecking/Expressions.ag"(line 303, column 7)
              _ntType =
                  {-# LINE 303 "./TypeChecking/Expressions.ag" #-}
                  do
                  t <- _tpe
                  return [(case _liftedColumnName     of
                            "" -> "?column?"
                            n -> n
                         ,t)]
                  {-# LINE 3702 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  WindowFn ann_ _fnIannotatedTree _partitionByIannotatedTree _orderByIannotatedTree dir_ frm_
                  {-# LINE 3707 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  WindowFn ann_ _fnIoriginalTree _partitionByIoriginalTree _orderByIoriginalTree dir_ frm_
                  {-# LINE 3712 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3717 "AstInternal.hs" #-}
              -- copy rule (down)
              _fnOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3722 "AstInternal.hs" #-}
              -- copy rule (down)
              _fnOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3727 "AstInternal.hs" #-}
              -- copy rule (down)
              _partitionByOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3732 "AstInternal.hs" #-}
              -- copy rule (down)
              _partitionByOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3737 "AstInternal.hs" #-}
              -- copy rule (down)
              _orderByOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3742 "AstInternal.hs" #-}
              -- copy rule (down)
              _orderByOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3747 "AstInternal.hs" #-}
              ( _fnIannotatedTree,_fnIntAnnotatedTree,_fnIntType,_fnIoriginalTree) =
                  (fn_ _fnOcat _fnOlib )
              ( _partitionByIannotatedTree,_partitionByIoriginalTree,_partitionByItypeList) =
                  (partitionBy_ _partitionByOcat _partitionByOlib )
              ( _orderByIannotatedTree,_orderByIoriginalTree,_orderByItypeList) =
                  (orderBy_ _orderByOcat _orderByOlib )
          in  ( _lhsOannotatedTree,_lhsOntAnnotatedTree,_lhsOntType,_lhsOoriginalTree)))
-- ExpressionDirectionPair -------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Tuple:
         child x1             : Expression 
         child x2             : {Direction}
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ExpressionDirectionPair  = ( (Expression),(Direction))
-- cata
sem_ExpressionDirectionPair :: ExpressionDirectionPair  ->
                               T_ExpressionDirectionPair 
sem_ExpressionDirectionPair ( x1,x2)  =
    (sem_ExpressionDirectionPair_Tuple (sem_Expression x1 ) x2 )
-- semantic domain
type T_ExpressionDirectionPair  = Catalog ->
                                  LocalBindings ->
                                  ( ExpressionDirectionPair,ExpressionDirectionPair)
data Inh_ExpressionDirectionPair  = Inh_ExpressionDirectionPair {cat_Inh_ExpressionDirectionPair :: Catalog,lib_Inh_ExpressionDirectionPair :: LocalBindings}
data Syn_ExpressionDirectionPair  = Syn_ExpressionDirectionPair {annotatedTree_Syn_ExpressionDirectionPair :: ExpressionDirectionPair,originalTree_Syn_ExpressionDirectionPair :: ExpressionDirectionPair}
wrap_ExpressionDirectionPair :: T_ExpressionDirectionPair  ->
                                Inh_ExpressionDirectionPair  ->
                                Syn_ExpressionDirectionPair 
wrap_ExpressionDirectionPair sem (Inh_ExpressionDirectionPair _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ExpressionDirectionPair _lhsOannotatedTree _lhsOoriginalTree ))
sem_ExpressionDirectionPair_Tuple :: T_Expression  ->
                                     Direction ->
                                     T_ExpressionDirectionPair 
sem_ExpressionDirectionPair_Tuple x1_ x2_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ExpressionDirectionPair
              _lhsOoriginalTree :: ExpressionDirectionPair
              _x1Ocat :: Catalog
              _x1Olib :: LocalBindings
              _x1IannotatedTree :: Expression
              _x1IntAnnotatedTree :: Expression
              _x1IntType :: ([(String,Type)])
              _x1IoriginalTree :: Expression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (_x1IannotatedTree,x2_)
                  {-# LINE 3809 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (_x1IoriginalTree,x2_)
                  {-# LINE 3814 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 3819 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3824 "AstInternal.hs" #-}
              -- copy rule (down)
              _x1Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3829 "AstInternal.hs" #-}
              -- copy rule (down)
              _x1Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3834 "AstInternal.hs" #-}
              ( _x1IannotatedTree,_x1IntAnnotatedTree,_x1IntType,_x1IoriginalTree) =
                  (x1_ _x1Ocat _x1Olib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- ExpressionDirectionPairList ---------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : ExpressionDirectionPair 
         child tl             : ExpressionDirectionPairList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ExpressionDirectionPairList  = [(ExpressionDirectionPair)]
-- cata
sem_ExpressionDirectionPairList :: ExpressionDirectionPairList  ->
                                   T_ExpressionDirectionPairList 
sem_ExpressionDirectionPairList list  =
    (Prelude.foldr sem_ExpressionDirectionPairList_Cons sem_ExpressionDirectionPairList_Nil (Prelude.map sem_ExpressionDirectionPair list) )
-- semantic domain
type T_ExpressionDirectionPairList  = Catalog ->
                                      LocalBindings ->
                                      ( ExpressionDirectionPairList,ExpressionDirectionPairList)
data Inh_ExpressionDirectionPairList  = Inh_ExpressionDirectionPairList {cat_Inh_ExpressionDirectionPairList :: Catalog,lib_Inh_ExpressionDirectionPairList :: LocalBindings}
data Syn_ExpressionDirectionPairList  = Syn_ExpressionDirectionPairList {annotatedTree_Syn_ExpressionDirectionPairList :: ExpressionDirectionPairList,originalTree_Syn_ExpressionDirectionPairList :: ExpressionDirectionPairList}
wrap_ExpressionDirectionPairList :: T_ExpressionDirectionPairList  ->
                                    Inh_ExpressionDirectionPairList  ->
                                    Syn_ExpressionDirectionPairList 
wrap_ExpressionDirectionPairList sem (Inh_ExpressionDirectionPairList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ExpressionDirectionPairList _lhsOannotatedTree _lhsOoriginalTree ))
sem_ExpressionDirectionPairList_Cons :: T_ExpressionDirectionPair  ->
                                        T_ExpressionDirectionPairList  ->
                                        T_ExpressionDirectionPairList 
sem_ExpressionDirectionPairList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ExpressionDirectionPairList
              _lhsOoriginalTree :: ExpressionDirectionPairList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: ExpressionDirectionPair
              _hdIoriginalTree :: ExpressionDirectionPair
              _tlIannotatedTree :: ExpressionDirectionPairList
              _tlIoriginalTree :: ExpressionDirectionPairList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 3898 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 3903 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 3908 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3913 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3918 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3923 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 3928 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 3933 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_ExpressionDirectionPairList_Nil :: T_ExpressionDirectionPairList 
sem_ExpressionDirectionPairList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ExpressionDirectionPairList
              _lhsOoriginalTree :: ExpressionDirectionPairList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 3949 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 3954 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 3959 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 3964 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- ExpressionList ----------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
         typeList             : [Maybe Type]
   alternatives:
      alternative Cons:
         child hd             : Expression 
         child tl             : ExpressionList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ExpressionList  = [(Expression)]
-- cata
sem_ExpressionList :: ExpressionList  ->
                      T_ExpressionList 
sem_ExpressionList list  =
    (Prelude.foldr sem_ExpressionList_Cons sem_ExpressionList_Nil (Prelude.map sem_Expression list) )
-- semantic domain
type T_ExpressionList  = Catalog ->
                         LocalBindings ->
                         ( ExpressionList,ExpressionList,([Maybe Type]))
data Inh_ExpressionList  = Inh_ExpressionList {cat_Inh_ExpressionList :: Catalog,lib_Inh_ExpressionList :: LocalBindings}
data Syn_ExpressionList  = Syn_ExpressionList {annotatedTree_Syn_ExpressionList :: ExpressionList,originalTree_Syn_ExpressionList :: ExpressionList,typeList_Syn_ExpressionList :: [Maybe Type]}
wrap_ExpressionList :: T_ExpressionList  ->
                       Inh_ExpressionList  ->
                       Syn_ExpressionList 
wrap_ExpressionList sem (Inh_ExpressionList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOtypeList) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ExpressionList _lhsOannotatedTree _lhsOoriginalTree _lhsOtypeList ))
sem_ExpressionList_Cons :: T_Expression  ->
                           T_ExpressionList  ->
                           T_ExpressionList 
sem_ExpressionList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOtypeList :: ([Maybe Type])
              _lhsOannotatedTree :: ExpressionList
              _lhsOoriginalTree :: ExpressionList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: Expression
              _hdIntAnnotatedTree :: Expression
              _hdIntType :: ([(String,Type)])
              _hdIoriginalTree :: Expression
              _tlIannotatedTree :: ExpressionList
              _tlIoriginalTree :: ExpressionList
              _tlItypeList :: ([Maybe Type])
              -- "./TypeChecking/Misc.ag"(line 49, column 12)
              _lhsOtypeList =
                  {-# LINE 49 "./TypeChecking/Misc.ag" #-}
                  getTypeAnnotation _hdIannotatedTree : _tlItypeList
                  {-# LINE 4031 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 4036 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 4041 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4046 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4051 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4056 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4061 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4066 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4071 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIntAnnotatedTree,_hdIntType,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree,_tlItypeList) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOtypeList)))
sem_ExpressionList_Nil :: T_ExpressionList 
sem_ExpressionList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOtypeList :: ([Maybe Type])
              _lhsOannotatedTree :: ExpressionList
              _lhsOoriginalTree :: ExpressionList
              -- "./TypeChecking/Misc.ag"(line 50, column 11)
              _lhsOtypeList =
                  {-# LINE 50 "./TypeChecking/Misc.ag" #-}
                  []
                  {-# LINE 4088 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 4093 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 4098 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4103 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4108 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOtypeList)))
-- ExpressionListList ------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
         typeListList         : [[Maybe Type]]
   alternatives:
      alternative Cons:
         child hd             : ExpressionList 
         child tl             : ExpressionListList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ExpressionListList  = [(ExpressionList)]
-- cata
sem_ExpressionListList :: ExpressionListList  ->
                          T_ExpressionListList 
sem_ExpressionListList list  =
    (Prelude.foldr sem_ExpressionListList_Cons sem_ExpressionListList_Nil (Prelude.map sem_ExpressionList list) )
-- semantic domain
type T_ExpressionListList  = Catalog ->
                             LocalBindings ->
                             ( ExpressionListList,ExpressionListList,([[Maybe Type]]))
data Inh_ExpressionListList  = Inh_ExpressionListList {cat_Inh_ExpressionListList :: Catalog,lib_Inh_ExpressionListList :: LocalBindings}
data Syn_ExpressionListList  = Syn_ExpressionListList {annotatedTree_Syn_ExpressionListList :: ExpressionListList,originalTree_Syn_ExpressionListList :: ExpressionListList,typeListList_Syn_ExpressionListList :: [[Maybe Type]]}
wrap_ExpressionListList :: T_ExpressionListList  ->
                           Inh_ExpressionListList  ->
                           Syn_ExpressionListList 
wrap_ExpressionListList sem (Inh_ExpressionListList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOtypeListList) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ExpressionListList _lhsOannotatedTree _lhsOoriginalTree _lhsOtypeListList ))
sem_ExpressionListList_Cons :: T_ExpressionList  ->
                               T_ExpressionListList  ->
                               T_ExpressionListList 
sem_ExpressionListList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOtypeListList :: ([[Maybe Type]])
              _lhsOannotatedTree :: ExpressionListList
              _lhsOoriginalTree :: ExpressionListList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: ExpressionList
              _hdIoriginalTree :: ExpressionList
              _hdItypeList :: ([Maybe Type])
              _tlIannotatedTree :: ExpressionListList
              _tlIoriginalTree :: ExpressionListList
              _tlItypeListList :: ([[Maybe Type]])
              -- "./TypeChecking/Misc.ag"(line 56, column 12)
              _lhsOtypeListList =
                  {-# LINE 56 "./TypeChecking/Misc.ag" #-}
                  _hdItypeList : _tlItypeListList
                  {-# LINE 4174 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 4179 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 4184 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4189 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4194 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4199 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4204 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4209 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4214 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIoriginalTree,_hdItypeList) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree,_tlItypeListList) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOtypeListList)))
sem_ExpressionListList_Nil :: T_ExpressionListList 
sem_ExpressionListList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOtypeListList :: ([[Maybe Type]])
              _lhsOannotatedTree :: ExpressionListList
              _lhsOoriginalTree :: ExpressionListList
              -- "./TypeChecking/Misc.ag"(line 57, column 11)
              _lhsOtypeListList =
                  {-# LINE 57 "./TypeChecking/Misc.ag" #-}
                  []
                  {-# LINE 4231 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 4236 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 4241 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4246 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4251 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOtypeListList)))
-- ExpressionListStatementListPair -----------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Tuple:
         child x1             : ExpressionList 
         child x2             : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ExpressionListStatementListPair  = ( (ExpressionList),(StatementList))
-- cata
sem_ExpressionListStatementListPair :: ExpressionListStatementListPair  ->
                                       T_ExpressionListStatementListPair 
sem_ExpressionListStatementListPair ( x1,x2)  =
    (sem_ExpressionListStatementListPair_Tuple (sem_ExpressionList x1 ) (sem_StatementList x2 ) )
-- semantic domain
type T_ExpressionListStatementListPair  = Catalog ->
                                          LocalBindings ->
                                          ( ExpressionListStatementListPair,ExpressionListStatementListPair)
data Inh_ExpressionListStatementListPair  = Inh_ExpressionListStatementListPair {cat_Inh_ExpressionListStatementListPair :: Catalog,lib_Inh_ExpressionListStatementListPair :: LocalBindings}
data Syn_ExpressionListStatementListPair  = Syn_ExpressionListStatementListPair {annotatedTree_Syn_ExpressionListStatementListPair :: ExpressionListStatementListPair,originalTree_Syn_ExpressionListStatementListPair :: ExpressionListStatementListPair}
wrap_ExpressionListStatementListPair :: T_ExpressionListStatementListPair  ->
                                        Inh_ExpressionListStatementListPair  ->
                                        Syn_ExpressionListStatementListPair 
wrap_ExpressionListStatementListPair sem (Inh_ExpressionListStatementListPair _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ExpressionListStatementListPair _lhsOannotatedTree _lhsOoriginalTree ))
sem_ExpressionListStatementListPair_Tuple :: T_ExpressionList  ->
                                             T_StatementList  ->
                                             T_ExpressionListStatementListPair 
sem_ExpressionListStatementListPair_Tuple x1_ x2_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _x2OcatUpdates :: ([CatalogUpdate])
              _x2OlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: ExpressionListStatementListPair
              _lhsOoriginalTree :: ExpressionListStatementListPair
              _x1Ocat :: Catalog
              _x1Olib :: LocalBindings
              _x2Ocat :: Catalog
              _x2Olib :: LocalBindings
              _x1IannotatedTree :: ExpressionList
              _x1IoriginalTree :: ExpressionList
              _x1ItypeList :: ([Maybe Type])
              _x2IannotatedTree :: StatementList
              _x2IoriginalTree :: StatementList
              _x2IproducedCat :: Catalog
              _x2IproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 111, column 9)
              _x2OcatUpdates =
                  {-# LINE 111 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 4314 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 112, column 9)
              _x2OlibUpdates =
                  {-# LINE 112 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 4319 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (_x1IannotatedTree,_x2IannotatedTree)
                  {-# LINE 4324 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (_x1IoriginalTree,_x2IoriginalTree)
                  {-# LINE 4329 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4334 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4339 "AstInternal.hs" #-}
              -- copy rule (down)
              _x1Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4344 "AstInternal.hs" #-}
              -- copy rule (down)
              _x1Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4349 "AstInternal.hs" #-}
              -- copy rule (down)
              _x2Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4354 "AstInternal.hs" #-}
              -- copy rule (down)
              _x2Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4359 "AstInternal.hs" #-}
              ( _x1IannotatedTree,_x1IoriginalTree,_x1ItypeList) =
                  (x1_ _x1Ocat _x1Olib )
              ( _x2IannotatedTree,_x2IoriginalTree,_x2IproducedCat,_x2IproducedLib) =
                  (x2_ _x2Ocat _x2OcatUpdates _x2Olib _x2OlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- ExpressionListStatementListPairList -------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : ExpressionListStatementListPair 
         child tl             : ExpressionListStatementListPairList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ExpressionListStatementListPairList  = [(ExpressionListStatementListPair)]
-- cata
sem_ExpressionListStatementListPairList :: ExpressionListStatementListPairList  ->
                                           T_ExpressionListStatementListPairList 
sem_ExpressionListStatementListPairList list  =
    (Prelude.foldr sem_ExpressionListStatementListPairList_Cons sem_ExpressionListStatementListPairList_Nil (Prelude.map sem_ExpressionListStatementListPair list) )
-- semantic domain
type T_ExpressionListStatementListPairList  = Catalog ->
                                              LocalBindings ->
                                              ( ExpressionListStatementListPairList,ExpressionListStatementListPairList)
data Inh_ExpressionListStatementListPairList  = Inh_ExpressionListStatementListPairList {cat_Inh_ExpressionListStatementListPairList :: Catalog,lib_Inh_ExpressionListStatementListPairList :: LocalBindings}
data Syn_ExpressionListStatementListPairList  = Syn_ExpressionListStatementListPairList {annotatedTree_Syn_ExpressionListStatementListPairList :: ExpressionListStatementListPairList,originalTree_Syn_ExpressionListStatementListPairList :: ExpressionListStatementListPairList}
wrap_ExpressionListStatementListPairList :: T_ExpressionListStatementListPairList  ->
                                            Inh_ExpressionListStatementListPairList  ->
                                            Syn_ExpressionListStatementListPairList 
wrap_ExpressionListStatementListPairList sem (Inh_ExpressionListStatementListPairList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ExpressionListStatementListPairList _lhsOannotatedTree _lhsOoriginalTree ))
sem_ExpressionListStatementListPairList_Cons :: T_ExpressionListStatementListPair  ->
                                                T_ExpressionListStatementListPairList  ->
                                                T_ExpressionListStatementListPairList 
sem_ExpressionListStatementListPairList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ExpressionListStatementListPairList
              _lhsOoriginalTree :: ExpressionListStatementListPairList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: ExpressionListStatementListPair
              _hdIoriginalTree :: ExpressionListStatementListPair
              _tlIannotatedTree :: ExpressionListStatementListPairList
              _tlIoriginalTree :: ExpressionListStatementListPairList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 4425 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 4430 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4435 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4440 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4445 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4450 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4455 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4460 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_ExpressionListStatementListPairList_Nil :: T_ExpressionListStatementListPairList 
sem_ExpressionListStatementListPairList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ExpressionListStatementListPairList
              _lhsOoriginalTree :: ExpressionListStatementListPairList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 4476 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 4481 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4486 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4491 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- ExpressionRoot ----------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative ExpressionRoot:
         child expr           : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data ExpressionRoot  = ExpressionRoot (Expression) 
                     deriving ( Show)
-- cata
sem_ExpressionRoot :: ExpressionRoot  ->
                      T_ExpressionRoot 
sem_ExpressionRoot (ExpressionRoot _expr )  =
    (sem_ExpressionRoot_ExpressionRoot (sem_Expression _expr ) )
-- semantic domain
type T_ExpressionRoot  = Catalog ->
                         LocalBindings ->
                         ( ExpressionRoot,ExpressionRoot)
data Inh_ExpressionRoot  = Inh_ExpressionRoot {cat_Inh_ExpressionRoot :: Catalog,lib_Inh_ExpressionRoot :: LocalBindings}
data Syn_ExpressionRoot  = Syn_ExpressionRoot {annotatedTree_Syn_ExpressionRoot :: ExpressionRoot,originalTree_Syn_ExpressionRoot :: ExpressionRoot}
wrap_ExpressionRoot :: T_ExpressionRoot  ->
                       Inh_ExpressionRoot  ->
                       Syn_ExpressionRoot 
wrap_ExpressionRoot sem (Inh_ExpressionRoot _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ExpressionRoot _lhsOannotatedTree _lhsOoriginalTree ))
sem_ExpressionRoot_ExpressionRoot :: T_Expression  ->
                                     T_ExpressionRoot 
sem_ExpressionRoot_ExpressionRoot expr_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ExpressionRoot
              _lhsOoriginalTree :: ExpressionRoot
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _exprIannotatedTree :: Expression
              _exprIntAnnotatedTree :: Expression
              _exprIntType :: ([(String,Type)])
              _exprIoriginalTree :: Expression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ExpressionRoot _exprIannotatedTree
                  {-# LINE 4546 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ExpressionRoot _exprIoriginalTree
                  {-# LINE 4551 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4556 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4561 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4566 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4571 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIntAnnotatedTree,_exprIntType,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- ExpressionStatementListPair ---------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Tuple:
         child x1             : Expression 
         child x2             : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ExpressionStatementListPair  = ( (Expression),(StatementList))
-- cata
sem_ExpressionStatementListPair :: ExpressionStatementListPair  ->
                                   T_ExpressionStatementListPair 
sem_ExpressionStatementListPair ( x1,x2)  =
    (sem_ExpressionStatementListPair_Tuple (sem_Expression x1 ) (sem_StatementList x2 ) )
-- semantic domain
type T_ExpressionStatementListPair  = Catalog ->
                                      LocalBindings ->
                                      ( ExpressionStatementListPair,ExpressionStatementListPair)
data Inh_ExpressionStatementListPair  = Inh_ExpressionStatementListPair {cat_Inh_ExpressionStatementListPair :: Catalog,lib_Inh_ExpressionStatementListPair :: LocalBindings}
data Syn_ExpressionStatementListPair  = Syn_ExpressionStatementListPair {annotatedTree_Syn_ExpressionStatementListPair :: ExpressionStatementListPair,originalTree_Syn_ExpressionStatementListPair :: ExpressionStatementListPair}
wrap_ExpressionStatementListPair :: T_ExpressionStatementListPair  ->
                                    Inh_ExpressionStatementListPair  ->
                                    Syn_ExpressionStatementListPair 
wrap_ExpressionStatementListPair sem (Inh_ExpressionStatementListPair _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ExpressionStatementListPair _lhsOannotatedTree _lhsOoriginalTree ))
sem_ExpressionStatementListPair_Tuple :: T_Expression  ->
                                         T_StatementList  ->
                                         T_ExpressionStatementListPair 
sem_ExpressionStatementListPair_Tuple x1_ x2_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _x2OcatUpdates :: ([CatalogUpdate])
              _x2OlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: ExpressionStatementListPair
              _lhsOoriginalTree :: ExpressionStatementListPair
              _x1Ocat :: Catalog
              _x1Olib :: LocalBindings
              _x2Ocat :: Catalog
              _x2Olib :: LocalBindings
              _x1IannotatedTree :: Expression
              _x1IntAnnotatedTree :: Expression
              _x1IntType :: ([(String,Type)])
              _x1IoriginalTree :: Expression
              _x2IannotatedTree :: StatementList
              _x2IoriginalTree :: StatementList
              _x2IproducedCat :: Catalog
              _x2IproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 115, column 9)
              _x2OcatUpdates =
                  {-# LINE 115 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 4637 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 116, column 9)
              _x2OlibUpdates =
                  {-# LINE 116 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 4642 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (_x1IannotatedTree,_x2IannotatedTree)
                  {-# LINE 4647 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (_x1IoriginalTree,_x2IoriginalTree)
                  {-# LINE 4652 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4657 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4662 "AstInternal.hs" #-}
              -- copy rule (down)
              _x1Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4667 "AstInternal.hs" #-}
              -- copy rule (down)
              _x1Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4672 "AstInternal.hs" #-}
              -- copy rule (down)
              _x2Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4677 "AstInternal.hs" #-}
              -- copy rule (down)
              _x2Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4682 "AstInternal.hs" #-}
              ( _x1IannotatedTree,_x1IntAnnotatedTree,_x1IntType,_x1IoriginalTree) =
                  (x1_ _x1Ocat _x1Olib )
              ( _x2IannotatedTree,_x2IoriginalTree,_x2IproducedCat,_x2IproducedLib) =
                  (x2_ _x2Ocat _x2OcatUpdates _x2Olib _x2OlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- ExpressionStatementListPairList -----------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : ExpressionStatementListPair 
         child tl             : ExpressionStatementListPairList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ExpressionStatementListPairList  = [(ExpressionStatementListPair)]
-- cata
sem_ExpressionStatementListPairList :: ExpressionStatementListPairList  ->
                                       T_ExpressionStatementListPairList 
sem_ExpressionStatementListPairList list  =
    (Prelude.foldr sem_ExpressionStatementListPairList_Cons sem_ExpressionStatementListPairList_Nil (Prelude.map sem_ExpressionStatementListPair list) )
-- semantic domain
type T_ExpressionStatementListPairList  = Catalog ->
                                          LocalBindings ->
                                          ( ExpressionStatementListPairList,ExpressionStatementListPairList)
data Inh_ExpressionStatementListPairList  = Inh_ExpressionStatementListPairList {cat_Inh_ExpressionStatementListPairList :: Catalog,lib_Inh_ExpressionStatementListPairList :: LocalBindings}
data Syn_ExpressionStatementListPairList  = Syn_ExpressionStatementListPairList {annotatedTree_Syn_ExpressionStatementListPairList :: ExpressionStatementListPairList,originalTree_Syn_ExpressionStatementListPairList :: ExpressionStatementListPairList}
wrap_ExpressionStatementListPairList :: T_ExpressionStatementListPairList  ->
                                        Inh_ExpressionStatementListPairList  ->
                                        Syn_ExpressionStatementListPairList 
wrap_ExpressionStatementListPairList sem (Inh_ExpressionStatementListPairList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_ExpressionStatementListPairList _lhsOannotatedTree _lhsOoriginalTree ))
sem_ExpressionStatementListPairList_Cons :: T_ExpressionStatementListPair  ->
                                            T_ExpressionStatementListPairList  ->
                                            T_ExpressionStatementListPairList 
sem_ExpressionStatementListPairList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ExpressionStatementListPairList
              _lhsOoriginalTree :: ExpressionStatementListPairList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: ExpressionStatementListPair
              _hdIoriginalTree :: ExpressionStatementListPair
              _tlIannotatedTree :: ExpressionStatementListPairList
              _tlIoriginalTree :: ExpressionStatementListPairList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 4748 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 4753 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4758 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4763 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4768 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4773 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4778 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4783 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_ExpressionStatementListPairList_Nil :: T_ExpressionStatementListPairList 
sem_ExpressionStatementListPairList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: ExpressionStatementListPairList
              _lhsOoriginalTree :: ExpressionStatementListPairList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 4799 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 4804 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4809 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4814 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- FnBody ------------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative PlpgsqlFnBody:
         child ann            : {Annotation}
         child vars           : VarDefList 
         child sts            : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative SqlFnBody:
         child ann            : {Annotation}
         child sts            : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data FnBody  = PlpgsqlFnBody (Annotation) (VarDefList) (StatementList) 
             | SqlFnBody (Annotation) (StatementList) 
             deriving ( Data,Eq,Show,Typeable)
-- cata
sem_FnBody :: FnBody  ->
              T_FnBody 
sem_FnBody (PlpgsqlFnBody _ann _vars _sts )  =
    (sem_FnBody_PlpgsqlFnBody _ann (sem_VarDefList _vars ) (sem_StatementList _sts ) )
sem_FnBody (SqlFnBody _ann _sts )  =
    (sem_FnBody_SqlFnBody _ann (sem_StatementList _sts ) )
-- semantic domain
type T_FnBody  = Catalog ->
                 LocalBindings ->
                 ( FnBody,FnBody)
data Inh_FnBody  = Inh_FnBody {cat_Inh_FnBody :: Catalog,lib_Inh_FnBody :: LocalBindings}
data Syn_FnBody  = Syn_FnBody {annotatedTree_Syn_FnBody :: FnBody,originalTree_Syn_FnBody :: FnBody}
wrap_FnBody :: T_FnBody  ->
               Inh_FnBody  ->
               Syn_FnBody 
wrap_FnBody sem (Inh_FnBody _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_FnBody _lhsOannotatedTree _lhsOoriginalTree ))
sem_FnBody_PlpgsqlFnBody :: Annotation ->
                            T_VarDefList  ->
                            T_StatementList  ->
                            T_FnBody 
sem_FnBody_PlpgsqlFnBody ann_ vars_ sts_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _stsOcatUpdates :: ([CatalogUpdate])
              _stsOlibUpdates :: ([LocalBindingsUpdate])
              _stsOlib :: LocalBindings
              _lhsOannotatedTree :: FnBody
              _lhsOoriginalTree :: FnBody
              _varsOcat :: Catalog
              _varsOlib :: LocalBindings
              _stsOcat :: Catalog
              _varsIannotatedTree :: VarDefList
              _varsIdefs :: ([(String,Maybe Type)])
              _varsIoriginalTree :: VarDefList
              _stsIannotatedTree :: StatementList
              _stsIoriginalTree :: StatementList
              _stsIproducedCat :: Catalog
              _stsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 119, column 9)
              _stsOcatUpdates =
                  {-# LINE 119 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 4889 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 120, column 9)
              _stsOlibUpdates =
                  {-# LINE 120 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 4894 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 109, column 9)
              _stsOlib =
                  {-# LINE 109 "./TypeChecking/CreateFunction.ag" #-}
                  fromRight _lhsIlib $
                  lbUpdate _lhsIcat
                           (LBIds "declarations" "" (mapMaybe lv _varsIdefs) [])
                           _lhsIlib
                  where
                    lv (s,Nothing) = Nothing
                    lv (s,Just t) = Just (s,t)
                  {-# LINE 4905 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  PlpgsqlFnBody ann_ _varsIannotatedTree _stsIannotatedTree
                  {-# LINE 4910 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  PlpgsqlFnBody ann_ _varsIoriginalTree _stsIoriginalTree
                  {-# LINE 4915 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4920 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4925 "AstInternal.hs" #-}
              -- copy rule (down)
              _varsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4930 "AstInternal.hs" #-}
              -- copy rule (down)
              _varsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 4935 "AstInternal.hs" #-}
              -- copy rule (down)
              _stsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4940 "AstInternal.hs" #-}
              ( _varsIannotatedTree,_varsIdefs,_varsIoriginalTree) =
                  (vars_ _varsOcat _varsOlib )
              ( _stsIannotatedTree,_stsIoriginalTree,_stsIproducedCat,_stsIproducedLib) =
                  (sts_ _stsOcat _stsOcatUpdates _stsOlib _stsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_FnBody_SqlFnBody :: Annotation ->
                        T_StatementList  ->
                        T_FnBody 
sem_FnBody_SqlFnBody ann_ sts_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _stsOcatUpdates :: ([CatalogUpdate])
              _stsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: FnBody
              _lhsOoriginalTree :: FnBody
              _stsOcat :: Catalog
              _stsOlib :: LocalBindings
              _stsIannotatedTree :: StatementList
              _stsIoriginalTree :: StatementList
              _stsIproducedCat :: Catalog
              _stsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 119, column 9)
              _stsOcatUpdates =
                  {-# LINE 119 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 4966 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 120, column 9)
              _stsOlibUpdates =
                  {-# LINE 120 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 4971 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  SqlFnBody ann_ _stsIannotatedTree
                  {-# LINE 4976 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  SqlFnBody ann_ _stsIoriginalTree
                  {-# LINE 4981 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 4986 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 4991 "AstInternal.hs" #-}
              -- copy rule (down)
              _stsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 4996 "AstInternal.hs" #-}
              -- copy rule (down)
              _stsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5001 "AstInternal.hs" #-}
              ( _stsIannotatedTree,_stsIoriginalTree,_stsIproducedCat,_stsIproducedLib) =
                  (sts_ _stsOcat _stsOcatUpdates _stsOlib _stsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- InList ------------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         listType             : Either [TypeError] Type
         originalTree         : SELF 
   alternatives:
      alternative InList:
         child ann            : {Annotation}
         child exprs          : ExpressionList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative InSelect:
         child ann            : {Annotation}
         child sel            : SelectExpression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data InList  = InList (Annotation) (ExpressionList) 
             | InSelect (Annotation) (SelectExpression) 
             deriving ( Data,Eq,Show,Typeable)
-- cata
sem_InList :: InList  ->
              T_InList 
sem_InList (InList _ann _exprs )  =
    (sem_InList_InList _ann (sem_ExpressionList _exprs ) )
sem_InList (InSelect _ann _sel )  =
    (sem_InList_InSelect _ann (sem_SelectExpression _sel ) )
-- semantic domain
type T_InList  = Catalog ->
                 LocalBindings ->
                 ( InList,(Either [TypeError] Type),InList)
data Inh_InList  = Inh_InList {cat_Inh_InList :: Catalog,lib_Inh_InList :: LocalBindings}
data Syn_InList  = Syn_InList {annotatedTree_Syn_InList :: InList,listType_Syn_InList :: Either [TypeError] Type,originalTree_Syn_InList :: InList}
wrap_InList :: T_InList  ->
               Inh_InList  ->
               Syn_InList 
wrap_InList sem (Inh_InList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_InList _lhsOannotatedTree _lhsOlistType _lhsOoriginalTree ))
sem_InList_InList :: Annotation ->
                     T_ExpressionList  ->
                     T_InList 
sem_InList_InList ann_ exprs_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOlistType :: (Either [TypeError] Type)
              _lhsOannotatedTree :: InList
              _lhsOoriginalTree :: InList
              _exprsOcat :: Catalog
              _exprsOlib :: LocalBindings
              _exprsIannotatedTree :: ExpressionList
              _exprsIoriginalTree :: ExpressionList
              _exprsItypeList :: ([Maybe Type])
              -- "./TypeChecking/Expressions.ag"(line 370, column 9)
              _lhsOlistType =
                  {-# LINE 370 "./TypeChecking/Expressions.ag" #-}
                  mapM lmt _exprsItypeList >>= resolveResultSetType _lhsIcat
                  {-# LINE 5070 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  InList ann_ _exprsIannotatedTree
                  {-# LINE 5075 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  InList ann_ _exprsIoriginalTree
                  {-# LINE 5080 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5085 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5090 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 5095 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5100 "AstInternal.hs" #-}
              ( _exprsIannotatedTree,_exprsIoriginalTree,_exprsItypeList) =
                  (exprs_ _exprsOcat _exprsOlib )
          in  ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree)))
sem_InList_InSelect :: Annotation ->
                       T_SelectExpression  ->
                       T_InList 
sem_InList_InSelect ann_ sel_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOlistType :: (Either [TypeError] Type)
              _lhsOannotatedTree :: InList
              _lhsOoriginalTree :: InList
              _selOcat :: Catalog
              _selOlib :: LocalBindings
              _selIannotatedTree :: SelectExpression
              _selIoriginalTree :: SelectExpression
              -- "./TypeChecking/Expressions.ag"(line 372, column 9)
              _lhsOlistType =
                  {-# LINE 372 "./TypeChecking/Expressions.ag" #-}
                  do
                  st <- lmt $ getTypeAnnotation _selIannotatedTree
                  attrs <- map snd <$> unwrapSetOfComposite st
                  case length attrs of
                            0 -> Left [InternalError
                                       "got subquery with no columns? in inselect"]
                            1 -> Right $ head attrs
                            _ -> Right $ AnonymousRecordType attrs
                  {-# LINE 5128 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  InSelect ann_ _selIannotatedTree
                  {-# LINE 5133 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  InSelect ann_ _selIoriginalTree
                  {-# LINE 5138 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5143 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5148 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 5153 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5158 "AstInternal.hs" #-}
              ( _selIannotatedTree,_selIoriginalTree) =
                  (sel_ _selOcat _selOlib )
          in  ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree)))
-- JoinExpression ----------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative JoinOn:
         child ann            : {Annotation}
         child expression     : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative JoinUsing:
         child ann            : {Annotation}
         child x              : {[String]}
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data JoinExpression  = JoinOn (Annotation) (Expression) 
                     | JoinUsing (Annotation) ([String]) 
                     deriving ( Data,Eq,Show,Typeable)
-- cata
sem_JoinExpression :: JoinExpression  ->
                      T_JoinExpression 
sem_JoinExpression (JoinOn _ann _expression )  =
    (sem_JoinExpression_JoinOn _ann (sem_Expression _expression ) )
sem_JoinExpression (JoinUsing _ann _x )  =
    (sem_JoinExpression_JoinUsing _ann _x )
-- semantic domain
type T_JoinExpression  = Catalog ->
                         LocalBindings ->
                         ( JoinExpression,JoinExpression)
data Inh_JoinExpression  = Inh_JoinExpression {cat_Inh_JoinExpression :: Catalog,lib_Inh_JoinExpression :: LocalBindings}
data Syn_JoinExpression  = Syn_JoinExpression {annotatedTree_Syn_JoinExpression :: JoinExpression,originalTree_Syn_JoinExpression :: JoinExpression}
wrap_JoinExpression :: T_JoinExpression  ->
                       Inh_JoinExpression  ->
                       Syn_JoinExpression 
wrap_JoinExpression sem (Inh_JoinExpression _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_JoinExpression _lhsOannotatedTree _lhsOoriginalTree ))
sem_JoinExpression_JoinOn :: Annotation ->
                             T_Expression  ->
                             T_JoinExpression 
sem_JoinExpression_JoinOn ann_ expression_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: JoinExpression
              _lhsOoriginalTree :: JoinExpression
              _expressionOcat :: Catalog
              _expressionOlib :: LocalBindings
              _expressionIannotatedTree :: Expression
              _expressionIntAnnotatedTree :: Expression
              _expressionIntType :: ([(String,Type)])
              _expressionIoriginalTree :: Expression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  JoinOn ann_ _expressionIannotatedTree
                  {-# LINE 5226 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  JoinOn ann_ _expressionIoriginalTree
                  {-# LINE 5231 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5236 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5241 "AstInternal.hs" #-}
              -- copy rule (down)
              _expressionOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 5246 "AstInternal.hs" #-}
              -- copy rule (down)
              _expressionOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5251 "AstInternal.hs" #-}
              ( _expressionIannotatedTree,_expressionIntAnnotatedTree,_expressionIntType,_expressionIoriginalTree) =
                  (expression_ _expressionOcat _expressionOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_JoinExpression_JoinUsing :: Annotation ->
                                ([String]) ->
                                T_JoinExpression 
sem_JoinExpression_JoinUsing ann_ x_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: JoinExpression
              _lhsOoriginalTree :: JoinExpression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  JoinUsing ann_ x_
                  {-# LINE 5267 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  JoinUsing ann_ x_
                  {-# LINE 5272 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5277 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5282 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- MaybeBoolExpression -----------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Just:
         child just           : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nothing:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type MaybeBoolExpression  = (Maybe (Expression))
-- cata
sem_MaybeBoolExpression :: MaybeBoolExpression  ->
                           T_MaybeBoolExpression 
sem_MaybeBoolExpression (Prelude.Just x )  =
    (sem_MaybeBoolExpression_Just (sem_Expression x ) )
sem_MaybeBoolExpression Prelude.Nothing  =
    sem_MaybeBoolExpression_Nothing
-- semantic domain
type T_MaybeBoolExpression  = Catalog ->
                              LocalBindings ->
                              ( MaybeBoolExpression,MaybeBoolExpression)
data Inh_MaybeBoolExpression  = Inh_MaybeBoolExpression {cat_Inh_MaybeBoolExpression :: Catalog,lib_Inh_MaybeBoolExpression :: LocalBindings}
data Syn_MaybeBoolExpression  = Syn_MaybeBoolExpression {annotatedTree_Syn_MaybeBoolExpression :: MaybeBoolExpression,originalTree_Syn_MaybeBoolExpression :: MaybeBoolExpression}
wrap_MaybeBoolExpression :: T_MaybeBoolExpression  ->
                            Inh_MaybeBoolExpression  ->
                            Syn_MaybeBoolExpression 
wrap_MaybeBoolExpression sem (Inh_MaybeBoolExpression _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_MaybeBoolExpression _lhsOannotatedTree _lhsOoriginalTree ))
sem_MaybeBoolExpression_Just :: T_Expression  ->
                                T_MaybeBoolExpression 
sem_MaybeBoolExpression_Just just_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: MaybeBoolExpression
              _lhsOoriginalTree :: MaybeBoolExpression
              _justOcat :: Catalog
              _justOlib :: LocalBindings
              _justIannotatedTree :: Expression
              _justIntAnnotatedTree :: Expression
              _justIntType :: ([(String,Type)])
              _justIoriginalTree :: Expression
              -- "./TypeChecking/Misc.ag"(line 71, column 9)
              _lhsOannotatedTree =
                  {-# LINE 71 "./TypeChecking/Misc.ag" #-}
                  let t = getTypeAnnotation _justIannotatedTree
                  in if t `elem` [Nothing,Just typeBool]
                     then Just _justIannotatedTree
                     else Just $ addTypeErrors [ExpressionMustBeBool] _justIannotatedTree
                  {-# LINE 5345 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Just _justIannotatedTree
                  {-# LINE 5350 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Just _justIoriginalTree
                  {-# LINE 5355 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5360 "AstInternal.hs" #-}
              -- copy rule (down)
              _justOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 5365 "AstInternal.hs" #-}
              -- copy rule (down)
              _justOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5370 "AstInternal.hs" #-}
              ( _justIannotatedTree,_justIntAnnotatedTree,_justIntType,_justIoriginalTree) =
                  (just_ _justOcat _justOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_MaybeBoolExpression_Nothing :: T_MaybeBoolExpression 
sem_MaybeBoolExpression_Nothing  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: MaybeBoolExpression
              _lhsOoriginalTree :: MaybeBoolExpression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Nothing
                  {-# LINE 5384 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Nothing
                  {-# LINE 5389 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5394 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5399 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- MaybeExpression ---------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Just:
         child just           : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nothing:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type MaybeExpression  = (Maybe (Expression))
-- cata
sem_MaybeExpression :: MaybeExpression  ->
                       T_MaybeExpression 
sem_MaybeExpression (Prelude.Just x )  =
    (sem_MaybeExpression_Just (sem_Expression x ) )
sem_MaybeExpression Prelude.Nothing  =
    sem_MaybeExpression_Nothing
-- semantic domain
type T_MaybeExpression  = Catalog ->
                          LocalBindings ->
                          ( MaybeExpression,MaybeExpression)
data Inh_MaybeExpression  = Inh_MaybeExpression {cat_Inh_MaybeExpression :: Catalog,lib_Inh_MaybeExpression :: LocalBindings}
data Syn_MaybeExpression  = Syn_MaybeExpression {annotatedTree_Syn_MaybeExpression :: MaybeExpression,originalTree_Syn_MaybeExpression :: MaybeExpression}
wrap_MaybeExpression :: T_MaybeExpression  ->
                        Inh_MaybeExpression  ->
                        Syn_MaybeExpression 
wrap_MaybeExpression sem (Inh_MaybeExpression _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_MaybeExpression _lhsOannotatedTree _lhsOoriginalTree ))
sem_MaybeExpression_Just :: T_Expression  ->
                            T_MaybeExpression 
sem_MaybeExpression_Just just_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: MaybeExpression
              _lhsOoriginalTree :: MaybeExpression
              _justOcat :: Catalog
              _justOlib :: LocalBindings
              _justIannotatedTree :: Expression
              _justIntAnnotatedTree :: Expression
              _justIntType :: ([(String,Type)])
              _justIoriginalTree :: Expression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Just _justIannotatedTree
                  {-# LINE 5459 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Just _justIoriginalTree
                  {-# LINE 5464 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5469 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5474 "AstInternal.hs" #-}
              -- copy rule (down)
              _justOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 5479 "AstInternal.hs" #-}
              -- copy rule (down)
              _justOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5484 "AstInternal.hs" #-}
              ( _justIannotatedTree,_justIntAnnotatedTree,_justIntType,_justIoriginalTree) =
                  (just_ _justOcat _justOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_MaybeExpression_Nothing :: T_MaybeExpression 
sem_MaybeExpression_Nothing  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: MaybeExpression
              _lhsOoriginalTree :: MaybeExpression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Nothing
                  {-# LINE 5498 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Nothing
                  {-# LINE 5503 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5508 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5513 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- MaybeSelectList ---------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         listType             : [(String,Type)]
         originalTree         : SELF 
   alternatives:
      alternative Just:
         child just           : SelectList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nothing:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type MaybeSelectList  = (Maybe (SelectList))
-- cata
sem_MaybeSelectList :: MaybeSelectList  ->
                       T_MaybeSelectList 
sem_MaybeSelectList (Prelude.Just x )  =
    (sem_MaybeSelectList_Just (sem_SelectList x ) )
sem_MaybeSelectList Prelude.Nothing  =
    sem_MaybeSelectList_Nothing
-- semantic domain
type T_MaybeSelectList  = Catalog ->
                          LocalBindings ->
                          ( MaybeSelectList,([(String,Type)]),MaybeSelectList)
data Inh_MaybeSelectList  = Inh_MaybeSelectList {cat_Inh_MaybeSelectList :: Catalog,lib_Inh_MaybeSelectList :: LocalBindings}
data Syn_MaybeSelectList  = Syn_MaybeSelectList {annotatedTree_Syn_MaybeSelectList :: MaybeSelectList,listType_Syn_MaybeSelectList :: [(String,Type)],originalTree_Syn_MaybeSelectList :: MaybeSelectList}
wrap_MaybeSelectList :: T_MaybeSelectList  ->
                        Inh_MaybeSelectList  ->
                        Syn_MaybeSelectList 
wrap_MaybeSelectList sem (Inh_MaybeSelectList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_MaybeSelectList _lhsOannotatedTree _lhsOlistType _lhsOoriginalTree ))
sem_MaybeSelectList_Just :: T_SelectList  ->
                            T_MaybeSelectList 
sem_MaybeSelectList_Just just_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOlistType :: ([(String,Type)])
              _lhsOannotatedTree :: MaybeSelectList
              _lhsOoriginalTree :: MaybeSelectList
              _justOcat :: Catalog
              _justOlib :: LocalBindings
              _justIannotatedTree :: SelectList
              _justIlistType :: ([(String,Type)])
              _justIoriginalTree :: SelectList
              -- "./TypeChecking/SelectLists.ag"(line 39, column 12)
              _lhsOlistType =
                  {-# LINE 39 "./TypeChecking/SelectLists.ag" #-}
                  _justIlistType
                  {-# LINE 5574 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Just _justIannotatedTree
                  {-# LINE 5579 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Just _justIoriginalTree
                  {-# LINE 5584 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5589 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5594 "AstInternal.hs" #-}
              -- copy rule (down)
              _justOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 5599 "AstInternal.hs" #-}
              -- copy rule (down)
              _justOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5604 "AstInternal.hs" #-}
              ( _justIannotatedTree,_justIlistType,_justIoriginalTree) =
                  (just_ _justOcat _justOlib )
          in  ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree)))
sem_MaybeSelectList_Nothing :: T_MaybeSelectList 
sem_MaybeSelectList_Nothing  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOlistType :: ([(String,Type)])
              _lhsOannotatedTree :: MaybeSelectList
              _lhsOoriginalTree :: MaybeSelectList
              -- "./TypeChecking/SelectLists.ag"(line 40, column 15)
              _lhsOlistType =
                  {-# LINE 40 "./TypeChecking/SelectLists.ag" #-}
                  []
                  {-# LINE 5619 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Nothing
                  {-# LINE 5624 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Nothing
                  {-# LINE 5629 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5634 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5639 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree)))
-- OnExpr ------------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Just:
         child just           : JoinExpression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nothing:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type OnExpr  = (Maybe (JoinExpression))
-- cata
sem_OnExpr :: OnExpr  ->
              T_OnExpr 
sem_OnExpr (Prelude.Just x )  =
    (sem_OnExpr_Just (sem_JoinExpression x ) )
sem_OnExpr Prelude.Nothing  =
    sem_OnExpr_Nothing
-- semantic domain
type T_OnExpr  = Catalog ->
                 LocalBindings ->
                 ( OnExpr,OnExpr)
data Inh_OnExpr  = Inh_OnExpr {cat_Inh_OnExpr :: Catalog,lib_Inh_OnExpr :: LocalBindings}
data Syn_OnExpr  = Syn_OnExpr {annotatedTree_Syn_OnExpr :: OnExpr,originalTree_Syn_OnExpr :: OnExpr}
wrap_OnExpr :: T_OnExpr  ->
               Inh_OnExpr  ->
               Syn_OnExpr 
wrap_OnExpr sem (Inh_OnExpr _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_OnExpr _lhsOannotatedTree _lhsOoriginalTree ))
sem_OnExpr_Just :: T_JoinExpression  ->
                   T_OnExpr 
sem_OnExpr_Just just_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: OnExpr
              _lhsOoriginalTree :: OnExpr
              _justOcat :: Catalog
              _justOlib :: LocalBindings
              _justIannotatedTree :: JoinExpression
              _justIoriginalTree :: JoinExpression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Just _justIannotatedTree
                  {-# LINE 5697 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Just _justIoriginalTree
                  {-# LINE 5702 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5707 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5712 "AstInternal.hs" #-}
              -- copy rule (down)
              _justOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 5717 "AstInternal.hs" #-}
              -- copy rule (down)
              _justOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5722 "AstInternal.hs" #-}
              ( _justIannotatedTree,_justIoriginalTree) =
                  (just_ _justOcat _justOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_OnExpr_Nothing :: T_OnExpr 
sem_OnExpr_Nothing  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: OnExpr
              _lhsOoriginalTree :: OnExpr
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Nothing
                  {-# LINE 5736 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Nothing
                  {-# LINE 5741 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5746 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5751 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- ParamDef ----------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
         pos                  : Int
      synthesized attributes:
         annotatedTree        : SELF 
         namedType            : Maybe Type
         originalTree         : SELF 
         paramName            : ParamName
   alternatives:
      alternative ParamDef:
         child ann            : {Annotation}
         child name           : {String}
         child typ            : TypeName 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative ParamDefTp:
         child ann            : {Annotation}
         child typ            : TypeName 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data ParamDef  = ParamDef (Annotation) (String) (TypeName) 
               | ParamDefTp (Annotation) (TypeName) 
               deriving ( Data,Eq,Show,Typeable)
-- cata
sem_ParamDef :: ParamDef  ->
                T_ParamDef 
sem_ParamDef (ParamDef _ann _name _typ )  =
    (sem_ParamDef_ParamDef _ann _name (sem_TypeName _typ ) )
sem_ParamDef (ParamDefTp _ann _typ )  =
    (sem_ParamDef_ParamDefTp _ann (sem_TypeName _typ ) )
-- semantic domain
type T_ParamDef  = Catalog ->
                   LocalBindings ->
                   Int ->
                   ( ParamDef,(Maybe Type),ParamDef,ParamName)
data Inh_ParamDef  = Inh_ParamDef {cat_Inh_ParamDef :: Catalog,lib_Inh_ParamDef :: LocalBindings,pos_Inh_ParamDef :: Int}
data Syn_ParamDef  = Syn_ParamDef {annotatedTree_Syn_ParamDef :: ParamDef,namedType_Syn_ParamDef :: Maybe Type,originalTree_Syn_ParamDef :: ParamDef,paramName_Syn_ParamDef :: ParamName}
wrap_ParamDef :: T_ParamDef  ->
                 Inh_ParamDef  ->
                 Syn_ParamDef 
wrap_ParamDef sem (Inh_ParamDef _lhsIcat _lhsIlib _lhsIpos )  =
    (let ( _lhsOannotatedTree,_lhsOnamedType,_lhsOoriginalTree,_lhsOparamName) =
             (sem _lhsIcat _lhsIlib _lhsIpos )
     in  (Syn_ParamDef _lhsOannotatedTree _lhsOnamedType _lhsOoriginalTree _lhsOparamName ))
sem_ParamDef_ParamDef :: Annotation ->
                         String ->
                         T_TypeName  ->
                         T_ParamDef 
sem_ParamDef_ParamDef ann_ name_ typ_  =
    (\ _lhsIcat
       _lhsIlib
       _lhsIpos ->
         (let _lhsOnamedType :: (Maybe Type)
              _lhsOparamName :: ParamName
              _lhsOannotatedTree :: ParamDef
              _lhsOoriginalTree :: ParamDef
              _typOcat :: Catalog
              _typOlib :: LocalBindings
              _typIannotatedTree :: TypeName
              _typInamedType :: (Maybe Type)
              _typIoriginalTree :: TypeName
              -- "./TypeChecking/CreateFunction.ag"(line 48, column 9)
              _lhsOnamedType =
                  {-# LINE 48 "./TypeChecking/CreateFunction.ag" #-}
                  _typInamedType
                  {-# LINE 5825 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 50, column 9)
              _lhsOparamName =
                  {-# LINE 50 "./TypeChecking/CreateFunction.ag" #-}
                  NamedParam _lhsIpos name_
                  {-# LINE 5830 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ParamDef ann_ name_ _typIannotatedTree
                  {-# LINE 5835 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ParamDef ann_ name_ _typIoriginalTree
                  {-# LINE 5840 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5845 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5850 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 5855 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5860 "AstInternal.hs" #-}
              ( _typIannotatedTree,_typInamedType,_typIoriginalTree) =
                  (typ_ _typOcat _typOlib )
          in  ( _lhsOannotatedTree,_lhsOnamedType,_lhsOoriginalTree,_lhsOparamName)))
sem_ParamDef_ParamDefTp :: Annotation ->
                           T_TypeName  ->
                           T_ParamDef 
sem_ParamDef_ParamDefTp ann_ typ_  =
    (\ _lhsIcat
       _lhsIlib
       _lhsIpos ->
         (let _lhsOnamedType :: (Maybe Type)
              _lhsOparamName :: ParamName
              _lhsOannotatedTree :: ParamDef
              _lhsOoriginalTree :: ParamDef
              _typOcat :: Catalog
              _typOlib :: LocalBindings
              _typIannotatedTree :: TypeName
              _typInamedType :: (Maybe Type)
              _typIoriginalTree :: TypeName
              -- "./TypeChecking/CreateFunction.ag"(line 48, column 9)
              _lhsOnamedType =
                  {-# LINE 48 "./TypeChecking/CreateFunction.ag" #-}
                  _typInamedType
                  {-# LINE 5884 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 52, column 9)
              _lhsOparamName =
                  {-# LINE 52 "./TypeChecking/CreateFunction.ag" #-}
                  UnnamedParam _lhsIpos
                  {-# LINE 5889 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ParamDefTp ann_ _typIannotatedTree
                  {-# LINE 5894 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ParamDefTp ann_ _typIoriginalTree
                  {-# LINE 5899 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 5904 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 5909 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 5914 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 5919 "AstInternal.hs" #-}
              ( _typIannotatedTree,_typInamedType,_typIoriginalTree) =
                  (typ_ _typOcat _typOlib )
          in  ( _lhsOannotatedTree,_lhsOnamedType,_lhsOoriginalTree,_lhsOparamName)))
-- ParamDefList ------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
         pos                  : Int
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
         params               : [(ParamName, Maybe Type)]
   alternatives:
      alternative Cons:
         child hd             : ParamDef 
         child tl             : ParamDefList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type ParamDefList  = [(ParamDef)]
-- cata
sem_ParamDefList :: ParamDefList  ->
                    T_ParamDefList 
sem_ParamDefList list  =
    (Prelude.foldr sem_ParamDefList_Cons sem_ParamDefList_Nil (Prelude.map sem_ParamDef list) )
-- semantic domain
type T_ParamDefList  = Catalog ->
                       LocalBindings ->
                       Int ->
                       ( ParamDefList,ParamDefList,([(ParamName, Maybe Type)]))
data Inh_ParamDefList  = Inh_ParamDefList {cat_Inh_ParamDefList :: Catalog,lib_Inh_ParamDefList :: LocalBindings,pos_Inh_ParamDefList :: Int}
data Syn_ParamDefList  = Syn_ParamDefList {annotatedTree_Syn_ParamDefList :: ParamDefList,originalTree_Syn_ParamDefList :: ParamDefList,params_Syn_ParamDefList :: [(ParamName, Maybe Type)]}
wrap_ParamDefList :: T_ParamDefList  ->
                     Inh_ParamDefList  ->
                     Syn_ParamDefList 
wrap_ParamDefList sem (Inh_ParamDefList _lhsIcat _lhsIlib _lhsIpos )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOparams) =
             (sem _lhsIcat _lhsIlib _lhsIpos )
     in  (Syn_ParamDefList _lhsOannotatedTree _lhsOoriginalTree _lhsOparams ))
sem_ParamDefList_Cons :: T_ParamDef  ->
                         T_ParamDefList  ->
                         T_ParamDefList 
sem_ParamDefList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib
       _lhsIpos ->
         (let _lhsOparams :: ([(ParamName, Maybe Type)])
              _hdOpos :: Int
              _tlOpos :: Int
              _lhsOannotatedTree :: ParamDefList
              _lhsOoriginalTree :: ParamDefList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: ParamDef
              _hdInamedType :: (Maybe Type)
              _hdIoriginalTree :: ParamDef
              _hdIparamName :: ParamName
              _tlIannotatedTree :: ParamDefList
              _tlIoriginalTree :: ParamDefList
              _tlIparams :: ([(ParamName, Maybe Type)])
              -- "./TypeChecking/CreateFunction.ag"(line 56, column 13)
              _lhsOparams =
                  {-# LINE 56 "./TypeChecking/CreateFunction.ag" #-}
                  ((_hdIparamName, _hdInamedType) : _tlIparams)
                  {-# LINE 5993 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 57, column 13)
              _hdOpos =
                  {-# LINE 57 "./TypeChecking/CreateFunction.ag" #-}
                  _lhsIpos
                  {-# LINE 5998 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 58, column 13)
              _tlOpos =
                  {-# LINE 58 "./TypeChecking/CreateFunction.ag" #-}
                  _lhsIpos + 1
                  {-# LINE 6003 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 6008 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 6013 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6018 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6023 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6028 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6033 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6038 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6043 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdInamedType,_hdIoriginalTree,_hdIparamName) =
                  (hd_ _hdOcat _hdOlib _hdOpos )
              ( _tlIannotatedTree,_tlIoriginalTree,_tlIparams) =
                  (tl_ _tlOcat _tlOlib _tlOpos )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOparams)))
sem_ParamDefList_Nil :: T_ParamDefList 
sem_ParamDefList_Nil  =
    (\ _lhsIcat
       _lhsIlib
       _lhsIpos ->
         (let _lhsOparams :: ([(ParamName, Maybe Type)])
              _lhsOannotatedTree :: ParamDefList
              _lhsOoriginalTree :: ParamDefList
              -- "./TypeChecking/CreateFunction.ag"(line 55, column 12)
              _lhsOparams =
                  {-# LINE 55 "./TypeChecking/CreateFunction.ag" #-}
                  []
                  {-# LINE 6061 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 6066 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 6071 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6076 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6081 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOparams)))
-- Root --------------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
         producedCat          : Catalog
         producedLib          : LocalBindings
   alternatives:
      alternative Root:
         child statements     : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data Root  = Root (StatementList) 
           deriving ( Show)
-- cata
sem_Root :: Root  ->
            T_Root 
sem_Root (Root _statements )  =
    (sem_Root_Root (sem_StatementList _statements ) )
-- semantic domain
type T_Root  = Catalog ->
               LocalBindings ->
               ( Root,Root,Catalog,LocalBindings)
data Inh_Root  = Inh_Root {cat_Inh_Root :: Catalog,lib_Inh_Root :: LocalBindings}
data Syn_Root  = Syn_Root {annotatedTree_Syn_Root :: Root,originalTree_Syn_Root :: Root,producedCat_Syn_Root :: Catalog,producedLib_Syn_Root :: LocalBindings}
wrap_Root :: T_Root  ->
             Inh_Root  ->
             Syn_Root 
wrap_Root sem (Inh_Root _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOproducedCat,_lhsOproducedLib) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_Root _lhsOannotatedTree _lhsOoriginalTree _lhsOproducedCat _lhsOproducedLib ))
sem_Root_Root :: T_StatementList  ->
                 T_Root 
sem_Root_Root statements_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _statementsOcatUpdates :: ([CatalogUpdate])
              _statementsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Root
              _lhsOoriginalTree :: Root
              _lhsOproducedCat :: Catalog
              _lhsOproducedLib :: LocalBindings
              _statementsOcat :: Catalog
              _statementsOlib :: LocalBindings
              _statementsIannotatedTree :: StatementList
              _statementsIoriginalTree :: StatementList
              _statementsIproducedCat :: Catalog
              _statementsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 97, column 12)
              _statementsOcatUpdates =
                  {-# LINE 97 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 6142 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 98, column 12)
              _statementsOlibUpdates =
                  {-# LINE 98 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 6147 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Root _statementsIannotatedTree
                  {-# LINE 6152 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Root _statementsIoriginalTree
                  {-# LINE 6157 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6162 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6167 "AstInternal.hs" #-}
              -- copy rule (up)
              _lhsOproducedCat =
                  {-# LINE 27 "./TypeChecking/Statements.ag" #-}
                  _statementsIproducedCat
                  {-# LINE 6172 "AstInternal.hs" #-}
              -- copy rule (up)
              _lhsOproducedLib =
                  {-# LINE 28 "./TypeChecking/Statements.ag" #-}
                  _statementsIproducedLib
                  {-# LINE 6177 "AstInternal.hs" #-}
              -- copy rule (down)
              _statementsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6182 "AstInternal.hs" #-}
              -- copy rule (down)
              _statementsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6187 "AstInternal.hs" #-}
              ( _statementsIannotatedTree,_statementsIoriginalTree,_statementsIproducedCat,_statementsIproducedLib) =
                  (statements_ _statementsOcat _statementsOcatUpdates _statementsOlib _statementsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOproducedCat,_lhsOproducedLib)))
-- RowConstraint -----------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative NotNullConstraint:
         child ann            : {Annotation}
         child name           : {String}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative NullConstraint:
         child ann            : {Annotation}
         child name           : {String}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative RowCheckConstraint:
         child ann            : {Annotation}
         child name           : {String}
         child expression     : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative RowPrimaryKeyConstraint:
         child ann            : {Annotation}
         child name           : {String}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative RowReferenceConstraint:
         child ann            : {Annotation}
         child name           : {String}
         child table          : {String}
         child att            : {Maybe String}
         child onUpdate       : {Cascade}
         child onDelete       : {Cascade}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative RowUniqueConstraint:
         child ann            : {Annotation}
         child name           : {String}
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data RowConstraint  = NotNullConstraint (Annotation) (String) 
                    | NullConstraint (Annotation) (String) 
                    | RowCheckConstraint (Annotation) (String) (Expression) 
                    | RowPrimaryKeyConstraint (Annotation) (String) 
                    | RowReferenceConstraint (Annotation) (String) (String) (Maybe String) (Cascade) (Cascade) 
                    | RowUniqueConstraint (Annotation) (String) 
                    deriving ( Data,Eq,Show,Typeable)
-- cata
sem_RowConstraint :: RowConstraint  ->
                     T_RowConstraint 
sem_RowConstraint (NotNullConstraint _ann _name )  =
    (sem_RowConstraint_NotNullConstraint _ann _name )
sem_RowConstraint (NullConstraint _ann _name )  =
    (sem_RowConstraint_NullConstraint _ann _name )
sem_RowConstraint (RowCheckConstraint _ann _name _expression )  =
    (sem_RowConstraint_RowCheckConstraint _ann _name (sem_Expression _expression ) )
sem_RowConstraint (RowPrimaryKeyConstraint _ann _name )  =
    (sem_RowConstraint_RowPrimaryKeyConstraint _ann _name )
sem_RowConstraint (RowReferenceConstraint _ann _name _table _att _onUpdate _onDelete )  =
    (sem_RowConstraint_RowReferenceConstraint _ann _name _table _att _onUpdate _onDelete )
sem_RowConstraint (RowUniqueConstraint _ann _name )  =
    (sem_RowConstraint_RowUniqueConstraint _ann _name )
-- semantic domain
type T_RowConstraint  = Catalog ->
                        LocalBindings ->
                        ( RowConstraint,RowConstraint)
data Inh_RowConstraint  = Inh_RowConstraint {cat_Inh_RowConstraint :: Catalog,lib_Inh_RowConstraint :: LocalBindings}
data Syn_RowConstraint  = Syn_RowConstraint {annotatedTree_Syn_RowConstraint :: RowConstraint,originalTree_Syn_RowConstraint :: RowConstraint}
wrap_RowConstraint :: T_RowConstraint  ->
                      Inh_RowConstraint  ->
                      Syn_RowConstraint 
wrap_RowConstraint sem (Inh_RowConstraint _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_RowConstraint _lhsOannotatedTree _lhsOoriginalTree ))
sem_RowConstraint_NotNullConstraint :: Annotation ->
                                       String ->
                                       T_RowConstraint 
sem_RowConstraint_NotNullConstraint ann_ name_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: RowConstraint
              _lhsOoriginalTree :: RowConstraint
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  NotNullConstraint ann_ name_
                  {-# LINE 6290 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  NotNullConstraint ann_ name_
                  {-# LINE 6295 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6300 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6305 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_RowConstraint_NullConstraint :: Annotation ->
                                    String ->
                                    T_RowConstraint 
sem_RowConstraint_NullConstraint ann_ name_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: RowConstraint
              _lhsOoriginalTree :: RowConstraint
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  NullConstraint ann_ name_
                  {-# LINE 6319 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  NullConstraint ann_ name_
                  {-# LINE 6324 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6329 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6334 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_RowConstraint_RowCheckConstraint :: Annotation ->
                                        String ->
                                        T_Expression  ->
                                        T_RowConstraint 
sem_RowConstraint_RowCheckConstraint ann_ name_ expression_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: RowConstraint
              _lhsOoriginalTree :: RowConstraint
              _expressionOcat :: Catalog
              _expressionOlib :: LocalBindings
              _expressionIannotatedTree :: Expression
              _expressionIntAnnotatedTree :: Expression
              _expressionIntType :: ([(String,Type)])
              _expressionIoriginalTree :: Expression
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  RowCheckConstraint ann_ name_ _expressionIannotatedTree
                  {-# LINE 6355 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  RowCheckConstraint ann_ name_ _expressionIoriginalTree
                  {-# LINE 6360 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6365 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6370 "AstInternal.hs" #-}
              -- copy rule (down)
              _expressionOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6375 "AstInternal.hs" #-}
              -- copy rule (down)
              _expressionOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6380 "AstInternal.hs" #-}
              ( _expressionIannotatedTree,_expressionIntAnnotatedTree,_expressionIntType,_expressionIoriginalTree) =
                  (expression_ _expressionOcat _expressionOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_RowConstraint_RowPrimaryKeyConstraint :: Annotation ->
                                             String ->
                                             T_RowConstraint 
sem_RowConstraint_RowPrimaryKeyConstraint ann_ name_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: RowConstraint
              _lhsOoriginalTree :: RowConstraint
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  RowPrimaryKeyConstraint ann_ name_
                  {-# LINE 6396 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  RowPrimaryKeyConstraint ann_ name_
                  {-# LINE 6401 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6406 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6411 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_RowConstraint_RowReferenceConstraint :: Annotation ->
                                            String ->
                                            String ->
                                            (Maybe String) ->
                                            Cascade ->
                                            Cascade ->
                                            T_RowConstraint 
sem_RowConstraint_RowReferenceConstraint ann_ name_ table_ att_ onUpdate_ onDelete_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: RowConstraint
              _lhsOoriginalTree :: RowConstraint
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  RowReferenceConstraint ann_ name_ table_ att_ onUpdate_ onDelete_
                  {-# LINE 6429 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  RowReferenceConstraint ann_ name_ table_ att_ onUpdate_ onDelete_
                  {-# LINE 6434 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6439 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6444 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_RowConstraint_RowUniqueConstraint :: Annotation ->
                                         String ->
                                         T_RowConstraint 
sem_RowConstraint_RowUniqueConstraint ann_ name_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: RowConstraint
              _lhsOoriginalTree :: RowConstraint
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  RowUniqueConstraint ann_ name_
                  {-# LINE 6458 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  RowUniqueConstraint ann_ name_
                  {-# LINE 6463 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6468 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6473 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- RowConstraintList -------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : RowConstraint 
         child tl             : RowConstraintList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type RowConstraintList  = [(RowConstraint)]
-- cata
sem_RowConstraintList :: RowConstraintList  ->
                         T_RowConstraintList 
sem_RowConstraintList list  =
    (Prelude.foldr sem_RowConstraintList_Cons sem_RowConstraintList_Nil (Prelude.map sem_RowConstraint list) )
-- semantic domain
type T_RowConstraintList  = Catalog ->
                            LocalBindings ->
                            ( RowConstraintList,RowConstraintList)
data Inh_RowConstraintList  = Inh_RowConstraintList {cat_Inh_RowConstraintList :: Catalog,lib_Inh_RowConstraintList :: LocalBindings}
data Syn_RowConstraintList  = Syn_RowConstraintList {annotatedTree_Syn_RowConstraintList :: RowConstraintList,originalTree_Syn_RowConstraintList :: RowConstraintList}
wrap_RowConstraintList :: T_RowConstraintList  ->
                          Inh_RowConstraintList  ->
                          Syn_RowConstraintList 
wrap_RowConstraintList sem (Inh_RowConstraintList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_RowConstraintList _lhsOannotatedTree _lhsOoriginalTree ))
sem_RowConstraintList_Cons :: T_RowConstraint  ->
                              T_RowConstraintList  ->
                              T_RowConstraintList 
sem_RowConstraintList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: RowConstraintList
              _lhsOoriginalTree :: RowConstraintList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: RowConstraint
              _hdIoriginalTree :: RowConstraint
              _tlIannotatedTree :: RowConstraintList
              _tlIoriginalTree :: RowConstraintList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 6535 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 6540 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6545 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6550 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6555 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6560 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6565 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6570 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_RowConstraintList_Nil :: T_RowConstraintList 
sem_RowConstraintList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: RowConstraintList
              _lhsOoriginalTree :: RowConstraintList
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 6586 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 6591 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 6596 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6601 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- SelectExpression --------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
   alternatives:
      alternative CombineSelect:
         child ann            : {Annotation}
         child ctype          : {CombineType}
         child sel1           : SelectExpression 
         child sel2           : SelectExpression 
         visit 0:
            local tpe         : {Et}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative Select:
         child ann            : {Annotation}
         child selDistinct    : {Distinct}
         child selSelectList  : SelectList 
         child selTref        : TableRefList 
         child selWhere       : MaybeBoolExpression 
         child selGroupBy     : ExpressionList 
         child selHaving      : MaybeBoolExpression 
         child selOrderBy     : ExpressionDirectionPairList 
         child selLimit       : MaybeExpression 
         child selOffset      : MaybeExpression 
         visit 0:
            local newLib      : _
            local tpe         : {Et}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative Values:
         child ann            : {Annotation}
         child vll            : ExpressionListList 
         visit 0:
            local tpe         : {Et}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative WithSelect:
         child ann            : {Annotation}
         child withs          : WithQueryList 
         child ex             : SelectExpression 
         visit 0:
            local tpe         : {Et}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
-}
data SelectExpression  = CombineSelect (Annotation) (CombineType) (SelectExpression) (SelectExpression) 
                       | Select (Annotation) (Distinct) (SelectList) (TableRefList) (MaybeBoolExpression) (ExpressionList) (MaybeBoolExpression) (ExpressionDirectionPairList) (MaybeExpression) (MaybeExpression) 
                       | Values (Annotation) (ExpressionListList) 
                       | WithSelect (Annotation) (WithQueryList) (SelectExpression) 
                       deriving ( Data,Eq,Show,Typeable)
-- cata
sem_SelectExpression :: SelectExpression  ->
                        T_SelectExpression 
sem_SelectExpression (CombineSelect _ann _ctype _sel1 _sel2 )  =
    (sem_SelectExpression_CombineSelect _ann _ctype (sem_SelectExpression _sel1 ) (sem_SelectExpression _sel2 ) )
sem_SelectExpression (Select _ann _selDistinct _selSelectList _selTref _selWhere _selGroupBy _selHaving _selOrderBy _selLimit _selOffset )  =
    (sem_SelectExpression_Select _ann _selDistinct (sem_SelectList _selSelectList ) (sem_TableRefList _selTref ) (sem_MaybeBoolExpression _selWhere ) (sem_ExpressionList _selGroupBy ) (sem_MaybeBoolExpression _selHaving ) (sem_ExpressionDirectionPairList _selOrderBy ) (sem_MaybeExpression _selLimit ) (sem_MaybeExpression _selOffset ) )
sem_SelectExpression (Values _ann _vll )  =
    (sem_SelectExpression_Values _ann (sem_ExpressionListList _vll ) )
sem_SelectExpression (WithSelect _ann _withs _ex )  =
    (sem_SelectExpression_WithSelect _ann (sem_WithQueryList _withs ) (sem_SelectExpression _ex ) )
-- semantic domain
type T_SelectExpression  = Catalog ->
                           LocalBindings ->
                           ( SelectExpression,SelectExpression)
data Inh_SelectExpression  = Inh_SelectExpression {cat_Inh_SelectExpression :: Catalog,lib_Inh_SelectExpression :: LocalBindings}
data Syn_SelectExpression  = Syn_SelectExpression {annotatedTree_Syn_SelectExpression :: SelectExpression,originalTree_Syn_SelectExpression :: SelectExpression}
wrap_SelectExpression :: T_SelectExpression  ->
                         Inh_SelectExpression  ->
                         Syn_SelectExpression 
wrap_SelectExpression sem (Inh_SelectExpression _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_SelectExpression _lhsOannotatedTree _lhsOoriginalTree ))
sem_SelectExpression_CombineSelect :: Annotation ->
                                      CombineType ->
                                      T_SelectExpression  ->
                                      T_SelectExpression  ->
                                      T_SelectExpression 
sem_SelectExpression_CombineSelect ann_ ctype_ sel1_ sel2_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: SelectExpression
              _tpe :: Et
              _lhsOoriginalTree :: SelectExpression
              _sel1Ocat :: Catalog
              _sel1Olib :: LocalBindings
              _sel2Ocat :: Catalog
              _sel2Olib :: LocalBindings
              _sel1IannotatedTree :: SelectExpression
              _sel1IoriginalTree :: SelectExpression
              _sel2IannotatedTree :: SelectExpression
              _sel2IoriginalTree :: SelectExpression
              -- "./TypeChecking/SelectStatement.ag"(line 30, column 9)
              _lhsOannotatedTree =
                  {-# LINE 30 "./TypeChecking/SelectStatement.ag" #-}
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 6710 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 132, column 9)
              _tpe =
                  {-# LINE 132 "./TypeChecking/SelectStatement.ag" #-}
                  do
                  sel1t <- lmt $ getTypeAnnotation _sel1IannotatedTree
                  sel2t <- lmt $ getTypeAnnotation _sel2IannotatedTree
                  typeCheckCombineSelect _lhsIcat sel1t sel2t
                  {-# LINE 6718 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 138, column 9)
              _backTree =
                  {-# LINE 138 "./TypeChecking/SelectStatement.ag" #-}
                  CombineSelect ann_ ctype_
                                _sel1IannotatedTree
                                _sel2IannotatedTree
                  {-# LINE 6725 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CombineSelect ann_ ctype_ _sel1IannotatedTree _sel2IannotatedTree
                  {-# LINE 6730 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CombineSelect ann_ ctype_ _sel1IoriginalTree _sel2IoriginalTree
                  {-# LINE 6735 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6740 "AstInternal.hs" #-}
              -- copy rule (down)
              _sel1Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6745 "AstInternal.hs" #-}
              -- copy rule (down)
              _sel1Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6750 "AstInternal.hs" #-}
              -- copy rule (down)
              _sel2Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6755 "AstInternal.hs" #-}
              -- copy rule (down)
              _sel2Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6760 "AstInternal.hs" #-}
              ( _sel1IannotatedTree,_sel1IoriginalTree) =
                  (sel1_ _sel1Ocat _sel1Olib )
              ( _sel2IannotatedTree,_sel2IoriginalTree) =
                  (sel2_ _sel2Ocat _sel2Olib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_SelectExpression_Select :: Annotation ->
                               Distinct ->
                               T_SelectList  ->
                               T_TableRefList  ->
                               T_MaybeBoolExpression  ->
                               T_ExpressionList  ->
                               T_MaybeBoolExpression  ->
                               T_ExpressionDirectionPairList  ->
                               T_MaybeExpression  ->
                               T_MaybeExpression  ->
                               T_SelectExpression 
sem_SelectExpression_Select ann_ selDistinct_ selSelectList_ selTref_ selWhere_ selGroupBy_ selHaving_ selOrderBy_ selLimit_ selOffset_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: SelectExpression
              _selSelectListOlib :: LocalBindings
              _selWhereOlib :: LocalBindings
              _selGroupByOlib :: LocalBindings
              _selOrderByOlib :: LocalBindings
              _tpe :: Et
              _lhsOoriginalTree :: SelectExpression
              _selSelectListOcat :: Catalog
              _selTrefOcat :: Catalog
              _selTrefOlib :: LocalBindings
              _selWhereOcat :: Catalog
              _selGroupByOcat :: Catalog
              _selHavingOcat :: Catalog
              _selHavingOlib :: LocalBindings
              _selOrderByOcat :: Catalog
              _selLimitOcat :: Catalog
              _selLimitOlib :: LocalBindings
              _selOffsetOcat :: Catalog
              _selOffsetOlib :: LocalBindings
              _selSelectListIannotatedTree :: SelectList
              _selSelectListIlistType :: ([(String,Type)])
              _selSelectListIoriginalTree :: SelectList
              _selTrefIannotatedTree :: TableRefList
              _selTrefIlibUpdates :: ([LocalBindingsUpdate])
              _selTrefIoriginalTree :: TableRefList
              _selWhereIannotatedTree :: MaybeBoolExpression
              _selWhereIoriginalTree :: MaybeBoolExpression
              _selGroupByIannotatedTree :: ExpressionList
              _selGroupByIoriginalTree :: ExpressionList
              _selGroupByItypeList :: ([Maybe Type])
              _selHavingIannotatedTree :: MaybeBoolExpression
              _selHavingIoriginalTree :: MaybeBoolExpression
              _selOrderByIannotatedTree :: ExpressionDirectionPairList
              _selOrderByIoriginalTree :: ExpressionDirectionPairList
              _selLimitIannotatedTree :: MaybeExpression
              _selLimitIoriginalTree :: MaybeExpression
              _selOffsetIannotatedTree :: MaybeExpression
              _selOffsetIoriginalTree :: MaybeExpression
              -- "./TypeChecking/SelectStatement.ag"(line 30, column 9)
              _lhsOannotatedTree =
                  {-# LINE 30 "./TypeChecking/SelectStatement.ag" #-}
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 6822 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 99, column 10)
              _newLib =
                  {-# LINE 99 "./TypeChecking/SelectStatement.ag" #-}
                  case foldM (flip $ lbUpdate _lhsIcat) _lhsIlib _selTrefIlibUpdates of
                    Left x -> error $ "selectexpression-select-loc.newlib " ++ show x
                    Right e -> e
                  {-# LINE 6829 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 102, column 10)
              _selSelectListOlib =
                  {-# LINE 102 "./TypeChecking/SelectStatement.ag" #-}
                  _newLib
                  {-# LINE 6834 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 103, column 10)
              _selWhereOlib =
                  {-# LINE 103 "./TypeChecking/SelectStatement.ag" #-}
                  _newLib
                  {-# LINE 6839 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 104, column 10)
              _selGroupByOlib =
                  {-# LINE 104 "./TypeChecking/SelectStatement.ag" #-}
                  _newLib
                  {-# LINE 6844 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 105, column 10)
              _selOrderByOlib =
                  {-# LINE 105 "./TypeChecking/SelectStatement.ag" #-}
                  _newLib
                  {-# LINE 6849 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 116, column 9)
              _tpe =
                  {-# LINE 116 "./TypeChecking/SelectStatement.ag" #-}
                  Right $ SetOfType $ CompositeType _selSelectListIlistType
                  {-# LINE 6854 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 121, column 9)
              _backTree =
                  {-# LINE 121 "./TypeChecking/SelectStatement.ag" #-}
                  Select ann_
                         selDistinct_
                         _selSelectListIannotatedTree
                         _selTrefIannotatedTree
                         _selWhereIannotatedTree
                         _selGroupByIannotatedTree
                         _selHavingIannotatedTree
                         _selOrderByIannotatedTree
                         _selLimitIannotatedTree
                         _selOffsetIannotatedTree
                  {-# LINE 6868 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Select ann_ selDistinct_ _selSelectListIannotatedTree _selTrefIannotatedTree _selWhereIannotatedTree _selGroupByIannotatedTree _selHavingIannotatedTree _selOrderByIannotatedTree _selLimitIannotatedTree _selOffsetIannotatedTree
                  {-# LINE 6873 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Select ann_ selDistinct_ _selSelectListIoriginalTree _selTrefIoriginalTree _selWhereIoriginalTree _selGroupByIoriginalTree _selHavingIoriginalTree _selOrderByIoriginalTree _selLimitIoriginalTree _selOffsetIoriginalTree
                  {-# LINE 6878 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 6883 "AstInternal.hs" #-}
              -- copy rule (down)
              _selSelectListOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6888 "AstInternal.hs" #-}
              -- copy rule (down)
              _selTrefOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6893 "AstInternal.hs" #-}
              -- copy rule (down)
              _selTrefOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6898 "AstInternal.hs" #-}
              -- copy rule (down)
              _selWhereOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6903 "AstInternal.hs" #-}
              -- copy rule (down)
              _selGroupByOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6908 "AstInternal.hs" #-}
              -- copy rule (down)
              _selHavingOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6913 "AstInternal.hs" #-}
              -- copy rule (down)
              _selHavingOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6918 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOrderByOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6923 "AstInternal.hs" #-}
              -- copy rule (down)
              _selLimitOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6928 "AstInternal.hs" #-}
              -- copy rule (down)
              _selLimitOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6933 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOffsetOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 6938 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOffsetOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 6943 "AstInternal.hs" #-}
              ( _selSelectListIannotatedTree,_selSelectListIlistType,_selSelectListIoriginalTree) =
                  (selSelectList_ _selSelectListOcat _selSelectListOlib )
              ( _selTrefIannotatedTree,_selTrefIlibUpdates,_selTrefIoriginalTree) =
                  (selTref_ _selTrefOcat _selTrefOlib )
              ( _selWhereIannotatedTree,_selWhereIoriginalTree) =
                  (selWhere_ _selWhereOcat _selWhereOlib )
              ( _selGroupByIannotatedTree,_selGroupByIoriginalTree,_selGroupByItypeList) =
                  (selGroupBy_ _selGroupByOcat _selGroupByOlib )
              ( _selHavingIannotatedTree,_selHavingIoriginalTree) =
                  (selHaving_ _selHavingOcat _selHavingOlib )
              ( _selOrderByIannotatedTree,_selOrderByIoriginalTree) =
                  (selOrderBy_ _selOrderByOcat _selOrderByOlib )
              ( _selLimitIannotatedTree,_selLimitIoriginalTree) =
                  (selLimit_ _selLimitOcat _selLimitOlib )
              ( _selOffsetIannotatedTree,_selOffsetIoriginalTree) =
                  (selOffset_ _selOffsetOcat _selOffsetOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_SelectExpression_Values :: Annotation ->
                               T_ExpressionListList  ->
                               T_SelectExpression 
sem_SelectExpression_Values ann_ vll_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: SelectExpression
              _tpe :: Et
              _lhsOoriginalTree :: SelectExpression
              _vllOcat :: Catalog
              _vllOlib :: LocalBindings
              _vllIannotatedTree :: ExpressionListList
              _vllIoriginalTree :: ExpressionListList
              _vllItypeListList :: ([[Maybe Type]])
              -- "./TypeChecking/SelectStatement.ag"(line 30, column 9)
              _lhsOannotatedTree =
                  {-# LINE 30 "./TypeChecking/SelectStatement.ag" #-}
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 6979 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 111, column 9)
              _tpe =
                  {-# LINE 111 "./TypeChecking/SelectStatement.ag" #-}
                  typeCheckValuesExpr
                              _lhsIcat
                              _vllItypeListList
                  {-# LINE 6986 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 114, column 9)
              _backTree =
                  {-# LINE 114 "./TypeChecking/SelectStatement.ag" #-}
                  Values ann_ _vllIannotatedTree
                  {-# LINE 6991 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Values ann_ _vllIannotatedTree
                  {-# LINE 6996 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Values ann_ _vllIoriginalTree
                  {-# LINE 7001 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 7006 "AstInternal.hs" #-}
              -- copy rule (down)
              _vllOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 7011 "AstInternal.hs" #-}
              -- copy rule (down)
              _vllOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 7016 "AstInternal.hs" #-}
              ( _vllIannotatedTree,_vllIoriginalTree,_vllItypeListList) =
                  (vll_ _vllOcat _vllOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
sem_SelectExpression_WithSelect :: Annotation ->
                                   T_WithQueryList  ->
                                   T_SelectExpression  ->
                                   T_SelectExpression 
sem_SelectExpression_WithSelect ann_ withs_ ex_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: SelectExpression
              _tpe :: Et
              _exOcat :: Catalog
              _withsOcatUpdates :: ([CatalogUpdate])
              _lhsOoriginalTree :: SelectExpression
              _withsOcat :: Catalog
              _withsOlib :: LocalBindings
              _exOlib :: LocalBindings
              _withsIannotatedTree :: WithQueryList
              _withsIoriginalTree :: WithQueryList
              _withsIproducedCat :: Catalog
              _exIannotatedTree :: SelectExpression
              _exIoriginalTree :: SelectExpression
              -- "./TypeChecking/SelectStatement.ag"(line 30, column 9)
              _lhsOannotatedTree =
                  {-# LINE 30 "./TypeChecking/SelectStatement.ag" #-}
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 7044 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 142, column 9)
              _tpe =
                  {-# LINE 142 "./TypeChecking/SelectStatement.ag" #-}
                  lmt $ getTypeAnnotation _exIannotatedTree
                  {-# LINE 7049 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 143, column 9)
              _backTree =
                  {-# LINE 143 "./TypeChecking/SelectStatement.ag" #-}
                  WithSelect ann_ _withsIannotatedTree _exIannotatedTree
                  {-# LINE 7054 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 144, column 9)
              _exOcat =
                  {-# LINE 144 "./TypeChecking/SelectStatement.ag" #-}
                  _withsIproducedCat
                  {-# LINE 7059 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 145, column 9)
              _withsOcatUpdates =
                  {-# LINE 145 "./TypeChecking/SelectStatement.ag" #-}
                  []
                  {-# LINE 7064 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  WithSelect ann_ _withsIannotatedTree _exIannotatedTree
                  {-# LINE 7069 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  WithSelect ann_ _withsIoriginalTree _exIoriginalTree
                  {-# LINE 7074 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 7079 "AstInternal.hs" #-}
              -- copy rule (down)
              _withsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 7084 "AstInternal.hs" #-}
              -- copy rule (down)
              _withsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 7089 "AstInternal.hs" #-}
              -- copy rule (down)
              _exOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 7094 "AstInternal.hs" #-}
              ( _withsIannotatedTree,_withsIoriginalTree,_withsIproducedCat) =
                  (withs_ _withsOcat _withsOcatUpdates _withsOlib )
              ( _exIannotatedTree,_exIoriginalTree) =
                  (ex_ _exOcat _exOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree)))
-- SelectItem --------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         itemType             : [(String,Type)]
         originalTree         : SELF 
   alternatives:
      alternative SelExp:
         child ann            : {Annotation}
         child ex             : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative SelectItem:
         child ann            : {Annotation}
         child ex             : Expression 
         child name           : {String}
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data SelectItem  = SelExp (Annotation) (Expression) 
                 | SelectItem (Annotation) (Expression) (String) 
                 deriving ( Data,Eq,Show,Typeable)
-- cata
sem_SelectItem :: SelectItem  ->
                  T_SelectItem 
sem_SelectItem (SelExp _ann _ex )  =
    (sem_SelectItem_SelExp _ann (sem_Expression _ex ) )
sem_SelectItem (SelectItem _ann _ex _name )  =
    (sem_SelectItem_SelectItem _ann (sem_Expression _ex ) _name )
-- semantic domain
type T_SelectItem  = Catalog ->
                     LocalBindings ->
                     ( SelectItem,([(String,Type)]),SelectItem)
data Inh_SelectItem  = Inh_SelectItem {cat_Inh_SelectItem :: Catalog,lib_Inh_SelectItem :: LocalBindings}
data Syn_SelectItem  = Syn_SelectItem {annotatedTree_Syn_SelectItem :: SelectItem,itemType_Syn_SelectItem :: [(String,Type)],originalTree_Syn_SelectItem :: SelectItem}
wrap_SelectItem :: T_SelectItem  ->
                   Inh_SelectItem  ->
                   Syn_SelectItem 
wrap_SelectItem sem (Inh_SelectItem _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOitemType,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_SelectItem _lhsOannotatedTree _lhsOitemType _lhsOoriginalTree ))
sem_SelectItem_SelExp :: Annotation ->
                         T_Expression  ->
                         T_SelectItem 
sem_SelectItem_SelExp ann_ ex_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOitemType :: ([(String,Type)])
              _lhsOannotatedTree :: SelectItem
              _lhsOoriginalTree :: SelectItem
              _exOcat :: Catalog
              _exOlib :: LocalBindings
              _exIannotatedTree :: Expression
              _exIntAnnotatedTree :: Expression
              _exIntType :: ([(String,Type)])
              _exIoriginalTree :: Expression
              -- "./TypeChecking/SelectLists.ag"(line 33, column 9)
              _annotatedTree =
                  {-# LINE 33 "./TypeChecking/SelectLists.ag" #-}
                  SelExp ann_ _exIntAnnotatedTree
                  {-# LINE 7167 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectLists.ag"(line 61, column 9)
              _lhsOitemType =
                  {-# LINE 61 "./TypeChecking/SelectLists.ag" #-}
                  _exIntType
                  {-# LINE 7172 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  SelExp ann_ _exIoriginalTree
                  {-# LINE 7177 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 7182 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 7187 "AstInternal.hs" #-}
              -- copy rule (down)
              _exOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 7192 "AstInternal.hs" #-}
              -- copy rule (down)
              _exOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 7197 "AstInternal.hs" #-}
              ( _exIannotatedTree,_exIntAnnotatedTree,_exIntType,_exIoriginalTree) =
                  (ex_ _exOcat _exOlib )
          in  ( _lhsOannotatedTree,_lhsOitemType,_lhsOoriginalTree)))
sem_SelectItem_SelectItem :: Annotation ->
                             T_Expression  ->
                             String ->
                             T_SelectItem 
sem_SelectItem_SelectItem ann_ ex_ name_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOitemType :: ([(String,Type)])
              _lhsOannotatedTree :: SelectItem
              _lhsOoriginalTree :: SelectItem
              _exOcat :: Catalog
              _exOlib :: LocalBindings
              _exIannotatedTree :: Expression
              _exIntAnnotatedTree :: Expression
              _exIntType :: ([(String,Type)])
              _exIoriginalTree :: Expression
              -- "./TypeChecking/SelectLists.ag"(line 35, column 9)
              _annotatedTree =
                  {-# LINE 35 "./TypeChecking/SelectLists.ag" #-}
                  SelectItem ann_ _exIannotatedTree name_
                  {-# LINE 7221 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectLists.ag"(line 68, column 9)
              _lhsOitemType =
                  {-# LINE 68 "./TypeChecking/SelectLists.ag" #-}
                  maybe [] id $ do
                  t <- getTypeAnnotation _exIannotatedTree
                  return [(name_,t)]
                  {-# LINE 7228 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  SelectItem ann_ _exIoriginalTree name_
                  {-# LINE 7233 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 7238 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 7243 "AstInternal.hs" #-}
              -- copy rule (down)
              _exOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 7248 "AstInternal.hs" #-}
              -- copy rule (down)
              _exOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 7253 "AstInternal.hs" #-}
              ( _exIannotatedTree,_exIntAnnotatedTree,_exIntType,_exIoriginalTree) =
                  (ex_ _exOcat _exOlib )
          in  ( _lhsOannotatedTree,_lhsOitemType,_lhsOoriginalTree)))
-- SelectItemList ----------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         listType             : [(String,Type)]
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : SelectItem 
         child tl             : SelectItemList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type SelectItemList  = [(SelectItem)]
-- cata
sem_SelectItemList :: SelectItemList  ->
                      T_SelectItemList 
sem_SelectItemList list  =
    (Prelude.foldr sem_SelectItemList_Cons sem_SelectItemList_Nil (Prelude.map sem_SelectItem list) )
-- semantic domain
type T_SelectItemList  = Catalog ->
                         LocalBindings ->
                         ( SelectItemList,([(String,Type)]),SelectItemList)
data Inh_SelectItemList  = Inh_SelectItemList {cat_Inh_SelectItemList :: Catalog,lib_Inh_SelectItemList :: LocalBindings}
data Syn_SelectItemList  = Syn_SelectItemList {annotatedTree_Syn_SelectItemList :: SelectItemList,listType_Syn_SelectItemList :: [(String,Type)],originalTree_Syn_SelectItemList :: SelectItemList}
wrap_SelectItemList :: T_SelectItemList  ->
                       Inh_SelectItemList  ->
                       Syn_SelectItemList 
wrap_SelectItemList sem (Inh_SelectItemList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_SelectItemList _lhsOannotatedTree _lhsOlistType _lhsOoriginalTree ))
sem_SelectItemList_Cons :: T_SelectItem  ->
                           T_SelectItemList  ->
                           T_SelectItemList 
sem_SelectItemList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOlistType :: ([(String,Type)])
              _lhsOannotatedTree :: SelectItemList
              _lhsOoriginalTree :: SelectItemList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: SelectItem
              _hdIitemType :: ([(String,Type)])
              _hdIoriginalTree :: SelectItem
              _tlIannotatedTree :: SelectItemList
              _tlIlistType :: ([(String,Type)])
              _tlIoriginalTree :: SelectItemList
              -- "./TypeChecking/SelectLists.ag"(line 43, column 12)
              _lhsOlistType =
                  {-# LINE 43 "./TypeChecking/SelectLists.ag" #-}
                  _hdIitemType ++ _tlIlistType
                  {-# LINE 7321 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 7326 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 7331 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 7336 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 7341 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 7346 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 7351 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 7356 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 7361 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIitemType,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIlistType,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree)))
sem_SelectItemList_Nil :: T_SelectItemList 
sem_SelectItemList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOlistType :: ([(String,Type)])
              _lhsOannotatedTree :: SelectItemList
              _lhsOoriginalTree :: SelectItemList
              -- "./TypeChecking/SelectLists.ag"(line 44, column 11)
              _lhsOlistType =
                  {-# LINE 44 "./TypeChecking/SelectLists.ag" #-}
                  []
                  {-# LINE 7378 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 7383 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 7388 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 7393 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 7398 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree)))
-- SelectList --------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         listType             : [(String,Type)]
         originalTree         : SELF 
   alternatives:
      alternative SelectList:
         child ann            : {Annotation}
         child items          : SelectItemList 
         child into           : {[String]}
         visit 0:
            local tpe         : _
            local annotatedTree : _
            local originalTree : _
-}
data SelectList  = SelectList (Annotation) (SelectItemList) ([String]) 
                 deriving ( Data,Eq,Show,Typeable)
-- cata
sem_SelectList :: SelectList  ->
                  T_SelectList 
sem_SelectList (SelectList _ann _items _into )  =
    (sem_SelectList_SelectList _ann (sem_SelectItemList _items ) _into )
-- semantic domain
type T_SelectList  = Catalog ->
                     LocalBindings ->
                     ( SelectList,([(String,Type)]),SelectList)
data Inh_SelectList  = Inh_SelectList {cat_Inh_SelectList :: Catalog,lib_Inh_SelectList :: LocalBindings}
data Syn_SelectList  = Syn_SelectList {annotatedTree_Syn_SelectList :: SelectList,listType_Syn_SelectList :: [(String,Type)],originalTree_Syn_SelectList :: SelectList}
wrap_SelectList :: T_SelectList  ->
                   Inh_SelectList  ->
                   Syn_SelectList 
wrap_SelectList sem (Inh_SelectList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_SelectList _lhsOannotatedTree _lhsOlistType _lhsOoriginalTree ))
sem_SelectList_SelectList :: Annotation ->
                             T_SelectItemList  ->
                             ([String]) ->
                             T_SelectList 
sem_SelectList_SelectList ann_ items_ into_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOlistType :: ([(String,Type)])
              _lhsOannotatedTree :: SelectList
              _lhsOoriginalTree :: SelectList
              _itemsOcat :: Catalog
              _itemsOlib :: LocalBindings
              _itemsIannotatedTree :: SelectItemList
              _itemsIlistType :: ([(String,Type)])
              _itemsIoriginalTree :: SelectItemList
              -- "./TypeChecking/SelectLists.ag"(line 76, column 9)
              _lhsOlistType =
                  {-# LINE 76 "./TypeChecking/SelectLists.ag" #-}
                  _itemsIlistType
                  {-# LINE 7459 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectLists.ag"(line 77, column 9)
              _tpe =
                  {-# LINE 77 "./TypeChecking/SelectLists.ag" #-}
                  returnWhen (into_ == []) (()) $ do
                  intoTypes <- either (Left . concat) Right $ listEither $ map (lbLookupID _lhsIlib) into_
                  let fromTypes = map snd _itemsIlistType
                  checkAssignmentValid _lhsIcat
                                       (AnonymousRecordType fromTypes)
                                       (AnonymousRecordType intoTypes)
                  {-# LINE 7469 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectLists.ag"(line 106, column 9)
              _lhsOannotatedTree =
                  {-# LINE 106 "./TypeChecking/SelectLists.ag" #-}
                  addTypeErrors (tes _tpe    ) $
                  SelectList ann_
                             _itemsIannotatedTree
                             into_
                  {-# LINE 7477 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  SelectList ann_ _itemsIannotatedTree into_
                  {-# LINE 7482 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  SelectList ann_ _itemsIoriginalTree into_
                  {-# LINE 7487 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 7492 "AstInternal.hs" #-}
              -- copy rule (down)
              _itemsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 7497 "AstInternal.hs" #-}
              -- copy rule (down)
              _itemsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 7502 "AstInternal.hs" #-}
              ( _itemsIannotatedTree,_itemsIlistType,_itemsIoriginalTree) =
                  (items_ _itemsOcat _itemsOlib )
          in  ( _lhsOannotatedTree,_lhsOlistType,_lhsOoriginalTree)))
-- Statement ---------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         inProducedCat        : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         catUpdates           : [CatalogUpdate]
         libUpdates           : [LocalBindingsUpdate]
         originalTree         : SELF 
   alternatives:
      alternative AlterSequence:
         child ann            : {Annotation}
         child name           : {String}
         child ownedBy        : {String}
         visit 0:
            local libUpdates  : _
            local annotatedTree : _
            local originalTree : _
      alternative AlterTable:
         child ann            : {Annotation}
         child name           : {String}
         child actions        : AlterTableActionList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Assignment:
         child ann            : {Annotation}
         child target         : {String}
         child value          : Expression 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local backTree    : _
            local catUpdates  : {[CatalogUpdate]}
            local statementType : {Maybe StatementType}
            local annotatedTree : _
            local originalTree : _
      alternative CaseStatement:
         child ann            : {Annotation}
         child cases          : ExpressionListStatementListPairList 
         child els            : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative CaseStatementSimple:
         child ann            : {Annotation}
         child val            : Expression 
         child cases          : ExpressionListStatementListPairList 
         child els            : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative ContinueStatement:
         child ann            : {Annotation}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Copy:
         child ann            : {Annotation}
         child table          : {String}
         child targetCols     : {[String]}
         child source         : {CopySource}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative CopyData:
         child ann            : {Annotation}
         child insData        : {String}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative CreateDomain:
         child ann            : {Annotation}
         child name           : {String}
         child typ            : TypeName 
         child checkName      : {String}
         child check          : MaybeBoolExpression 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local backTree    : _
            local statementType : {Maybe StatementType}
            local catUpdates  : {[CatalogUpdate]}
            local annotatedTree : _
            local originalTree : _
      alternative CreateFunction:
         child ann            : {Annotation}
         child name           : {String}
         child params         : ParamDefList 
         child rettype        : TypeName 
         child rep            : {Replace}
         child lang           : {Language}
         child body           : FnBody 
         child vol            : {Volatility}
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local catUpdates  : {[CatalogUpdate]}
            local backTree    : _
            local statementType : {Maybe StatementType}
            local annotatedTree : _
            local originalTree : _
      alternative CreateLanguage:
         child ann            : {Annotation}
         child name           : {String}
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local backTree    : _
            local statementType : {Maybe StatementType}
            local catUpdates  : {[CatalogUpdate]}
            local annotatedTree : _
            local originalTree : _
      alternative CreateSequence:
         child ann            : {Annotation}
         child name           : {String}
         child incr           : {Integer}
         child min            : {Integer}
         child max            : {Integer}
         child start          : {Integer}
         child cache          : {Integer}
         visit 0:
            local libUpdates  : _
            local annotatedTree : _
            local originalTree : _
      alternative CreateTable:
         child ann            : {Annotation}
         child name           : {String}
         child atts           : AttributeDefList 
         child cons           : ConstraintList 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local catUpdates  : {[CatalogUpdate]}
            local attrs       : {[(String,Type)]}
            local statementType : {Maybe StatementType}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative CreateTableAs:
         child ann            : {Annotation}
         child name           : {String}
         child expr           : SelectExpression 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local catUpdates  : {[CatalogUpdate]}
            local selType     : {Maybe Type}
            local attrs       : {Either [TypeError] [(String,Type)]}
            local backTree    : _
            local statementType : {Maybe StatementType}
            local annotatedTree : _
            local originalTree : _
      alternative CreateTrigger:
         child ann            : {Annotation}
         child name           : {String}
         child wh             : {TriggerWhen}
         child events         : {[TriggerEvent]}
         child tbl            : {String}
         child firing         : {TriggerFire}
         child fnName         : {String}
         child fnArgs         : ExpressionList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative CreateType:
         child ann            : {Annotation}
         child name           : {String}
         child atts           : TypeAttributeDefList 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local attrs       : _
            local backTree    : _
            local statementType : {Maybe StatementType}
            local catUpdates  : {[CatalogUpdate]}
            local annotatedTree : _
            local originalTree : _
      alternative CreateView:
         child ann            : {Annotation}
         child name           : {String}
         child expr           : SelectExpression 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local backTree    : _
            local attrs       : _
            local catUpdates  : {[CatalogUpdate]}
            local statementType : {Maybe StatementType}
            local annotatedTree : _
            local originalTree : _
      alternative Delete:
         child ann            : {Annotation}
         child table          : {String}
         child using          : TableRefList 
         child whr            : MaybeBoolExpression 
         child returning      : MaybeSelectList 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local statementType : {Maybe StatementType}
            local backTree    : _
            local catUpdates  : {[CatalogUpdate]}
            local attrs       : {E [(String,Type)]}
            local lib         : _
            local annotatedTree : _
            local originalTree : _
      alternative DropFunction:
         child ann            : {Annotation}
         child ifE            : {IfExists}
         child sigs           : StringTypeNameListPairList 
         child cascade        : {Cascade}
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local backTree    : _
            local catUpdates  : {[CatalogUpdate]}
            local statementType : {Maybe StatementType}
            local annotatedTree : _
            local originalTree : _
      alternative DropSomething:
         child ann            : {Annotation}
         child dropType       : {DropType}
         child ifE            : {IfExists}
         child names          : {[String]}
         child cascade        : {Cascade}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Execute:
         child ann            : {Annotation}
         child expr           : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative ExecuteInto:
         child ann            : {Annotation}
         child expr           : Expression 
         child targets        : {[String]}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative ExitStatement:
         child ann            : {Annotation}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative ForIntegerStatement:
         child ann            : {Annotation}
         child var            : {String}
         child from           : Expression 
         child to             : Expression 
         child sts            : StatementList 
         visit 0:
            local libUpdates  : _
            local varTypeE    : _
            local tpe         : {Either [TypeError] Type}
            local backTree    : _
            local catUpdates  : {[CatalogUpdate]}
            local statementType : {Maybe StatementType}
            local annotatedTree : _
            local originalTree : _
      alternative ForSelectStatement:
         child ann            : {Annotation}
         child var            : {String}
         child sel            : SelectExpression 
         child sts            : StatementList 
         visit 0:
            local libUpdates  : _
            local selType     : _
            local tpe         : {Either [TypeError] Type}
            local backTree    : _
            local catUpdates  : {[CatalogUpdate]}
            local statementType : {Maybe StatementType}
            local annotatedTree : _
            local originalTree : _
      alternative If:
         child ann            : {Annotation}
         child cases          : ExpressionStatementListPairList 
         child els            : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Insert:
         child ann            : {Annotation}
         child table          : {String}
         child targetCols     : {[String]}
         child insData        : SelectExpression 
         child returning      : MaybeSelectList 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local statementType : {Maybe StatementType}
            local columnTypes : {Either [TypeError] [(String,Type)]}
            local insDataAddedInferredTypes : _
            local backTree    : _
            local catUpdates  : {[CatalogUpdate]}
            local annotatedTree : _
            local originalTree : _
      alternative LoopStatement:
         child ann            : {Annotation}
         child sts            : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Notify:
         child ann            : {Annotation}
         child name           : {String}
         visit 0:
            local libUpdates  : _
            local annotatedTree : _
            local originalTree : _
      alternative NullStatement:
         child ann            : {Annotation}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Perform:
         child ann            : {Annotation}
         child expr           : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Raise:
         child ann            : {Annotation}
         child level          : {RaiseType}
         child message        : {String}
         child args           : ExpressionList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Return:
         child ann            : {Annotation}
         child value          : MaybeExpression 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local backTree    : _
            local catUpdates  : {[CatalogUpdate]}
            local statementType : {Maybe StatementType}
            local annotatedTree : _
            local originalTree : _
      alternative ReturnNext:
         child ann            : {Annotation}
         child expr           : Expression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative ReturnQuery:
         child ann            : {Annotation}
         child sel            : SelectExpression 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative SelectStatement:
         child ann            : {Annotation}
         child ex             : SelectExpression 
         visit 0:
            local tpe         : {Either [TypeError] Type}
            local statementType : {Maybe StatementType}
            local backTree    : _
            local catUpdates  : {[CatalogUpdate]}
            local libUpdates  : _
            local annotatedTree : _
            local originalTree : _
      alternative Set:
         child ann            : {Annotation}
         child name           : {String}
         child values         : {[SetValue]}
         visit 0:
            local libUpdates  : _
            local annotatedTree : _
            local originalTree : _
      alternative Truncate:
         child ann            : {Annotation}
         child tables         : {[String]}
         child restartIdentity : {RestartIdentity}
         child cascade        : {Cascade}
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Update:
         child ann            : {Annotation}
         child table          : {String}
         child assigns        : ExpressionList 
         child fromList       : TableRefList 
         child whr            : MaybeBoolExpression 
         child returning      : MaybeSelectList 
         visit 0:
            local libUpdates  : _
            local tpe         : {Either [TypeError] Type}
            local attrs       : {E [(String,Type)]}
            local statementType : {Maybe StatementType}
            local backTree    : _
            local catUpdates  : {[CatalogUpdate]}
            local lib         : _
            local annotatedTree : _
            local originalTree : _
      alternative WhileStatement:
         child ann            : {Annotation}
         child expr           : Expression 
         child sts            : StatementList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data Statement  = AlterSequence (Annotation) (String) (String) 
                | AlterTable (Annotation) (String) (AlterTableActionList) 
                | Assignment (Annotation) (String) (Expression) 
                | CaseStatement (Annotation) (ExpressionListStatementListPairList) (StatementList) 
                | CaseStatementSimple (Annotation) (Expression) (ExpressionListStatementListPairList) (StatementList) 
                | ContinueStatement (Annotation) 
                | Copy (Annotation) (String) ([String]) (CopySource) 
                | CopyData (Annotation) (String) 
                | CreateDomain (Annotation) (String) (TypeName) (String) (MaybeBoolExpression) 
                | CreateFunction (Annotation) (String) (ParamDefList) (TypeName) (Replace) (Language) (FnBody) (Volatility) 
                | CreateLanguage (Annotation) (String) 
                | CreateSequence (Annotation) (String) (Integer) (Integer) (Integer) (Integer) (Integer) 
                | CreateTable (Annotation) (String) (AttributeDefList) (ConstraintList) 
                | CreateTableAs (Annotation) (String) (SelectExpression) 
                | CreateTrigger (Annotation) (String) (TriggerWhen) ([TriggerEvent]) (String) (TriggerFire) (String) (ExpressionList) 
                | CreateType (Annotation) (String) (TypeAttributeDefList) 
                | CreateView (Annotation) (String) (SelectExpression) 
                | Delete (Annotation) (String) (TableRefList) (MaybeBoolExpression) (MaybeSelectList) 
                | DropFunction (Annotation) (IfExists) (StringTypeNameListPairList) (Cascade) 
                | DropSomething (Annotation) (DropType) (IfExists) ([String]) (Cascade) 
                | Execute (Annotation) (Expression) 
                | ExecuteInto (Annotation) (Expression) ([String]) 
                | ExitStatement (Annotation) 
                | ForIntegerStatement (Annotation) (String) (Expression) (Expression) (StatementList) 
                | ForSelectStatement (Annotation) (String) (SelectExpression) (StatementList) 
                | If (Annotation) (ExpressionStatementListPairList) (StatementList) 
                | Insert (Annotation) (String) ([String]) (SelectExpression) (MaybeSelectList) 
                | LoopStatement (Annotation) (StatementList) 
                | Notify (Annotation) (String) 
                | NullStatement (Annotation) 
                | Perform (Annotation) (Expression) 
                | Raise (Annotation) (RaiseType) (String) (ExpressionList) 
                | Return (Annotation) (MaybeExpression) 
                | ReturnNext (Annotation) (Expression) 
                | ReturnQuery (Annotation) (SelectExpression) 
                | SelectStatement (Annotation) (SelectExpression) 
                | Set (Annotation) (String) ([SetValue]) 
                | Truncate (Annotation) ([String]) (RestartIdentity) (Cascade) 
                | Update (Annotation) (String) (ExpressionList) (TableRefList) (MaybeBoolExpression) (MaybeSelectList) 
                | WhileStatement (Annotation) (Expression) (StatementList) 
                deriving ( Data,Eq,Show,Typeable)
-- cata
sem_Statement :: Statement  ->
                 T_Statement 
sem_Statement (AlterSequence _ann _name _ownedBy )  =
    (sem_Statement_AlterSequence _ann _name _ownedBy )
sem_Statement (AlterTable _ann _name _actions )  =
    (sem_Statement_AlterTable _ann _name (sem_AlterTableActionList _actions ) )
sem_Statement (Assignment _ann _target _value )  =
    (sem_Statement_Assignment _ann _target (sem_Expression _value ) )
sem_Statement (CaseStatement _ann _cases _els )  =
    (sem_Statement_CaseStatement _ann (sem_ExpressionListStatementListPairList _cases ) (sem_StatementList _els ) )
sem_Statement (CaseStatementSimple _ann _val _cases _els )  =
    (sem_Statement_CaseStatementSimple _ann (sem_Expression _val ) (sem_ExpressionListStatementListPairList _cases ) (sem_StatementList _els ) )
sem_Statement (ContinueStatement _ann )  =
    (sem_Statement_ContinueStatement _ann )
sem_Statement (Copy _ann _table _targetCols _source )  =
    (sem_Statement_Copy _ann _table _targetCols _source )
sem_Statement (CopyData _ann _insData )  =
    (sem_Statement_CopyData _ann _insData )
sem_Statement (CreateDomain _ann _name _typ _checkName _check )  =
    (sem_Statement_CreateDomain _ann _name (sem_TypeName _typ ) _checkName (sem_MaybeBoolExpression _check ) )
sem_Statement (CreateFunction _ann _name _params _rettype _rep _lang _body _vol )  =
    (sem_Statement_CreateFunction _ann _name (sem_ParamDefList _params ) (sem_TypeName _rettype ) _rep _lang (sem_FnBody _body ) _vol )
sem_Statement (CreateLanguage _ann _name )  =
    (sem_Statement_CreateLanguage _ann _name )
sem_Statement (CreateSequence _ann _name _incr _min _max _start _cache )  =
    (sem_Statement_CreateSequence _ann _name _incr _min _max _start _cache )
sem_Statement (CreateTable _ann _name _atts _cons )  =
    (sem_Statement_CreateTable _ann _name (sem_AttributeDefList _atts ) (sem_ConstraintList _cons ) )
sem_Statement (CreateTableAs _ann _name _expr )  =
    (sem_Statement_CreateTableAs _ann _name (sem_SelectExpression _expr ) )
sem_Statement (CreateTrigger _ann _name _wh _events _tbl _firing _fnName _fnArgs )  =
    (sem_Statement_CreateTrigger _ann _name _wh _events _tbl _firing _fnName (sem_ExpressionList _fnArgs ) )
sem_Statement (CreateType _ann _name _atts )  =
    (sem_Statement_CreateType _ann _name (sem_TypeAttributeDefList _atts ) )
sem_Statement (CreateView _ann _name _expr )  =
    (sem_Statement_CreateView _ann _name (sem_SelectExpression _expr ) )
sem_Statement (Delete _ann _table _using _whr _returning )  =
    (sem_Statement_Delete _ann _table (sem_TableRefList _using ) (sem_MaybeBoolExpression _whr ) (sem_MaybeSelectList _returning ) )
sem_Statement (DropFunction _ann _ifE _sigs _cascade )  =
    (sem_Statement_DropFunction _ann _ifE (sem_StringTypeNameListPairList _sigs ) _cascade )
sem_Statement (DropSomething _ann _dropType _ifE _names _cascade )  =
    (sem_Statement_DropSomething _ann _dropType _ifE _names _cascade )
sem_Statement (Execute _ann _expr )  =
    (sem_Statement_Execute _ann (sem_Expression _expr ) )
sem_Statement (ExecuteInto _ann _expr _targets )  =
    (sem_Statement_ExecuteInto _ann (sem_Expression _expr ) _targets )
sem_Statement (ExitStatement _ann )  =
    (sem_Statement_ExitStatement _ann )
sem_Statement (ForIntegerStatement _ann _var _from _to _sts )  =
    (sem_Statement_ForIntegerStatement _ann _var (sem_Expression _from ) (sem_Expression _to ) (sem_StatementList _sts ) )
sem_Statement (ForSelectStatement _ann _var _sel _sts )  =
    (sem_Statement_ForSelectStatement _ann _var (sem_SelectExpression _sel ) (sem_StatementList _sts ) )
sem_Statement (If _ann _cases _els )  =
    (sem_Statement_If _ann (sem_ExpressionStatementListPairList _cases ) (sem_StatementList _els ) )
sem_Statement (Insert _ann _table _targetCols _insData _returning )  =
    (sem_Statement_Insert _ann _table _targetCols (sem_SelectExpression _insData ) (sem_MaybeSelectList _returning ) )
sem_Statement (LoopStatement _ann _sts )  =
    (sem_Statement_LoopStatement _ann (sem_StatementList _sts ) )
sem_Statement (Notify _ann _name )  =
    (sem_Statement_Notify _ann _name )
sem_Statement (NullStatement _ann )  =
    (sem_Statement_NullStatement _ann )
sem_Statement (Perform _ann _expr )  =
    (sem_Statement_Perform _ann (sem_Expression _expr ) )
sem_Statement (Raise _ann _level _message _args )  =
    (sem_Statement_Raise _ann _level _message (sem_ExpressionList _args ) )
sem_Statement (Return _ann _value )  =
    (sem_Statement_Return _ann (sem_MaybeExpression _value ) )
sem_Statement (ReturnNext _ann _expr )  =
    (sem_Statement_ReturnNext _ann (sem_Expression _expr ) )
sem_Statement (ReturnQuery _ann _sel )  =
    (sem_Statement_ReturnQuery _ann (sem_SelectExpression _sel ) )
sem_Statement (SelectStatement _ann _ex )  =
    (sem_Statement_SelectStatement _ann (sem_SelectExpression _ex ) )
sem_Statement (Set _ann _name _values )  =
    (sem_Statement_Set _ann _name _values )
sem_Statement (Truncate _ann _tables _restartIdentity _cascade )  =
    (sem_Statement_Truncate _ann _tables _restartIdentity _cascade )
sem_Statement (Update _ann _table _assigns _fromList _whr _returning )  =
    (sem_Statement_Update _ann _table (sem_ExpressionList _assigns ) (sem_TableRefList _fromList ) (sem_MaybeBoolExpression _whr ) (sem_MaybeSelectList _returning ) )
sem_Statement (WhileStatement _ann _expr _sts )  =
    (sem_Statement_WhileStatement _ann (sem_Expression _expr ) (sem_StatementList _sts ) )
-- semantic domain
type T_Statement  = Catalog ->
                    Catalog ->
                    LocalBindings ->
                    ( Statement,([CatalogUpdate]),([LocalBindingsUpdate]),Statement)
data Inh_Statement  = Inh_Statement {cat_Inh_Statement :: Catalog,inProducedCat_Inh_Statement :: Catalog,lib_Inh_Statement :: LocalBindings}
data Syn_Statement  = Syn_Statement {annotatedTree_Syn_Statement :: Statement,catUpdates_Syn_Statement :: [CatalogUpdate],libUpdates_Syn_Statement :: [LocalBindingsUpdate],originalTree_Syn_Statement :: Statement}
wrap_Statement :: T_Statement  ->
                  Inh_Statement  ->
                  Syn_Statement 
wrap_Statement sem (Inh_Statement _lhsIcat _lhsIinProducedCat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIinProducedCat _lhsIlib )
     in  (Syn_Statement _lhsOannotatedTree _lhsOcatUpdates _lhsOlibUpdates _lhsOoriginalTree ))
sem_Statement_AlterSequence :: Annotation ->
                               String ->
                               String ->
                               T_Statement 
sem_Statement_AlterSequence ann_ name_ ownedBy_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8069 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8074 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8079 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  AlterSequence ann_ name_ ownedBy_
                  {-# LINE 8084 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  AlterSequence ann_ name_ ownedBy_
                  {-# LINE 8089 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 8094 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8099 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_AlterTable :: Annotation ->
                            String ->
                            T_AlterTableActionList  ->
                            T_Statement 
sem_Statement_AlterTable ann_ name_ actions_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _actionsOcat :: Catalog
              _actionsOlib :: LocalBindings
              _actionsIannotatedTree :: AlterTableActionList
              _actionsIoriginalTree :: AlterTableActionList
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8121 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8126 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  AlterTable ann_ name_ _actionsIannotatedTree
                  {-# LINE 8131 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  AlterTable ann_ name_ _actionsIoriginalTree
                  {-# LINE 8136 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 8141 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8146 "AstInternal.hs" #-}
              -- copy rule (down)
              _actionsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8151 "AstInternal.hs" #-}
              -- copy rule (down)
              _actionsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8156 "AstInternal.hs" #-}
              ( _actionsIannotatedTree,_actionsIoriginalTree) =
                  (actions_ _actionsOcat _actionsOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Assignment :: Annotation ->
                            String ->
                            T_Expression  ->
                            T_Statement 
sem_Statement_Assignment ann_ target_ value_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _catUpdates :: ([CatalogUpdate])
              _statementType :: (Maybe StatementType)
              _lhsOoriginalTree :: Statement
              _valueOcat :: Catalog
              _valueOlib :: LocalBindings
              _valueIannotatedTree :: Expression
              _valueIntAnnotatedTree :: Expression
              _valueIntType :: ([(String,Type)])
              _valueIoriginalTree :: Expression
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 8188 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 8193 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 8198 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8203 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 20, column 9)
              _tpe =
                  {-# LINE 20 "./TypeChecking/Plpgsql.ag" #-}
                  do
                  fromType <- lmt $ getTypeAnnotation _valueIannotatedTree
                  toType <- lbLookupID _lhsIlib target_
                  checkAssignmentValid _lhsIcat fromType toType
                  return $ Pseudo Void
                  {-# LINE 8212 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 26, column 9)
              _backTree =
                  {-# LINE 26 "./TypeChecking/Plpgsql.ag" #-}
                  Assignment ann_ target_ _valueIannotatedTree
                  {-# LINE 8217 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 27, column 9)
              _catUpdates =
                  {-# LINE 27 "./TypeChecking/Plpgsql.ag" #-}
                  []
                  {-# LINE 8222 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 28, column 9)
              _statementType =
                  {-# LINE 28 "./TypeChecking/Plpgsql.ag" #-}
                  Nothing
                  {-# LINE 8227 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Assignment ann_ target_ _valueIannotatedTree
                  {-# LINE 8232 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Assignment ann_ target_ _valueIoriginalTree
                  {-# LINE 8237 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8242 "AstInternal.hs" #-}
              -- copy rule (down)
              _valueOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8247 "AstInternal.hs" #-}
              -- copy rule (down)
              _valueOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8252 "AstInternal.hs" #-}
              ( _valueIannotatedTree,_valueIntAnnotatedTree,_valueIntType,_valueIoriginalTree) =
                  (value_ _valueOcat _valueOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CaseStatement :: Annotation ->
                               T_ExpressionListStatementListPairList  ->
                               T_StatementList  ->
                               T_Statement 
sem_Statement_CaseStatement ann_ cases_ els_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _elsOcatUpdates :: ([CatalogUpdate])
              _elsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _casesOcat :: Catalog
              _casesOlib :: LocalBindings
              _elsOcat :: Catalog
              _elsOlib :: LocalBindings
              _casesIannotatedTree :: ExpressionListStatementListPairList
              _casesIoriginalTree :: ExpressionListStatementListPairList
              _elsIannotatedTree :: StatementList
              _elsIoriginalTree :: StatementList
              _elsIproducedCat :: Catalog
              _elsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8284 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8289 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 123, column 9)
              _elsOcatUpdates =
                  {-# LINE 123 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8294 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 124, column 9)
              _elsOlibUpdates =
                  {-# LINE 124 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8299 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CaseStatement ann_ _casesIannotatedTree _elsIannotatedTree
                  {-# LINE 8304 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CaseStatement ann_ _casesIoriginalTree _elsIoriginalTree
                  {-# LINE 8309 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 8314 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8319 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8324 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8329 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8334 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8339 "AstInternal.hs" #-}
              ( _casesIannotatedTree,_casesIoriginalTree) =
                  (cases_ _casesOcat _casesOlib )
              ( _elsIannotatedTree,_elsIoriginalTree,_elsIproducedCat,_elsIproducedLib) =
                  (els_ _elsOcat _elsOcatUpdates _elsOlib _elsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CaseStatementSimple :: Annotation ->
                                     T_Expression  ->
                                     T_ExpressionListStatementListPairList  ->
                                     T_StatementList  ->
                                     T_Statement 
sem_Statement_CaseStatementSimple ann_ val_ cases_ els_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _elsOcatUpdates :: ([CatalogUpdate])
              _elsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _valOcat :: Catalog
              _valOlib :: LocalBindings
              _casesOcat :: Catalog
              _casesOlib :: LocalBindings
              _elsOcat :: Catalog
              _elsOlib :: LocalBindings
              _valIannotatedTree :: Expression
              _valIntAnnotatedTree :: Expression
              _valIntType :: ([(String,Type)])
              _valIoriginalTree :: Expression
              _casesIannotatedTree :: ExpressionListStatementListPairList
              _casesIoriginalTree :: ExpressionListStatementListPairList
              _elsIannotatedTree :: StatementList
              _elsIoriginalTree :: StatementList
              _elsIproducedCat :: Catalog
              _elsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8380 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8385 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 123, column 9)
              _elsOcatUpdates =
                  {-# LINE 123 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8390 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 124, column 9)
              _elsOlibUpdates =
                  {-# LINE 124 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8395 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CaseStatementSimple ann_ _valIannotatedTree _casesIannotatedTree _elsIannotatedTree
                  {-# LINE 8400 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CaseStatementSimple ann_ _valIoriginalTree _casesIoriginalTree _elsIoriginalTree
                  {-# LINE 8405 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 8410 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8415 "AstInternal.hs" #-}
              -- copy rule (down)
              _valOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8420 "AstInternal.hs" #-}
              -- copy rule (down)
              _valOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8425 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8430 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8435 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8440 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8445 "AstInternal.hs" #-}
              ( _valIannotatedTree,_valIntAnnotatedTree,_valIntType,_valIoriginalTree) =
                  (val_ _valOcat _valOlib )
              ( _casesIannotatedTree,_casesIoriginalTree) =
                  (cases_ _casesOcat _casesOlib )
              ( _elsIannotatedTree,_elsIoriginalTree,_elsIproducedCat,_elsIproducedLib) =
                  (els_ _elsOcat _elsOcatUpdates _elsOlib _elsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_ContinueStatement :: Annotation ->
                                   T_Statement 
sem_Statement_ContinueStatement ann_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8467 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8472 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ContinueStatement ann_
                  {-# LINE 8477 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ContinueStatement ann_
                  {-# LINE 8482 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 8487 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8492 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Copy :: Annotation ->
                      String ->
                      ([String]) ->
                      CopySource ->
                      T_Statement 
sem_Statement_Copy ann_ table_ targetCols_ source_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8511 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8516 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Copy ann_ table_ targetCols_ source_
                  {-# LINE 8521 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Copy ann_ table_ targetCols_ source_
                  {-# LINE 8526 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 8531 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8536 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CopyData :: Annotation ->
                          String ->
                          T_Statement 
sem_Statement_CopyData ann_ insData_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8553 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8558 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CopyData ann_ insData_
                  {-# LINE 8563 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CopyData ann_ insData_
                  {-# LINE 8568 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 8573 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8578 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CreateDomain :: Annotation ->
                              String ->
                              T_TypeName  ->
                              String ->
                              T_MaybeBoolExpression  ->
                              T_Statement 
sem_Statement_CreateDomain ann_ name_ typ_ checkName_ check_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _statementType :: (Maybe StatementType)
              _catUpdates :: ([CatalogUpdate])
              _checkOlib :: LocalBindings
              _lhsOoriginalTree :: Statement
              _typOcat :: Catalog
              _typOlib :: LocalBindings
              _checkOcat :: Catalog
              _typIannotatedTree :: TypeName
              _typInamedType :: (Maybe Type)
              _typIoriginalTree :: TypeName
              _checkIannotatedTree :: MaybeBoolExpression
              _checkIoriginalTree :: MaybeBoolExpression
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 8613 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 8618 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 8623 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8628 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 68, column 9)
              _tpe =
                  {-# LINE 68 "./TypeChecking/MiscCreates.ag" #-}
                  Right $ Pseudo Void
                  {-# LINE 8633 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 69, column 9)
              _backTree =
                  {-# LINE 69 "./TypeChecking/MiscCreates.ag" #-}
                  CreateDomain ann_ name_ _typIannotatedTree checkName_ _checkIannotatedTree
                  {-# LINE 8638 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 70, column 9)
              _statementType =
                  {-# LINE 70 "./TypeChecking/MiscCreates.ag" #-}
                  Nothing
                  {-# LINE 8643 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 71, column 9)
              _catUpdates =
                  {-# LINE 71 "./TypeChecking/MiscCreates.ag" #-}
                  maybe [] (\t -> [CatCreateDomain (DomainType name_) t]) _typInamedType
                  {-# LINE 8648 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 73, column 9)
              _checkOlib =
                  {-# LINE 73 "./TypeChecking/MiscCreates.ag" #-}
                  either (const _lhsIlib) id $ do
                  nt <- lmt _typInamedType
                  lbUpdate _lhsIcat
                    (LBIds "domain check value" "" [("value", nt)] [])
                    _lhsIlib
                  {-# LINE 8657 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CreateDomain ann_ name_ _typIannotatedTree checkName_ _checkIannotatedTree
                  {-# LINE 8662 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CreateDomain ann_ name_ _typIoriginalTree checkName_ _checkIoriginalTree
                  {-# LINE 8667 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8672 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8677 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8682 "AstInternal.hs" #-}
              -- copy rule (down)
              _checkOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8687 "AstInternal.hs" #-}
              ( _typIannotatedTree,_typInamedType,_typIoriginalTree) =
                  (typ_ _typOcat _typOlib )
              ( _checkIannotatedTree,_checkIoriginalTree) =
                  (check_ _checkOcat _checkOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CreateFunction :: Annotation ->
                                String ->
                                T_ParamDefList  ->
                                T_TypeName  ->
                                Replace ->
                                Language ->
                                T_FnBody  ->
                                Volatility ->
                                T_Statement 
sem_Statement_CreateFunction ann_ name_ params_ rettype_ rep_ lang_ body_ vol_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _bodyOlib :: LocalBindings
              _paramsOpos :: Int
              _tpe :: (Either [TypeError] Type)
              _catUpdates :: ([CatalogUpdate])
              _statementType :: (Maybe StatementType)
              _bodyOcat :: Catalog
              _lhsOoriginalTree :: Statement
              _paramsOcat :: Catalog
              _paramsOlib :: LocalBindings
              _rettypeOcat :: Catalog
              _rettypeOlib :: LocalBindings
              _paramsIannotatedTree :: ParamDefList
              _paramsIoriginalTree :: ParamDefList
              _paramsIparams :: ([(ParamName, Maybe Type)])
              _rettypeIannotatedTree :: TypeName
              _rettypeInamedType :: (Maybe Type)
              _rettypeIoriginalTree :: TypeName
              _bodyIannotatedTree :: FnBody
              _bodyIoriginalTree :: FnBody
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 8735 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 8740 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 8745 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8750 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 66, column 9)
              _bodyOlib =
                  {-# LINE 66 "./TypeChecking/CreateFunction.ag" #-}
                  either (const _lhsIlib) id $ do
                  rt <- lmt _rettypeInamedType
                  let p = params
                          ++ case rt of
                               Pseudo Trigger -> [("OLD", Pseudo TriggerRecord)
                                                 ,("NEW", Pseudo TriggerRecord)]
                               _ -> []
                  lbUpdate _lhsIcat (LBIds (name_ ++ " parameters") "" p []) _lhsIlib
                    >>= lbUpdate _lhsIcat (LBIds (name_ ++ " parameters") name_ paramsNoPos [])
                  where
                    params :: [(String,Type)]
                    params = concat $ mapMaybe prm _paramsIparams
                    paramsNoPos :: [(String,Type)]
                    paramsNoPos = mapMaybe pnp _paramsIparams
                    prm :: (ParamName,Maybe Type) -> Maybe [(String,Type)]
                    prm (NamedParam p n,Just t) = Just [(n,t),("$" ++ show p, t)]
                    prm (UnnamedParam p,Just t) = Just [("$" ++ show p, t)]
                    prm _ = Nothing
                    pnp :: (ParamName,Maybe Type) -> Maybe (String,Type)
                    pnp (NamedParam _ n,Just t) = Just (n,t)
                    pnp _ = Nothing
                  {-# LINE 8775 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 88, column 9)
              _paramsOpos =
                  {-# LINE 88 "./TypeChecking/CreateFunction.ag" #-}
                  1
                  {-# LINE 8780 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 128, column 9)
              _tpe =
                  {-# LINE 128 "./TypeChecking/CreateFunction.ag" #-}
                  Right $ Pseudo Void
                  {-# LINE 8785 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 129, column 9)
              _catUpdates =
                  {-# LINE 129 "./TypeChecking/CreateFunction.ag" #-}
                  either (const []) id $ do
                  let ps = mapMaybe lpt _paramsIparams
                  rt <- lmt _rettypeInamedType
                  return [CatCreateFunction FunName
                                            (map toLower name_)
                                            ps
                                            rt
                                            False]
                  where
                    lpt (_,Just t) = Just t
                    lpt _ = Nothing
                  {-# LINE 8800 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 141, column 9)
              _backTree =
                  {-# LINE 141 "./TypeChecking/CreateFunction.ag" #-}
                  CreateFunction ann_
                                 name_
                                 _paramsIannotatedTree
                                 _rettypeIannotatedTree
                                 rep_
                                 lang_
                                 _bodyIannotatedTree
                                 vol_
                  {-# LINE 8812 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 149, column 9)
              _statementType =
                  {-# LINE 149 "./TypeChecking/CreateFunction.ag" #-}
                  Nothing
                  {-# LINE 8817 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateFunction.ag"(line 150, column 9)
              _bodyOcat =
                  {-# LINE 150 "./TypeChecking/CreateFunction.ag" #-}
                  _lhsIinProducedCat
                  {-# LINE 8822 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CreateFunction ann_ name_ _paramsIannotatedTree _rettypeIannotatedTree rep_ lang_ _bodyIannotatedTree vol_
                  {-# LINE 8827 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CreateFunction ann_ name_ _paramsIoriginalTree _rettypeIoriginalTree rep_ lang_ _bodyIoriginalTree vol_
                  {-# LINE 8832 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8837 "AstInternal.hs" #-}
              -- copy rule (down)
              _paramsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8842 "AstInternal.hs" #-}
              -- copy rule (down)
              _paramsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8847 "AstInternal.hs" #-}
              -- copy rule (down)
              _rettypeOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 8852 "AstInternal.hs" #-}
              -- copy rule (down)
              _rettypeOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 8857 "AstInternal.hs" #-}
              ( _paramsIannotatedTree,_paramsIoriginalTree,_paramsIparams) =
                  (params_ _paramsOcat _paramsOlib _paramsOpos )
              ( _rettypeIannotatedTree,_rettypeInamedType,_rettypeIoriginalTree) =
                  (rettype_ _rettypeOcat _rettypeOlib )
              ( _bodyIannotatedTree,_bodyIoriginalTree) =
                  (body_ _bodyOcat _bodyOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CreateLanguage :: Annotation ->
                                String ->
                                T_Statement 
sem_Statement_CreateLanguage ann_ name_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _statementType :: (Maybe StatementType)
              _catUpdates :: ([CatalogUpdate])
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 8886 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 8891 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 8896 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8901 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 81, column 9)
              _tpe =
                  {-# LINE 81 "./TypeChecking/MiscCreates.ag" #-}
                  Right $ Pseudo Void
                  {-# LINE 8906 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 82, column 9)
              _backTree =
                  {-# LINE 82 "./TypeChecking/MiscCreates.ag" #-}
                  CreateLanguage ann_ name_
                  {-# LINE 8911 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 83, column 9)
              _statementType =
                  {-# LINE 83 "./TypeChecking/MiscCreates.ag" #-}
                  Nothing
                  {-# LINE 8916 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 84, column 9)
              _catUpdates =
                  {-# LINE 84 "./TypeChecking/MiscCreates.ag" #-}
                  [CatCreateFunction FunName "plpgsql_call_handler" [] (Pseudo LanguageHandler) False
                  ,CatCreateFunction FunName "plpgsql_validator" [ScalarType "oid"] (Pseudo Void) False]
                  {-# LINE 8922 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CreateLanguage ann_ name_
                  {-# LINE 8927 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CreateLanguage ann_ name_
                  {-# LINE 8932 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8937 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CreateSequence :: Annotation ->
                                String ->
                                Integer ->
                                Integer ->
                                Integer ->
                                Integer ->
                                Integer ->
                                T_Statement 
sem_Statement_CreateSequence ann_ name_ incr_ min_ max_ start_ cache_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8959 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8964 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 8969 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CreateSequence ann_ name_ incr_ min_ max_ start_ cache_
                  {-# LINE 8974 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CreateSequence ann_ name_ incr_ min_ max_ start_ cache_
                  {-# LINE 8979 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 8984 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 8989 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CreateTable :: Annotation ->
                             String ->
                             T_AttributeDefList  ->
                             T_ConstraintList  ->
                             T_Statement 
sem_Statement_CreateTable ann_ name_ atts_ cons_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _catUpdates :: ([CatalogUpdate])
              _attrs :: ([(String,Type)])
              _statementType :: (Maybe StatementType)
              _consOlib :: LocalBindings
              _lhsOoriginalTree :: Statement
              _attsOcat :: Catalog
              _attsOlib :: LocalBindings
              _consOcat :: Catalog
              _attsIannotatedTree :: AttributeDefList
              _attsIattrs :: ([(String, Maybe Type)])
              _attsIoriginalTree :: AttributeDefList
              _consIannotatedTree :: ConstraintList
              _consIoriginalTree :: ConstraintList
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 9024 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 9029 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 9034 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9039 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 31, column 9)
              _tpe =
                  {-# LINE 31 "./TypeChecking/CreateTable.ag" #-}
                  Right $ Pseudo Void
                  {-# LINE 9044 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 32, column 9)
              _catUpdates =
                  {-# LINE 32 "./TypeChecking/CreateTable.ag" #-}
                  [CatCreateTable name_ _attrs     defaultSystemColumns]
                  {-# LINE 9049 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 35, column 9)
              _attrs =
                  {-# LINE 35 "./TypeChecking/CreateTable.ag" #-}
                  mapMaybe okAt _attsIattrs
                  where
                    okAt (s, Just t) = Just (s,t)
                    okAt (_,Nothing) = Nothing
                  {-# LINE 9057 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 40, column 9)
              _statementType =
                  {-# LINE 40 "./TypeChecking/CreateTable.ag" #-}
                  Nothing
                  {-# LINE 9062 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 41, column 9)
              _backTree =
                  {-# LINE 41 "./TypeChecking/CreateTable.ag" #-}
                  CreateTable ann_
                              name_
                              _attsIannotatedTree
                              _consIannotatedTree
                  {-# LINE 9070 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 45, column 9)
              _consOlib =
                  {-# LINE 45 "./TypeChecking/CreateTable.ag" #-}
                  case lbUpdate _lhsIcat
                         (LBIds "attributedefs" "" _attrs     [])
                         _lhsIlib of
                     Left x -> error $ "statement-createtable-cons.lib " ++ show x
                     Right e -> e
                  {-# LINE 9079 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CreateTable ann_ name_ _attsIannotatedTree _consIannotatedTree
                  {-# LINE 9084 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CreateTable ann_ name_ _attsIoriginalTree _consIoriginalTree
                  {-# LINE 9089 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9094 "AstInternal.hs" #-}
              -- copy rule (down)
              _attsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9099 "AstInternal.hs" #-}
              -- copy rule (down)
              _attsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 9104 "AstInternal.hs" #-}
              -- copy rule (down)
              _consOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9109 "AstInternal.hs" #-}
              ( _attsIannotatedTree,_attsIattrs,_attsIoriginalTree) =
                  (atts_ _attsOcat _attsOlib )
              ( _consIannotatedTree,_consIoriginalTree) =
                  (cons_ _consOcat _consOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CreateTableAs :: Annotation ->
                               String ->
                               T_SelectExpression  ->
                               T_Statement 
sem_Statement_CreateTableAs ann_ name_ expr_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _catUpdates :: ([CatalogUpdate])
              _selType :: (Maybe Type)
              _attrs :: (Either [TypeError] [(String,Type)])
              _statementType :: (Maybe StatementType)
              _lhsOoriginalTree :: Statement
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _exprIannotatedTree :: SelectExpression
              _exprIoriginalTree :: SelectExpression
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 9143 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 9148 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 9153 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9158 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 64, column 9)
              _tpe =
                  {-# LINE 64 "./TypeChecking/CreateTable.ag" #-}
                  lmt _selType
                  {-# LINE 9163 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 65, column 9)
              _catUpdates =
                  {-# LINE 65 "./TypeChecking/CreateTable.ag" #-}
                  either (const []) id $ do
                  ats <- _attrs
                  return [CatCreateTable name_ ats defaultSystemColumns]
                  {-# LINE 9170 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 71, column 9)
              _selType =
                  {-# LINE 71 "./TypeChecking/CreateTable.ag" #-}
                  getTypeAnnotation _exprIannotatedTree
                  {-# LINE 9175 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 74, column 9)
              _attrs =
                  {-# LINE 74 "./TypeChecking/CreateTable.ag" #-}
                  lmt _selType     >>= unwrapSetOfComposite
                  {-# LINE 9180 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 76, column 9)
              _backTree =
                  {-# LINE 76 "./TypeChecking/CreateTable.ag" #-}
                  CreateTableAs ann_ name_ _exprIannotatedTree
                  {-# LINE 9185 "AstInternal.hs" #-}
              -- "./TypeChecking/CreateTable.ag"(line 77, column 9)
              _statementType =
                  {-# LINE 77 "./TypeChecking/CreateTable.ag" #-}
                  Nothing
                  {-# LINE 9190 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CreateTableAs ann_ name_ _exprIannotatedTree
                  {-# LINE 9195 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CreateTableAs ann_ name_ _exprIoriginalTree
                  {-# LINE 9200 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9205 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9210 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 9215 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CreateTrigger :: Annotation ->
                               String ->
                               TriggerWhen ->
                               ([TriggerEvent]) ->
                               String ->
                               TriggerFire ->
                               String ->
                               T_ExpressionList  ->
                               T_Statement 
sem_Statement_CreateTrigger ann_ name_ wh_ events_ tbl_ firing_ fnName_ fnArgs_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _fnArgsOcat :: Catalog
              _fnArgsOlib :: LocalBindings
              _fnArgsIannotatedTree :: ExpressionList
              _fnArgsIoriginalTree :: ExpressionList
              _fnArgsItypeList :: ([Maybe Type])
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9245 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9250 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CreateTrigger ann_ name_ wh_ events_ tbl_ firing_ fnName_ _fnArgsIannotatedTree
                  {-# LINE 9255 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CreateTrigger ann_ name_ wh_ events_ tbl_ firing_ fnName_ _fnArgsIoriginalTree
                  {-# LINE 9260 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 9265 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9270 "AstInternal.hs" #-}
              -- copy rule (down)
              _fnArgsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9275 "AstInternal.hs" #-}
              -- copy rule (down)
              _fnArgsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 9280 "AstInternal.hs" #-}
              ( _fnArgsIannotatedTree,_fnArgsIoriginalTree,_fnArgsItypeList) =
                  (fnArgs_ _fnArgsOcat _fnArgsOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CreateType :: Annotation ->
                            String ->
                            T_TypeAttributeDefList  ->
                            T_Statement 
sem_Statement_CreateType ann_ name_ atts_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _statementType :: (Maybe StatementType)
              _catUpdates :: ([CatalogUpdate])
              _lhsOoriginalTree :: Statement
              _attsOcat :: Catalog
              _attsOlib :: LocalBindings
              _attsIannotatedTree :: TypeAttributeDefList
              _attsIattrs :: ([(String, Maybe Type)])
              _attsIoriginalTree :: TypeAttributeDefList
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 9311 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 9316 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 9321 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9326 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 51, column 9)
              _tpe =
                  {-# LINE 51 "./TypeChecking/MiscCreates.ag" #-}
                  Right $ Pseudo Void
                  {-# LINE 9331 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 52, column 9)
              _attrs =
                  {-# LINE 52 "./TypeChecking/MiscCreates.ag" #-}
                  mapMaybe okAt _attsIattrs
                  where
                    okAt (s, Just t) = Just (s,t)
                    okAt (_,Nothing) = Nothing
                  {-# LINE 9339 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 56, column 9)
              _backTree =
                  {-# LINE 56 "./TypeChecking/MiscCreates.ag" #-}
                  CreateType ann_ name_ _attsIannotatedTree
                  {-# LINE 9344 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 57, column 9)
              _statementType =
                  {-# LINE 57 "./TypeChecking/MiscCreates.ag" #-}
                  Nothing
                  {-# LINE 9349 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 58, column 9)
              _catUpdates =
                  {-# LINE 58 "./TypeChecking/MiscCreates.ag" #-}
                  [CatCreateComposite name_ _attrs    ]
                  {-# LINE 9354 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CreateType ann_ name_ _attsIannotatedTree
                  {-# LINE 9359 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CreateType ann_ name_ _attsIoriginalTree
                  {-# LINE 9364 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9369 "AstInternal.hs" #-}
              -- copy rule (down)
              _attsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9374 "AstInternal.hs" #-}
              -- copy rule (down)
              _attsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 9379 "AstInternal.hs" #-}
              ( _attsIannotatedTree,_attsIattrs,_attsIoriginalTree) =
                  (atts_ _attsOcat _attsOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_CreateView :: Annotation ->
                            String ->
                            T_SelectExpression  ->
                            T_Statement 
sem_Statement_CreateView ann_ name_ expr_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _catUpdates :: ([CatalogUpdate])
              _statementType :: (Maybe StatementType)
              _lhsOoriginalTree :: Statement
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _exprIannotatedTree :: SelectExpression
              _exprIoriginalTree :: SelectExpression
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 9409 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 9414 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 9419 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9424 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 15, column 9)
              _tpe =
                  {-# LINE 15 "./TypeChecking/MiscCreates.ag" #-}
                  Right $ Pseudo Void
                  {-# LINE 9429 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 16, column 9)
              _backTree =
                  {-# LINE 16 "./TypeChecking/MiscCreates.ag" #-}
                  CreateView ann_ name_ _exprIannotatedTree
                  {-# LINE 9434 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 17, column 9)
              _attrs =
                  {-# LINE 17 "./TypeChecking/MiscCreates.ag" #-}
                  case getTypeAnnotation _exprIannotatedTree of
                    Just(SetOfType (CompositeType c)) -> Just c
                    _ -> Nothing
                  {-# LINE 9441 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 20, column 9)
              _catUpdates =
                  {-# LINE 20 "./TypeChecking/MiscCreates.ag" #-}
                  maybe [] (\a -> [CatCreateView name_ a]) _attrs
                  {-# LINE 9446 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 22, column 9)
              _statementType =
                  {-# LINE 22 "./TypeChecking/MiscCreates.ag" #-}
                  Nothing
                  {-# LINE 9451 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  CreateView ann_ name_ _exprIannotatedTree
                  {-# LINE 9456 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  CreateView ann_ name_ _exprIoriginalTree
                  {-# LINE 9461 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9466 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9471 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 9476 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Delete :: Annotation ->
                        String ->
                        T_TableRefList  ->
                        T_MaybeBoolExpression  ->
                        T_MaybeSelectList  ->
                        T_Statement 
sem_Statement_Delete ann_ table_ using_ whr_ returning_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _statementType :: (Maybe StatementType)
              _catUpdates :: ([CatalogUpdate])
              _attrs :: (E [(String,Type)])
              _whrOlib :: LocalBindings
              _returningOlib :: LocalBindings
              _lhsOoriginalTree :: Statement
              _usingOcat :: Catalog
              _usingOlib :: LocalBindings
              _whrOcat :: Catalog
              _returningOcat :: Catalog
              _usingIannotatedTree :: TableRefList
              _usingIlibUpdates :: ([LocalBindingsUpdate])
              _usingIoriginalTree :: TableRefList
              _whrIannotatedTree :: MaybeBoolExpression
              _whrIoriginalTree :: MaybeBoolExpression
              _returningIannotatedTree :: MaybeSelectList
              _returningIlistType :: ([(String,Type)])
              _returningIoriginalTree :: MaybeSelectList
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 9519 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 9524 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 9529 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9534 "AstInternal.hs" #-}
              -- "./TypeChecking/Delete.ag"(line 16, column 9)
              _tpe =
                  {-# LINE 16 "./TypeChecking/Delete.ag" #-}
                  either Left (const $ Right $ Pseudo Void) _attrs
                  {-# LINE 9539 "AstInternal.hs" #-}
              -- "./TypeChecking/Delete.ag"(line 17, column 9)
              _statementType =
                  {-# LINE 17 "./TypeChecking/Delete.ag" #-}
                  do
                  pt <- sequence $ getPlaceholderTypes _whrIannotatedTree
                  return (pt,_returningIlistType)
                  {-# LINE 9546 "AstInternal.hs" #-}
              -- "./TypeChecking/Delete.ag"(line 21, column 9)
              _backTree =
                  {-# LINE 21 "./TypeChecking/Delete.ag" #-}
                  Delete ann_ table_ _usingIannotatedTree _whrIannotatedTree _returningIannotatedTree
                  {-# LINE 9551 "AstInternal.hs" #-}
              -- "./TypeChecking/Delete.ag"(line 22, column 9)
              _catUpdates =
                  {-# LINE 22 "./TypeChecking/Delete.ag" #-}
                  []
                  {-# LINE 9556 "AstInternal.hs" #-}
              -- "./TypeChecking/Delete.ag"(line 24, column 9)
              _attrs =
                  {-# LINE 24 "./TypeChecking/Delete.ag" #-}
                  catCompositeAttrs _lhsIcat relationComposites table_
                  {-# LINE 9561 "AstInternal.hs" #-}
              -- "./TypeChecking/Delete.ag"(line 26, column 9)
              _lib =
                  {-# LINE 26 "./TypeChecking/Delete.ag" #-}
                  either (const _lhsIlib) id $ do
                  a <- _attrs
                  lbUpdate _lhsIcat (LBIds "delete table attrs" "" a []) _lhsIlib
                  {-# LINE 9568 "AstInternal.hs" #-}
              -- "./TypeChecking/Delete.ag"(line 30, column 9)
              _whrOlib =
                  {-# LINE 30 "./TypeChecking/Delete.ag" #-}
                  _lib
                  {-# LINE 9573 "AstInternal.hs" #-}
              -- "./TypeChecking/Delete.ag"(line 31, column 9)
              _returningOlib =
                  {-# LINE 31 "./TypeChecking/Delete.ag" #-}
                  _lib
                  {-# LINE 9578 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Delete ann_ table_ _usingIannotatedTree _whrIannotatedTree _returningIannotatedTree
                  {-# LINE 9583 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Delete ann_ table_ _usingIoriginalTree _whrIoriginalTree _returningIoriginalTree
                  {-# LINE 9588 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9593 "AstInternal.hs" #-}
              -- copy rule (down)
              _usingOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9598 "AstInternal.hs" #-}
              -- copy rule (from local)
              _usingOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lib
                  {-# LINE 9603 "AstInternal.hs" #-}
              -- copy rule (down)
              _whrOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9608 "AstInternal.hs" #-}
              -- copy rule (down)
              _returningOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9613 "AstInternal.hs" #-}
              ( _usingIannotatedTree,_usingIlibUpdates,_usingIoriginalTree) =
                  (using_ _usingOcat _usingOlib )
              ( _whrIannotatedTree,_whrIoriginalTree) =
                  (whr_ _whrOcat _whrOlib )
              ( _returningIannotatedTree,_returningIlistType,_returningIoriginalTree) =
                  (returning_ _returningOcat _returningOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_DropFunction :: Annotation ->
                              IfExists ->
                              T_StringTypeNameListPairList  ->
                              Cascade ->
                              T_Statement 
sem_Statement_DropFunction ann_ ifE_ sigs_ cascade_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _catUpdates :: ([CatalogUpdate])
              _statementType :: (Maybe StatementType)
              _lhsOoriginalTree :: Statement
              _sigsOcat :: Catalog
              _sigsOlib :: LocalBindings
              _sigsIannotatedTree :: StringTypeNameListPairList
              _sigsIfnSigs :: ([(String,[Maybe Type])])
              _sigsIoriginalTree :: StringTypeNameListPairList
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 9649 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 9654 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 9659 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9664 "AstInternal.hs" #-}
              -- "./TypeChecking/Drops.ag"(line 10, column 9)
              _tpe =
                  {-# LINE 10 "./TypeChecking/Drops.ag" #-}
                  Right $ Pseudo Void
                  {-# LINE 9669 "AstInternal.hs" #-}
              -- "./TypeChecking/Drops.ag"(line 11, column 9)
              _backTree =
                  {-# LINE 11 "./TypeChecking/Drops.ag" #-}
                  DropFunction ann_ ifE_ _sigsIannotatedTree cascade_
                  {-# LINE 9674 "AstInternal.hs" #-}
              -- "./TypeChecking/Drops.ag"(line 12, column 9)
              _catUpdates =
                  {-# LINE 12 "./TypeChecking/Drops.ag" #-}
                  either (const []) id $
                  Right $ map mcu $ mapMaybe goodSig _sigsIfnSigs
                  where
                    mcu :: (String,[Type]) -> CatalogUpdate
                    mcu (nm,args) = CatDropFunction ifE nm args
                    ifE = ifE_ == IfExists
                    goodSig :: (String,[Maybe Type]) -> Maybe (String,[Type])
                    goodSig (s, ts) = do
                                  ts1 <- sequence ts
                                  return (s,ts1)
                  {-# LINE 9688 "AstInternal.hs" #-}
              -- "./TypeChecking/Drops.ag"(line 23, column 9)
              _statementType =
                  {-# LINE 23 "./TypeChecking/Drops.ag" #-}
                  Nothing
                  {-# LINE 9693 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  DropFunction ann_ ifE_ _sigsIannotatedTree cascade_
                  {-# LINE 9698 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  DropFunction ann_ ifE_ _sigsIoriginalTree cascade_
                  {-# LINE 9703 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9708 "AstInternal.hs" #-}
              -- copy rule (down)
              _sigsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9713 "AstInternal.hs" #-}
              -- copy rule (down)
              _sigsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 9718 "AstInternal.hs" #-}
              ( _sigsIannotatedTree,_sigsIfnSigs,_sigsIoriginalTree) =
                  (sigs_ _sigsOcat _sigsOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_DropSomething :: Annotation ->
                               DropType ->
                               IfExists ->
                               ([String]) ->
                               Cascade ->
                               T_Statement 
sem_Statement_DropSomething ann_ dropType_ ifE_ names_ cascade_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9740 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9745 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  DropSomething ann_ dropType_ ifE_ names_ cascade_
                  {-# LINE 9750 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  DropSomething ann_ dropType_ ifE_ names_ cascade_
                  {-# LINE 9755 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 9760 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9765 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Execute :: Annotation ->
                         T_Expression  ->
                         T_Statement 
sem_Statement_Execute ann_ expr_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _exprIannotatedTree :: Expression
              _exprIntAnnotatedTree :: Expression
              _exprIntType :: ([(String,Type)])
              _exprIoriginalTree :: Expression
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9788 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9793 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Execute ann_ _exprIannotatedTree
                  {-# LINE 9798 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Execute ann_ _exprIoriginalTree
                  {-# LINE 9803 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 9808 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9813 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9818 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 9823 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIntAnnotatedTree,_exprIntType,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_ExecuteInto :: Annotation ->
                             T_Expression  ->
                             ([String]) ->
                             T_Statement 
sem_Statement_ExecuteInto ann_ expr_ targets_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _exprIannotatedTree :: Expression
              _exprIntAnnotatedTree :: Expression
              _exprIntType :: ([(String,Type)])
              _exprIoriginalTree :: Expression
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9849 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9854 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ExecuteInto ann_ _exprIannotatedTree targets_
                  {-# LINE 9859 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ExecuteInto ann_ _exprIoriginalTree targets_
                  {-# LINE 9864 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 9869 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9874 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 9879 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 9884 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIntAnnotatedTree,_exprIntType,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_ExitStatement :: Annotation ->
                               T_Statement 
sem_Statement_ExitStatement ann_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9902 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9907 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ExitStatement ann_
                  {-# LINE 9912 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ExitStatement ann_
                  {-# LINE 9917 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 9922 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 9927 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_ForIntegerStatement :: Annotation ->
                                     String ->
                                     T_Expression  ->
                                     T_Expression  ->
                                     T_StatementList  ->
                                     T_Statement 
sem_Statement_ForIntegerStatement ann_ var_ from_ to_ sts_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _stsOcatUpdates :: ([CatalogUpdate])
              _stsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _stsOlib :: LocalBindings
              _catUpdates :: ([CatalogUpdate])
              _statementType :: (Maybe StatementType)
              _lhsOoriginalTree :: Statement
              _fromOcat :: Catalog
              _fromOlib :: LocalBindings
              _toOcat :: Catalog
              _toOlib :: LocalBindings
              _stsOcat :: Catalog
              _fromIannotatedTree :: Expression
              _fromIntAnnotatedTree :: Expression
              _fromIntType :: ([(String,Type)])
              _fromIoriginalTree :: Expression
              _toIannotatedTree :: Expression
              _toIntAnnotatedTree :: Expression
              _toIntType :: ([(String,Type)])
              _toIoriginalTree :: Expression
              _stsIannotatedTree :: StatementList
              _stsIoriginalTree :: StatementList
              _stsIproducedCat :: Catalog
              _stsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 9973 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 9978 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 9983 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9988 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 127, column 9)
              _stsOcatUpdates =
                  {-# LINE 127 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9993 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 128, column 9)
              _stsOlibUpdates =
                  {-# LINE 128 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 9998 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 32, column 9)
              _varTypeE =
                  {-# LINE 32 "./TypeChecking/Plpgsql.ag" #-}
                  lbLookupID _lhsIlib var_
                  {-# LINE 10003 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 33, column 9)
              _tpe =
                  {-# LINE 33 "./TypeChecking/Plpgsql.ag" #-}
                  do
                  fromType <- lmt $ getTypeAnnotation _fromIannotatedTree
                  toType <- lmt $ getTypeAnnotation _toIannotatedTree
                  errorWhen (fromType /= toType) [FromToTypesNotSame fromType toType]
                  case _varTypeE     of
                    Right t -> checkAssignmentValid _lhsIcat fromType t
                    Left _ -> return ()
                  return $ Pseudo Void
                  {-# LINE 10015 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 42, column 9)
              _stsOlib =
                  {-# LINE 42 "./TypeChecking/Plpgsql.ag" #-}
                  case _varTypeE     of
                    Left [UnrecognisedIdentifier var_] ->
                        either (const _lhsIlib) id $ do
                        ft <- lmt $ getTypeAnnotation _fromIannotatedTree
                        lbUpdate _lhsIcat
                          (LBIds "local for loop variable" "" [(var_,ft)] []) _lhsIlib
                    _ -> _lhsIlib
                  {-# LINE 10026 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 52, column 9)
              _backTree =
                  {-# LINE 52 "./TypeChecking/Plpgsql.ag" #-}
                  ForIntegerStatement ann_ var_ _fromIannotatedTree _toIannotatedTree _stsIannotatedTree
                  {-# LINE 10031 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 53, column 9)
              _catUpdates =
                  {-# LINE 53 "./TypeChecking/Plpgsql.ag" #-}
                  []
                  {-# LINE 10036 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 54, column 9)
              _statementType =
                  {-# LINE 54 "./TypeChecking/Plpgsql.ag" #-}
                  Nothing
                  {-# LINE 10041 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ForIntegerStatement ann_ var_ _fromIannotatedTree _toIannotatedTree _stsIannotatedTree
                  {-# LINE 10046 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ForIntegerStatement ann_ var_ _fromIoriginalTree _toIoriginalTree _stsIoriginalTree
                  {-# LINE 10051 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10056 "AstInternal.hs" #-}
              -- copy rule (down)
              _fromOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10061 "AstInternal.hs" #-}
              -- copy rule (down)
              _fromOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10066 "AstInternal.hs" #-}
              -- copy rule (down)
              _toOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10071 "AstInternal.hs" #-}
              -- copy rule (down)
              _toOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10076 "AstInternal.hs" #-}
              -- copy rule (down)
              _stsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10081 "AstInternal.hs" #-}
              ( _fromIannotatedTree,_fromIntAnnotatedTree,_fromIntType,_fromIoriginalTree) =
                  (from_ _fromOcat _fromOlib )
              ( _toIannotatedTree,_toIntAnnotatedTree,_toIntType,_toIoriginalTree) =
                  (to_ _toOcat _toOlib )
              ( _stsIannotatedTree,_stsIoriginalTree,_stsIproducedCat,_stsIproducedLib) =
                  (sts_ _stsOcat _stsOcatUpdates _stsOlib _stsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_ForSelectStatement :: Annotation ->
                                    String ->
                                    T_SelectExpression  ->
                                    T_StatementList  ->
                                    T_Statement 
sem_Statement_ForSelectStatement ann_ var_ sel_ sts_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _stsOcatUpdates :: ([CatalogUpdate])
              _stsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _stsOlib :: LocalBindings
              _catUpdates :: ([CatalogUpdate])
              _statementType :: (Maybe StatementType)
              _lhsOoriginalTree :: Statement
              _selOcat :: Catalog
              _selOlib :: LocalBindings
              _stsOcat :: Catalog
              _selIannotatedTree :: SelectExpression
              _selIoriginalTree :: SelectExpression
              _stsIannotatedTree :: StatementList
              _stsIoriginalTree :: StatementList
              _stsIproducedCat :: Catalog
              _stsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 10124 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 10129 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 10134 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10139 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 127, column 9)
              _stsOcatUpdates =
                  {-# LINE 127 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10144 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 128, column 9)
              _stsOlibUpdates =
                  {-# LINE 128 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10149 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 59, column 9)
              _selType =
                  {-# LINE 59 "./TypeChecking/Plpgsql.ag" #-}
                  getTypeAnnotation _selIannotatedTree
                  {-# LINE 10154 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 60, column 9)
              _tpe =
                  {-# LINE 60 "./TypeChecking/Plpgsql.ag" #-}
                  do
                  st <- lmt _selType
                  toType <- lbLookupID _lhsIlib var_
                  checkAssignmentValid _lhsIcat st toType
                  return $ Pseudo Void
                  {-# LINE 10163 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 70, column 9)
              _stsOlib =
                  {-# LINE 70 "./TypeChecking/Plpgsql.ag" #-}
                  either (const _lhsIlib) id $ do
                  _ <- _tpe
                  st <- lmt _selType
                  lbUpdate _lhsIcat (LBIds "for loop record type" "" [(var_,st)] []) _lhsIlib
                  {-# LINE 10171 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 76, column 9)
              _backTree =
                  {-# LINE 76 "./TypeChecking/Plpgsql.ag" #-}
                  ForSelectStatement ann_ var_ _selIannotatedTree _stsIannotatedTree
                  {-# LINE 10176 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 77, column 9)
              _catUpdates =
                  {-# LINE 77 "./TypeChecking/Plpgsql.ag" #-}
                  []
                  {-# LINE 10181 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 78, column 9)
              _statementType =
                  {-# LINE 78 "./TypeChecking/Plpgsql.ag" #-}
                  Nothing
                  {-# LINE 10186 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ForSelectStatement ann_ var_ _selIannotatedTree _stsIannotatedTree
                  {-# LINE 10191 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ForSelectStatement ann_ var_ _selIoriginalTree _stsIoriginalTree
                  {-# LINE 10196 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10201 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10206 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10211 "AstInternal.hs" #-}
              -- copy rule (down)
              _stsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10216 "AstInternal.hs" #-}
              ( _selIannotatedTree,_selIoriginalTree) =
                  (sel_ _selOcat _selOlib )
              ( _stsIannotatedTree,_stsIoriginalTree,_stsIproducedCat,_stsIproducedLib) =
                  (sts_ _stsOcat _stsOcatUpdates _stsOlib _stsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_If :: Annotation ->
                    T_ExpressionStatementListPairList  ->
                    T_StatementList  ->
                    T_Statement 
sem_Statement_If ann_ cases_ els_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _elsOcatUpdates :: ([CatalogUpdate])
              _elsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _casesOcat :: Catalog
              _casesOlib :: LocalBindings
              _elsOcat :: Catalog
              _elsOlib :: LocalBindings
              _casesIannotatedTree :: ExpressionStatementListPairList
              _casesIoriginalTree :: ExpressionStatementListPairList
              _elsIannotatedTree :: StatementList
              _elsIoriginalTree :: StatementList
              _elsIproducedCat :: Catalog
              _elsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10250 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10255 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 123, column 9)
              _elsOcatUpdates =
                  {-# LINE 123 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10260 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 124, column 9)
              _elsOlibUpdates =
                  {-# LINE 124 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10265 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  If ann_ _casesIannotatedTree _elsIannotatedTree
                  {-# LINE 10270 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  If ann_ _casesIoriginalTree _elsIoriginalTree
                  {-# LINE 10275 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 10280 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10285 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10290 "AstInternal.hs" #-}
              -- copy rule (down)
              _casesOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10295 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10300 "AstInternal.hs" #-}
              -- copy rule (down)
              _elsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10305 "AstInternal.hs" #-}
              ( _casesIannotatedTree,_casesIoriginalTree) =
                  (cases_ _casesOcat _casesOlib )
              ( _elsIannotatedTree,_elsIoriginalTree,_elsIproducedCat,_elsIproducedLib) =
                  (els_ _elsOcat _elsOcatUpdates _elsOlib _elsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Insert :: Annotation ->
                        String ->
                        ([String]) ->
                        T_SelectExpression  ->
                        T_MaybeSelectList  ->
                        T_Statement 
sem_Statement_Insert ann_ table_ targetCols_ insData_ returning_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _statementType :: (Maybe StatementType)
              _columnTypes :: (Either [TypeError] [(String,Type)])
              _catUpdates :: ([CatalogUpdate])
              _returningOlib :: LocalBindings
              _lhsOoriginalTree :: Statement
              _insDataOcat :: Catalog
              _insDataOlib :: LocalBindings
              _returningOcat :: Catalog
              _insDataIannotatedTree :: SelectExpression
              _insDataIoriginalTree :: SelectExpression
              _returningIannotatedTree :: MaybeSelectList
              _returningIlistType :: ([(String,Type)])
              _returningIoriginalTree :: MaybeSelectList
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 10345 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 10350 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 10355 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10360 "AstInternal.hs" #-}
              -- "./TypeChecking/Insert.ag"(line 13, column 9)
              _tpe =
                  {-# LINE 13 "./TypeChecking/Insert.ag" #-}
                  either Left (const $ Right $ Pseudo Void) _columnTypes
                  {-# LINE 10365 "AstInternal.hs" #-}
              -- "./TypeChecking/Insert.ag"(line 14, column 9)
              _statementType =
                  {-# LINE 14 "./TypeChecking/Insert.ag" #-}
                  Just (catMaybes $ getPlaceholderTypes _insDataAddedInferredTypes
                       ,_returningIlistType)
                  {-# LINE 10371 "AstInternal.hs" #-}
              -- "./TypeChecking/Insert.ag"(line 19, column 9)
              _columnTypes =
                  {-# LINE 19 "./TypeChecking/Insert.ag" #-}
                  do
                  atts <- catCompositeAttrs _lhsIcat relationComposites table_
                  expAtts <- lmt (getTypeAnnotation _insDataIannotatedTree)
                             >>= unwrapSetOfComposite
                  let eNames = map fst expAtts
                      tAtts = filter (\(s,_) -> s `elem` eNames) atts
                  checkAssignmentValid _lhsIcat (CompositeType expAtts) (CompositeType tAtts)
                  return tAtts
                  {-# LINE 10383 "AstInternal.hs" #-}
              -- "./TypeChecking/Insert.ag"(line 28, column 9)
              _insDataAddedInferredTypes =
                  {-# LINE 28 "./TypeChecking/Insert.ag" #-}
                  either (const _insDataIannotatedTree) id $
                  case _insDataIannotatedTree of
                    Values ann [exl] -> do
                        fargs <- map (Just . snd) <$> _columnTypes
                        let newExl = map setInfType $ zip (fargs ++ repeat Nothing) exl
                        return $ Values ann [newExl]
                    x -> return x
                  where
                    setInfType :: (Maybe Type,Expression) -> Expression
                    setInfType (t,a) = updateAnnotation (\i -> i {infType = t}) a
                  {-# LINE 10397 "AstInternal.hs" #-}
              -- "./TypeChecking/Insert.ag"(line 40, column 9)
              _backTree =
                  {-# LINE 40 "./TypeChecking/Insert.ag" #-}
                  Insert ann_ table_ targetCols_
                         _insDataAddedInferredTypes
                         _returningIannotatedTree
                  {-# LINE 10404 "AstInternal.hs" #-}
              -- "./TypeChecking/Insert.ag"(line 43, column 9)
              _catUpdates =
                  {-# LINE 43 "./TypeChecking/Insert.ag" #-}
                  []
                  {-# LINE 10409 "AstInternal.hs" #-}
              -- "./TypeChecking/Insert.ag"(line 49, column 9)
              _returningOlib =
                  {-# LINE 49 "./TypeChecking/Insert.ag" #-}
                  either (const _lhsIlib) id $ do
                    atts <- catCompositeAttrs _lhsIcat relationComposites table_
                    lbUpdate _lhsIcat (LBIds "insert target table" "" atts []) _lhsIlib
                  {-# LINE 10416 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Insert ann_ table_ targetCols_ _insDataIannotatedTree _returningIannotatedTree
                  {-# LINE 10421 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Insert ann_ table_ targetCols_ _insDataIoriginalTree _returningIoriginalTree
                  {-# LINE 10426 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10431 "AstInternal.hs" #-}
              -- copy rule (down)
              _insDataOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10436 "AstInternal.hs" #-}
              -- copy rule (down)
              _insDataOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10441 "AstInternal.hs" #-}
              -- copy rule (down)
              _returningOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10446 "AstInternal.hs" #-}
              ( _insDataIannotatedTree,_insDataIoriginalTree) =
                  (insData_ _insDataOcat _insDataOlib )
              ( _returningIannotatedTree,_returningIlistType,_returningIoriginalTree) =
                  (returning_ _returningOcat _returningOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_LoopStatement :: Annotation ->
                               T_StatementList  ->
                               T_Statement 
sem_Statement_LoopStatement ann_ sts_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _stsOcatUpdates :: ([CatalogUpdate])
              _stsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _stsOcat :: Catalog
              _stsOlib :: LocalBindings
              _stsIannotatedTree :: StatementList
              _stsIoriginalTree :: StatementList
              _stsIproducedCat :: Catalog
              _stsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10475 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10480 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 127, column 9)
              _stsOcatUpdates =
                  {-# LINE 127 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10485 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 128, column 9)
              _stsOlibUpdates =
                  {-# LINE 128 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10490 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  LoopStatement ann_ _stsIannotatedTree
                  {-# LINE 10495 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  LoopStatement ann_ _stsIoriginalTree
                  {-# LINE 10500 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 10505 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10510 "AstInternal.hs" #-}
              -- copy rule (down)
              _stsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10515 "AstInternal.hs" #-}
              -- copy rule (down)
              _stsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10520 "AstInternal.hs" #-}
              ( _stsIannotatedTree,_stsIoriginalTree,_stsIproducedCat,_stsIproducedLib) =
                  (sts_ _stsOcat _stsOcatUpdates _stsOlib _stsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Notify :: Annotation ->
                        String ->
                        T_Statement 
sem_Statement_Notify ann_ name_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10539 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10544 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10549 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Notify ann_ name_
                  {-# LINE 10554 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Notify ann_ name_
                  {-# LINE 10559 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 10564 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10569 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_NullStatement :: Annotation ->
                               T_Statement 
sem_Statement_NullStatement ann_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10585 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10590 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  NullStatement ann_
                  {-# LINE 10595 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  NullStatement ann_
                  {-# LINE 10600 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 10605 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10610 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Perform :: Annotation ->
                         T_Expression  ->
                         T_Statement 
sem_Statement_Perform ann_ expr_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _exprIannotatedTree :: Expression
              _exprIntAnnotatedTree :: Expression
              _exprIntType :: ([(String,Type)])
              _exprIoriginalTree :: Expression
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10633 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10638 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Perform ann_ _exprIannotatedTree
                  {-# LINE 10643 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Perform ann_ _exprIoriginalTree
                  {-# LINE 10648 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 10653 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10658 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10663 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10668 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIntAnnotatedTree,_exprIntType,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Raise :: Annotation ->
                       RaiseType ->
                       String ->
                       T_ExpressionList  ->
                       T_Statement 
sem_Statement_Raise ann_ level_ message_ args_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _argsOcat :: Catalog
              _argsOlib :: LocalBindings
              _argsIannotatedTree :: ExpressionList
              _argsIoriginalTree :: ExpressionList
              _argsItypeList :: ([Maybe Type])
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10694 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10699 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Raise ann_ level_ message_ _argsIannotatedTree
                  {-# LINE 10704 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Raise ann_ level_ message_ _argsIoriginalTree
                  {-# LINE 10709 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 10714 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10719 "AstInternal.hs" #-}
              -- copy rule (down)
              _argsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10724 "AstInternal.hs" #-}
              -- copy rule (down)
              _argsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10729 "AstInternal.hs" #-}
              ( _argsIannotatedTree,_argsIoriginalTree,_argsItypeList) =
                  (args_ _argsOcat _argsOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Return :: Annotation ->
                        T_MaybeExpression  ->
                        T_Statement 
sem_Statement_Return ann_ value_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _catUpdates :: ([CatalogUpdate])
              _statementType :: (Maybe StatementType)
              _lhsOoriginalTree :: Statement
              _valueOcat :: Catalog
              _valueOlib :: LocalBindings
              _valueIannotatedTree :: MaybeExpression
              _valueIoriginalTree :: MaybeExpression
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 10758 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 10763 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 10768 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10773 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 12, column 9)
              _tpe =
                  {-# LINE 12 "./TypeChecking/Plpgsql.ag" #-}
                  maybe (Right $ Pseudo Void) Right $ getTypeAnnotation _valueIannotatedTree
                  {-# LINE 10778 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 13, column 9)
              _backTree =
                  {-# LINE 13 "./TypeChecking/Plpgsql.ag" #-}
                  Return ann_ _valueIannotatedTree
                  {-# LINE 10783 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 14, column 9)
              _catUpdates =
                  {-# LINE 14 "./TypeChecking/Plpgsql.ag" #-}
                  []
                  {-# LINE 10788 "AstInternal.hs" #-}
              -- "./TypeChecking/Plpgsql.ag"(line 15, column 9)
              _statementType =
                  {-# LINE 15 "./TypeChecking/Plpgsql.ag" #-}
                  Nothing
                  {-# LINE 10793 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Return ann_ _valueIannotatedTree
                  {-# LINE 10798 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Return ann_ _valueIoriginalTree
                  {-# LINE 10803 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10808 "AstInternal.hs" #-}
              -- copy rule (down)
              _valueOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10813 "AstInternal.hs" #-}
              -- copy rule (down)
              _valueOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10818 "AstInternal.hs" #-}
              ( _valueIannotatedTree,_valueIoriginalTree) =
                  (value_ _valueOcat _valueOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_ReturnNext :: Annotation ->
                            T_Expression  ->
                            T_Statement 
sem_Statement_ReturnNext ann_ expr_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _exprIannotatedTree :: Expression
              _exprIntAnnotatedTree :: Expression
              _exprIntType :: ([(String,Type)])
              _exprIoriginalTree :: Expression
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10843 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10848 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ReturnNext ann_ _exprIannotatedTree
                  {-# LINE 10853 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ReturnNext ann_ _exprIoriginalTree
                  {-# LINE 10858 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 10863 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10868 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10873 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10878 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIntAnnotatedTree,_exprIntType,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_ReturnQuery :: Annotation ->
                             T_SelectExpression  ->
                             T_Statement 
sem_Statement_ReturnQuery ann_ sel_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _selOcat :: Catalog
              _selOlib :: LocalBindings
              _selIannotatedTree :: SelectExpression
              _selIoriginalTree :: SelectExpression
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10901 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 10906 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ReturnQuery ann_ _selIannotatedTree
                  {-# LINE 10911 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ReturnQuery ann_ _selIoriginalTree
                  {-# LINE 10916 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 10921 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 10926 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 10931 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 10936 "AstInternal.hs" #-}
              ( _selIannotatedTree,_selIoriginalTree) =
                  (sel_ _selOcat _selOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_SelectStatement :: Annotation ->
                                 T_SelectExpression  ->
                                 T_Statement 
sem_Statement_SelectStatement ann_ ex_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _statementType :: (Maybe StatementType)
              _catUpdates :: ([CatalogUpdate])
              _lhsOoriginalTree :: Statement
              _exOcat :: Catalog
              _exOlib :: LocalBindings
              _exIannotatedTree :: SelectExpression
              _exIoriginalTree :: SelectExpression
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 10965 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 10970 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 10975 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 14, column 9)
              _tpe =
                  {-# LINE 14 "./TypeChecking/SelectStatement.ag" #-}
                  Right $ Pseudo Void
                  {-# LINE 10980 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 15, column 9)
              _statementType =
                  {-# LINE 15 "./TypeChecking/SelectStatement.ag" #-}
                  do
                  pt <- sequence $ getPlaceholderTypes _exIannotatedTree
                  ext <- getTypeAnnotation _exIannotatedTree
                  st <- etmt $ unwrapSetOfComposite ext
                  return (pt
                         ,case st of
                            [(_,(Pseudo Void))] -> []
                            t -> t)
                  {-# LINE 10992 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 24, column 9)
              _backTree =
                  {-# LINE 24 "./TypeChecking/SelectStatement.ag" #-}
                  SelectStatement ann_ _exIannotatedTree
                  {-# LINE 10997 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 25, column 9)
              _catUpdates =
                  {-# LINE 25 "./TypeChecking/SelectStatement.ag" #-}
                  []
                  {-# LINE 11002 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectLists.ag"(line 119, column 9)
              _libUpdates =
                  {-# LINE 119 "./TypeChecking/SelectLists.ag" #-}
                  undefined
                  {-# LINE 11007 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  SelectStatement ann_ _exIannotatedTree
                  {-# LINE 11012 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  SelectStatement ann_ _exIoriginalTree
                  {-# LINE 11017 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11022 "AstInternal.hs" #-}
              -- copy rule (down)
              _exOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11027 "AstInternal.hs" #-}
              -- copy rule (down)
              _exOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 11032 "AstInternal.hs" #-}
              ( _exIannotatedTree,_exIoriginalTree) =
                  (ex_ _exOcat _exOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Set :: Annotation ->
                     String ->
                     ([SetValue]) ->
                     T_Statement 
sem_Statement_Set ann_ name_ values_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11052 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11057 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11062 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Set ann_ name_ values_
                  {-# LINE 11067 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Set ann_ name_ values_
                  {-# LINE 11072 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 11077 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11082 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Truncate :: Annotation ->
                          ([String]) ->
                          RestartIdentity ->
                          Cascade ->
                          T_Statement 
sem_Statement_Truncate ann_ tables_ restartIdentity_ cascade_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11101 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11106 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Truncate ann_ tables_ restartIdentity_ cascade_
                  {-# LINE 11111 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Truncate ann_ tables_ restartIdentity_ cascade_
                  {-# LINE 11116 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 11121 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11126 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_Update :: Annotation ->
                        String ->
                        T_ExpressionList  ->
                        T_TableRefList  ->
                        T_MaybeBoolExpression  ->
                        T_MaybeSelectList  ->
                        T_Statement 
sem_Statement_Update ann_ table_ assigns_ fromList_ whr_ returning_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOannotatedTree :: Statement
              _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _tpe :: (Either [TypeError] Type)
              _attrs :: (E [(String,Type)])
              _statementType :: (Maybe StatementType)
              _catUpdates :: ([CatalogUpdate])
              _whrOlib :: LocalBindings
              _assignsOlib :: LocalBindings
              _returningOlib :: LocalBindings
              _lhsOoriginalTree :: Statement
              _assignsOcat :: Catalog
              _fromListOcat :: Catalog
              _fromListOlib :: LocalBindings
              _whrOcat :: Catalog
              _returningOcat :: Catalog
              _assignsIannotatedTree :: ExpressionList
              _assignsIoriginalTree :: ExpressionList
              _assignsItypeList :: ([Maybe Type])
              _fromListIannotatedTree :: TableRefList
              _fromListIlibUpdates :: ([LocalBindingsUpdate])
              _fromListIoriginalTree :: TableRefList
              _whrIannotatedTree :: MaybeBoolExpression
              _whrIoriginalTree :: MaybeBoolExpression
              _returningIannotatedTree :: MaybeSelectList
              _returningIlistType :: ([(String,Type)])
              _returningIoriginalTree :: MaybeSelectList
              -- "./TypeChecking/Statements.ag"(line 78, column 9)
              _lhsOannotatedTree =
                  {-# LINE 78 "./TypeChecking/Statements.ag" #-}
                  updateAnnotation
                      (\a -> a {stType = _statementType
                               ,catUpd = _catUpdates    }) $
                  setTypeAddErrors _tpe     _backTree
                  {-# LINE 11173 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 84, column 9)
              _lhsOcatUpdates =
                  {-# LINE 84 "./TypeChecking/Statements.ag" #-}
                  _catUpdates
                  {-# LINE 11178 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 85, column 9)
              _lhsOlibUpdates =
                  {-# LINE 85 "./TypeChecking/Statements.ag" #-}
                  _libUpdates
                  {-# LINE 11183 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 90, column 9)
              _libUpdates =
                  {-# LINE 90 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11188 "AstInternal.hs" #-}
              -- "./TypeChecking/Update.ag"(line 12, column 9)
              _tpe =
                  {-# LINE 12 "./TypeChecking/Update.ag" #-}
                  either Left (const $ Right $ Pseudo Void) _attrs
                  {-# LINE 11193 "AstInternal.hs" #-}
              -- "./TypeChecking/Update.ag"(line 14, column 9)
              _attrs =
                  {-# LINE 14 "./TypeChecking/Update.ag" #-}
                  catCompositeAttrs _lhsIcat
                                    relationComposites
                                    table_
                  {-# LINE 11200 "AstInternal.hs" #-}
              -- "./TypeChecking/Update.ag"(line 21, column 9)
              _statementType =
                  {-# LINE 21 "./TypeChecking/Update.ag" #-}
                  do
                  pt <- sequence $ getPlaceholderTypes _assignsIannotatedTree
                                   ++ getPlaceholderTypes _whrIannotatedTree
                  return (pt,_returningIlistType)
                  {-# LINE 11208 "AstInternal.hs" #-}
              -- "./TypeChecking/Update.ag"(line 27, column 9)
              _backTree =
                  {-# LINE 27 "./TypeChecking/Update.ag" #-}
                  Update ann_
                         table_
                         _assignsIannotatedTree
                         _fromListIannotatedTree
                         _whrIannotatedTree
                         _returningIannotatedTree
                  {-# LINE 11218 "AstInternal.hs" #-}
              -- "./TypeChecking/Update.ag"(line 33, column 9)
              _catUpdates =
                  {-# LINE 33 "./TypeChecking/Update.ag" #-}
                  []
                  {-# LINE 11223 "AstInternal.hs" #-}
              -- "./TypeChecking/Update.ag"(line 38, column 9)
              _lib =
                  {-# LINE 38 "./TypeChecking/Update.ag" #-}
                  either (const _lhsIlib) id $ do
                  a <- _attrs
                  lbUpdate _lhsIcat (LBIds "updated table attrs" "" a []) _lhsIlib
                  {-# LINE 11230 "AstInternal.hs" #-}
              -- "./TypeChecking/Update.ag"(line 42, column 9)
              _whrOlib =
                  {-# LINE 42 "./TypeChecking/Update.ag" #-}
                  _lib
                  {-# LINE 11235 "AstInternal.hs" #-}
              -- "./TypeChecking/Update.ag"(line 43, column 9)
              _assignsOlib =
                  {-# LINE 43 "./TypeChecking/Update.ag" #-}
                  _lib
                  {-# LINE 11240 "AstInternal.hs" #-}
              -- "./TypeChecking/Update.ag"(line 44, column 9)
              _returningOlib =
                  {-# LINE 44 "./TypeChecking/Update.ag" #-}
                  _lib
                  {-# LINE 11245 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Update ann_ table_ _assignsIannotatedTree _fromListIannotatedTree _whrIannotatedTree _returningIannotatedTree
                  {-# LINE 11250 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Update ann_ table_ _assignsIoriginalTree _fromListIoriginalTree _whrIoriginalTree _returningIoriginalTree
                  {-# LINE 11255 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11260 "AstInternal.hs" #-}
              -- copy rule (down)
              _assignsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11265 "AstInternal.hs" #-}
              -- copy rule (down)
              _fromListOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11270 "AstInternal.hs" #-}
              -- copy rule (from local)
              _fromListOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lib
                  {-# LINE 11275 "AstInternal.hs" #-}
              -- copy rule (down)
              _whrOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11280 "AstInternal.hs" #-}
              -- copy rule (down)
              _returningOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11285 "AstInternal.hs" #-}
              ( _assignsIannotatedTree,_assignsIoriginalTree,_assignsItypeList) =
                  (assigns_ _assignsOcat _assignsOlib )
              ( _fromListIannotatedTree,_fromListIlibUpdates,_fromListIoriginalTree) =
                  (fromList_ _fromListOcat _fromListOlib )
              ( _whrIannotatedTree,_whrIoriginalTree) =
                  (whr_ _whrOcat _whrOlib )
              ( _returningIannotatedTree,_returningIlistType,_returningIoriginalTree) =
                  (returning_ _returningOcat _returningOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_Statement_WhileStatement :: Annotation ->
                                T_Expression  ->
                                T_StatementList  ->
                                T_Statement 
sem_Statement_WhileStatement ann_ expr_ sts_  =
    (\ _lhsIcat
       _lhsIinProducedCat
       _lhsIlib ->
         (let _lhsOcatUpdates :: ([CatalogUpdate])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _stsOcatUpdates :: ([CatalogUpdate])
              _stsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: Statement
              _lhsOoriginalTree :: Statement
              _exprOcat :: Catalog
              _exprOlib :: LocalBindings
              _stsOcat :: Catalog
              _stsOlib :: LocalBindings
              _exprIannotatedTree :: Expression
              _exprIntAnnotatedTree :: Expression
              _exprIntType :: ([(String,Type)])
              _exprIoriginalTree :: Expression
              _stsIannotatedTree :: StatementList
              _stsIoriginalTree :: StatementList
              _stsIproducedCat :: Catalog
              _stsIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 106, column 9)
              _lhsOcatUpdates =
                  {-# LINE 106 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11325 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 107, column 9)
              _lhsOlibUpdates =
                  {-# LINE 107 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11330 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 127, column 9)
              _stsOcatUpdates =
                  {-# LINE 127 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11335 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 128, column 9)
              _stsOlibUpdates =
                  {-# LINE 128 "./TypeChecking/Statements.ag" #-}
                  []
                  {-# LINE 11340 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  WhileStatement ann_ _exprIannotatedTree _stsIannotatedTree
                  {-# LINE 11345 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  WhileStatement ann_ _exprIoriginalTree _stsIoriginalTree
                  {-# LINE 11350 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 11355 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11360 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11365 "AstInternal.hs" #-}
              -- copy rule (down)
              _exprOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 11370 "AstInternal.hs" #-}
              -- copy rule (down)
              _stsOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11375 "AstInternal.hs" #-}
              -- copy rule (down)
              _stsOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 11380 "AstInternal.hs" #-}
              ( _exprIannotatedTree,_exprIntAnnotatedTree,_exprIntType,_exprIoriginalTree) =
                  (expr_ _exprOcat _exprOlib )
              ( _stsIannotatedTree,_stsIoriginalTree,_stsIproducedCat,_stsIproducedLib) =
                  (sts_ _stsOcat _stsOcatUpdates _stsOlib _stsOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOlibUpdates,_lhsOoriginalTree)))
-- StatementList -----------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         catUpdates           : [CatalogUpdate]
         lib                  : LocalBindings
         libUpdates           : [LocalBindingsUpdate]
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
         producedCat          : Catalog
         producedLib          : LocalBindings
   alternatives:
      alternative Cons:
         child hd             : Statement 
         child tl             : StatementList 
         visit 0:
            local newCat      : _
            local newLib      : _
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local newCat      : _
            local newLib      : _
            local annotatedTree : _
            local originalTree : _
-}
type StatementList  = [(Statement)]
-- cata
sem_StatementList :: StatementList  ->
                     T_StatementList 
sem_StatementList list  =
    (Prelude.foldr sem_StatementList_Cons sem_StatementList_Nil (Prelude.map sem_Statement list) )
-- semantic domain
type T_StatementList  = Catalog ->
                        ([CatalogUpdate]) ->
                        LocalBindings ->
                        ([LocalBindingsUpdate]) ->
                        ( StatementList,StatementList,Catalog,LocalBindings)
data Inh_StatementList  = Inh_StatementList {cat_Inh_StatementList :: Catalog,catUpdates_Inh_StatementList :: [CatalogUpdate],lib_Inh_StatementList :: LocalBindings,libUpdates_Inh_StatementList :: [LocalBindingsUpdate]}
data Syn_StatementList  = Syn_StatementList {annotatedTree_Syn_StatementList :: StatementList,originalTree_Syn_StatementList :: StatementList,producedCat_Syn_StatementList :: Catalog,producedLib_Syn_StatementList :: LocalBindings}
wrap_StatementList :: T_StatementList  ->
                      Inh_StatementList  ->
                      Syn_StatementList 
wrap_StatementList sem (Inh_StatementList _lhsIcat _lhsIcatUpdates _lhsIlib _lhsIlibUpdates )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOproducedCat,_lhsOproducedLib) =
             (sem _lhsIcat _lhsIcatUpdates _lhsIlib _lhsIlibUpdates )
     in  (Syn_StatementList _lhsOannotatedTree _lhsOoriginalTree _lhsOproducedCat _lhsOproducedLib ))
sem_StatementList_Cons :: T_Statement  ->
                          T_StatementList  ->
                          T_StatementList 
sem_StatementList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIcatUpdates
       _lhsIlib
       _lhsIlibUpdates ->
         (let _hdOcat :: Catalog
              _tlOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOlib :: LocalBindings
              _lhsOproducedCat :: Catalog
              _lhsOproducedLib :: LocalBindings
              _tlOcatUpdates :: ([CatalogUpdate])
              _tlOlibUpdates :: ([LocalBindingsUpdate])
              _hdOinProducedCat :: Catalog
              _lhsOannotatedTree :: StatementList
              _lhsOoriginalTree :: StatementList
              _hdIannotatedTree :: Statement
              _hdIcatUpdates :: ([CatalogUpdate])
              _hdIlibUpdates :: ([LocalBindingsUpdate])
              _hdIoriginalTree :: Statement
              _tlIannotatedTree :: StatementList
              _tlIoriginalTree :: StatementList
              _tlIproducedCat :: Catalog
              _tlIproducedLib :: LocalBindings
              -- "./TypeChecking/Statements.ag"(line 52, column 9)
              _newCat =
                  {-# LINE 52 "./TypeChecking/Statements.ag" #-}
                  fromRight _lhsIcat $ updateCatalog _lhsIcat _lhsIcatUpdates
                  {-# LINE 11467 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 53, column 9)
              _newLib =
                  {-# LINE 53 "./TypeChecking/Statements.ag" #-}
                  fromRight _lhsIlib $ foldM (flip $ lbUpdate _lhsIcat) _lhsIlib _lhsIlibUpdates
                  {-# LINE 11472 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 55, column 9)
              _hdOcat =
                  {-# LINE 55 "./TypeChecking/Statements.ag" #-}
                  _newCat
                  {-# LINE 11477 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 56, column 9)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/Statements.ag" #-}
                  _newCat
                  {-# LINE 11482 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 57, column 9)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/Statements.ag" #-}
                  _newLib
                  {-# LINE 11487 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 58, column 9)
              _tlOlib =
                  {-# LINE 58 "./TypeChecking/Statements.ag" #-}
                  _newLib
                  {-# LINE 11492 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 62, column 9)
              _lhsOproducedCat =
                  {-# LINE 62 "./TypeChecking/Statements.ag" #-}
                  _tlIproducedCat
                  {-# LINE 11497 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 63, column 9)
              _lhsOproducedLib =
                  {-# LINE 63 "./TypeChecking/Statements.ag" #-}
                  _tlIproducedLib
                  {-# LINE 11502 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 66, column 9)
              _tlOcatUpdates =
                  {-# LINE 66 "./TypeChecking/Statements.ag" #-}
                  _hdIcatUpdates
                  {-# LINE 11507 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 67, column 9)
              _tlOlibUpdates =
                  {-# LINE 67 "./TypeChecking/Statements.ag" #-}
                  _hdIlibUpdates
                  {-# LINE 11512 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 93, column 12)
              _hdOinProducedCat =
                  {-# LINE 93 "./TypeChecking/Statements.ag" #-}
                  _tlIproducedCat
                  {-# LINE 11517 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 11522 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 11527 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 11532 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11537 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIcatUpdates,_hdIlibUpdates,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOinProducedCat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree,_tlIproducedCat,_tlIproducedLib) =
                  (tl_ _tlOcat _tlOcatUpdates _tlOlib _tlOlibUpdates )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOproducedCat,_lhsOproducedLib)))
sem_StatementList_Nil :: T_StatementList 
sem_StatementList_Nil  =
    (\ _lhsIcat
       _lhsIcatUpdates
       _lhsIlib
       _lhsIlibUpdates ->
         (let _lhsOproducedCat :: Catalog
              _lhsOproducedLib :: LocalBindings
              _lhsOannotatedTree :: StatementList
              _lhsOoriginalTree :: StatementList
              -- "./TypeChecking/Statements.ag"(line 52, column 9)
              _newCat =
                  {-# LINE 52 "./TypeChecking/Statements.ag" #-}
                  fromRight _lhsIcat $ updateCatalog _lhsIcat _lhsIcatUpdates
                  {-# LINE 11557 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 53, column 9)
              _newLib =
                  {-# LINE 53 "./TypeChecking/Statements.ag" #-}
                  fromRight _lhsIlib $ foldM (flip $ lbUpdate _lhsIcat) _lhsIlib _lhsIlibUpdates
                  {-# LINE 11562 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 69, column 9)
              _lhsOproducedCat =
                  {-# LINE 69 "./TypeChecking/Statements.ag" #-}
                  _newCat
                  {-# LINE 11567 "AstInternal.hs" #-}
              -- "./TypeChecking/Statements.ag"(line 70, column 9)
              _lhsOproducedLib =
                  {-# LINE 70 "./TypeChecking/Statements.ag" #-}
                  _newLib
                  {-# LINE 11572 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 11577 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 11582 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 11587 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11592 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOproducedCat,_lhsOproducedLib)))
-- StringTypeNameListPair --------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         fnSig                : (String,[Maybe Type])
         originalTree         : SELF 
   alternatives:
      alternative Tuple:
         child x1             : {String}
         child x2             : TypeNameList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type StringTypeNameListPair  = ( (String),(TypeNameList))
-- cata
sem_StringTypeNameListPair :: StringTypeNameListPair  ->
                              T_StringTypeNameListPair 
sem_StringTypeNameListPair ( x1,x2)  =
    (sem_StringTypeNameListPair_Tuple x1 (sem_TypeNameList x2 ) )
-- semantic domain
type T_StringTypeNameListPair  = Catalog ->
                                 LocalBindings ->
                                 ( StringTypeNameListPair,((String,[Maybe Type])),StringTypeNameListPair)
data Inh_StringTypeNameListPair  = Inh_StringTypeNameListPair {cat_Inh_StringTypeNameListPair :: Catalog,lib_Inh_StringTypeNameListPair :: LocalBindings}
data Syn_StringTypeNameListPair  = Syn_StringTypeNameListPair {annotatedTree_Syn_StringTypeNameListPair :: StringTypeNameListPair,fnSig_Syn_StringTypeNameListPair :: (String,[Maybe Type]),originalTree_Syn_StringTypeNameListPair :: StringTypeNameListPair}
wrap_StringTypeNameListPair :: T_StringTypeNameListPair  ->
                               Inh_StringTypeNameListPair  ->
                               Syn_StringTypeNameListPair 
wrap_StringTypeNameListPair sem (Inh_StringTypeNameListPair _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOfnSig,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_StringTypeNameListPair _lhsOannotatedTree _lhsOfnSig _lhsOoriginalTree ))
sem_StringTypeNameListPair_Tuple :: String ->
                                    T_TypeNameList  ->
                                    T_StringTypeNameListPair 
sem_StringTypeNameListPair_Tuple x1_ x2_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOfnSig :: ((String,[Maybe Type]))
              _lhsOannotatedTree :: StringTypeNameListPair
              _lhsOoriginalTree :: StringTypeNameListPair
              _x2Ocat :: Catalog
              _x2Olib :: LocalBindings
              _x2IannotatedTree :: TypeNameList
              _x2InamedTypes :: ([Maybe Type])
              _x2IoriginalTree :: TypeNameList
              -- "./TypeChecking/Drops.ag"(line 32, column 13)
              _lhsOfnSig =
                  {-# LINE 32 "./TypeChecking/Drops.ag" #-}
                  (x1_, _x2InamedTypes)
                  {-# LINE 11649 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (x1_,_x2IannotatedTree)
                  {-# LINE 11654 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (x1_,_x2IoriginalTree)
                  {-# LINE 11659 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 11664 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11669 "AstInternal.hs" #-}
              -- copy rule (down)
              _x2Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11674 "AstInternal.hs" #-}
              -- copy rule (down)
              _x2Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 11679 "AstInternal.hs" #-}
              ( _x2IannotatedTree,_x2InamedTypes,_x2IoriginalTree) =
                  (x2_ _x2Ocat _x2Olib )
          in  ( _lhsOannotatedTree,_lhsOfnSig,_lhsOoriginalTree)))
-- StringTypeNameListPairList ----------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         fnSigs               : [(String,[Maybe Type])]
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : StringTypeNameListPair 
         child tl             : StringTypeNameListPairList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type StringTypeNameListPairList  = [(StringTypeNameListPair)]
-- cata
sem_StringTypeNameListPairList :: StringTypeNameListPairList  ->
                                  T_StringTypeNameListPairList 
sem_StringTypeNameListPairList list  =
    (Prelude.foldr sem_StringTypeNameListPairList_Cons sem_StringTypeNameListPairList_Nil (Prelude.map sem_StringTypeNameListPair list) )
-- semantic domain
type T_StringTypeNameListPairList  = Catalog ->
                                     LocalBindings ->
                                     ( StringTypeNameListPairList,([(String,[Maybe Type])]),StringTypeNameListPairList)
data Inh_StringTypeNameListPairList  = Inh_StringTypeNameListPairList {cat_Inh_StringTypeNameListPairList :: Catalog,lib_Inh_StringTypeNameListPairList :: LocalBindings}
data Syn_StringTypeNameListPairList  = Syn_StringTypeNameListPairList {annotatedTree_Syn_StringTypeNameListPairList :: StringTypeNameListPairList,fnSigs_Syn_StringTypeNameListPairList :: [(String,[Maybe Type])],originalTree_Syn_StringTypeNameListPairList :: StringTypeNameListPairList}
wrap_StringTypeNameListPairList :: T_StringTypeNameListPairList  ->
                                   Inh_StringTypeNameListPairList  ->
                                   Syn_StringTypeNameListPairList 
wrap_StringTypeNameListPairList sem (Inh_StringTypeNameListPairList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOfnSigs,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_StringTypeNameListPairList _lhsOannotatedTree _lhsOfnSigs _lhsOoriginalTree ))
sem_StringTypeNameListPairList_Cons :: T_StringTypeNameListPair  ->
                                       T_StringTypeNameListPairList  ->
                                       T_StringTypeNameListPairList 
sem_StringTypeNameListPairList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOfnSigs :: ([(String,[Maybe Type])])
              _lhsOannotatedTree :: StringTypeNameListPairList
              _lhsOoriginalTree :: StringTypeNameListPairList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: StringTypeNameListPair
              _hdIfnSig :: ((String,[Maybe Type]))
              _hdIoriginalTree :: StringTypeNameListPair
              _tlIannotatedTree :: StringTypeNameListPairList
              _tlIfnSigs :: ([(String,[Maybe Type])])
              _tlIoriginalTree :: StringTypeNameListPairList
              -- "./TypeChecking/Drops.ag"(line 27, column 12)
              _lhsOfnSigs =
                  {-# LINE 27 "./TypeChecking/Drops.ag" #-}
                  _hdIfnSig : _tlIfnSigs
                  {-# LINE 11747 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 11752 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 11757 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 11762 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11767 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11772 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 11777 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 11782 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 11787 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIfnSig,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIfnSigs,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOfnSigs,_lhsOoriginalTree)))
sem_StringTypeNameListPairList_Nil :: T_StringTypeNameListPairList 
sem_StringTypeNameListPairList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOfnSigs :: ([(String,[Maybe Type])])
              _lhsOannotatedTree :: StringTypeNameListPairList
              _lhsOoriginalTree :: StringTypeNameListPairList
              -- "./TypeChecking/Drops.ag"(line 28, column 11)
              _lhsOfnSigs =
                  {-# LINE 28 "./TypeChecking/Drops.ag" #-}
                  []
                  {-# LINE 11804 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 11809 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 11814 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 11819 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 11824 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOfnSigs,_lhsOoriginalTree)))
-- TableRef ----------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         libUpdates           : [LocalBindingsUpdate]
         originalTree         : SELF 
   alternatives:
      alternative JoinedTref:
         child ann            : {Annotation}
         child tbl            : TableRef 
         child nat            : {Natural}
         child joinType       : {JoinType}
         child tbl1           : TableRef 
         child onExpr         : OnExpr 
         child alias          : {TableAlias}
         visit 0:
            local errs        : _
            local joinErrors  : _
            local libUpdates  : _
            local newLib      : {Either [TypeError] LocalBindings}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative SubTref:
         child ann            : {Annotation}
         child sel            : SelectExpression 
         child alias          : {TableAlias}
         visit 0:
            local errs        : _
            local selectAttrs : {Either [TypeError] [(String,Type)]}
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative Tref:
         child ann            : {Annotation}
         child tbl            : {String}
         child alias          : {TableAlias}
         visit 0:
            local errs        : _
            local relType     : {Either [TypeError] ([(String, Type)], [(String, Type)])}
            local relType1    : _
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative TrefFun:
         child ann            : {Annotation}
         child fn             : Expression 
         child alias          : {TableAlias}
         visit 0:
            local errs        : _
            local eqfunIdens  : {Either [TypeError] (String,[(String,Type)])}
            local qfunIdens   : _
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
-}
data TableRef  = JoinedTref (Annotation) (TableRef) (Natural) (JoinType) (TableRef) (OnExpr) (TableAlias) 
               | SubTref (Annotation) (SelectExpression) (TableAlias) 
               | Tref (Annotation) (String) (TableAlias) 
               | TrefFun (Annotation) (Expression) (TableAlias) 
               deriving ( Data,Eq,Show,Typeable)
-- cata
sem_TableRef :: TableRef  ->
                T_TableRef 
sem_TableRef (JoinedTref _ann _tbl _nat _joinType _tbl1 _onExpr _alias )  =
    (sem_TableRef_JoinedTref _ann (sem_TableRef _tbl ) _nat _joinType (sem_TableRef _tbl1 ) (sem_OnExpr _onExpr ) _alias )
sem_TableRef (SubTref _ann _sel _alias )  =
    (sem_TableRef_SubTref _ann (sem_SelectExpression _sel ) _alias )
sem_TableRef (Tref _ann _tbl _alias )  =
    (sem_TableRef_Tref _ann _tbl _alias )
sem_TableRef (TrefFun _ann _fn _alias )  =
    (sem_TableRef_TrefFun _ann (sem_Expression _fn ) _alias )
-- semantic domain
type T_TableRef  = Catalog ->
                   LocalBindings ->
                   ( TableRef,([LocalBindingsUpdate]),TableRef)
data Inh_TableRef  = Inh_TableRef {cat_Inh_TableRef :: Catalog,lib_Inh_TableRef :: LocalBindings}
data Syn_TableRef  = Syn_TableRef {annotatedTree_Syn_TableRef :: TableRef,libUpdates_Syn_TableRef :: [LocalBindingsUpdate],originalTree_Syn_TableRef :: TableRef}
wrap_TableRef :: T_TableRef  ->
                 Inh_TableRef  ->
                 Syn_TableRef 
wrap_TableRef sem (Inh_TableRef _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOlibUpdates,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_TableRef _lhsOannotatedTree _lhsOlibUpdates _lhsOoriginalTree ))
sem_TableRef_JoinedTref :: Annotation ->
                           T_TableRef  ->
                           Natural ->
                           JoinType ->
                           T_TableRef  ->
                           T_OnExpr  ->
                           TableAlias ->
                           T_TableRef 
sem_TableRef_JoinedTref ann_ tbl_ nat_ joinType_ tbl1_ onExpr_ alias_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: TableRef
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _newLib :: (Either [TypeError] LocalBindings)
              _onExprOlib :: LocalBindings
              _lhsOoriginalTree :: TableRef
              _tblOcat :: Catalog
              _tblOlib :: LocalBindings
              _tbl1Ocat :: Catalog
              _tbl1Olib :: LocalBindings
              _onExprOcat :: Catalog
              _tblIannotatedTree :: TableRef
              _tblIlibUpdates :: ([LocalBindingsUpdate])
              _tblIoriginalTree :: TableRef
              _tbl1IannotatedTree :: TableRef
              _tbl1IlibUpdates :: ([LocalBindingsUpdate])
              _tbl1IoriginalTree :: TableRef
              _onExprIannotatedTree :: OnExpr
              _onExprIoriginalTree :: OnExpr
              -- "./TypeChecking/TableRefs.ag"(line 91, column 9)
              _lhsOannotatedTree =
                  {-# LINE 91 "./TypeChecking/TableRefs.ag" #-}
                  addTypeErrors _errs     _backTree
                  {-# LINE 11948 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 183, column 9)
              _errs =
                  {-# LINE 183 "./TypeChecking/TableRefs.ag" #-}
                  fromLeft [] _newLib
                  ++ _joinErrors
                  {-# LINE 11954 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 185, column 9)
              _lhsOlibUpdates =
                  {-# LINE 185 "./TypeChecking/TableRefs.ag" #-}
                  if _joinErrors     == []
                  then _libUpdates
                  else []
                  {-# LINE 11961 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 190, column 9)
              _joinErrors =
                  {-# LINE 190 "./TypeChecking/TableRefs.ag" #-}
                  fromLeft [] (foldM (flip $ lbUpdate _lhsIcat) _lhsIlib _libUpdates    )
                  {-# LINE 11966 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 191, column 9)
              _libUpdates =
                  {-# LINE 191 "./TypeChecking/TableRefs.ag" #-}
                  case (_tblIlibUpdates, _tbl1IlibUpdates) of
                    ([u1], [u2]) -> [LBJoinIds u1 u2 jids (case alias_ of
                                                             NoAlias -> ""
                                                             TableAlias t -> t
                                                             FullAlias t _ -> t)]
                    _ -> []
                  where
                    jids = case (nat_, _onExprIoriginalTree) of
                                (Natural, _) -> Left ()
                                (_,Just (JoinUsing _ s)) -> Right s
                                _ -> Right []
                  {-# LINE 11981 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 204, column 9)
              _newLib =
                  {-# LINE 204 "./TypeChecking/TableRefs.ag" #-}
                  case (_tblIlibUpdates, _tbl1IlibUpdates) of
                    ([u1],[u2]) -> lbUpdate _lhsIcat (LBParallel u1 u2) _lhsIlib
                    _ -> Right _lhsIlib
                  {-# LINE 11988 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 207, column 9)
              _onExprOlib =
                  {-# LINE 207 "./TypeChecking/TableRefs.ag" #-}
                  fromRight _lhsIlib _newLib
                  {-# LINE 11993 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 266, column 9)
              _backTree =
                  {-# LINE 266 "./TypeChecking/TableRefs.ag" #-}
                  JoinedTref ann_
                             _tblIannotatedTree
                             nat_
                             joinType_
                             _tbl1IannotatedTree
                             _onExprIannotatedTree
                             alias_
                  {-# LINE 12004 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  JoinedTref ann_ _tblIannotatedTree nat_ joinType_ _tbl1IannotatedTree _onExprIannotatedTree alias_
                  {-# LINE 12009 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  JoinedTref ann_ _tblIoriginalTree nat_ joinType_ _tbl1IoriginalTree _onExprIoriginalTree alias_
                  {-# LINE 12014 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12019 "AstInternal.hs" #-}
              -- copy rule (down)
              _tblOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12024 "AstInternal.hs" #-}
              -- copy rule (down)
              _tblOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12029 "AstInternal.hs" #-}
              -- copy rule (down)
              _tbl1Ocat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12034 "AstInternal.hs" #-}
              -- copy rule (down)
              _tbl1Olib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12039 "AstInternal.hs" #-}
              -- copy rule (down)
              _onExprOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12044 "AstInternal.hs" #-}
              ( _tblIannotatedTree,_tblIlibUpdates,_tblIoriginalTree) =
                  (tbl_ _tblOcat _tblOlib )
              ( _tbl1IannotatedTree,_tbl1IlibUpdates,_tbl1IoriginalTree) =
                  (tbl1_ _tbl1Ocat _tbl1Olib )
              ( _onExprIannotatedTree,_onExprIoriginalTree) =
                  (onExpr_ _onExprOcat _onExprOlib )
          in  ( _lhsOannotatedTree,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_TableRef_SubTref :: Annotation ->
                        T_SelectExpression  ->
                        TableAlias ->
                        T_TableRef 
sem_TableRef_SubTref ann_ sel_ alias_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: TableRef
              _selectAttrs :: (Either [TypeError] [(String,Type)])
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOoriginalTree :: TableRef
              _selOcat :: Catalog
              _selOlib :: LocalBindings
              _selIannotatedTree :: SelectExpression
              _selIoriginalTree :: SelectExpression
              -- "./TypeChecking/TableRefs.ag"(line 91, column 9)
              _lhsOannotatedTree =
                  {-# LINE 91 "./TypeChecking/TableRefs.ag" #-}
                  addTypeErrors _errs     _backTree
                  {-# LINE 12071 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 134, column 9)
              _errs =
                  {-# LINE 134 "./TypeChecking/TableRefs.ag" #-}
                  case _selectAttrs     of
                          Left e -> e
                          Right _ -> []
                  {-# LINE 12078 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 138, column 9)
              _selectAttrs =
                  {-# LINE 138 "./TypeChecking/TableRefs.ag" #-}
                  lmt (getTypeAnnotation _selIannotatedTree)
                  >>= unwrapSetOfComposite
                  {-# LINE 12084 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 140, column 9)
              _lhsOlibUpdates =
                  {-# LINE 140 "./TypeChecking/TableRefs.ag" #-}
                  [LBIds "sub query" (getAlias "" alias_)
                                  (fromRight [] _selectAttrs    ) []]
                  {-# LINE 12090 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 260, column 9)
              _backTree =
                  {-# LINE 260 "./TypeChecking/TableRefs.ag" #-}
                  SubTref ann_ _selIannotatedTree alias_
                  {-# LINE 12095 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  SubTref ann_ _selIannotatedTree alias_
                  {-# LINE 12100 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  SubTref ann_ _selIoriginalTree alias_
                  {-# LINE 12105 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12110 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12115 "AstInternal.hs" #-}
              -- copy rule (down)
              _selOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12120 "AstInternal.hs" #-}
              ( _selIannotatedTree,_selIoriginalTree) =
                  (sel_ _selOcat _selOlib )
          in  ( _lhsOannotatedTree,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_TableRef_Tref :: Annotation ->
                     String ->
                     TableAlias ->
                     T_TableRef 
sem_TableRef_Tref ann_ tbl_ alias_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: TableRef
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _relType :: (Either [TypeError] ([(String, Type)], [(String, Type)]))
              _lhsOoriginalTree :: TableRef
              -- "./TypeChecking/TableRefs.ag"(line 91, column 9)
              _lhsOannotatedTree =
                  {-# LINE 91 "./TypeChecking/TableRefs.ag" #-}
                  addTypeErrors _errs     _backTree
                  {-# LINE 12139 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 148, column 9)
              _errs =
                  {-# LINE 148 "./TypeChecking/TableRefs.ag" #-}
                  case _relType     of
                    Left e -> e
                    Right _ -> []
                  {-# LINE 12146 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 151, column 9)
              _lhsOlibUpdates =
                  {-# LINE 151 "./TypeChecking/TableRefs.ag" #-}
                  [LBIds ("tref: " ++ tbl_)
                                  (getAlias tbl_ alias_)
                                  (fst _relType1    )
                                  (snd _relType1    )]
                  {-# LINE 12154 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 157, column 9)
              _relType =
                  {-# LINE 157 "./TypeChecking/TableRefs.ag" #-}
                  catCompositeAttrsPair _lhsIcat [] tbl_
                  {-# LINE 12159 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 158, column 9)
              _relType1 =
                  {-# LINE 158 "./TypeChecking/TableRefs.ag" #-}
                  fromRight ([],[]) _relType
                  {-# LINE 12164 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 262, column 9)
              _backTree =
                  {-# LINE 262 "./TypeChecking/TableRefs.ag" #-}
                  Tref ann_ tbl_ alias_
                  {-# LINE 12169 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  Tref ann_ tbl_ alias_
                  {-# LINE 12174 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  Tref ann_ tbl_ alias_
                  {-# LINE 12179 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12184 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_TableRef_TrefFun :: Annotation ->
                        T_Expression  ->
                        TableAlias ->
                        T_TableRef 
sem_TableRef_TrefFun ann_ fn_ alias_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: TableRef
              _eqfunIdens :: (Either [TypeError] (String,[(String,Type)]))
              _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOoriginalTree :: TableRef
              _fnOcat :: Catalog
              _fnOlib :: LocalBindings
              _fnIannotatedTree :: Expression
              _fnIntAnnotatedTree :: Expression
              _fnIntType :: ([(String,Type)])
              _fnIoriginalTree :: Expression
              -- "./TypeChecking/TableRefs.ag"(line 91, column 9)
              _lhsOannotatedTree =
                  {-# LINE 91 "./TypeChecking/TableRefs.ag" #-}
                  addTypeErrors _errs     _backTree
                  {-# LINE 12207 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 167, column 9)
              _errs =
                  {-# LINE 167 "./TypeChecking/TableRefs.ag" #-}
                  case _eqfunIdens of
                    Left e -> e
                    Right _ -> []
                  {-# LINE 12214 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 173, column 9)
              _eqfunIdens =
                  {-# LINE 173 "./TypeChecking/TableRefs.ag" #-}
                  funIdens _lhsIcat (getAlias "" alias_) _fnIannotatedTree
                  {-# LINE 12219 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 174, column 9)
              _lhsOlibUpdates =
                  {-# LINE 174 "./TypeChecking/TableRefs.ag" #-}
                  [LBIds ("fn")
                                  (fst _qfunIdens    )
                                  (snd _qfunIdens    )
                                  []]
                  {-# LINE 12227 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 178, column 9)
              _qfunIdens =
                  {-# LINE 178 "./TypeChecking/TableRefs.ag" #-}
                  fromRight ("",[]) _eqfunIdens
                  {-# LINE 12232 "AstInternal.hs" #-}
              -- "./TypeChecking/TableRefs.ag"(line 264, column 9)
              _backTree =
                  {-# LINE 264 "./TypeChecking/TableRefs.ag" #-}
                  TrefFun ann_ _fnIannotatedTree alias_
                  {-# LINE 12237 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  TrefFun ann_ _fnIannotatedTree alias_
                  {-# LINE 12242 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  TrefFun ann_ _fnIoriginalTree alias_
                  {-# LINE 12247 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12252 "AstInternal.hs" #-}
              -- copy rule (down)
              _fnOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12257 "AstInternal.hs" #-}
              -- copy rule (down)
              _fnOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12262 "AstInternal.hs" #-}
              ( _fnIannotatedTree,_fnIntAnnotatedTree,_fnIntType,_fnIoriginalTree) =
                  (fn_ _fnOcat _fnOlib )
          in  ( _lhsOannotatedTree,_lhsOlibUpdates,_lhsOoriginalTree)))
-- TableRefList ------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         libUpdates           : [LocalBindingsUpdate]
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : TableRef 
         child tl             : TableRefList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type TableRefList  = [(TableRef)]
-- cata
sem_TableRefList :: TableRefList  ->
                    T_TableRefList 
sem_TableRefList list  =
    (Prelude.foldr sem_TableRefList_Cons sem_TableRefList_Nil (Prelude.map sem_TableRef list) )
-- semantic domain
type T_TableRefList  = Catalog ->
                       LocalBindings ->
                       ( TableRefList,([LocalBindingsUpdate]),TableRefList)
data Inh_TableRefList  = Inh_TableRefList {cat_Inh_TableRefList :: Catalog,lib_Inh_TableRefList :: LocalBindings}
data Syn_TableRefList  = Syn_TableRefList {annotatedTree_Syn_TableRefList :: TableRefList,libUpdates_Syn_TableRefList :: [LocalBindingsUpdate],originalTree_Syn_TableRefList :: TableRefList}
wrap_TableRefList :: T_TableRefList  ->
                     Inh_TableRefList  ->
                     Syn_TableRefList 
wrap_TableRefList sem (Inh_TableRefList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOlibUpdates,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_TableRefList _lhsOannotatedTree _lhsOlibUpdates _lhsOoriginalTree ))
sem_TableRefList_Cons :: T_TableRef  ->
                         T_TableRefList  ->
                         T_TableRefList 
sem_TableRefList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: TableRefList
              _lhsOoriginalTree :: TableRefList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: TableRef
              _hdIlibUpdates :: ([LocalBindingsUpdate])
              _hdIoriginalTree :: TableRef
              _tlIannotatedTree :: TableRefList
              _tlIlibUpdates :: ([LocalBindingsUpdate])
              _tlIoriginalTree :: TableRefList
              -- "./TypeChecking/TableRefs.ag"(line 97, column 9)
              _lhsOlibUpdates =
                  {-# LINE 97 "./TypeChecking/TableRefs.ag" #-}
                  _hdIlibUpdates
                  {-# LINE 12330 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 12335 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 12340 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 12345 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12350 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12355 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12360 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12365 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12370 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIlibUpdates,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIlibUpdates,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOlibUpdates,_lhsOoriginalTree)))
sem_TableRefList_Nil :: T_TableRefList 
sem_TableRefList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOlibUpdates :: ([LocalBindingsUpdate])
              _lhsOannotatedTree :: TableRefList
              _lhsOoriginalTree :: TableRefList
              -- "./TypeChecking/TableRefs.ag"(line 95, column 9)
              _lhsOlibUpdates =
                  {-# LINE 95 "./TypeChecking/TableRefs.ag" #-}
                  []
                  {-# LINE 12387 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 12392 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 12397 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 12402 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12407 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOlibUpdates,_lhsOoriginalTree)))
-- TypeAttributeDef --------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         attrName             : String
         namedType            : Maybe Type
         originalTree         : SELF 
   alternatives:
      alternative TypeAttDef:
         child ann            : {Annotation}
         child name           : {String}
         child typ            : TypeName 
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data TypeAttributeDef  = TypeAttDef (Annotation) (String) (TypeName) 
                       deriving ( Data,Eq,Show,Typeable)
-- cata
sem_TypeAttributeDef :: TypeAttributeDef  ->
                        T_TypeAttributeDef 
sem_TypeAttributeDef (TypeAttDef _ann _name _typ )  =
    (sem_TypeAttributeDef_TypeAttDef _ann _name (sem_TypeName _typ ) )
-- semantic domain
type T_TypeAttributeDef  = Catalog ->
                           LocalBindings ->
                           ( TypeAttributeDef,String,(Maybe Type),TypeAttributeDef)
data Inh_TypeAttributeDef  = Inh_TypeAttributeDef {cat_Inh_TypeAttributeDef :: Catalog,lib_Inh_TypeAttributeDef :: LocalBindings}
data Syn_TypeAttributeDef  = Syn_TypeAttributeDef {annotatedTree_Syn_TypeAttributeDef :: TypeAttributeDef,attrName_Syn_TypeAttributeDef :: String,namedType_Syn_TypeAttributeDef :: Maybe Type,originalTree_Syn_TypeAttributeDef :: TypeAttributeDef}
wrap_TypeAttributeDef :: T_TypeAttributeDef  ->
                         Inh_TypeAttributeDef  ->
                         Syn_TypeAttributeDef 
wrap_TypeAttributeDef sem (Inh_TypeAttributeDef _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOattrName,_lhsOnamedType,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_TypeAttributeDef _lhsOannotatedTree _lhsOattrName _lhsOnamedType _lhsOoriginalTree ))
sem_TypeAttributeDef_TypeAttDef :: Annotation ->
                                   String ->
                                   T_TypeName  ->
                                   T_TypeAttributeDef 
sem_TypeAttributeDef_TypeAttDef ann_ name_ typ_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOattrName :: String
              _lhsOnamedType :: (Maybe Type)
              _lhsOannotatedTree :: TypeAttributeDef
              _lhsOoriginalTree :: TypeAttributeDef
              _typOcat :: Catalog
              _typOlib :: LocalBindings
              _typIannotatedTree :: TypeName
              _typInamedType :: (Maybe Type)
              _typIoriginalTree :: TypeName
              -- "./TypeChecking/MiscCreates.ag"(line 40, column 9)
              _lhsOattrName =
                  {-# LINE 40 "./TypeChecking/MiscCreates.ag" #-}
                  name_
                  {-# LINE 12469 "AstInternal.hs" #-}
              -- "./TypeChecking/MiscCreates.ag"(line 41, column 9)
              _lhsOnamedType =
                  {-# LINE 41 "./TypeChecking/MiscCreates.ag" #-}
                  _typInamedType
                  {-# LINE 12474 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  TypeAttDef ann_ name_ _typIannotatedTree
                  {-# LINE 12479 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  TypeAttDef ann_ name_ _typIoriginalTree
                  {-# LINE 12484 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 12489 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12494 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12499 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12504 "AstInternal.hs" #-}
              ( _typIannotatedTree,_typInamedType,_typIoriginalTree) =
                  (typ_ _typOcat _typOlib )
          in  ( _lhsOannotatedTree,_lhsOattrName,_lhsOnamedType,_lhsOoriginalTree)))
-- TypeAttributeDefList ----------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         attrs                : [(String, Maybe Type)]
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : TypeAttributeDef 
         child tl             : TypeAttributeDefList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type TypeAttributeDefList  = [(TypeAttributeDef)]
-- cata
sem_TypeAttributeDefList :: TypeAttributeDefList  ->
                            T_TypeAttributeDefList 
sem_TypeAttributeDefList list  =
    (Prelude.foldr sem_TypeAttributeDefList_Cons sem_TypeAttributeDefList_Nil (Prelude.map sem_TypeAttributeDef list) )
-- semantic domain
type T_TypeAttributeDefList  = Catalog ->
                               LocalBindings ->
                               ( TypeAttributeDefList,([(String, Maybe Type)]),TypeAttributeDefList)
data Inh_TypeAttributeDefList  = Inh_TypeAttributeDefList {cat_Inh_TypeAttributeDefList :: Catalog,lib_Inh_TypeAttributeDefList :: LocalBindings}
data Syn_TypeAttributeDefList  = Syn_TypeAttributeDefList {annotatedTree_Syn_TypeAttributeDefList :: TypeAttributeDefList,attrs_Syn_TypeAttributeDefList :: [(String, Maybe Type)],originalTree_Syn_TypeAttributeDefList :: TypeAttributeDefList}
wrap_TypeAttributeDefList :: T_TypeAttributeDefList  ->
                             Inh_TypeAttributeDefList  ->
                             Syn_TypeAttributeDefList 
wrap_TypeAttributeDefList sem (Inh_TypeAttributeDefList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOattrs,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_TypeAttributeDefList _lhsOannotatedTree _lhsOattrs _lhsOoriginalTree ))
sem_TypeAttributeDefList_Cons :: T_TypeAttributeDef  ->
                                 T_TypeAttributeDefList  ->
                                 T_TypeAttributeDefList 
sem_TypeAttributeDefList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOattrs :: ([(String, Maybe Type)])
              _lhsOannotatedTree :: TypeAttributeDefList
              _lhsOoriginalTree :: TypeAttributeDefList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: TypeAttributeDef
              _hdIattrName :: String
              _hdInamedType :: (Maybe Type)
              _hdIoriginalTree :: TypeAttributeDef
              _tlIannotatedTree :: TypeAttributeDefList
              _tlIattrs :: ([(String, Maybe Type)])
              _tlIoriginalTree :: TypeAttributeDefList
              -- "./TypeChecking/MiscCreates.ag"(line 46, column 12)
              _lhsOattrs =
                  {-# LINE 46 "./TypeChecking/MiscCreates.ag" #-}
                  (_hdIattrName, _hdInamedType) : _tlIattrs
                  {-# LINE 12573 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 12578 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 12583 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 12588 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12593 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12598 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12603 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12608 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12613 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIattrName,_hdInamedType,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIattrs,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOattrs,_lhsOoriginalTree)))
sem_TypeAttributeDefList_Nil :: T_TypeAttributeDefList 
sem_TypeAttributeDefList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOattrs :: ([(String, Maybe Type)])
              _lhsOannotatedTree :: TypeAttributeDefList
              _lhsOoriginalTree :: TypeAttributeDefList
              -- "./TypeChecking/MiscCreates.ag"(line 47, column 11)
              _lhsOattrs =
                  {-# LINE 47 "./TypeChecking/MiscCreates.ag" #-}
                  []
                  {-# LINE 12630 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 12635 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 12640 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 12645 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12650 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOattrs,_lhsOoriginalTree)))
-- TypeName ----------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         namedType            : Maybe Type
         originalTree         : SELF 
   alternatives:
      alternative ArrayTypeName:
         child ann            : {Annotation}
         child typ            : TypeName 
         visit 0:
            local tpe         : _
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative PrecTypeName:
         child ann            : {Annotation}
         child tn             : {String}
         child prec           : {Integer}
         visit 0:
            local tpe         : _
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative SetOfTypeName:
         child ann            : {Annotation}
         child typ            : TypeName 
         visit 0:
            local tpe         : _
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
      alternative SimpleTypeName:
         child ann            : {Annotation}
         child tn             : {String}
         visit 0:
            local tpe         : _
            local backTree    : _
            local annotatedTree : _
            local originalTree : _
-}
data TypeName  = ArrayTypeName (Annotation) (TypeName) 
               | PrecTypeName (Annotation) (String) (Integer) 
               | SetOfTypeName (Annotation) (TypeName) 
               | SimpleTypeName (Annotation) (String) 
               deriving ( Data,Eq,Show,Typeable)
-- cata
sem_TypeName :: TypeName  ->
                T_TypeName 
sem_TypeName (ArrayTypeName _ann _typ )  =
    (sem_TypeName_ArrayTypeName _ann (sem_TypeName _typ ) )
sem_TypeName (PrecTypeName _ann _tn _prec )  =
    (sem_TypeName_PrecTypeName _ann _tn _prec )
sem_TypeName (SetOfTypeName _ann _typ )  =
    (sem_TypeName_SetOfTypeName _ann (sem_TypeName _typ ) )
sem_TypeName (SimpleTypeName _ann _tn )  =
    (sem_TypeName_SimpleTypeName _ann _tn )
-- semantic domain
type T_TypeName  = Catalog ->
                   LocalBindings ->
                   ( TypeName,(Maybe Type),TypeName)
data Inh_TypeName  = Inh_TypeName {cat_Inh_TypeName :: Catalog,lib_Inh_TypeName :: LocalBindings}
data Syn_TypeName  = Syn_TypeName {annotatedTree_Syn_TypeName :: TypeName,namedType_Syn_TypeName :: Maybe Type,originalTree_Syn_TypeName :: TypeName}
wrap_TypeName :: T_TypeName  ->
                 Inh_TypeName  ->
                 Syn_TypeName 
wrap_TypeName sem (Inh_TypeName _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOnamedType,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_TypeName _lhsOannotatedTree _lhsOnamedType _lhsOoriginalTree ))
sem_TypeName_ArrayTypeName :: Annotation ->
                              T_TypeName  ->
                              T_TypeName 
sem_TypeName_ArrayTypeName ann_ typ_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOnamedType :: (Maybe Type)
              _lhsOannotatedTree :: TypeName
              _lhsOoriginalTree :: TypeName
              _typOcat :: Catalog
              _typOlib :: LocalBindings
              _typIannotatedTree :: TypeName
              _typInamedType :: (Maybe Type)
              _typIoriginalTree :: TypeName
              -- "./TypeChecking/Misc.ag"(line 19, column 10)
              _lhsOnamedType =
                  {-# LINE 19 "./TypeChecking/Misc.ag" #-}
                  etmt _tpe
                  {-# LINE 12744 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 20, column 10)
              _lhsOannotatedTree =
                  {-# LINE 20 "./TypeChecking/Misc.ag" #-}
                  addTypeErrors (tes _tpe    ) _backTree
                  {-# LINE 12749 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 27, column 9)
              _tpe =
                  {-# LINE 27 "./TypeChecking/Misc.ag" #-}
                  lmt _typInamedType >>=  Right . ArrayType
                  {-# LINE 12754 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 28, column 9)
              _backTree =
                  {-# LINE 28 "./TypeChecking/Misc.ag" #-}
                  ArrayTypeName ann_ _typIannotatedTree
                  {-# LINE 12759 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  ArrayTypeName ann_ _typIannotatedTree
                  {-# LINE 12764 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  ArrayTypeName ann_ _typIoriginalTree
                  {-# LINE 12769 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12774 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12779 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12784 "AstInternal.hs" #-}
              ( _typIannotatedTree,_typInamedType,_typIoriginalTree) =
                  (typ_ _typOcat _typOlib )
          in  ( _lhsOannotatedTree,_lhsOnamedType,_lhsOoriginalTree)))
sem_TypeName_PrecTypeName :: Annotation ->
                             String ->
                             Integer ->
                             T_TypeName 
sem_TypeName_PrecTypeName ann_ tn_ prec_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOnamedType :: (Maybe Type)
              _lhsOannotatedTree :: TypeName
              _lhsOoriginalTree :: TypeName
              -- "./TypeChecking/Misc.ag"(line 19, column 10)
              _lhsOnamedType =
                  {-# LINE 19 "./TypeChecking/Misc.ag" #-}
                  etmt _tpe
                  {-# LINE 12802 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 20, column 10)
              _lhsOannotatedTree =
                  {-# LINE 20 "./TypeChecking/Misc.ag" #-}
                  addTypeErrors (tes _tpe    ) _backTree
                  {-# LINE 12807 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 33, column 9)
              _tpe =
                  {-# LINE 33 "./TypeChecking/Misc.ag" #-}
                  catLookupType _lhsIcat $ canonicalizeTypeName tn_
                  {-# LINE 12812 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 34, column 9)
              _backTree =
                  {-# LINE 34 "./TypeChecking/Misc.ag" #-}
                  PrecTypeName ann_ tn_ prec_
                  {-# LINE 12817 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  PrecTypeName ann_ tn_ prec_
                  {-# LINE 12822 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  PrecTypeName ann_ tn_ prec_
                  {-# LINE 12827 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12832 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOnamedType,_lhsOoriginalTree)))
sem_TypeName_SetOfTypeName :: Annotation ->
                              T_TypeName  ->
                              T_TypeName 
sem_TypeName_SetOfTypeName ann_ typ_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOnamedType :: (Maybe Type)
              _lhsOannotatedTree :: TypeName
              _lhsOoriginalTree :: TypeName
              _typOcat :: Catalog
              _typOlib :: LocalBindings
              _typIannotatedTree :: TypeName
              _typInamedType :: (Maybe Type)
              _typIoriginalTree :: TypeName
              -- "./TypeChecking/Misc.ag"(line 19, column 10)
              _lhsOnamedType =
                  {-# LINE 19 "./TypeChecking/Misc.ag" #-}
                  etmt _tpe
                  {-# LINE 12852 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 20, column 10)
              _lhsOannotatedTree =
                  {-# LINE 20 "./TypeChecking/Misc.ag" #-}
                  addTypeErrors (tes _tpe    ) _backTree
                  {-# LINE 12857 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 30, column 9)
              _tpe =
                  {-# LINE 30 "./TypeChecking/Misc.ag" #-}
                  lmt _typInamedType >>=  Right . SetOfType
                  {-# LINE 12862 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 31, column 9)
              _backTree =
                  {-# LINE 31 "./TypeChecking/Misc.ag" #-}
                  SetOfTypeName ann_ _typIannotatedTree
                  {-# LINE 12867 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  SetOfTypeName ann_ _typIannotatedTree
                  {-# LINE 12872 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  SetOfTypeName ann_ _typIoriginalTree
                  {-# LINE 12877 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12882 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 12887 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 12892 "AstInternal.hs" #-}
              ( _typIannotatedTree,_typInamedType,_typIoriginalTree) =
                  (typ_ _typOcat _typOlib )
          in  ( _lhsOannotatedTree,_lhsOnamedType,_lhsOoriginalTree)))
sem_TypeName_SimpleTypeName :: Annotation ->
                               String ->
                               T_TypeName 
sem_TypeName_SimpleTypeName ann_ tn_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOnamedType :: (Maybe Type)
              _lhsOannotatedTree :: TypeName
              _lhsOoriginalTree :: TypeName
              -- "./TypeChecking/Misc.ag"(line 19, column 10)
              _lhsOnamedType =
                  {-# LINE 19 "./TypeChecking/Misc.ag" #-}
                  etmt _tpe
                  {-# LINE 12909 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 20, column 10)
              _lhsOannotatedTree =
                  {-# LINE 20 "./TypeChecking/Misc.ag" #-}
                  addTypeErrors (tes _tpe    ) _backTree
                  {-# LINE 12914 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 24, column 9)
              _tpe =
                  {-# LINE 24 "./TypeChecking/Misc.ag" #-}
                  catLookupType _lhsIcat $ canonicalizeTypeName tn_
                  {-# LINE 12919 "AstInternal.hs" #-}
              -- "./TypeChecking/Misc.ag"(line 25, column 9)
              _backTree =
                  {-# LINE 25 "./TypeChecking/Misc.ag" #-}
                  SimpleTypeName ann_ tn_
                  {-# LINE 12924 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  SimpleTypeName ann_ tn_
                  {-# LINE 12929 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  SimpleTypeName ann_ tn_
                  {-# LINE 12934 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 12939 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOnamedType,_lhsOoriginalTree)))
-- TypeNameList ------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         namedTypes           : [Maybe Type]
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : TypeName 
         child tl             : TypeNameList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type TypeNameList  = [(TypeName)]
-- cata
sem_TypeNameList :: TypeNameList  ->
                    T_TypeNameList 
sem_TypeNameList list  =
    (Prelude.foldr sem_TypeNameList_Cons sem_TypeNameList_Nil (Prelude.map sem_TypeName list) )
-- semantic domain
type T_TypeNameList  = Catalog ->
                       LocalBindings ->
                       ( TypeNameList,([Maybe Type]),TypeNameList)
data Inh_TypeNameList  = Inh_TypeNameList {cat_Inh_TypeNameList :: Catalog,lib_Inh_TypeNameList :: LocalBindings}
data Syn_TypeNameList  = Syn_TypeNameList {annotatedTree_Syn_TypeNameList :: TypeNameList,namedTypes_Syn_TypeNameList :: [Maybe Type],originalTree_Syn_TypeNameList :: TypeNameList}
wrap_TypeNameList :: T_TypeNameList  ->
                     Inh_TypeNameList  ->
                     Syn_TypeNameList 
wrap_TypeNameList sem (Inh_TypeNameList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOnamedTypes,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_TypeNameList _lhsOannotatedTree _lhsOnamedTypes _lhsOoriginalTree ))
sem_TypeNameList_Cons :: T_TypeName  ->
                         T_TypeNameList  ->
                         T_TypeNameList 
sem_TypeNameList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOnamedTypes :: ([Maybe Type])
              _lhsOannotatedTree :: TypeNameList
              _lhsOoriginalTree :: TypeNameList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: TypeName
              _hdInamedType :: (Maybe Type)
              _hdIoriginalTree :: TypeName
              _tlIannotatedTree :: TypeNameList
              _tlInamedTypes :: ([Maybe Type])
              _tlIoriginalTree :: TypeNameList
              -- "./TypeChecking/Drops.ag"(line 37, column 12)
              _lhsOnamedTypes =
                  {-# LINE 37 "./TypeChecking/Drops.ag" #-}
                  _hdInamedType : _tlInamedTypes
                  {-# LINE 13005 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 13010 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 13015 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 13020 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 13025 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 13030 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 13035 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 13040 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 13045 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdInamedType,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlInamedTypes,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOnamedTypes,_lhsOoriginalTree)))
sem_TypeNameList_Nil :: T_TypeNameList 
sem_TypeNameList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOnamedTypes :: ([Maybe Type])
              _lhsOannotatedTree :: TypeNameList
              _lhsOoriginalTree :: TypeNameList
              -- "./TypeChecking/Drops.ag"(line 38, column 11)
              _lhsOnamedTypes =
                  {-# LINE 38 "./TypeChecking/Drops.ag" #-}
                  []
                  {-# LINE 13062 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 13067 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 13072 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 13077 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 13082 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOnamedTypes,_lhsOoriginalTree)))
-- VarDef ------------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         def                  : (String,Maybe Type)
         originalTree         : SELF 
   alternatives:
      alternative VarDef:
         child ann            : {Annotation}
         child name           : {String}
         child typ            : TypeName 
         child value          : {Maybe Expression}
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
data VarDef  = VarDef (Annotation) (String) (TypeName) (Maybe Expression) 
             deriving ( Data,Eq,Show,Typeable)
-- cata
sem_VarDef :: VarDef  ->
              T_VarDef 
sem_VarDef (VarDef _ann _name _typ _value )  =
    (sem_VarDef_VarDef _ann _name (sem_TypeName _typ ) _value )
-- semantic domain
type T_VarDef  = Catalog ->
                 LocalBindings ->
                 ( VarDef,((String,Maybe Type)),VarDef)
data Inh_VarDef  = Inh_VarDef {cat_Inh_VarDef :: Catalog,lib_Inh_VarDef :: LocalBindings}
data Syn_VarDef  = Syn_VarDef {annotatedTree_Syn_VarDef :: VarDef,def_Syn_VarDef :: (String,Maybe Type),originalTree_Syn_VarDef :: VarDef}
wrap_VarDef :: T_VarDef  ->
               Inh_VarDef  ->
               Syn_VarDef 
wrap_VarDef sem (Inh_VarDef _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOdef,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_VarDef _lhsOannotatedTree _lhsOdef _lhsOoriginalTree ))
sem_VarDef_VarDef :: Annotation ->
                     String ->
                     T_TypeName  ->
                     (Maybe Expression) ->
                     T_VarDef 
sem_VarDef_VarDef ann_ name_ typ_ value_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOdef :: ((String,Maybe Type))
              _lhsOannotatedTree :: VarDef
              _lhsOoriginalTree :: VarDef
              _typOcat :: Catalog
              _typOlib :: LocalBindings
              _typIannotatedTree :: TypeName
              _typInamedType :: (Maybe Type)
              _typIoriginalTree :: TypeName
              -- "./TypeChecking/CreateFunction.ag"(line 94, column 14)
              _lhsOdef =
                  {-# LINE 94 "./TypeChecking/CreateFunction.ag" #-}
                  (name_, if _typInamedType == Just (Pseudo Record)
                          then Just (PgRecord Nothing)
                          else _typInamedType)
                  {-# LINE 13146 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  VarDef ann_ name_ _typIannotatedTree value_
                  {-# LINE 13151 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  VarDef ann_ name_ _typIoriginalTree value_
                  {-# LINE 13156 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 13161 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 13166 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 13171 "AstInternal.hs" #-}
              -- copy rule (down)
              _typOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 13176 "AstInternal.hs" #-}
              ( _typIannotatedTree,_typInamedType,_typIoriginalTree) =
                  (typ_ _typOcat _typOlib )
          in  ( _lhsOannotatedTree,_lhsOdef,_lhsOoriginalTree)))
-- VarDefList --------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         defs                 : [(String,Maybe Type)]
         originalTree         : SELF 
   alternatives:
      alternative Cons:
         child hd             : VarDef 
         child tl             : VarDefList 
         visit 0:
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local annotatedTree : _
            local originalTree : _
-}
type VarDefList  = [(VarDef)]
-- cata
sem_VarDefList :: VarDefList  ->
                  T_VarDefList 
sem_VarDefList list  =
    (Prelude.foldr sem_VarDefList_Cons sem_VarDefList_Nil (Prelude.map sem_VarDef list) )
-- semantic domain
type T_VarDefList  = Catalog ->
                     LocalBindings ->
                     ( VarDefList,([(String,Maybe Type)]),VarDefList)
data Inh_VarDefList  = Inh_VarDefList {cat_Inh_VarDefList :: Catalog,lib_Inh_VarDefList :: LocalBindings}
data Syn_VarDefList  = Syn_VarDefList {annotatedTree_Syn_VarDefList :: VarDefList,defs_Syn_VarDefList :: [(String,Maybe Type)],originalTree_Syn_VarDefList :: VarDefList}
wrap_VarDefList :: T_VarDefList  ->
                   Inh_VarDefList  ->
                   Syn_VarDefList 
wrap_VarDefList sem (Inh_VarDefList _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOdefs,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_VarDefList _lhsOannotatedTree _lhsOdefs _lhsOoriginalTree ))
sem_VarDefList_Cons :: T_VarDef  ->
                       T_VarDefList  ->
                       T_VarDefList 
sem_VarDefList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOdefs :: ([(String,Maybe Type)])
              _lhsOannotatedTree :: VarDefList
              _lhsOoriginalTree :: VarDefList
              _hdOcat :: Catalog
              _hdOlib :: LocalBindings
              _tlOcat :: Catalog
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: VarDef
              _hdIdef :: ((String,Maybe Type))
              _hdIoriginalTree :: VarDef
              _tlIannotatedTree :: VarDefList
              _tlIdefs :: ([(String,Maybe Type)])
              _tlIoriginalTree :: VarDefList
              -- "./TypeChecking/CreateFunction.ag"(line 99, column 12)
              _lhsOdefs =
                  {-# LINE 99 "./TypeChecking/CreateFunction.ag" #-}
                  _hdIdef : _tlIdefs
                  {-# LINE 13244 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 13249 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 13254 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 13259 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 13264 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 13269 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 13274 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 13279 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 13284 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIdef,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIdefs,_tlIoriginalTree) =
                  (tl_ _tlOcat _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOdefs,_lhsOoriginalTree)))
sem_VarDefList_Nil :: T_VarDefList 
sem_VarDefList_Nil  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOdefs :: ([(String,Maybe Type)])
              _lhsOannotatedTree :: VarDefList
              _lhsOoriginalTree :: VarDefList
              -- "./TypeChecking/CreateFunction.ag"(line 100, column 11)
              _lhsOdefs =
                  {-# LINE 100 "./TypeChecking/CreateFunction.ag" #-}
                  []
                  {-# LINE 13301 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 13306 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 13311 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 13316 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 13321 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOdefs,_lhsOoriginalTree)))
-- WithQuery ---------------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         catUpdates           : [CatalogUpdate]
         originalTree         : SELF 
   alternatives:
      alternative WithQuery:
         child ann            : {Annotation}
         child name           : {String}
         child ex             : SelectExpression 
         visit 0:
            local tpe         : _
            local backTree    : _
            local attrs       : _
            local catUpdates  : _
            local statementType : _
            local annotatedTree : _
            local originalTree : _
-}
data WithQuery  = WithQuery (Annotation) (String) (SelectExpression) 
                deriving ( Data,Eq,Show,Typeable)
-- cata
sem_WithQuery :: WithQuery  ->
                 T_WithQuery 
sem_WithQuery (WithQuery _ann _name _ex )  =
    (sem_WithQuery_WithQuery _ann _name (sem_SelectExpression _ex ) )
-- semantic domain
type T_WithQuery  = Catalog ->
                    LocalBindings ->
                    ( WithQuery,([CatalogUpdate]),WithQuery)
data Inh_WithQuery  = Inh_WithQuery {cat_Inh_WithQuery :: Catalog,lib_Inh_WithQuery :: LocalBindings}
data Syn_WithQuery  = Syn_WithQuery {annotatedTree_Syn_WithQuery :: WithQuery,catUpdates_Syn_WithQuery :: [CatalogUpdate],originalTree_Syn_WithQuery :: WithQuery}
wrap_WithQuery :: T_WithQuery  ->
                  Inh_WithQuery  ->
                  Syn_WithQuery 
wrap_WithQuery sem (Inh_WithQuery _lhsIcat _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOoriginalTree) =
             (sem _lhsIcat _lhsIlib )
     in  (Syn_WithQuery _lhsOannotatedTree _lhsOcatUpdates _lhsOoriginalTree ))
sem_WithQuery_WithQuery :: Annotation ->
                           String ->
                           T_SelectExpression  ->
                           T_WithQuery 
sem_WithQuery_WithQuery ann_ name_ ex_  =
    (\ _lhsIcat
       _lhsIlib ->
         (let _lhsOannotatedTree :: WithQuery
              _lhsOoriginalTree :: WithQuery
              _lhsOcatUpdates :: ([CatalogUpdate])
              _exOcat :: Catalog
              _exOlib :: LocalBindings
              _exIannotatedTree :: SelectExpression
              _exIoriginalTree :: SelectExpression
              -- "./TypeChecking/SelectStatement.ag"(line 232, column 9)
              _tpe =
                  {-# LINE 232 "./TypeChecking/SelectStatement.ag" #-}
                  Right $ Pseudo Void
                  {-# LINE 13385 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 233, column 9)
              _backTree =
                  {-# LINE 233 "./TypeChecking/SelectStatement.ag" #-}
                  WithQuery ann_ name_ _exIannotatedTree
                  {-# LINE 13390 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 234, column 9)
              _attrs =
                  {-# LINE 234 "./TypeChecking/SelectStatement.ag" #-}
                  case getTypeAnnotation _exIannotatedTree of
                    Just(SetOfType (CompositeType c)) -> c
                    _ -> []
                  {-# LINE 13397 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 237, column 9)
              _catUpdates =
                  {-# LINE 237 "./TypeChecking/SelectStatement.ag" #-}
                  [CatCreateView name_ _attrs    ]
                  {-# LINE 13402 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 238, column 9)
              _statementType =
                  {-# LINE 238 "./TypeChecking/SelectStatement.ag" #-}
                  Nothing
                  {-# LINE 13407 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  WithQuery ann_ name_ _exIannotatedTree
                  {-# LINE 13412 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  WithQuery ann_ name_ _exIoriginalTree
                  {-# LINE 13417 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 13422 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 13427 "AstInternal.hs" #-}
              -- copy rule (from local)
              _lhsOcatUpdates =
                  {-# LINE 206 "./TypeChecking/SelectStatement.ag" #-}
                  _catUpdates
                  {-# LINE 13432 "AstInternal.hs" #-}
              -- copy rule (down)
              _exOcat =
                  {-# LINE 56 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIcat
                  {-# LINE 13437 "AstInternal.hs" #-}
              -- copy rule (down)
              _exOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 13442 "AstInternal.hs" #-}
              ( _exIannotatedTree,_exIoriginalTree) =
                  (ex_ _exOcat _exOlib )
          in  ( _lhsOannotatedTree,_lhsOcatUpdates,_lhsOoriginalTree)))
-- WithQueryList -----------------------------------------------
{-
   visit 0:
      inherited attributes:
         cat                  : Catalog
         catUpdates           : [CatalogUpdate]
         lib                  : LocalBindings
      synthesized attributes:
         annotatedTree        : SELF 
         originalTree         : SELF 
         producedCat          : Catalog
   alternatives:
      alternative Cons:
         child hd             : WithQuery 
         child tl             : WithQueryList 
         visit 0:
            local newCat      : _
            local annotatedTree : _
            local originalTree : _
      alternative Nil:
         visit 0:
            local newCat      : _
            local annotatedTree : _
            local originalTree : _
-}
type WithQueryList  = [(WithQuery)]
-- cata
sem_WithQueryList :: WithQueryList  ->
                     T_WithQueryList 
sem_WithQueryList list  =
    (Prelude.foldr sem_WithQueryList_Cons sem_WithQueryList_Nil (Prelude.map sem_WithQuery list) )
-- semantic domain
type T_WithQueryList  = Catalog ->
                        ([CatalogUpdate]) ->
                        LocalBindings ->
                        ( WithQueryList,WithQueryList,Catalog)
data Inh_WithQueryList  = Inh_WithQueryList {cat_Inh_WithQueryList :: Catalog,catUpdates_Inh_WithQueryList :: [CatalogUpdate],lib_Inh_WithQueryList :: LocalBindings}
data Syn_WithQueryList  = Syn_WithQueryList {annotatedTree_Syn_WithQueryList :: WithQueryList,originalTree_Syn_WithQueryList :: WithQueryList,producedCat_Syn_WithQueryList :: Catalog}
wrap_WithQueryList :: T_WithQueryList  ->
                      Inh_WithQueryList  ->
                      Syn_WithQueryList 
wrap_WithQueryList sem (Inh_WithQueryList _lhsIcat _lhsIcatUpdates _lhsIlib )  =
    (let ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOproducedCat) =
             (sem _lhsIcat _lhsIcatUpdates _lhsIlib )
     in  (Syn_WithQueryList _lhsOannotatedTree _lhsOoriginalTree _lhsOproducedCat ))
sem_WithQueryList_Cons :: T_WithQuery  ->
                          T_WithQueryList  ->
                          T_WithQueryList 
sem_WithQueryList_Cons hd_ tl_  =
    (\ _lhsIcat
       _lhsIcatUpdates
       _lhsIlib ->
         (let _hdOcat :: Catalog
              _tlOcat :: Catalog
              _lhsOproducedCat :: Catalog
              _tlOcatUpdates :: ([CatalogUpdate])
              _lhsOannotatedTree :: WithQueryList
              _lhsOoriginalTree :: WithQueryList
              _hdOlib :: LocalBindings
              _tlOlib :: LocalBindings
              _hdIannotatedTree :: WithQuery
              _hdIcatUpdates :: ([CatalogUpdate])
              _hdIoriginalTree :: WithQuery
              _tlIannotatedTree :: WithQueryList
              _tlIoriginalTree :: WithQueryList
              _tlIproducedCat :: Catalog
              -- "./TypeChecking/SelectStatement.ag"(line 216, column 9)
              _newCat =
                  {-# LINE 216 "./TypeChecking/SelectStatement.ag" #-}
                  fromRight _lhsIcat $ updateCatalog _lhsIcat _lhsIcatUpdates
                  {-# LINE 13516 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 218, column 9)
              _hdOcat =
                  {-# LINE 218 "./TypeChecking/SelectStatement.ag" #-}
                  _newCat
                  {-# LINE 13521 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 219, column 9)
              _tlOcat =
                  {-# LINE 219 "./TypeChecking/SelectStatement.ag" #-}
                  _newCat
                  {-# LINE 13526 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 223, column 9)
              _lhsOproducedCat =
                  {-# LINE 223 "./TypeChecking/SelectStatement.ag" #-}
                  _tlIproducedCat
                  {-# LINE 13531 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 226, column 9)
              _tlOcatUpdates =
                  {-# LINE 226 "./TypeChecking/SelectStatement.ag" #-}
                  _hdIcatUpdates
                  {-# LINE 13536 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIannotatedTree _tlIannotatedTree
                  {-# LINE 13541 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  (:) _hdIoriginalTree _tlIoriginalTree
                  {-# LINE 13546 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 13551 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 13556 "AstInternal.hs" #-}
              -- copy rule (down)
              _hdOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 13561 "AstInternal.hs" #-}
              -- copy rule (down)
              _tlOlib =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _lhsIlib
                  {-# LINE 13566 "AstInternal.hs" #-}
              ( _hdIannotatedTree,_hdIcatUpdates,_hdIoriginalTree) =
                  (hd_ _hdOcat _hdOlib )
              ( _tlIannotatedTree,_tlIoriginalTree,_tlIproducedCat) =
                  (tl_ _tlOcat _tlOcatUpdates _tlOlib )
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOproducedCat)))
sem_WithQueryList_Nil :: T_WithQueryList 
sem_WithQueryList_Nil  =
    (\ _lhsIcat
       _lhsIcatUpdates
       _lhsIlib ->
         (let _lhsOproducedCat :: Catalog
              _lhsOannotatedTree :: WithQueryList
              _lhsOoriginalTree :: WithQueryList
              -- "./TypeChecking/SelectStatement.ag"(line 216, column 9)
              _newCat =
                  {-# LINE 216 "./TypeChecking/SelectStatement.ag" #-}
                  fromRight _lhsIcat $ updateCatalog _lhsIcat _lhsIcatUpdates
                  {-# LINE 13584 "AstInternal.hs" #-}
              -- "./TypeChecking/SelectStatement.ag"(line 228, column 9)
              _lhsOproducedCat =
                  {-# LINE 228 "./TypeChecking/SelectStatement.ag" #-}
                  _newCat
                  {-# LINE 13589 "AstInternal.hs" #-}
              -- self rule
              _annotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 13594 "AstInternal.hs" #-}
              -- self rule
              _originalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  []
                  {-# LINE 13599 "AstInternal.hs" #-}
              -- self rule
              _lhsOannotatedTree =
                  {-# LINE 57 "./TypeChecking/TypeChecking.ag" #-}
                  _annotatedTree
                  {-# LINE 13604 "AstInternal.hs" #-}
              -- self rule
              _lhsOoriginalTree =
                  {-# LINE 63 "./TypeChecking/TypeChecking.ag" #-}
                  _originalTree
                  {-# LINE 13609 "AstInternal.hs" #-}
          in  ( _lhsOannotatedTree,_lhsOoriginalTree,_lhsOproducedCat)))