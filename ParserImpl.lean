import Parser
import Ast

def pID : Parser String := letter *> (letter <|> digit)* |>.map String.ofList
def pNumber : Parser Expr := nat.map Expr.num
def pExpr : Parser Expr := sorry -- implement recursive expr parser
def pStatement : Parser Stmt := sorry -- implement from README
def pProgram : Parser (List Stmt) := many pStatement

def parseProgram (input : String) : Except String (List Stmt) := 
  Parser.runParser pProgram input |>.toExcept (λe => s!"Parse error at {e}")
