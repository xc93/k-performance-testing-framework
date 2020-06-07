require "substitution.k"

module LAMBDASUBST-SYNTAX

imports INT-SYNTAX
imports BOOL
imports KVAR

syntax Val ::= KVar
             | "lambda" KVar "." Pgm  [binder]
syntax Pgm ::= Val
             | Pgm Pgm                [strict,left]
             | "(" Pgm ")"            [bracket]

syntax Val ::= Int | Bool
syntax Pgm ::= Pgm "*" Pgm            [strict,left]
             | Pgm "/" Pgm            [strict]
             > Pgm "+" Pgm            [strict,left]
             | Pgm "-" Pgm            [strict,left]
             > Pgm "<=" Pgm           [strict]
             | Pgm "=" Pgm            [strict]
                      
syntax Pgm ::= "if" Pgm "then" Pgm "else" Pgm [strict(1)]
             | "mu" KVar "." Pgm              [binder]
             | "let" KVar "=" Pgm "in" Pgm  
             | "let" "rec" KVar KVar "=" Pgm "in" Pgm
             | "let" "rec" KVar KVar KVar "=" Pgm "in" Pgm

rule let X = E in E':Pgm => (lambda X . E') E     [macro]
rule let rec F:KVar X = E in E' 
  => let F = mu F . lambda X . E in E'            [macro]
rule let rec F:KVar X Y = E in E'
  => let F = mu F . lambda X . lambda Y . E in E' [macro]
  
endmodule

module LAMBDASUBST

imports LAMBDASUBST-SYNTAX
imports SUBSTITUTION

configuration <T> <k> $PGM:Pgm </k> </T>
syntax KResult ::= Val

rule (lambda X:KVar . E:Pgm) V:Val => E[V / X]
rule I1 * I2 => I1 *Int I2
rule I1 / I2 => I1 /Int I2
rule I1 + I2 => I1 +Int I2
rule I1 - I2 => I1 -Int I2
rule I1 <= I2 => I1 <=Int I2
rule I1 = I2 => I1 ==Int I2
rule if true  then E else _ => E
rule if false then _ else E => E
rule mu X . E => E[(mu X . E) / X]

endmodule
