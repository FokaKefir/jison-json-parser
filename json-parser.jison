%lex
%%
\s+                     /* Skip whitespace */
"{"                     return '{';
"}"                     return '}';
"["                     return '[';
"]"                     return ']';
":"                     return ':';
","                     return ',';
\"([^"]*)\"             return 'STRING';  // Match double-quoted strings
[-]?[0-9]+(\.[0-9]+)?   return 'NUMBER';  // Match numbers, with optional negative sign
true|false              return 'BOOLEAN'; // Match true/false
null                    return 'NULL';    // Match null
<<EOF>>                 return 'EOF';     // Match end of file
.                       return 'INVALID'; // Catch all other characters
/lex

%start json

%%

json
    : object EOF           { return $1; } 
    | array EOF            { return $1; } 
    ;

object
    : '{' '}'              { $$ = {}; }
    | '{' members '}'      { $$ = $2; }
    ;

members
    : pair                 { $$ = {}; $$[$1[0]] = $1[1]; }
    | members ',' pair     { $$ = $1; $$[$3[0]] = $3[1]; }
    ;

pair
    : 'STRING' ':' value   { $$ = [$1.slice(1, -1), $3]; } // Strip quotes from key only
    ;

array
    : '[' ']'              { $$ = []; }
    | '[' elements ']'     { $$ = $2; }
    ;

elements
    : value                { $$ = [$1]; }
    | elements ',' value   { $$ = $1; $1.push($3); }
    ;

value
    : 'STRING'             { $$ = $1.slice(1, -1); }  // Preserve quotes for string values
    | 'NUMBER'             { $$ = parseFloat(yytext); }
    | 'BOOLEAN'            { $$ = (yytext === "true"); }
    | 'NULL'               { $$ = null; }
    | object               { $$ = $1; }
    | array                { $$ = $1; }
    ;
