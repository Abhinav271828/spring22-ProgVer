data Expr = Atom Int
          | Not  Expr
          | And  Expr Expr
          | Or   Expr Expr
          | Impl Expr Expr
                deriving (Eq, Show)

type Child = [Expr]

isSat :: Expr -> Bool
isSat e = let children = getChildren e
          in  any hasNoConf children

hasNoConf :: Child -> Bool
hasNoConf es
  | all isLeaf es = if (any (\a -> (Not a) `elem` es)
                            (filter isAtom es))
                    then False
                    else True
  | otherwise     = let css = map getChildren es
                    in  any hasNoConf
                            (foldr (\cs1 cs2 -> pure (++) <*> cs1 <*> cs2)
                                   [ [] ]
                                   css)

isLeaf :: Expr -> Bool
isLeaf (Atom _)       = True
isLeaf (Not (Atom _)) = True
isLeaf _              = False

isAtom :: Expr -> Bool
isAtom (Atom _) = True
isAtom _        = False

getChildren :: Expr -> [Child]
getChildren e@(Atom _)           = [[e]]
getChildren   (And  e1 e2)       = [[e1, e2]]
getChildren   (Or   e1 e2)       = [[e1], [e2]]
getChildren   (Impl e1 e2)       = [[Not e1], [e2]]
getChildren e@(Not (Atom _))     = [[e]]
getChildren   (Not (And  e1 e2)) = [[Not e1], [Not e2]]
getChildren   (Not (Or   e1 e2)) = [[Not e1, Not e2]]
getChildren   (Not (Impl e1 e2)) = [[e1], [Not e2]]
