-- Declaração de variáveis --

-- Posição no plano --

local x = 0
local z = 0
local y = 0

local xAlvo = 0
local zAlvo = 0

-- Orientação --

local o = 0

-- Direção do giro --
-- Direita - 0, Esquerda - 1

local d = 0

-- Combustível --

local combustivel = 0
local limiteCombustivel = 20

-- Direção da mineração --

local direcaoMineracao = 0
local direcaoDeVirar = 0

-- Variáveis para colocação de tocha -- 

local countDownTocha = 0
local eTocha = 0

-- Método para reabastecer com carvão --

function reabastecer()

    turtle.select(1)

    turtle.digDown()
    os.sleep(0.1)
    turtle.placeDown()
    os.sleep(0.5)

    turtle.select(1)
    turtle.suckDown(2)
    turtle.refuel(2)

    turtle.select(1)
    turtle.digDown()

end

-- Método para quebrar o bloco frontal, superior e inferior --

function quebrar()

    while turtle.detect() do
        turtle.dig()
        os.sleep(0.5)
    end

    _,eTocha = turtle.inspectUp()
    if eTocha.name ~= "minecraft:torch" then
        while turtle.detectUp() do
            turtle.digUp()
            os.sleep(0.5)
        end
    end

    _,eTocha = turtle.inspectDown()
    if eTocha.name ~= "minecraft:torch" then
        while turtle.detectDown() do
            turtle.digDown()
            os.sleep(0.5)
        end
    end

    if checarInventario() == true then
        depositarInventario()
    end

end

-- Método para andar para frente --

function andar()

    while turtle.detect() do
        turtle.dig()
        os.sleep(0.5)
    end
    turtle.forward()

    if o == 0 then
            x = x + 1
    elseif o == 90 then
            z = z + 1
    elseif o == 180 then
            x = x - 1
    else -- 270
            z = z - 1
    end

    limparTerminal()
    print("\n       TURTIMO.EXE VERSION 3.0")
    print("\n             by M4ND4RiM")

    print("\n\n\n     ".."X:"..x.." , ".."Z:"..z.." | Orientação: "..o.."º")
    checarCombustivel()

end

-- Método para virar 90º --

function virar(d)

    if d == 0 and o == 0 then
        turtle.turnRight()
        o = 90
    elseif d == 0 and o == 90 then
        turtle.turnRight()
        o = 180
    elseif d == 0 and o == 180 then
        turtle.turnRight()
        o = 270
    elseif d == 0 and o == 270 then
        turtle.turnRight()
        o = 0
    elseif d == 1 and o == 0 then
        turtle.turnLeft()
        o = 270
    elseif d == 1 and o == 270 then
        turtle.turnLeft()
        o = 180
    elseif d == 1 and o == 180 then
        turtle.turnLeft()
        o = 90
    else
        turtle.turnLeft()
        o = 0
    end

end

-- Método para quebrar a linha --

function quebrarLinha(vz)

    if vz % 2 == 0 then
        while math.sqrt(z^2) ~= 0 do
            quebrar()
            if opcaoTocha == 1 then
                local xTocha = x + 1
                if xTocha % 5 == 0 or x == 0 then
                countDownTocha = colocarTocha(countDownTocha)
                countDownTocha = countDownTocha - 1
                end
            end
            andar()
        end
    else
        while math.sqrt(z^2) ~= zAlvo do
            quebrar()
            if opcaoTocha == 1 then
                local xTocha = x + 1
                if xTocha % 5 == 0 or x == 0 then
                    countDownTocha = colocarTocha(countDownTocha)
                    countDownTocha = countDownTocha - 1
                end
            end
            andar()
        end
    end
    

end

-- Método para fazer a volta --

function fazerVolta1()

    virar(direcaoDeVirar1)
    quebrar()
    andar()
    virar(direcaoDeVirar1)
    quebrar()
    andar()

end

function fazerVolta2()

    virar(direcaoDeVirar2)
    quebrar()
    andar()
    virar(direcaoDeVirar2)
    quebrar()
    andar()

end

-- Método que leva o robô para sua posição incial

function desligar()

    while z ~= 0 do
        quebrar()
        andar()
    end
    virar(direcaoDeVirar1)
    while x ~= 0 do
        andar()
    end

    turtle.select(2)

    turtle.digDown()
    os.sleep(0.1)
    turtle.placeDown()

    for var = 4,16,1 do
        turtle.select(var)
        turtle.dropDown()
    end

    turtle.select(2)
    turtle.digDown()

    turtle.select(1)

    virar(1)
    virar(1)

end

-- Método checar combustivel, para checar o combustível do robô --

function checarCombustivel()

    combustivel = tonumber(turtle.getFuelLevel())
    print("\n       ".."Combustível: "..combustivel.." blocos")

    if tonumber(turtle.getFuelLevel()) < limiteCombustivel then
        print("\n         [Reabastecendo...]")
        reabastecer()
    end

end

-- Método para colocar tocha --

function colocarTocha(countDownTocha)

    turtle.select(4)
    if turtle.getItemCount() == 1 then

        print("\n      [Reabastecendo tochas...]")

        turtle.select(3)

        turtle.digDown()
        os.sleep(0.1)
        turtle.placeDown()
        os.sleep(0.5)

        turtle.select(4)
        turtle.suckDown(63)
        turtle.refuel(2)

        turtle.select(3)
        turtle.digDown()

        turtle.select(1)
    end

    if countDownTocha <= 0 then
        turtle.select(4)
        turtle.placeDown()
        turtle.select(1)
        countDownTocha = 10
    end
    
    return countDownTocha

end

-- Método para checar inventário no baú --

function checarInventario()

    local cheio = true
    for var = 5, 16, 1 do 
        turtle.select(var)
        local slot = turtle.getItemCount()
        if slot == 0 then
            cheio = false
        end
    end

    turtle.select(1)
    return cheio

end

-- Método para depositar inventário no baú --

function depositarInventario()

    print("\n           [Depositando...]")

    turtle.select(2)

    turtle.digDown()
    os.sleep(0.1)
    turtle.placeDown()

    for var = 5,16,1 do
        turtle.select(var)
        turtle.dropDown()
    end

    turtle.select(2)
    turtle.digDown()

    turtle.select(1)

end

function limparTerminal()
    for i = 1, 255 do
        print()
    end
end

-- Método Main --

limparTerminal()
print("\n       TURTIMO.EXE VERSION 3.0")
print("\n             by M4ND4RiM")
print("\n\nPor favor, configure o Turtimo para a tarefa desejada...")
print("\nProfundidade em chunks: ")
xAlvo = tonumber(read())
xAlvo = xAlvo*16
xAlvo = xAlvo - 1
print("\nComprimento em chunks: ")
zAlvo = tonumber(read())
zAlvo = zAlvo*16
zAlvo = zAlvo - 1

print("\nDefine a direção da mineração:\n 1 - Esquerda para a direita\n 2 - Direita para a esquerda")
direcaoMineracao = tonumber(read())

if direcaoMineracao == 1 then
    direcaoDeVirar1 = 1
    direcaoDeVirar2 = 0
else
    direcaoDeVirar1 = 0
    direcaoDeVirar2 = 1
end

print("\nColocar tochas?\n 1 - Sim\n 2 - Não")
opcaoTocha = tonumber(read())

combustivel = tonumber(turtle.getFuelLevel())
if combustivel < 20 then
    turtle.select(16)
    while turtle.getItemCount() == 0 do
        print("\nColoque um carvão no meu ultimo slot...")
        os.sleep(5)
    end
    turtle.refuel(1)
    turtle.select(1)
end

turtle.select(1)
while turtle.getItemCount() == 0 do
    print("\nColoque o baú de carvão no primeiro slot!")
    os.sleep(5)
end

turtle.select(2)
while turtle.getItemCount() == 0 do
    print("\nColoque o baú de depósito no segundo slot!")
    os.sleep(5)
end

if opcaoTocha == 1 then
    turtle.select(3)
    while turtle.getItemCount() == 0 do
        print("\nColoque o baú de tochas no terceiro slot!")
        os.sleep(5)
    end
    turtle.select(4)
    while turtle.getItemCount() == 0 do
        print("\nColoque uma tocha no quarto slot!")
        os.sleep(5)
    end
    turtle.select(1)
end

-- Início do movimento --

countDownTocha = 0

virar(direcaoDeVirar2)
quebrar()
andar()

local vz = 1

while x ~= xAlvo and z ~=zAlvo do
    quebrarLinha(vz)
    if vz % 2 == 0 then
        fazerVolta2()
    else
        fazerVolta1()
    end
    vz = vz + 1
end

-- Fim do movimento --

desligar()

limparTerminal()
print("\n       TURTIMO.EXE VERSION 3.0")
print("\n             by M4ND4RiM")
print("\n\n\n              Finalizado")
if combustivel == 0 then
    print("\n         [ERRO: Sem combustível]")
else
    print("\n\n")
end
