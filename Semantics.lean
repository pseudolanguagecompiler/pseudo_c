import Ast.UniversalIR

namespace UniversalIR

abbrev State := String → Option Nat

def seq (f g : State → State) : State → State := f ∘ g

notation:50 stmt " ⟦" s:51 "⟧" => evalStmt stmt s
notation:50 expr " ⟦" s:51 "⟧" => evalExpr expr s

theorem assign_semantics (x : String) (e : Expr) (s : State) (y : String) :
    (⟦Stmt.set x e⟧ s) y = if y == x then some (⟦e⟧ s) else s y := by
  simp [evalStmt, evalExpr]

theorem seq_assoc (s1 s2 s3 : State → State) :
    seq (seq s1 s2) s3 = seq s1 (seq s2 s3) := by
  simp [seq]

theorem seq_denote (s1 s2 : Stmt) :
    ⟦s1; s2⟧ = seq ⟦s1⟧ ⟦s2⟧ := sorry

end UniversalIR [attached_file:1]
