%{
#include "token.h"
#include <string.h>

#define STR_TBLE_ROWS 500
#define STR_TBLE_COLS 4096

char stringTable[STR_TBLE_ROWS][STR_TBLE_COLS];
void upper2lower (char*);
int addStrTable(char*);
void printStrTable();
void ReportError(int, int, int, char*);

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
		ReportError(ERR_COMMENT, start_line, yycolumn, NULL);
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
	ReportError(ERR_COMMENT, yyline, yycolumn, NULL);
	// Return value for consistency
	return OTHERS;
}

declarations { /* RULE FOR DECLARATIONS KEYWORD */
	// update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return DECLARATIONnum;
}

enddeclarations { /* RULE FOR ENDDECLARATIONS KEYWORD */
	// update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return ENDDECLARATIONSnum;
}

method { /* RULE FOR METHOD KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return METHODnum;
}

program { /* RULE FOR PROGRAM KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return PROGRAMnum;
}

val { /* RULE FOR VAL KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return VALnum;
}

while { /* RULE FOR WHILE KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return WHILEnum;
}

class { /* RULE FOR CLASS KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return CLASSnum;
}

else { /* RULE FOR ELSE KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return ELSEnum;
}

if { /* RULE FOR IF KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return IFnum;
}

return { /* RULE FOR RETURN KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return RETURNnum;
}

void { /* RULE FOR VOID KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return VOIDnum;
}

int { /* RULE FOR INT KEYWORD */
	// Update column by length of keyword
	yycolumn += strlen(yytext);
	// Return token value
	return INTnum;
}

";" { /* RULE FOR SEMICOLON */
	// Increment column by 1
	++yycolumn;
	// Return token value
	return SEMInum;
}

"{" { /* RULE FOR LEFT BRACE */
	// Increment column by 1
	++yycolumn;
	// Return token value
	return LBRACEnum;
}

"}" { /* RULE FOR RIGHT BRACE */
	// Increment column by 1
	++yycolumn;
	// Return token value
	return RBRACEnum;
}

"(" { /* RULE FOR LEFT PARENTHESIS */
	// Increment column by 1
	++yycolumn;
	// Return token value
	return LPARENnum;
}

")" { /* RULE FOR RIGHT PARENTHESIS */
	// Increment column by 1
	++yycolumn;
	// Return token value
	return RPARENnum;
}

"." { /* RULE FOR DOT */
	// Increment column by 1
	++yycolumn;
	// Return token value
	return DOTnum;
}

"=" { /* RULE FOR EQUAL SIGN */
	// Increment column by 1
	yycolumn++;
	// Return token value
	return EQUALnum;
}

":=" { /* RULE FOR ASSIGN */
	// Increment column by 2
	yycolumn = yycolumn + 2;
	// Return token value
	return ASSGNnum;
}

"<" { /* RULE FOR LESS THAN */
	// Increment column by 1
	++yycolumn;
	// Return token value
	return LTnum;
}

"+" { /* RULE FOR PLUS */
	// Increment column by 1
	++yycolumn;
	// Return token value
	return PLUSnum;
}

{digit}+ { /* RULE FOR INTEGER CONSTANT */
	// Convert input to int
	yylval = atoi(yytext);
	// Update column with number of digits
	yycolumn += strlen(yytext);
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
		ReportError(ERR_STRING, yyline, start_string, NULL);
		// Place \n back on yytext
		unput(curr_c);
		// return for consistency
		return OTHERS;
	}
	// Good String
	else {
		// Add to string table
		yylval = addStrTable(str_buff);
		// return token value
		return SCONSTnum;
	}
}
	
[a-zA-Z][a-zA-Z0-9]* { /* RULE FOR IDENTIFIER */
	char * intext;		// Pointer to character string

	// Allocate space for identifier
	intext = (char *) calloc(strlen(yytext) + 1, sizeof(char));

	// Copy identifier
	strcpy(intext, yytext);

	// Convert to lowercase
	upper2lower(intext);

	// Update column by length of identifier
	yycolumn += strlen(intext);
	// Add identifier to string table
	yylval = addStrTable(intext);

	// Deallocate
	free(intext);

	// Return token value
	return IDnum;
}

[0-9]+[a-zA-Z]+[a-zA-Z0-9]* { /* RULE FOR BAD IDENTIFIER */
	// Raise Malformed ID Error
	ReportError(ERR_ID, yyline, yycolumn, yytext);
	// Update column for length of bad identifier
	yycolumn += strlen(yytext);
	// return for consistency
	return OTHERS;
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

<<EOF>> { /* RULE FOR END OF FILE */
	// Return token value
	return EOFnum;
}

. { /* RULE FOR ANY UNMATCHED SYMBOL */
	// Raise Undefined Symbol Error
	ReportError(ERR_SYMBOL, yyline, yycolumn, yytext);
	// Update column for length of symbol
	yycolumn += strlen(yytext);
	// return for consistency
	return OTHERS;
}

%%

/* CONVERT STRING TO ALL LOWERCASE */
void upper2lower (char * instring) {

	int i;		// Counting Variable

	// For all characters in string...
	for (i = 0; i < strlen(instring); ++i) {
		if (instring[i] >= 'A' && instring[i] <= 'Z') instring[i] = instring[i] + 'a' - 'A';
	}

	return;
}

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
void ReportError(int err_num, int e_line, int e_column, char * in_string) {

	// Get Error
	switch (err_num) {
		case ERR_COMMENT:
			printf("Error: Unmatched comment, at line %d column %d\n", e_line, e_column);
			break;
		case ERR_ID:
			printf("Error: Malformed identifier '%s', at line %d column %d\n", in_string, e_line, e_column);
			break;
		case ERR_STRING:
			printf("Error: Unmatched string constant, at line %d column %d\n", e_line, e_column);
			break;
		case ERR_SYMBOL:
			printf("Error: Undefined symbol '%s', at line %d column %d\n", in_string, e_line, e_column);
			break;
		default:
			break;
	}

	return;
}
