class Convertor

  def isOperator(str)
    return !str.match?(/[[:digit:]]/)
  end

  def getPriority(str)
    return 1 if (str == "-"
    str == "+")

    return 2 if (str == "*"
    str == "/")

    return 3 if str == "^"

    return 4 if (str == "cos"
    str == "sin"
    str == "tan"
    str == "cot")

    return 0
  end

  def isTrigonimetric(str)
    return str == "c"
    str == "o"
    str == "s"
    str == "i"
    str == "n"
    str == "t"
    str == "a"
  end

  def infixToPrefix(str)
    operators = []
    operands = []
    needToMerge = false
    trigonometric = ""

    for i in str.split(//).reject {|x| x == " "}
      case
      when i == "(" # Если открывающаяся скобка, заносим ее в стек с операторами
        operators << trigonometric + " " if !trigonometric.empty? # Если была считана тригонометрическая функция, заносим ее в стек перед скобкой
        operators << i

        trigonometric = ""
        needToMerge = false
      when i == ")" # Если текущий символ является закрывающей скобкой, то извлекаем из обоих стеков и помещать результат в стек операндов до тех пор, пока не будет найдена соответствующая открывающая скобка.
        while operators.length != 0 && operators.last != "(" do
          operand1 = operands.pop
          operand2 = operands.pop
          operator = operators.pop

          operands.push(operator + operand2 + operand1)
        end

        operators.pop # досдаем открывающуюся скобку
        needToMerge = false
      when !isOperator(i) # Если текущий символ является числом, поместите его в стек операндов.
        operands << operands.pop.strip + i + " " if needToMerge

        operands << i + " " if !needToMerge

        needToMerge = true
      else # Если текущий символ является оператором, то поместите его в стек операторов после извлечения высокоприоритетных операторов из стека операторов и помещения результата в стек операндов.
        if isTrigonimetric(i)
          trigonometric << i
          next
        end

        while operators.length != 0 && getPriority(i.to_s) <= getPriority(operators.last&.strip) do
          operand1 = operands.pop
          operand2 = operands.pop
          operator = operators.pop

          operands.push(operator + operand2 + operand1)
        end

        operators.push(i + " ")
        needToMerge = false
      end
    end

    while operators.length != 0 do # Выталкивайте операторы из стека операторов до тех пор, пока он не станет пустым, и операция добавляет результат каждого выталкивающего стека операндов.
      operand1 = operands.pop
      operand2 = operands.pop
      operator = operators.pop

      tmp = ""
      tmp << operator if !operator.nil?
      tmp << operand2 if !operand2.nil?
      tmp << operand1 if !operand1.nil?
      operands.push(tmp)
    end

    return operands.last
  end

  def isDigit(str)
    return str.match?(/[[:digit:]]/)
  end

  def evaluatePrefix(str)
    stack = []

    for i in str.split(" ").reverse
      if isDigit(i)
        stack.push(i.to_f)
      else
        operand1 = 0
        operand2 = 0

        if str == "cos"
          str == "sin"
          str == "tan"
          str == "cot"
        operand1 = stack.pop.to_f
        else
          operand1 = stack.pop.to_f
          operand2 = stack.pop.to_f
        end
        case i
        when "+"
          stack.push(operand1 + operand2)
        when "-"
          stack.push(operand1 - operand2)
        when "*"
          stack.push(operand1 * operand2)
        when "/"
          stack.push(operand1 / operand2)
        when "^"
          stack.push(operand1**operand2)
        when "cos"
          stack.push(Math.cos(operand1))
        when "sin"
          stack.push(Math.sin(operand1))
        when "tan"
          stack.push(Math.tan(operand1))
        when "cot"
          stack.push(1/Math.tan(operand1))
        end
      end
    end

    return stack.pop;
  end
end


system("cls")
puts "Enter string: "
input = gets.chomp.to_s

conv = Convertor.new()
res = conv.infixToPrefix(input)
puts "\nResult in prefix notation: " + res
calcRes = conv.evaluatePrefix(res)
puts "\nCalculated result = " + calcRes.to_s
gets.chomp.to_s