import Ast.UniversalIR

namespace UniversalIR

-- KEY THEOREMS (notebook-ready)
theorem assign_semantics (x : String) (e : Expr) (s : State) (y : String) :
    (⟦.assign x e⟧ s) y = if y == x then some (⟦e⟧ s) else s y := by rfl

theorem seq_assoc (s1 s2 s3 : State → State) :
    seq (seq s1 s2) s3 = seq s1 (seq s2 s3) := by rfl

-- Compositional sequence
theorem seq_denote (s1 s2 : Stmt) :
    ⟦s1; s2⟧ = seq ⟦s1⟧ ⟦s2⟧ := sorry -- Prove!

end UniversalIR
