code.txt: onde codamos na linguagem
code.txt.c: codigo de saida em c
Arquivo com os tokens lidos: tokens.txt

Comando para compilar no windows: bison -d -t -v parser.y; flex lexer.l; gcc parser.tab.c lista_var.c var_aleatorio.c lex.yy.c
Comando para rodar testar o codigo: a.exe code.txt
Comando para rodar o codigo de saida: gcc code.txt.c

Códigos teste: code.txt code2.txt code3.txt