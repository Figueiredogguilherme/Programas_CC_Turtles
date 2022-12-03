local x = 0
local y = 0
local z = 0
local o = ''

local d = ''
local ciclo = 2
local loop = 1
local inv = 0
local invCheio = 'false'

function quebrar()
    term.write('Quebrando blocos...')
    while turtle.detect() do
        turtle.dig()
    end
    while turtle.detectUp() do
        turtle.digUp()
    end
    while turtle.detectDown() do
        turtle.digDown()
    end
end

function andar()
    term.write('Andando...')
    while turtle.detect() == 'false' do
        turtle.forward()
        if o == 'E' then
            x = x + 1
        elseif o == 'W' then
            x = x - 1
        elseif o == 'N' then
            z = z - 1
        else
            z = z + 1
        end
    end            
end

function subir()
    term.write('Subindo...')
    while turtle.detectUp() == 'false' do
        turtle.up()
        y = y + 1
    end
end

function descer()
    term.write('Descendo...')
    while turtle.detectDown() == 'false' do
        turtle.down()
        y = y - 1
    end
end

function virar(d)
    if d == 'E' then
        term.write('Virando a esquerda...')
        turtle.turnLeft()
        if o == 'E' then
            o = 'N'
        elseif o == 'N' then
            o = 'W'
        elseif o == 'W' then 
            o = 'S'
        else
            o = 'E'
        end
    end
    if d == 'D' then
        term.write('Virando a direita...')
        turtle.turnRight()
        if o == 'E' then
            o = 'S'
        elseif o == 'S' then
            o = 'W'
        elseif o == 'W' then
            o = 'N'
        else
            o = 'E'
        end
    end
end

function depositar()
    term.write('Inventário cheio, indo depositar...')
    local xOld = x
    local yOld = y 
    local zOld = z
    local oOld = o
    local var = 0
    local var2 = -1
    local var3 = 1

    if x > 0 then
        for x,var,var2 in
            if o == 'E' then
                virar('D')
                andar()
                virar('D')
                andar()
            elseif o == 'S' then
                virar('D')
                andar()
            else
                virar('D')
                andar()
                virar('E')
                andar()
            end
        end
    else
        for x,var,var3 in
            if o == 'E' then
                virar('D')
                andar()
                virar('E')
                andar()
            elseif o == 'N' then
                virar('D')
                andar()
            else
                virar('D')
                andar()
                virar('D')
                andar()
            end
        end
    end

    if z > 0 then
        for z,var,var2 in
            if o == 'E' then
                virar('E')
                andar()
            else
                virar('D')
                andar()
            end
        end
    else
        if o == 'E' then
            virar('D')
            andar()
        else
            virar('E')
            andar()
        end
    end

    if o == 'N' then
        virar('D')
    else
        virar('E')
    end

    turtle.down()

    for i=16,1,-1
        turtle.select(i)
        turtle.dropDown()
    end

    turtle.up()

    term.write('Inventário vazio, voltando a minerar...')

    if xOld > 0 then
        if zOld > 0 then
            for x,xOld,1 in
                andar()
            end
            virar('D')
            for z,zOld,1 in
                andar()
            end
            virar('D')
            local deteccao = turtle.detect()
            if deteccao == 'false' then
                virar('E')
            end
        else
            virar('E')
            for z,zOld,-1 in
                andar()
            end
            virar('D')
            for x,xOld,1 in
                andar()
            end
            virar('D')
            local deteccao = turtle.detect()
            if deteccao == 'false' then
                virar('E')
            end
        end
    else
        if zOld < 0 then
            virar('E')
            virar('E')
            for x,xOld,-1 in
                andar()
            end
            virar('D')
            for z,zOld,-1 in
                andar()
            end
            virar('D')
            local deteccao = turtle.detect()
            if deteccao == 'false' then
                virar('E')
            end
        else
            virar('D')
            for z,zOld,1 in
                andar()
            end
            virar('D')
            for x,xOld,-1 in
                andar()
            end
            virar('D')
            local deteccao = turtle.detect()
            if deteccao == 'false' then
                virar('E')
            end
        end

end

function recarregar()
    term.write('Baixo combustível, recarregando...')
    while turtle.getItemCount > 1 do
        turtle.refuel()
    end
end

function checarInv()
    inv = 0
    for i=16,1,-1
        turtle.select(i)
        local slot = turtle.getItemCount()
        if slot > 0 then
            inv = inv + 1
    end
    if inv < 15 then
        invCheio = 'false'
    else
        invCheio = 'true'
    end     
end

-- Início do método Main --

term.write('Bem-vindo ao programa de mineração em caracol desenvolvido pelo M4ND4RiM!')
term.write('Inicinado agora...')

local primeiro = 'true'

turtle.up()

while loop == 1 do

    while turtle.getFuelLevel > 81 do
        checarInv()
        while invCheio == 'false' do
            if primeiro == 'true' then
                quebrar()
                andar()
                virar('D')
                quebrar()
                andar()
                virar('D')
            else
                for local c = 0,ciclo,0.5 in
                    quebrar()
                    andar()
                end
                virar('D')
                for local c = 0,ciclo,0.5 in
                    quebrar()
                    andar()
                end
                virar('D')
                for local c = 0,ciclo,0.5 in
                    quebrar()
                    andar()
                end
                virar('D')
                quebrar()
                andar()
                ciclo = ciclo + 1
            end
            primeiro = 'false'
        end
        depositar()
    end

    recarregar()

end
