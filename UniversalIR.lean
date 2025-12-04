-- Ast/UniversalIR.lean a interface on top of various ILs
import Ast.Base

namespace UniversalIR
inductive BinOp where | add | sub | gt
inductive Expr where
  | var : String → Expr
  | num : Nat → Expr
  | binOp : BinOp → Expr → Expr → Expr
inductive Stmt where
  | assign : String → Expr → Stmt
  | print : Expr → Stmt
  | if_ : Expr → List Stmt → List Stmt → Stmt
  | while : Expr → List Stmt → Stmt

abbrev State := String → Option Nat

instance : IR where
  Expr := Expr
  Stmt := Stmt
  stateType := State
  evalExpr := ...
  evalStmt := ...
end UniversalIR
