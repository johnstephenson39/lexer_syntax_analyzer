class Lexer
  
  # all the symbols used for the lexer to turn text into symbols
  INTEGER = 1
  SEMI = 2
  EQUAL = 3
  IF = 4
  THEN = 5
  ENDD = 6
  ELSE = 7
  FOR = 8
  FROM = 9
  TO = 10
  DO = 11
  BY = 12
  PLUS = 13
  MINUS = 14
  TIMES = 15
  DIV = 16
  LPAREN = 17
  RPAREN = 18
  AND = 19
  NOT = 20
  TRUEE = 21
  FALSEE = 22
  LESSEQUAL = 23
  LESSTHAN = 24
  EQUALEQUAL = 25
  IDENTIFIER = 26
  EOF = 27
  DEF = 28
  OR = 29
  COMMENT = 30
  BADIDENTIFIER = 31
  KEYWORD = Hash[ "not" => NOT, 
                  "for" => FOR, 
                  "if" => IF,
                  "else" => ELSE,
                  "then" => THEN,
                  "end" => ENDD,
                  "to" => TO,
                  "and" => AND,
                  "do" => DO,
                  "true" => TRUEE,
                  "false" => FALSEE,
                  ":=" => EQUAL,
                  "//" => COMMENT,
                  ";" => SEMI,
                  "def" => DEF,
                  "or" => OR,
                  "=" => EQUALEQUAL,
                  "from" => FROM,
                  "by" => BY,
                  "<=" => LESSEQUAL,
                  "<" => LESSTHAN]
  OPERATOR = Hash[ "+" => PLUS, 
                    "-" => MINUS, 
                    "*" => TIMES,
                    "/" => DIV,
                    "(" => LPAREN,
                    ")" => RPAREN]
  # initialization for the lexer, count is the line number
  def initialize(filename, count)  
    @filename = filename
    @count = count
    @LINES = Hash[]
    f = File.open(filename)
    # gets how many lines are in the file
    @lineCount = f.readlines.size
    # can't initialize the lexer if the line provided is out of range of the number of lines in the file
    if @count > @lineCount
      return
    end
    f = File.open(filename)
    # splits out all the comments in the file
    @temp = f.read.split(/(\/\/.*)/)
    # removes the comments from the lexer
    @temp = @temp.reject { |c| c.include?("//") }
    @temp = @temp.join(" ")
    # puts each line in a hash table with the appropriate line number
    @temp.split("\n").each_with_index do |line, index|
       @LINES.store(index+1, line.split(" "))
    end
    @arr = @LINES[@count].join(" ")
    f = File.open(filename)
    # splits out the rest of the important tokens
    @tokens = @arr.split(/\s*(:=)\s*|\s*(;)\s*|\s*(\+)\s*|\s*(\<=)\s*|\s*(\<)\s*|\s*(\=)\s*|\s*(\/\/.*)|\s*(\/)\s*|\s*(\()\s*|\s*(\))\s*|\s*(\*)\s*|\s*(\-)\s*|\s/)
    @tokensize = @tokens.size
    @index = 0
    @idx = 0
    # if the line used to initialize the lexer is the same as the total number of lines, then EOF is added to the end of the file
    if @count == @lineCount
      @tokens[@tokensize] = "EOF"
    end
    # symbols contains the numerical representations of the tokens, excluding empty lines/strings and comments
    @symbols = Array.new
    @tokens = @tokens.reject { |c| c.empty? }
    @tokens = @tokens.reject { |c| c.include?("//")}
    
      # fills the symbols array according the to tokens parsed
   for i in @tokens
     getTokenKind()
     nextToken()
   end
      
  end
  
  def getTokenKind()
    
    # check for integers
    if getTokenText() !~ /\D/ 
      @symbols[@index] = INTEGER
        return INTEGER
    end
    
    # check for keywords
    if KEYWORD[getTokenText()]
        @symbols[@index] = KEYWORD[getTokenText()]
         return KEYWORD[getTokenText()]
    end
    
    # check for operators
    if OPERATOR[getTokenText()]
        @symbols[@index] = OPERATOR[getTokenText()]
         return OPERATOR[getTokenText()]
    end
    
    # check for EOF
    if getTokenText() == "EOF"
      @symbols[@index] = EOF
      return EOF
    end
    
    # check for legal identifiers
    if getTokenText().is_a?(String) and getTokenText()[0] =~ /[A-Za-z]/
        @symbols[@index] = IDENTIFIER
        return IDENTIFIER
    end
    
    # check for illegal identifiers
    if getTokenText().is_a?(String) and getTokenText()[0] !~ /[A-Za-z]/
        @symbols[@index] = BADIDENTIFIER
        return BADIDENTIFIER
    end
    
    
  end
  
  # all of these methods are pretty self explanatory, and were used to access attributes of the lexer
 def getTokenText()
     return @tokens[@index]
 end
   
 def nextSymbol()
    @idx += 1
 end
 
 def getCount()
   return @count
 end
 
 def nextToken()
   @index +=1
 end
 
 def getSymbols()
  return @symbols
 end
 
 def getLineCount()
   return @lineCount
 end
 
def getSymbol()
 return @symbols[@idx]
end

def getPrevSymbol()
 return @symbols[@idx-1]
end

def getNextSymbol()
  return @symbols[@idx+1]
end

def getLines()
  return @LINES
end

def getIdx()
  return @idx
end
 
end