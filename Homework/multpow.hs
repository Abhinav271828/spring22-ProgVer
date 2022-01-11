open nat

def addZ : ℕ -> ℕ -> ℕ
 | m zero     := m
 | m (succ n) := addZ (succ m) n

def mulZ : ℕ -> ℕ -> ℕ
 | m zero     := 0
 | m (succ n) := addZ (mulZ m n) m

def powZ : ℕ -> ℕ -> ℕ
 | m zero     := 1
 | m (succ n) := mulZ (powZ m n) m

#reduce (addZ 3 5)
#reduce (mulZ 3 5)
#reduce (powZ 3 5)
