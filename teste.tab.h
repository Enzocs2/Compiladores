/* A Bison parser, made by GNU Bison 2.4.2.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2006, 2009-2010 Free Software
   Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ENTRADA = 258,
     ATRIBUICAO = 259,
     SAIDA = 260,
     CONDICIONAL = 261,
     DESVIOCONDICIONAL = 262,
     DESVIOANINHADO = 263,
     LACO = 264,
     MENOR = 265,
     MAIOR = 266,
     NOT = 267,
     NUMEROREAL = 268,
     NUMEROINTEIRO = 269,
     CHARACTERE = 270,
     AND = 271,
     OR = 272,
     PONTOFINAL = 273,
     DOISPONTOS = 274,
     ABREPARENTESES = 275,
     FECHAPARENTESES = 276,
     SOMA = 277,
     SUBTRACAO = 278,
     MULTIPLICACAO = 279,
     DIVISAO = 280,
     MOD = 281,
     INICIOBLOCO = 282,
     FIMBLOCO = 283,
     INICIO = 284,
     INT = 285,
     CHAR = 286,
     REAL = 287,
     ID = 288
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1685 of yacc.c  */
#line 37 "teste.y"

    int inteiro; /* integer value */
    double real; /* symbol table index */
    char caractere;
    variavel var;
    //nodeType nPtr; /* node pointer */



/* Line 1685 of yacc.c  */
#line 94 "teste.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


