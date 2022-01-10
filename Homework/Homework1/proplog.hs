data Exp = Var Char
         | And Exp Exp
         | Or  Exp Exp
         | Imp Exp Exp
         | Eqv Exp Exp
         | Not Exp
           deriving (Show, Eq)

data Turn = L | R deriving (Show, Eq)
type Address = [Turn]

vars' :: Exp -> [Char]
vars' (Var x    ) = [x]
vars' (And e1 e2) = (vars' e1) ++ (vars' e2)
vars' (Or  e1 e2) = (vars' e1) ++ (vars' e2)
vars' (Imp e1 e2) = (vars' e1) ++ (vars' e2)
vars' (Eqv e1 e2) = (vars' e1) ++ (vars' e2)
vars' (Not e    ) = vars' e

remdups :: Eq a => [a] -> [a]
remdups []     = []
remdups (x:xs) = x : (remdups $ filter (/= x) xs)

vars :: Exp -> [Char]
vars = remdups . vars'

size :: Exp -> Int
size (Var _    ) = 1
size (And e1 e2) = (size e1) + (size e2)
size (Or  e1 e2) = (size e1) + (size e2)
size (Imp e1 e2) = (size e1) + (size e2)
size (Eqv e1 e2) = (size e1) + (size e2)
size (Not e    ) = (size e ) + 1

addresses :: Exp -> [Address]
addresses (Var _    ) = [[]]
addresses (And e1 e2) =  []
                      : (map (L:) (addresses e1))
                     ++ (map (R:) (addresses e2))
addresses (Or  e1 e2) =  []
                      : (map (L:) (addresses e1))
                     ++ (map (R:) (addresses e2))
addresses (Imp e1 e2) =  []
                      : (map (L:) (addresses e1))
                     ++ (map (R:) (addresses e2))
addresses (Eqv e1 e2) =  []
                      : (map (L:) (addresses e1))
                     ++ (map (R:) (addresses e2))
addresses (Not e    ) =  []
                      : (map (L:) (addresses e ))

subExpression :: Exp -> Address -> Exp
subExpression m@(Var _    ) []   = m
subExpression m@(And e1 e2) addr = case addr of
                                     []     -> m
                                     (L:as) -> subExpression e1 as
                                     (R:as) -> subExpression e2 as
subExpression m@(Or  e1 e2) addr = case addr of
                                     []     -> m
                                     (L:as) -> subExpression e1 as
                                     (R:as) -> subExpression e2 as
subExpression m@(Imp e1 e2) addr = case addr of
                                     []     -> m
                                     (L:as) -> subExpression e1 as
                                     (R:as) -> subExpression e2 as
subExpression m@(Eqv e1 e2) addr = case addr of
                                     []     -> m
                                     (L:as) -> subExpression e1 as
                                     (R:as) -> subExpression e2 as
subExpression m@(Not e    ) addr = case addr of
                                     []     -> m
                                     (L:as) -> subExpression e  as

graft :: Exp -> Address -> Exp -> Exp
graft m@(Var _    ) []   n = n
graft m@(And e1 e2) addr n = case addr of
                               []     -> n
                               (L:as) -> And (graft e1 as n) e2
                               (R:as) -> And e1 (graft e2 as n)
graft m@(Or  e1 e2) addr n = case addr of
                               []     -> n
                               (L:as) -> Or  (graft e1 as n) e2
                               (R:as) -> Or  e1 (graft e2 as n)
graft m@(Imp e1 e2) addr n = case addr of
                               []     -> n
                               (L:as) -> Imp (graft e1 as n) e2
                               (R:as) -> Imp e1 (graft e2 as n)
graft m@(Eqv e1 e2) addr n = case addr of
                               []     -> n
                               (L:as) -> Eqv (graft e1 as n) e2
                               (R:as) -> Eqv e1 (graft e2 as n)
graft m@(Not e    ) addr n = case addr of
                               []     -> n
                               (L:as) -> Not (graft e  as n)

occurrences :: Exp -> Exp -> [Address]
occurrences m@(Var _    ) exp = (if (m == exp) then [[]]
                                               else [  ] )
occurrences m@(And e1 e2) exp = (if (m == exp) then [[]] else [])
                             ++ (map (L:) (occurrences e1 exp))
                             ++ (map (R:) (occurrences e2 exp))
occurrences m@(Or  e1 e2) exp = (if (m == exp) then [[]] else [])
                             ++ (map (L:) (occurrences e1 exp))
                             ++ (map (R:) (occurrences e2 exp))
occurrences m@(Imp e1 e2) exp = (if (m == exp) then [[]] else [])
                             ++ (map (L:) (occurrences e1 exp))
                             ++ (map (R:) (occurrences e2 exp))
occurrences m@(Eqv e1 e2) exp = (if (m == exp) then [[]] else [])
                             ++ (map (L:) (occurrences e1 exp))
                             ++ (map (R:) (occurrences e2 exp))
occurrences m@(Not e    ) exp = (if (m == exp) then [[]] else [])
                             ++ (map (L:) (occurrences e  exp))

substitute :: Exp -> Exp -> Exp -> Exp
substitute exp m n = foldl (\xp addr -> graft xp addr n)
                            exp
                            (occurrences exp m)
