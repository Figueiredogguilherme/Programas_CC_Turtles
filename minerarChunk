-- Declaração de variáveis --

-- Posição no plano --

local x = 0
local z = 0

local xHome = 0
local zHome = 0

-- Orientação --
-- N - 0, W - 1, S - 2, E - 3 --

local o = 0

-- Direção do giro --
-- Direita - 0, Esquerda - 1

local d = 0

-- Tamanho da linha --

local t = 0

-- Tamanho da coluna --

local c = 0

-- Combustível --

local combustivel = 0
local limiteCombustivel = 20

-- Direção da mineração --

local direcaoMineracao = 0
local direcaoDeVirar = 0

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

    while turtle.detect() do
        turtle.dig()
        os.sleep(0.5)
    end
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

function quebrarLinha(vz)

    if vz % 2 ~= 0 then
        for i = 1,t-1,1 do 
            quebrar()
            andar()
        end
    else
        for i = 1,t,1 do 
            quebrar()
            andar()
        end
    end

end

-- Método para fazer a volta --

function fazerVolta()

    virar(direcaoDeVirar1)
    andar()
    virar(direcaoDeVirar1) 

end

-- Método para voltar e depositar os itens no baú --

function retornar()
    
    print("\nRetornando a origem para depositar...")

    local xOld = x 
    local zOld = z

    -- Indo depositar --

    if oSet == 1 or oSet == 3 then
        while x ~= 0 do
            quebrar()
            andar()
        end
        virar(direcaoDeVirar1)
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
        virar(direcaoDeVirar1)
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
        virar(direcaoDeVirar2)
    else
        while x ~= xOld do
            andar()
        end
        andar()
        virar(direcaoDeVirar2)
    end

end

-- Método que leva o robô para sua posição incial

function desligar()

    virar(direcaoDeVirar1)
    if oSet == 0 or oSet == 2 then
        while x ~= 0 do
            quebrar()
            andar()
        end
        virar(direcaoDeVirar1)
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
        virar(direcaoDeVirar1)
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

    if turtle.getItemCount() > 1 and tonumber(turtle.getFuelLevel()) < limiteCombustivel then
        print("\nReabastecendo...")
        reabastecer()
    end
end

-- Método Main --

print("\nBem-vindo programa Minerar em Área do M4ND4RiM!\n\nEu sou o Mimo e vou te ajudar a minerar!!\n\nPor favor, especifique a área para minerar:")
print("\nComprimento em chunks: ")
t = tonumber(read())
t = t*16
t = t - 1
print("\nLargura: em chunks")
c = tonumber(read())
c = c*16
c = c - 1
print("\nOrientação atual (N, W, S, E): ")
oSet = read()

if oSet == "N" or "n" then
    oSet = 0
    o = 0
elseif oSet == "W" or "w" then
    oSet = 1
    o = 1
elseif oSet == "S" or "s" then
    oSet = 2
    o = 2
else
    oSet = 3
    o = 3
end

print("\nDefine a direção da mineração:\n1 - Esquerda para a direita\n2 - Direita para a esquerda")
direcaoMineracao = tonumber(read())

if direcaoMineracao == 1 then
    direcaoDeVirar1 = 1
    direcaoDeVirar2 = 0
else
    direcaoDeVirar1 = 0
    direcaoDeVirar2 = 1
end

while turtle.getItemCount() == 0 do
    print("\nColoque carvão no primeiro slot!")
end

virar(direcaoDeVirar2)
turtle.digUp()
andar()

local vz = 0

if o == 1 or o == 3 then
    for vz = 1,c,1 do
        quebrarLinha(vz)
        if vz % 2 == 0 then
            retornar()
        else
            fazerVolta()
        end
    end
else
    for vz = 1,c,1 do
        quebrarLinha(vz)
        if vz % 2 == 0 then
            retornar()
        else
            fazerVolta()
        end
    end
end

desligar()

print("\nUfa, finalizei! :D")
