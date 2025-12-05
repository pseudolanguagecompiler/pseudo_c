import Ast.Base

namespace UniversalIR

inductive BinOp where
  | add | sub | gt
deriving Repr, BEq

inductive Expr where
  | var (name : String)
  | num (n : Nat)
  | binOp (op : BinOp) (left right : Expr)
deriving Repr, BEq

inductive Stmt where
  | set (var : String) (expr : Expr)
  | print (expr : Expr)
  | while (cond : Expr) (body : List Stmt)
deriving Repr, BEq

abbrev State := String → Option Nat

-- Notation: ⟦expr⟧ s = evaluation in state s
notation:50 "⟦" e:51 "⟧" s:52 => denoteExpr e s
notation:50 "⟦" S:51 "⟧" => denoteStmt S

-- Expression evaluation: always returns Nat (bool as 0/1)
def denoteExpr : Expr → State → Nat
  | .var x, s => s x |>.getD 0
  | .num n, _ => n
  | .binOp .add l r, s => denoteExpr l s + denoteExpr r s
  | .binOp .sub l r, s => denoteExpr l s - denoteExpr r s
  | .binOp .gt l r, s => if denoteExpr l s > denoteExpr r s then 1 else 0

-- Statement denotation: State → State (pure math functions)
def denoteStmt : Stmt → (State → State)
  | .set x e, s => fun y => if y == x then some (denoteExpr e s) else s y
  | .print e, s => 
    unsafe do
      IO.println s!"{denoteExpr e s}"
      pure s
  | .while cond body, s => 
    let bodyComp := body.foldl (init := id) fun acc stmt => acc ∘ denoteStmt stmt
    fixpoint (fun w σ => if denoteExpr cond σ ≠ 0 then w (bodyComp σ) else σ) s

-- Fixed-point combinator for while loops
def fixpoint {α : Type} (f : (α → α) → α → α) (a : α) : α := 
  let rec iter (fuel : Nat) : α → α := fun x => 
    if fuel = 0 then x else iter (fuel - 1) (f (iter (fuel - 1)) x)
  iter 1000 a

-- Sequential composition
def seq (s1 s2 : State → State) : State → State := s1 ∘ s2

-- Execute program: List Stmt → State → State (pure)
def execProgram (stmts : List Stmt) (init : State) : State :=
  stmts.foldl (init := id) (· ∘ denoteStmt) init | init

-- IO version for Main.lean
def execProgramIO (stmts : List Stmt) (init : State) : IO Unit := do
  let final := execProgram stmts init
  IO.println s!"Program executed. Final state function: {final}"

end UniversalIR
