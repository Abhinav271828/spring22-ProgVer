-- Types and Functions
constant a : ℕ
constants b c : ℕ

constant addType (p : ℕ) (q : ℕ) : ℕ
constant addTypeCurr : ℕ -> ℕ -> ℕ

def add (a : ℕ) (b : ℕ) : ℕ
 := a + b

def randomBinOp (op : ℕ -> ℕ -> ℕ) (a : ℕ) (b : ℕ) : ℕ
 := op a b

#eval (add 3 5)
#reduce (add 1)

def incr : ℕ -> ℕ
 := add 1

#reduce (incr 6)

-- Lists
open list

def ls : (list ℕ) := [1,2,3]
#reduce (nth ls 2)

-- Induction
open nat

def customAdd : ℕ -> ℕ -> ℕ
 | zero n     := n
 | (succ n) m := customAdd n (succ m)

def fact : ℕ -> ℕ
 | zero := 1
 | (succ n) := (succ n) * (fact n) -- this works

-- def notFact : ℕ -> ℕ
--  | 0 := 1
--  | n := n * (notFact (n-1))
        -- this doesn't; we need to prove that n-1 < n

def isFact : ℕ -> ℕ
 | 0     := 1
 | (n+1) := (n+1) * (isFact n) -- this also works

#eval (customAdd 3 5)
#eval (fact 6)
#eval (isFact 5)
