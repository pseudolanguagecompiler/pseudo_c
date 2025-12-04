import Parser
import Ast
import ParserImpl
import Semantics
import Codegen

def main (args : List String) : IO UInt32 := do
  if args.size != 1 then
    IO.println "usage: lake exe pseudocode_compiler <file.pseudo>"
    return 1
  let input ← IO.FS.readFile args.head!
  match ParserImpl.parseProgram input with
  | .error msg => 
    IO.println s!"Parse error: {msg}"
    return 1
  | .ok ast =>
    let result ← Semantics.evalProgram ast (λ_ => none)
    IO.println s!"Execution result: {result}"
    let leanCode ← Codegen.toLean ast
    IO.println "\n=== Generated Lean 4 code ==="
    IO.println leanCode
    return 0
