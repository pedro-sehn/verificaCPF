class Error
    def initialize(msg)
        @msg = msg
        throwError
    end
    def throwError
        raise "ERROR: #{@msg}"
    end
end
def gerarNumerosVerificadores(cpf)
    numbers = cpf.scan(/\d+/).join.split("")
    if numbers.length != 9
        return Error.new("Valor de CPF inválido. Não há a quantidade de dígitos esperada")
    end
    num1 = 0
    num2 = 0
    n = 0
    while(n<2) do
        nums = []
        i=0
        if n == 0
            nums = [10,9,8,7,6,5,4,3,2]
            while(i < nums.length) do
                num1 += numbers[i].to_i * nums[i]
    
                i=i+1
            end
            num1 = 11 - num1 % 11
        elsif n == 1
            nums = [11,10,9,8,7,6,5,4,3,2]
            if num1 >= 10
                num1 = 0
            end
            numbers.push(num1)
            while(i < nums.length) do
                num2 += numbers[i].to_i * nums[i]
                
                i=i+1
            end
            num2 = 11 - num2 % 11
            if num2 >= 10
                num2 = 0
            end
            numbers.push(num2)
        end
        n = n + 1
    end
    numerosVerificadores = num1.to_s + num2.to_s
    return numerosVerificadores
end
def criarCPF(regiao)
    cpf = ""

    8.times.map{ cpf += Random.rand(9).to_s }
    cpf += regiao.to_s

    numerosVerificadores = gerarNumerosVerificadores(cpf)
    numerosVerificadores.each_char do |num|
        cpf += num.to_s
    end

    cpf.to_i
    if verificarCPF(cpf)
        return cpf
    else 
        return Error.new("A criação do CPF foi mal sucedida")
    end
end
def verificarCPF(cpf)
    numbers = cpf.scan(/\d+/).join.split("")
    if numbers.length != 11
        return Error.new("Valor de CPF inválido. Não há a quantidade de dígitos esperada")
    end
    cpfCopia = []
    numbers.each do |number|
        if cpfCopia.length < 9
            cpfCopia.push(number)
        end
    end 
    numerosVerificadores = gerarNumerosVerificadores(cpfCopia.join)
    numerosVerificadores.each_char do |num|
        cpfCopia.push(num)
    end
    puts "#{cpfCopia}, #{numbers}"
    if cpfCopia == numbers
        return true
    else
        return false
    end
end
def main
    loop do
        acoes = {
            "cria" => "Criar CPF",
            "verifica" => "Verificar CPF",
            "sair" => "Sair do programa"
        }
        puts "Qual ação você deseja executar?"
        puts "#{acoes}"

        input = gets.chomp

        case input.downcase
        when "cria"
            puts "Insira o número da região"
            regiao = gets.chomp.to_i

            cpf = criarCPF(regiao)
            puts cpf
        when "verifica"
            puts "Insira um cpf"
            cpf = gets.chomp

            valor = verificarCPF(cpf)
            puts valor
        when "sair"
            break
        else
            return Error.new("Valor inválido")
        end
    end
end

main