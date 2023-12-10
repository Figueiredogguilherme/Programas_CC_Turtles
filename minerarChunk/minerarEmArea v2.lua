-- Declaração de variáveis --

local x = 0
local z = 0

-- Orientação --
-- N - 0, W - 1, S - 2, E - 3 --

local o = 0

-- Direção do giro --
-- Direita - 0, Esquerda - 1

local d = 0

-- Tamanho da linha --

local t = 9

-- Tamanho da coluna --

local c = 10

local combustivel = 0
local loop = 0

-- Método para reabastecer com carvão --

function reabastecer()

    turtle.select(1)
    turtle.refuel(1)

end

-- Método para quebrar o bloco frontal, superior e inferior --

function quebrar()

    while turtle.detect() do
        turtle.dig()
        os.sleep(0.5)
    end
    while turtle.detectUp() do
        turtle.digUp()
        os.sleep(0.5)
    end
    while turtle.detectDown() do
        turtle.digDown()
        os.sleep(0.5)
    end

end

-- Método para andar para frente --

function andar()

    turtle.dig()
    turtle.forward()

    if o == 0 then
            z = z - 1
    elseif o == 1 then
            x = x - 1
    elseif o == 2 then
            z = z + 1
    else
            x = x + 1
    end

    print("\nX: ")
    print(x)
    print("Z: ")
    print(z)
    print("O: ")

    if o == 0 then
            print("N")
    elseif o == 1 then
            print("W")
    elseif o == 2 then
            print("S")
    else
            print("E")
    end

    checarCombustivel()

end

-- Método para virar 90º --

function virar(d)

    if d == 0 and o == 0 then
        turtle.turnRight()
        o = 3
    elseif d == 0 and o == 1 then
        turtle.turnRight()
        o = 0
    elseif d == 0 and o == 2 then
        turtle.turnRight()
        o = 1
    elseif d == 0 and o == 3 then
        turtle.turnRight()
        o = 2
    elseif d == 1 and o == 0 then
        turtle.turnLeft()
        o = 1
    elseif d == 1 and o == 1 then
        turtle.turnLeft()
        o = 2
    elseif d == 1 and o == 2 then
        turtle.turnLeft()
        o = 3
    else
        turtle.turnLeft()
        o = 0
    end

end

-- Método para quebrar a linha --

function quebrarLinha(t)

    for i = 1,t,1 do 
        quebrar()
        andar()
    end

end

-- Método para voltar e depositar os itens no baú --

function retornar()
    
    print("\nRetornando a origem para depositar...")

    local xOld = x 
    local zOld = z

    -- Indo depositar --

    virar(1)
    virar(1)
    if o == oSet or oSet == 2 then
        while x ~= 0 do
            quebrar()
            andar()
        end
        virar(1)
        while z ~= 0 do
            andar()
        end
        for var = 2,16,1 do
            turtle.select(var)
            turtle.dropDown()
        end
    else
        while z ~= 0 do
            quebrar()
            andar()
        end
        virar(1)
        while x ~= 0 do
            andar()
        end
        for var = 2,16,1 do
            turtle.select(var)
            turtle.dropDown()
        end
    end
    turtle.select(1)

    -- Voltando do deposito

    print("\nDepositei! Voltando a minerar...")

    virar(1)
    virar(1)
    if oSet == 0 or oSet == 2 then
        while z ~= zOld do
            andar()
        end
        andar()
        virar(0)
    else
        while x ~= xOld do
            andar()
        end
        andar()
        virar(0)
    end

end

function desligar()

    virar(1)
    virar(1)
    if oSet == 0 or oSet == 2 then
        while x ~= 0 do
            quebrar()
            andar()
        end
        virar(1)
        while z ~= 0 do
            andar()
        end
        for var = 2,16,1 do
            turtle.select(var)
            turtle.dropDown()
        end
    else
        while z ~= 0 do
            quebrar()
            andar()
        end
        virar(1)
        while x ~= 0 do
            andar()
        end
        for var = 2,16,1 do
            turtle.select(var)
            turtle.dropDown()
        end
    end
    turtle.select(1)

    virar(1)
    virar(1)

end

-- Método checar combustivel, para checar o combustível do robô --

function checarCombustivel()
    combustivel = tonumber(turtle.getFuelLevel())
    print("\nCombustível: ")
    print(combustivel)

    if turtle.getItemCount() > 1 and tonumber(turtle.getFuelLevel()) < 80 then
        print("\nReabastecendo...")
        reabastecer()
    end
end

-- Método Main --

print("\nBem-vindo programa Minerar em Área do M4ND4RiM!\n\nEu sou o Timo e vou te ajudar a minerar!!\n\nPor favor, especifique a área para minerar:")
print("\nComprimento: ")
t = tonumber(read())
print("\nLargura: ")
c = tonumber(read())
print("\nOrientação atual (N - 0, W - 1, S - 2, E - 3): ")
oSet = tonumber(read())
o = oSet

andar()
virar(0)

for vz = 1,c,1 do

    quebrarLinha(t)
    retornar()

end

desligar()

print("\nUfa, finalizei! :D")
