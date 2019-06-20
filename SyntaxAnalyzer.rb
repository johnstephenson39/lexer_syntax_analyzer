require_relative "Lexer"

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
  
# initialization for the first file, $time is the current line number
$time = 1
$filename = "file.txt"
$lex = Lexer.new($filename, $time)
$lines = $lex.getLines()
$tmp
$if = false
$for = false
$endif = false
$endfor = false

# re-initializes the lexer to parse the next line
def newLine()
  if $time < $lex.getLineCount()
      $lex = Lexer.new($filename,$time+=1)
  end
end

# with all of the methods below they're very similar to the grammar, but with a few additional checks to ensure accuracy
def program()
  if stmts()
    # these conditionals make sure ifs and fors have a matching 'end' keyword
    if $if == true and $endif == false
      puts "Error on line #{$time}"
      return
    end
    if $if == false and $endif == true
      puts "Error on line #{$time}"
      return
    end
    if $for == true and $endfor == false
      puts "Error on line #{$time}"
      return
    end
    if $for == false and $endfor == true
      puts "Error on line #{$time}"
      return
    end
    if $lex.getSymbol() == EOF
      puts "The file is syntactically correct."
      return
    end
  end
  puts "Error on line #{$time}"
  return
end

def stmts()
  # calls newLine() if the current symbol is nil
  if $lex.getSymbol() == nil
    $tmp = $lex
    newLine()
    if stmts()
      return true
    end
     return false
  end
  if stmt()
    if $lex.getSymbol() == SEMI
      $lex.nextSymbol()
      if stmts()
         return true
      end
      if $lex.getSymbol() == EOF
        if $lex.getPrevSymbol() != SEMI
          return false
        end
        return true
      end
      return true
    end
    return false
  end
  return false
end

def stmt()
  if $lex.getSymbol() == IDENTIFIER
    $lex.nextSymbol()
    if $lex.getSymbol() == EQUAL
      $lex.nextSymbol()
      if addop()
        return true
      end
      return false
    end
    return false
  end
  if $lex.getSymbol() == IF
    $if = !$if
    $lex.nextSymbol()
    if lexpr()
      if $lex.getSymbol() == THEN
        $lex.nextSymbol()
        if stmts()
          if $lex.getSymbol() == ENDD
            $lex.nextSymbol()
              $endif = !$endif
            if $lex.getSymbol() == nil
               newLine()
            end
            return true
          end
            if $lex.getSymbol() == ELSE
            $lex.nextSymbol()
            if stmts()
              if $lex.getSymbol() == ENDD
                $lex.nextSymbol()
                $endif = !$endif
                if $lex.getSymbol() == nil
                  newLine()
                end
                return true
              end
              return false
            end
             return false
          end
           return false
        end
         return false
      end
       return false
    end
     return false
end
           
  if $lex.getSymbol() == FOR
    $for = !$for
    $lex.nextSymbol()
    if $lex.getSymbol() == IDENTIFIER
      $lex.nextSymbol()
      if $lex.getSymbol() == FROM
        $lex.nextSymbol()
        if addop()
          if $lex.getSymbol() == TO
            $lex.nextSymbol()
            if addop()
              if $lex.getSymbol() == DO
                $lex.nextSymbol()
                if stmts()
                  if $lex.getSymbol() == ENDD
                    $lex.nextSymbol()
                      $endfor = !$endfor
                    if $lex.getSymbol() == nil
                      newLine()
                    end
                    return true
                  end 
                  return false
                end
                return false
              end
                  if $lex.getSymbol() == BY
                     $lex.nextSymbol()
                    if addop()
                      if $lex.getSymbol() == DO
                        $lex.nextSymbol()
                          if stmts()
                            if $lex.getSymbol() == ENDD
                              $lex.nextSymbol()
                                $endfor = !$endfor
                                  if $lex.getSymbol() == nil
                                    newLine()
                                  end
                               return true
                            end
                            return false
                          end
                          return false
                        end
                      return false
                     end
                     return false
                   end
                  return false
                end
              return false
             end
            return false
           end
           return false
          end
          return false
        end
        return false
     end
   return false
end

def addop()
  if mulop()
    if $lex.getSymbol() == PLUS or $lex.getSymbol == MINUS
      $lex.nextSymbol()
      if addop()
        return true
      end
    end
    return true
  end
end

def mulop()
  if factor()
    if $lex.getSymbol() == TIMES or $lex.getSymbol() == DIV
      $lex.nextSymbol()
      if mulop()
        return true
      end
    end
    return true
  end
end

def factor()
  if $lex.getSymbol() == INTEGER or $lex.getSymbol() == IDENTIFIER
    $lex.nextSymbol()
    return true
  end
  if $lex.getSymbol() == LPAREN
    $lex.nextSymbol()
    if addop()
      if $lex.getSymbol() == RPAREN
        $lex.nextSymbol()
        return true
      end
    end
  end
end

def lexpr()
  if lterm()
    if $lex.getSymbol() == AND
      $lex.nextSymbol()
      if lexpr()
        return true
      end
    end
    return true
  end
end

def lterm()
  if $lex.getSymbol() == NOT
    $lex.nextSymbol()
    if lfactor()
      return true
    end
  end
  if lfactor()
    return true
  end
end

def lfactor()
  if $lex.getSymbol() == TRUEE or $lex.getSymbol() == FALSEE
    $lex.nextSymbol()
    return true
  end
  if relop()
    return true
  end
end

def relop()
  if addop()
    if $lex.getSymbol() == LESSEQUAL or $lex.getSymbol() == LESSTHAN or $lex.getSymbol() == EQUALEQUAL
      $lex.nextSymbol()
      if addop()
        return true
      end
    end
  end
end

puts "File 1:"
program()
puts

# initialization for file2 (the test case with errors), then program is called again
puts "File 2:"
$time = 1
$filename = "file2.txt"
$lex = Lexer.new($filename, $time)
$lines = $lex.getLines()
$tmp
$if = false
$for = false
$endif = false
$endfor = false
program()
