import sys
import re

def containsNumber(value):
    for character in value:
        if character.isdigit():
            return True
    return False





# test.prog is the test file included
file = open("test.prog")


keywords = ['for', 'printf' 'assign', 'input', 'get','while','False','else','if','True','and', 'end','or','print']


languageOperators = {'=' : 'operator',
'+' : 'operator',
'-' : 'operator',
'/' : 'operator',
'==' : 'operator',
'%' : 'operator',
'*' : 'operator',
'<' : 'operator',
'>' : 'operator' }

languageOperators_key = languageOperators.keys()


languageSymbols = { ':' : 'colon',
 ';' : 'semi-colon',
  '.' : 'dot',
   ',' : 'comma' }

languageSymbols_key = languageSymbols.keys()

languageSeperations = { '(' : 'languageSeperations',
 ')' : 'languageSeperations',
 ' ':'space' }

langeSeperations_key = languageSeperations.keys()



# Driver program

testfile=file.read()

testprogram = testfile.split("\n")

print("Token \t Lexeme\n")

for line in testprogram:
    tokens = line.split(' ')

    for token in tokens:
        if token in languageOperators_key:
            print(token ," \t ", languageOperators[token])
        elif token in keywords:
            print(token ," \t keywords")
        elif token in languageSymbols_key:
            print (token ," \t ", languageSymbols[token])
        elif token in langeSeperations_key:
            print (token ," \t ", languageSeperations[token])
        else:
            try:
                variable = int(token)
                variable = float(token)
            except ValueError:
                variable = None
            if variable:
                print (token ," \t  real")
            elif token == ' ':
                pass
            else:
                substring = "\""
                if containsNumber(token):
                    print (token ," \t  INT")
                elif isinstance((token), str) and token not in keywords and substring in token:
                    print (token ," \t  string")
                else:
                    print (token ," \t  ID")

"""

import sys

COMMA = 0
EQUAL = 1
LE = 2
LT = 3
ARROW = 4
MINUS = 5
INT = 6
KEYWORD = 7
ID = 8
END_OF_INPUT = 9
ERROR = 10

KEYWORDS = ["get", "print", "sum", "product", "modulo", "divide", "if", "while", "end"]

line = 1

def next_line():
    global line
    line = line + 1

def error(msg):
    return (ERROR, "Error on line " + str(line) + ": " + msg)

def lex_int(input, sign):
    i = 0
    lexeme = ""
    while i < len(input) and input[i].isdigit():
        lexeme = lexeme + input[i]
        i = i + 1
    return ((INT, sign*int(lexeme)), input[i:])

def lookup(lexeme):
    if lexeme in KEYWORDS:
        return (KEYWORD, lexeme)
    else:
        return (ID, lexeme)

def lex_keyword_or_id(input):
    i = 0
    lexeme = ""
    while i < len(input) and (input[i] == "_" or input[i].isalpha() or input[i].isdigit()):
        lexeme = lexeme + input[i]
        i = i + 1
    return (lookup(lexeme), input[i:])

def lex(input):
    i = 0
    while i < len(input) and (input[i].isspace() or input[i] == "/"):
        i = i + 1
        if input[i-1] == "/":
          if i < len(input) and input[i] == "/":
              while i < len(input) and input[i] != "\n":
                  i = i + 1
          else:
              return (error("Unexpected Character '" + input[i] + "'"), input[i:])
        elif input[i-1] == "\n":
            next_line()
    if i >= len(input):
        return ((END_OF_INPUT, None), [])
    if input[i] == ",":
        return ((COMMA,None), input[i+1:])
    elif input[i] == "=":
        return ((EQUAL,None), input[i+1:])
    elif input[i] == "<":
        i = i + 1
        if i < len(input) and input[i] == "=":
            return ((LE,None), input[i+1:])
        else:
            return ((LT,None), input[i:])
    elif input[i] == "-":
        i = i + 1
        if i < len(input) and input[i] == ">":
            return ((ARROW,None), input[i+1:])
        elif input[i].isdigit():
            return lex_int(input[i:], -1)
        else:
            return ((MINUS,None), input[i:])
    elif input[i] == "+":
        i = i + 1
        if i < len(input) and input[i].isdigit():
            return lex_int(input[i:], 1)
        else:
            return (error("Expected Integer after '+'"), input[i:])
    elif input[i].isdigit():
        return lex_int(input[i:], 1)
    elif input[i] == "_" or input[i].isalpha():
        return lex_keyword_or_id(input[i:])

# Driver Progam
#
#input = list(sys.stdin.read())
#
#tmp = lex(input)
#
#while tmp[0][0] != ERROR and tmp[0][0] != END_OF_INPUT:
#    print(tmp[0])
#    tmp = lex(tmp[1])
#print(tmp[0])







"""




