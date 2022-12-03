-- Declaração de variáveis --

-- Posição no plano --

local x = 0
local z = 0

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
    turtle.refuel(1)

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

    print("\nX: ")
    print(x)
    print("Z: ")
    print(z)
    print("O: ")

    if o == 0 then
            print("0º")
    elseif o == 90 then
            print("90º")
    elseif o == 180 then
            print("180º")
    else
            print("270º")
    end

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
            local xTocha = x + 1
            if xTocha % 5 == 0 or x == 0 then
                countDownTocha = colocarTocha(countDownTocha)
                countDownTocha = countDownTocha - 1
            end
            andar()
        end
    else
        while math.sqrt(z^2) ~= zAlvo do
            quebrar()
            local xTocha = x + 1
            if xTocha % 5 == 0 or x == 0 then
                countDownTocha = colocarTocha(countDownTocha)
                countDownTocha = countDownTocha - 1
            end
            andar()
        end
    end
    

end

-- Método para fazer a volta --

function fazerVolta()

    virar(direcaoDeVirar1)
    quebrar()
    andar()
    virar(direcaoDeVirar1)
    quebrar()
    andar()

end

-- Método para voltar e depositar os itens no baú --

function retornar()
    
    print("\nRetornando a origem para depositar...")

    local xOld = x 
    local zOld = z

    -- Indo depositar --

    while z ~= 0 do
        quebrar()
        andar()
    end
    virar(direcaoDeVirar1)
    quebrar()
    while x ~= 0 do
        andar()
    end
    for var = 3,16,1 do
        turtle.select(var)
        turtle.dropDown()
    end
    turtle.select(1)

    -- Voltando do deposito

    print("\nDepositei! Voltando a minerar...")

    virar(1)
    virar(1)
    while x ~= xOld do
        andar()
    end
    andar()
    virar(direcaoDeVirar2)
    while z ~= zOld do
        andar()
    end

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
    for var = 2,16,1 do
        turtle.select(var)
        turtle.dropDown()
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

function colocarTocha(countDownTocha)

    if countDownTocha <= 0 then
        turtle.select(2)
        turtle.placeDown()
        turtle.select(1)
        countDownTocha = 10
    end
    
    return countDownTocha

end

-- Método Main --

print("\nBem-vindo programa Minerar em Área do M4ND4RiM!\n\nEu sou o Timo e vou te ajudar a minerar!!\n\nPor favor, especifique a área para minerar:")
print("\nComprimento em chunks: ")
xAlvo = tonumber(read())
xAlvo = xAlvo*16
xAlvo = xAlvo - 1
print("\nLargura: em chunks")
zAlvo = tonumber(read())
zAlvo = zAlvo*16
zAlvo = zAlvo - 1

print("\nDefine a direção da mineração:\n1 - Esquerda para a direita\n2 - Direita para a esquerda")
direcaoMineracao = tonumber(read())

if direcaoMineracao == 1 then
    direcaoDeVirar1 = 1
    direcaoDeVirar2 = 0
else
    direcaoDeVirar1 = 0
    direcaoDeVirar2 = 1
end

turtle.select(1)
while turtle.getItemCount() == 0 do
    print("\nColoque carvão no primeiro slot!")
    os.sleep(5)
end

turtle.select(2)
while turtle.getItemCount() == 0 do
    print("\nColoque tocha no segundo slot!")
    os.sleep(5)
end
turtle.select(1)

countDownTocha = 0

virar(direcaoDeVirar2)
turtle.digUp()
andar()

local vz = 1

while x ~= xAlvo and z ~=zAlvo do
    quebrarLinha(vz)
    if vz % 2 == 0 then
        retornar()
    else
        fazerVolta()
    end
    vz = vz + 1
end

desligar()

print("\nUfa, finalizei! :D")
