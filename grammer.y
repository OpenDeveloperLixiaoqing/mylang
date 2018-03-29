%token STRING ID INT_NUM FLOAT_NUM TRUE FLASE
%token POINTER
%token IF ELSE WHILE FOR BREAK CONTINUE RETURN DELETE TRY CATCH THROW
%token CLASS FUNCTION LAMBDA CONSTRUCTOR DESTRUCTOR
%token ABSTRACT PUBLIC CONST INLINE STATIC DECLARE
%token ADD_ASGN SUB_ASGN MUL_ASGN DIV_ASGN MOD_ASGN AUTO
%token EQUAL NOT_EQ GT_EQ LT_EQ

%nonassoc IFX
%nonassoc ELSE

%right '='
%left '+' '-'
%left '*' '/'


%%
program: /*empty*/
	|program program_item
	;

program_item: function
	|clas
	;

function: FUNCTION ID fun_type ';'
	|modifier_list FUNCTION ID fun_type ';'
	;

clas: CLASS ID '{' clas_item_list '}'
	|modifier_list CLASS ID '{' clas_item_list '}'
	|CLASS ID ':' parent_list '{' clas_item_list '}'
	|modifier_list CLASS ID ':' parent_list '{' clas_item_list '}'
	;

parent_list: ID
	|parent_list ',' ID	
	;

clas_item_list: /*empty*/
	|clas_item_list clas_item
	;

clas_item: var_decl
	|fun_decl
	|constructor
	|destructor
	;

var_decl: var ';'
	|modifier_list var ';'
	|var '=' expr ';'
	|modifier_list var '=' expr ';'
	|var '=' auto_obj_expr ';'
	|modifier_list var '=' auto_obj_expr ';'
	;

var: ID ':' ID
	;

modifier_list: modifier
	|modifier_list modifier
	;

modifier: PUBLIC
	|STATIC
	;

fun_decl: ID fun_type ';'
	|modifier_list ID fun_type ';'
	|ID fun_type block_stat
	|modifier_list ID fun_type block_stat
	;

fun_type: '(' ')' ':' ID
	|'(' var_list ')' ':' ID
	;

var_list: var
	|var_list ',' var
	;

constructor: CONSTRUCTOR constructor_type ';'
	|CONSTRUCTOR constructor_type block_stat
	;

constructor_type: '(' ')'
	|'(' var_list ')'
	;

destructor: DESTRUCTOR '(' ')' ';'
	|DESTRUCTOR '(' ')' block_stat
	;

stat: block_stat
	|if_stat
	|while_stat
	|for_stat
	|expr_stat
	|continue_stat
	|break_stat
	|return_stat
	|try_stat
	|catch_stat
	|throw_stat
	;

block_stat: '{' block_item_list '}'
	;

block_item_list: /*empty*/
	|block_item_list block_item
	;

block_item: var_decl
	|stat
	;

if_stat: IF '(' expr ')' stat %prec IFX
	|IF '(' expr ')' stat ELSE stat
	;

while_stat: WHILE '(' expr ')' stat
	;

for_stat: FOR '(' expr ',' expr ',' expr ')' stat
	;

expr_stat: expr ';'
	;

continue_stat: CONTINUE ';'
	;

break_stat: BREAK ';'
	;

return_stat: RETURN ';'
	|RETURN expr ';'
	;

try_stat: TRY block_stat
	;

catch_stat: CATCH '(' var ')' block_stat
	;

throw_stat: THROW expr ';'
	;

expr: unary_expr
	|expr '+' expr
	|expr '-' expr
	|expr '*' expr
	|expr '/' expr
	|expr '=' expr
	;

unary_expr: post_expr
	|'!' unary_expr
	|'~' unary_expr
	|'-' unary_expr
	;

post_expr: prim_expr
	|post_expr POINTER ID
	|post_expr '.' ID
	|post_expr '(' ')'
	|post_expr '(' expr_list ')'
	;

prim_expr: STRING
	|ID
	|INT_NUM
	|FLOAT_NUM
	|TRUE
	|FLASE
	|lambda
	|'(' expr ')'
	;

lambda: LAMBDA fun_type block_stat 
	;

auto_obj_expr: AUTO expr
	;

expr_list: expr
	|expr_list ',' expr
	;

