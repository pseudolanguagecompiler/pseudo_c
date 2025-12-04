-- Ast/Base.lean
class IR where
  Expr : Type
  Stmt : Type
  stateType : Type
  evalExpr : Expr → stateType → Nat
  evalStmt : Stmt → stateType → stateType
