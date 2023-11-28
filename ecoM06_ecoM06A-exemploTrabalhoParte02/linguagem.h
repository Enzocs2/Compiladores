#ifndef _LINGUAGEM_H_
#define _LINGUAGEM_H_

/*# warning "Oi!"*/

struct No {
  int token;
  double val;
  char nome[256];

  struct No *esq, *dir, *prox, *lookahead, *lookahead1, *lookahead2;
};

typedef struct No No;

#endif
