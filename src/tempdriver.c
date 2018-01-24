// /////////////////////////////////////////////////////////////////
// Filename: tempdriver.c
// Description: Temporary Driver used for Part I in lieu of parser
// Date: 2018/01/24 -- ZDH
// /////////////////////////////////////////////////////////////////

#include "token.h"
#include <stdio.h>

// Variables from lex.yy.c
extern void printStrTable();
extern int yylex();
extern int yyline, yycolumn, yylval;

// Wrapper
int yywrap() {
	return 1;
}

// Boolean type definition
typedef enum {false, true} bool;

int main (void) {

	bool file_end = false;		// End of File flag

	printf("Line\tColumn\tToken\t\t    Index_in_String\n");

	// Until End of File ...
	while (!file_end) {
		// Get Token
		switch (yylex()) {
			case LPARENnum:
				printf("%d\t%d\tLPARENnum\n", yyline, yycolumn);
				break;
			case RPARENnum:
				printf("%d\t%d\tRPARENnum\n", yyline, yycolumn);
				break;
			case PLUSnum:
				printf("%d\t%d\tPLUSnum\n", yyline, yycolumn);
				break;
			case DOTnum:
				printf("%d\t%d\tDOTnum\n", yyline, yycolumn);
				break;
			case SEMInum:
				printf("%d\t%d\tSEMInum\n", yyline, yycolumn);
				break;
			case LTnum:
				printf("%d\t%d\tLTnum\n", yyline, yycolumn);
				break;
			case EQUALnum:
				printf("%d\t%d\tEQUALnum\n", yyline, yycolumn);
				break;
			case LBRACEnum:
				printf("%d\t%d\tLBRACEnum\n", yyline, yycolumn);
				break;
			case RBRACEnum:
				printf("%d\t%d\tRBRACEnum\n", yyline, yycolumn);
				break;
			case DECLARATIONnum:
				printf("%d\t%d\tDECLARATIONSnum\n", yyline, yycolumn);
				break;
			case ENDDECLARATIONSnum:
				printf("%d\t%d\tENDDECLARATIONSnum\n", yyline, yycolumn);
				break;
			case METHODnum:
				printf("%d\t%d\tMETHODnum\n", yyline, yycolumn);
				break;
			case PROGRAMnum:
				printf("%d\t%d\tPROGRAMnum\n", yyline, yycolumn);
				break;
			case VALnum:
				printf("%d\t%d\tVALnum\n", yyline, yycolumn);
				break;
			case WHILEnum:
				printf("%d\t%d\tWHILEnum\n", yyline, yycolumn);
				break;
			case CLASSnum:
				printf("%d\t%d\tCLASSnum\n", yyline, yycolumn);
				break;
			case ELSEnum:
				printf("%d\t%d\tELSEnum\n", yyline, yycolumn);
				break;
			case IFnum:
				printf("%d\t%d\tIFnum\n", yyline, yycolumn);
				break;
			case RETURNnum:
				printf("%d\t%d\tRETURNnum\n", yyline, yycolumn);
				break;
			case VOIDnum:
				printf("%d\t%d\tVOIDnum\n", yyline, yycolumn);
				break;
			case INTnum:
				printf("%d\t%d\tINTnum\n", yyline, yycolumn);
				break;
			case ASSGNnum:
				printf("%d\t%d\tASSGNnum\n", yyline, yycolumn);
				break;
			case ICONSTnum:
				printf("%d\t%d\tICONSTnum\n", yyline, yycolumn);
				break;
			case SCONSTnum:
				printf("%d\t%d\tSCONSTnum\t    %d\n", yyline, yycolumn, yylval);
				break;
			case IDnum:
				printf("%d\t%d\tIDnum\t\t    %d\n", yyline, yycolumn, yylval);
				break;
			case EOFnum:
				printf("%d\t%d\tEOFnum\n\n", yyline, yycolumn);
				file_end = true;
				printStrTable();
				printf("\n");
				break;
			default:
				break;
		}
	}

	return 0;
}
