#check ℕ -> ℕ
#check ℕ × ℕ

def a : Type := ℕ
#check a

universe u
def F (a : Type u) : Type u := a × a
#check F
