%{
#include "token.h"
#include <string.h>

#define STR_TBLE_ROWS 500
#define STR_TBLE_COLS 4096

char stringTable[STR_TBLE_ROWS][STR_TBLE_COLS];
int addStrTable(char*);
void printStrTable();
void ReportError(char*, int, int);

int yyline = 1, yycolumn = 1;
int yylval;
int curr_str_row = 0;

%}

newline \n
indent \t
digit [0-9]

%%

"/*" { /* RULE FOR COMMENT */
	int start_line = yyline;	// Line comment starts
	char curr_c, next_c;		// Characters consumed

	// get the next two (2) characters in input
	curr_c = input();		
	next_c = input();

	// While still reading a comment...
	while (1) {
		// Search for end of comment marker
		if (curr_c == '*' && next_c == '/') break;
		// Comment continues to next line...
		else if (curr_c == '\n') {
			yyline++;
		}
		// End of string
		else if (curr_c == '\0') break;

		// Advance character and read next character
		curr_c = next_c;
		next_c = input();
	}
	// End of File Marker or End of String -- NO COMMENT END
	if (next_c == EOF || next_c == '\0') {
		// Report Unmatched Comment
		ReportError("Unmatched comment", start_line, yycolumn);
		// Reset yycolumn
		yycolumn = 1;
	}
	
	// Return value for consistency
	return OTHERS;
}

"*/" { /* RULE FOR END COMMENT MARK ERROR */
	// Consumed two (2) characters
	yycolumn += 2;
	// Report Unmatched Comment
	ReportError("Unmatched comment", yyline, yycolumn);
	// Return value for consistency
	return OTHERS;
}

declarations { /* RULE FOR DECLARATIONS KEYWORD */
	// update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tDECLARATIONSnum\n", yyline, yycolumn);
	// Return token value
	return DECLARATIONnum;
}

enddeclarations { /* RULE FOR ENDDECLARATIONS KEYWORD */
	// update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tENDDECLARATIONSnum\n", yyline, yycolumn);
	// Return token value
	return ENDDECLARATIONSnum;
}

method { /* RULE FOR METHOD KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tMETHODnum\n", yyline, yycolumn);
	// Return token value
	return METHODnum;
}

program { /* RULE FOR PROGRAM KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tPROGRAMnum\n", yyline, yycolumn);
	// Return token value
	return PROGRAMnum;
}

val { /* RULE FOR VAL KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tVALnum\n", yyline, yycolumn);
	// Return token value
	return VALnum;
}

while { /* RULE FOR WHILE KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tWHILEnum\n", yyline, yycolumn);
	// Return token value
	return WHILEnum;
}

class { /* RULE FOR CLASS KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tCLASSnum\n", yyline, yycolumn);
	// Return token value
	return CLASSnum;
}

else { /* RULE FOR ELSE KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tELSEnum\n", yyline, yycolumn);
	// Return token value
	return ELSEnum;
}

if { /* RULE FOR IF KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tIFnum\n", yyline, yycolumn);
	// Return token value
	return IFnum;
}

return { /* RULE FOR RETURN KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tRETURNnum\n", yyline, yycolumn);
	// Return token value
	return RETURNnum;
}

void { /* RULE FOR VOID KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tVOIDnum\n", yyline, yycolumn);
	// Return token value
	return VOIDnum;
}

int { /* RULE FOR INT KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	printf("%d\t%d\tINTnum\n", yyline, yycolumn);
	// Return token value
	return INTnum;
}

[a-zA-Z][a-zA-Z0-9]* { /* RULE FOR IDENTIFIER */
	char * intext;		// Pointer to character string

	// Allocate space for identifier
	intext = (char *) calloc(strlen(yytext) + 1, sizeof(char));

	// Copy identifier
	strcpy(intext, yytext);

	// Update column by length of identifier
	yycolumn += strlen(intext);
	// Add identifier to string table
	yylval = addStrTable(intext);

	printf("%d\t%d\tIDnum\t\t    %d\n", yyline, yycolumn, yylval);

	// Deallocate
	free(intext);

	// Return token value
	return IDnum;
}

[0-9]+[a-zA-Z]+[a-zA-Z0-9]* { /* RULE FOR BAD IDENTIFIER */
	char * str_buff;
	int str_len = strlen(yytext) + 2 + 1 + strlen("Malformed identifier");
	str_buff = (char *) calloc(str_len + 1, sizeof(char));
	strcpy(str_buff, "Malformed identifier '");
	strcat(str_buff, yytext);
	strcat(str_buff, "'");
	// Raise Malformed ID Error
	ReportError(str_buff, yyline, yycolumn);
	// Update column for length of bad identifier
	yycolumn += strlen(yytext);
	// Free Memory
	free(str_buff);
	// return for consistency
	return OTHERS;
}

{digit}+ { /* RULE FOR INTEGER CONSTANT */
	// Convert input to int
	yylval = atoi(yytext);
	// Update column with number of digits
	yycolumn += strlen(yytext);
	printf("%d\t%d\tICONSTnum\t    %d\n", yyline, yycolumn, yylval);
	// Return token value
	return ICONSTnum;
}

"'" { /* RULE FOR STRING CONSTANT */
	char curr_c = input();		// Current character on input
	char str_buff[STR_TBLE_COLS];	// Buffer Variable
	int i = 0;			// Counting Variable
	int start_string = yycolumn;	// Starting Character of String

	// Increment column for ' character
	yycolumn++;

	// While Reading in String
	while (curr_c != '\n') {
		// Increment column for each character
		yycolumn++;
		// Check if escape sequence
		if (curr_c == '\\') {
			// Increment column
			yycolumn++;
			// get next character
			char next_c = input();
			// Determine Escape Sequence
			switch(next_c) {
				// NewLine
				case 'n':
					str_buff[i++] = '\n';
					break;
				// Tab
				case 't':
					str_buff[i++] = '\t';
					break;
				// BackSlash
				case '\'':
					str_buff[i++] = '\'';
					break;
				// Single Quote
				case '\\':
					str_buff[i++] = '\\';
					break;
				default:
					break;
			}
		}
		// End of String
		else if (curr_c == '\'') {
			str_buff[i++] = '\0';
			break;
		}
		// Add character to buffer and continue
		else str_buff[i++] = curr_c;
		curr_c = input();
	}
	// String never ends...
	if (curr_c == '\n') {
		// Raise Unending String Error
		ReportError("Unmatched string constant", yyline, start_string);
		// Place \n back on yytext
		unput(curr_c);
		// return for consistency
		return OTHERS;
	}
	// Good String
	else {
		// Add to string table
		yylval = addStrTable(str_buff);
		printf("%d\t%d\tSCONSTnum\t    %d\n", yyline, yycolumn, yylval);
		// return token value
		return SCONSTnum;
	}
}
	
":=" { /* RULE FOR ASSIGN */
	// Increment column by 2
	yycolumn = yycolumn + 2;
	printf("%d\t%d\tASSGNnum\n", yyline, yycolumn);
	// Return token value
	return ASSGNnum;
}

"==" { /* RULE FOR EQUAL (COMPARISON) */
	// Increment column by 2
	yycolumn = yycolumn + 2;
	printf("%d\t%d\tEQnum\n", yyline, yycolumn);
	// Return token value
	return EQnum;
}

"!=" { /* RULE FOR NOT EQUAL */
	// Increment column by 2
	yycolumn = yycolumn + 2;
	printf("%d\t%d\tNEnum\n", yyline, yycolumn);
	// Return token value
	return NEnum;
}

"&&" { /* RULE FOR AND */
	// Increment column by 2
	yycolumn = yycolumn + 2;
	printf("%d\t%d\tANDnum\n", yyline, yycolumn);
	// Return token value
	return ANDnum;
}

"||" { /* RULE FOR OR */
	// Increment column by 2
	yycolumn = yycolumn + 2;
	printf("%d\t%d\tORnum\n", yyline, yycolumn);
	// Return token value
	return ORnum;
}

">=" { /* RULE FOR GREATER THAN OR EQUAL */
	// Increment column by 2
	yycolumn = yycolumn + 2;
	printf("%d\t%d\tGEnum\n", yyline, yycolumn);
	// Return token value
	return GEnum;
}

"<=" { /* RULE FOR LESS THAN OR EQUAL */
	// Increment column by 2
	yycolumn = yycolumn + 2;
	printf("%d\t%d\tLEnum\n", yyline, yycolumn);
	// Return token value
	return LEnum;
}

"!" { /* RULE FOR NOT */
	// Increment column by 1
	yycolumn++;
	printf("%d\t%d\tNOTnum\n", yyline, yycolumn);
	// Return token value
	return NOTnum;
}

"(" { /* RULE FOR LEFT PARENTHESIS */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tLPARENnum\n", yyline, yycolumn);
	// Return token value
	return LPARENnum;
}

")" { /* RULE FOR RIGHT PARENTHESIS */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tRPARENnum\n", yyline, yycolumn);
	// Return token value
	return RPARENnum;
}

"*" { /* RULE FOR TIMES */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tTIMESnum\n", yyline, yycolumn);
	// Return token value
	return TIMESnum;
}

"+" { /* RULE FOR PLUS */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tPLUSnum\n", yyline, yycolumn);
	// Return token value
	return PLUSnum;
}

"," { /* RULE FOR COMMA */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tCOMMAnum\n", yyline, yycolumn);
	// Return token value
	return COMMAnum;
}

"-" { /* RULE FOR MINUS */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tMINUSnum\n", yyline, yycolumn);
	// Return token value
	return MINUSnum;
}

"." { /* RULE FOR DOT */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tDOTnum\n", yyline, yycolumn);
	// Return token value
	return DOTnum;
}

"/" { /* RULE FOR DIVIDE */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tDIVIDEnum\n", yyline, yycolumn);
	// Return token value
	return DIVIDEnum;
}

";" { /* RULE FOR SEMICOLON */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tSEMInum\n", yyline, yycolumn);
	// Return token value
	return SEMInum;
}

"<" { /* RULE FOR LESS THAN */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tLTnum\n", yyline, yycolumn);
	// Return token value
	return LTnum;
}

"=" { /* RULE FOR EQUAL SIGN */
	// Increment column by 1
	yycolumn++;
	printf("%d\t%d\tEQUALnum\n", yyline, yycolumn);
	// Return token value
	return EQUALnum;
}

">" { /* RULE FOR GREATER THAN */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tGTnum\n", yyline, yycolumn);
	// Return token value
	return GTnum;
}

"[" { /* RULE FOR LEFT BRACKET */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tLBRACnum\n", yyline, yycolumn);
	// Return token value
	return LBRACnum;
}

"]" { /* RULE FOR RIGHT BRACKET */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tRBRACnum\n", yyline, yycolumn);
	// Return token value
	return RBRACnum;
}

"{" { /* RULE FOR LEFT BRACE */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tLBRACEnum\n", yyline, yycolumn);
	// Return token value
	return LBRACEnum;
}

"}" { /* RULE FOR RIGHT BRACE */
	// Increment column by 1
	++yycolumn;
	printf("%d\t%d\tRBRACEnum\n", yyline, yycolumn);
	// Return token value
	return RBRACEnum;
}

" " { /* RULE FOR SPACE */
	// Update column
	yycolumn++;
	// Return for consistency
	return OTHERS;
}

{indent} { /* RULE FOR INDENT */
	// Update column
	++yycolumn;
	// Return for consistency
	return OTHERS;
}

{newline} { /* RULE FOR NEW LINE */
	// Increment Line and Reset Column
	yyline++;
	yycolumn = 1;
	// Return for consistency
	return OTHERS;
}

. { /* RULE FOR ANY UNMATCHED SYMBOL */
	char * str_buff;
	int str_len = strlen(yytext) + 2 + 1 + strlen("Undefined symbol");
	str_buff = (char *) calloc(str_len + 1, sizeof(char));
	strcpy(str_buff, "Undefined symbol '");
	strcat(str_buff, yytext);
	strcat(str_buff, "'");
	// Raise Undefined Symbol Error
	ReportError(str_buff, yyline, yycolumn);
	// Update column for length of symbol
	yycolumn += strlen(yytext);
	// Free Memory
	free(str_buff);
	// return for consistency
	return OTHERS;
}

<<EOF>> { /* RULE FOR END OF FILE */
	printf("%d\t%d\tEOFnum\n\n", yyline, yycolumn);
	// Return token value
	return EOFnum;
}

%%

/* ADD STRING TO STRING TABLE */
int addStrTable(char * intext){
	int i = 0;			// Counting Variable
	int search_len = 0;		// Length Searched in String
	int curr_str_pos = 0;		// Current Position
	int in_len = strlen(intext);	// Length of input string

	// Empty String
	if (in_len == 0) {
		// While first index of strings is not NULL...
		while (stringTable[i][0] != '\0') {
			// Accumulate search length
			search_len += strlen(&stringTable[i++][0]) + 1;
		}
	}
	// Non-Empty
	else {
		// Check if string in table
		for (i = 0; i < curr_str_row; ++i) {
			// Match?
			if (!strcmp(&stringTable[i][0], intext)) {
				return search_len;			
			}
			else {
				// Accumulate search length
				search_len += strlen(&stringTable[i][0]) + 1;
			}
		}
	}

	// Copy String to String Table
	strncpy(&stringTable[curr_str_row][0], intext, in_len);
	// Increment current row
	curr_str_row++;

	// Return index of string in table
	return search_len;
}

/* PRINT STRING TABLE */
void printStrTable () {
	int i, j;	// Counting Variables

	printf("String Table : ");

	// For all characters in string table...
	for (j = 0; j <= curr_str_row; ++j) {
		for (i = 0; i <= strlen(&stringTable[j][0]); ++i) {
			if (stringTable[j][i] == 0) printf("%c", ' ');
			else printf("%c", stringTable[j][i]);
		}	
	}
	printf("\n");

	return;
}

/* ERROR REPORTING */
void ReportError(char * in_string, int e_line, int e_column) {

	printf("Error: %s, at line %d column %d\n", in_string, e_line, e_column);

	return;
}
