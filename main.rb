class Error
    def initialize(msg)
        @msg = msg
        throwError
    end
    def throwError
        raise "ERROR: #{@msg}"
    end
end
def gerarTemplateCPF(cpf)
    cpf.split("")
    cpf.insert(3, ".")
    cpf.insert(7, ".")
    cpf.insert(11, "-")
    
    return cpf
end
def gerarNumerosVerificadores(cpf)
    if cpf.length != 9
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
                num1 += cpf[i].to_i * nums[i]
    
                i=i+1
            end
            num1 = 11 - num1 % 11
        elsif n == 1
            nums = [11,10,9,8,7,6,5,4,3,2]
            if num1 >= 10
                num1 = 0
            end
            cpf.push(num1.to_s)
            while(i < nums.length) do
                num2 += cpf[i].to_i * nums[i]
                
                i=i+1
            end
            num2 = 11 - num2 % 11
            if num2 >= 10
                num2 = 0
            end
            cpf.push(num2.to_s)
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

    numerosVerificadores = gerarNumerosVerificadores(cpf.split(""))
    numerosVerificadores.each_char do |num|
        cpf += num.to_s
    end

    cpf.to_i
    if verificarCPF(cpf.split(""))
        cpf = gerarTemplateCPF(cpf)
        return cpf
    else 
        return Error.new("A criação do CPF foi mal sucedida")
    end
end
def verificarCPF(cpf)
    if cpf.length != 11
        return Error.new("Valor de CPF inválido. Não há a quantidade de dígitos esperada")
    end
    cpfCopia = []
    cpf.each do |number|
        if cpfCopia.length < 9
            cpfCopia.push(number)
        end
    end 
    numerosVerificadores = gerarNumerosVerificadores(cpfCopia)
    if cpfCopia == cpf
        return true
    else
        return false
    end
end
def main
    loop do
        acoes = {
            "criar" => "Criar CPF",
            "verificar" => "Verificar CPF",
            "gerar" => "Gerar os números verificadores do CPF",
            "sair" => "Sair do programa"
        }
        puts "Qual ação você deseja executar?"
        print "\n"
        espaco = {
            "keyName" => 0
        }
        acoes.each do |key, value|
            if key.length > espaco["keyName"]
                espaco["keyName"] = key
                espaco["keyName"] = key.length
            end
        end
        acoes.each do |key, value|
            numEspaco = espaco["keyName"]-key.length
            espacos = ""
            numEspaco.times {espacos << " "}
            puts "> #{key}#{espacos} - #{value}"
        end
        print("\n")
        input = gets.chomp
        print("\n")

        case input.downcase
        when "criar"
            puts "Insira o número da região"
            regiao = gets.chomp.to_i

            cpf = criarCPF(regiao)
            puts cpf
            print "\n"
        when "verificar"
            puts "Insira um CPF"
            cpf = gets.chomp

            numeros = cpf.scan(/\d+/).join.split("")
            valor = verificarCPF(numeros)
            print "\n"
            if valor
                puts "> CPF Válido"
            else 
                puts "> CPF Inválido"
            end
            print "\n"
        when "gerar"
            puts "Insira os 9 dígitos do CPF"
            cpf = gets.chomp
            
            numeros = cpf.scan(/\d+/).join.split("")
            numerosVerificadores = gerarNumerosVerificadores(numeros)
            numeros = numeros.join
            puts "\nNúmeros verificadores: #{numerosVerificadores} \nCPF inteiro: #{gerarTemplateCPF(numeros.to_s)}"
            print "\n"
        when "sair"
            break
        else
            return Error.new("Comando inexistente")
        end
    end
end

main