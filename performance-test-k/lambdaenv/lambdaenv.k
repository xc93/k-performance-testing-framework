module LAMBDAENV-SYNTAX
  imports DOMAINS
  syntax Pgm ::= Id
               | "lambda" Id "." Pgm  
               | Pgm Pgm              [strict, left]
               | "(" Pgm ")"          [bracket]

  syntax Val ::= Int | Bool
  syntax Pgm ::= Pgm "*" Pgm          [strict, left]
               | Pgm "/" Pgm          [strict, left]
               > Pgm "+" Pgm          [strict, left]
               | Pgm "-" Pgm          [strict, left]
               > Pgm "<=" Pgm         [strict, left]
               | Pgm "="  Pgm         [strict, left]
               
  syntax Pgm ::= "if" Pgm "then" Pgm "else" Pgm  [strict(1)]
  syntax Pgm ::= "let" Id "=" Pgm "in" Pgm
  syntax Pgm ::= "let" "rec" Id Id "=" Pgm "in" Pgm
               | "let" "rec" Id Id Id "=" Pgm "in" Pgm
               | "mu" Id "." Pgm      
  syntax Pgm ::= muclosure(Map,Pgm)

  syntax Val ::= closure(Map,Id,Pgm)
  syntax Pgm ::= Val
  
  rule let X = E in E':Pgm => (lambda X . E') E                        [macro]

  rule let rec F:Id X = E in E' => let F = mu F . lambda X . E in E'    [macro]
  rule let rec F:Id X Y = E in E' 
    => let F = mu F . lambda X . lambda Y . E in E'    [macro]


endmodule

module LAMBDAENV-SEMANTICS
  imports syntax LAMBDAENV-SYNTAX
  
  configuration <T>
                  <k> $PGM:Pgm </k>
                  <env> .Map </env>
                  <store> .Map </store>
                </T>
  
  syntax KResult ::= Val

  rule <k> lambda X:Id . E => closure(Rho,X,E) ...</k>
       <env> Rho </env>
    [structural]
  rule <k> closure(Rho,X,E) V:Val => E ~> Rho' ...</k>
       <env> Rho' => Rho[X <- !N] </env>
       <store>... .Map => (!N:Int |-> V) ...</store>
  rule <k> X => V ...</k>
       <env>... X |-> N ...</env>
       <store>... N |-> V ...</store>
  rule <k> _:Val ~> (Rho => .) ...</k> <env> _ => Rho </env>
    [structural]

  rule I1 * I2 => I1 *Int I2
  rule I1 / I2 => I1 /Int I2
  rule I1 + I2 => I1 +Int I2
  rule I1 - I2 => I1 -Int I2
  rule I1 <= I2 => I1 <=Int I2
  rule I1 = I2 => I1 ==Int I2

    
  rule if true  then E else _ => E
  rule if false then _ else E => E


  rule <k> mu X . E => muclosure(Rho[X <- !N], E) ...</k>
       <env> Rho </env>
       <store>... .Map => (!N:Int |-> muclosure(Rho[X <- !N], E)) ...</store>
    [structural]
  rule <k> muclosure(Rho,E) => E ~> Rho' ...</k>
       <env> Rho' => Rho </env>

  // syntax Pgm ::= "callcc" Pgm  [strict]
  // syntax Val ::= cc(Map,K)
  // rule <k> (callcc V:Val => V cc(Rho,K)) ~> K </k> <env> Rho </env>
  // rule <k> cc(Rho,K) V:Val ~> _ =>  V ~> K </k> <env> _ => Rho </env>
endmodule

module LAMBDAENV
  imports LAMBDAENV-SEMANTICS
  imports LAMBDAENV-SYNTAX
endmodule
