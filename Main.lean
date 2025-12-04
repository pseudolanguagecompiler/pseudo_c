import Parser.UniversalParser
import Ast.UniversalIR
import Codegen.ToLean

def main (args : List String) : IO UInt32 := do
  if args.size != 1 then
    IO.println "usage: lake exe pseudocode_compiler <file.pseudo>"
    return 1
  
  let input ← IO.FS.readFile args.head!
  IO.println s!"Input: {input}"
  
  match UniversalParser.parseProgram input with
  | .error msg => 
    IO.println s!"Parse error: {msg}"
    return 1
  | .ok ast =>
    IO.println "✓ Parse successful"
    IO.println s!"AST: {ast}"
    
    -- Denotational execution with notation
    let init : UniversalIR.State := λ_ => none
    IO.println s!"⟦program⟧ init = {UniversalIR.execProgram ast init}"
    
    let leanCode ← Codegen.ToLean.fromUniversal ast
    IO.println "\n=== Generated Lean 4 ==="
    IO.println leanCode
    return 0
