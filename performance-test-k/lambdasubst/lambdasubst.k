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
syntax KResult ::= Val

syntax Val ::= Int | Bool
syntax Pgm ::= Pgm "*" Pgm            [strict,left]
             | Pgm "/" Pgm            [strict]
             > Pgm "+" Pgm            [strict,left]
             | Pgm "-" Pgm            [strict,left]
             > Pgm "<=" Pgm           [strict]
             | Pgm "=" Pgm            [strict]
             
syntax Pgm ::= "if" Pgm "then" Pgm "else" Pgm [strict(1)]
//syntax Pgm ::= "let" KVar "=" Pgm "in" Pgm    [strict(2)]
//             | "letrec" KVar KVar "=" Pgm "in" Pgm
syntax Pgm ::= "mu" KVar "." Pgm      [binder]
syntax Pgm ::= "callcc" Pgm           [strict]
// syntax Val ::= cc(K)
endmodule

module LAMBDASUBST

imports LAMBDASUBST-SYNTAX
imports SUBSTITUTION

configuration <T> <k> $PGM:Pgm </k> </T>

rule (lambda X:KVar . E:Pgm) V:Val => E[V / X]
rule I1 * I2 => I1 *Int I2
rule I1 / I2 => I1 /Int I2
rule I1 + I2 => I1 +Int I2
rule I1 - I2 => I1 -Int I2
rule I1 <= I2 => I1 <=Int I2
rule I1 = I2 => I1 ==Int I2
rule if true  then E else _ => E
rule if false then _ else E => E
// rule let X = E in E':Pgm => (lambda X . E') E 
// rule letrec F:KVar X = E in E' => let F = mu F . lambda X . E in E' 
rule mu X . E => E[(mu X . E) / X]
// rule <k> (callcc V:Val => V cc(K)) ~> K </k>
// rule <k> cc(K) V ~> _ =>  V ~> K </k>

endmodule
