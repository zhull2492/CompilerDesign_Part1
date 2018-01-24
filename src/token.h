// ////////////////////////////////////////////////////
// Filename: token.h
// Description: Token values used by lexer and parser
// Date: 2018/01/24 -- ZDH
// ////////////////////////////////////////////////////

// SINGLE CHARACTERS
#define LPARENnum '('
#define RPARENnum ')'
#define PLUSnum '+'
#define DOTnum '.'
#define SEMInum ';'
#define LTnum '<'
#define EQUALnum '='
#define LBRACEnum '{'
#define RBRACEnum '}'

// WORDS
#define DECLARATIONnum 257
#define ENDDECLARATIONSnum 258
#define METHODnum 259
#define PROGRAMnum 260
#define VALnum 261
#define WHILEnum 262
#define CLASSnum 263
#define ELSEnum 264
#define IFnum 265
#define RETURNnum 266
#define VOIDnum 267
#define INTnum 268
#define ASSGNnum 269 
#define ICONSTnum 270
#define SCONSTnum 271
#define IDnum 272
#define EOFnum 0

// OTHERS
#define OTHERS 300

// ERRORS
#define ERR_COMMENT 1
#define ERR_ID      2
#define ERR_STRING  3
#define ERR_SYMBOL  4
