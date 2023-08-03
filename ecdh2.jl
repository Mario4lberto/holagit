using OrderedCollections

input = nothing
oc = nothing
β = nothing
#firma_ma = nothing
#firma_loli = nothing
α = 60573 


dict_x = Dict()
dict_y = Dict()
lis = []
puntos = ()

for i in 0:630
   
    #print(i)
    dict_y[i] = (i^2) % 631#𝑦²
    dict_x[i] = ((i^3) + (2*i) + 2) % 631#𝑥³+2𝑥+2
   
end

ord_x = sort(dict_x)
ord_y = sort(dict_y)

lis = [(i,j) for i in  keys(ord_x), j in keys(ord_y) if  ord_x[i] == ord_y[j]]

#show(lis)

function suma_puntos(p1,p2)
    
    
    #=
    Función para calcular la suma de 2 puntos
    𝜆=(𝑦2−𝑦1)/(𝑥2−𝑥1)
    𝑥3=𝜆²−𝑥1−𝑥2
    𝑦3=𝜆(𝑥1−𝑥3)−𝑦1
    =#

    suma = []
    
    x1 = p1[1]
    x2 = p2[1]
    y1 = p1[2]
    y2 = p2[2]
    
     m = (y2 - y1)/(x2 - x1)
    
    x3 = 0
    y3 = 0
    
    
    if (isa(m,Int64))
        
        x3 = mod((m^2 - x1 - x2) ,631)
        y3 =mod((m * (x1 - x3 ) - y1) , 631)
        
    else
    
        #=
        Como el grupo tiene domino en los enteros positivos se implenta esta condición para calcular el 
        inverso multiplicativo modular y evitar números fraccionarios 
        =#
        m =  mod((y2 - y1)*(invmod( x2 - x1 ,631) ) , 631)
        x3 = mod((m^2 - x1 - x2) , 631)
        y3 = mod((m * (x1 - x3 ) - y1) , 631)
    
    end
    
    suma = [(x3,y3)]
    
    return suma
end

function mult_2(punto)#OjO point es una tupla
   
    #print("$xG,$yG")
    
    #=
    Función para doblar 1 punto
    𝜆=(3𝑥²𝐺+𝑎)/2𝑦𝐺
    𝑥2𝐺=𝜆−2𝑥𝐺
    𝑦2𝐺=𝜆(𝑥𝐺−𝑥2𝐺)−𝑦𝐺
    
    =#
    
    xG = punto[1]
    yG = punto[2]
    

    gf = ()
    my_list = []
    
    

    
    
     m = (3 * xG ^ 2 + 2) / (2*yG)
    
    
    if(isa(m, Int64))
        
        x2G = mod((m^2 - 2*xG) ,631)
        y2G =mod((m * (xG - x2G ) - yG) , 631)
    else
        m = mod((3 * xG ^ 2 + 2)*(invmod(2 * yG,631) ),631)
        x2G =mod((m^2 - 2*xG) , 631)
        y2G =mod((m * (xG - x2G ) - yG) , 631)
    end
    
    #gf  = x2G ,y2G
    
    #append!(my_list,x2G ,y2G)
    
    my_list = [(x2G ,y2G)]
    
    return my_list
    
end

mult_2(lis[1])
#show(mult_2(lis[1]))

lis_gf = [lis[1],mult_2(lis[1])[1]]
#show(lis_gf)

for i in 1:length(lis)-2
    append!(lis_gf, suma_puntos(lis_gf[1],lis_gf[length(lis_gf)]))
  end

push!(lis_gf, (-1,-1)) 

#=
print("->")
for i in 1:length(lis_gf)
    print(lis_gf[i])
    print("->")
end
=#

function identificar(firma,clv)
    c = 0
    aux_c = 0


    for i in lis_gf
   
        c = c + 1
        if i == firma
            aux_c = c
            #print(aux_c)
        end
        
        
    end

    identificado = aux_c*clv

    return   identificado 
end

function  firmar(identificado)

    d = 1

    aux = 0

    for x in 1:identificado
        #print(d)
        #print("\n")
        aux = d
        d = d + 1
        if d%596 == 0
            d = 1
        end
   
    end

    return aux
    
end

function  buscar_engrupo(identificado)

    d = 1

    aux = 0

    for x in 1:identificado
        #print(d)
        #print("\n")
        aux = d
        d = d + 1
        if d%596 == 0
            d = 1
        end
   
    end

    return aux
    
end


while input != 0
    
    print("Menu\n")
    print("1.-Crear clave privada\n")
    print("2.-Generar firma digital\n")
    print("3.-Firmar acta\n")
    print("Ingresa una opción del menú(0 para salir):\n")
    global input = parse(Int,readline())
        
    if(input == 1)
        print(" Crear clave privada\n" )
        print("Genera tu clave privada:\n")
        global β = parse(Int,readline())
        print("Clave privada generada, recuerda no compartirla con nadie:\n")
    elseif(input == 2)
        print("Ingresa tu clave privada\n")
        β2 = parse(Int,readline())
    
        a = lis_gf[buscar_engrupo(α)]
        print( buscar_engrupo(β2))
        print("\n")
        b = lis_gf[buscar_engrupo(β2)]

        global firma_ma = a
        global firma_loli = b
        print("Tu firma digital es:\n")

        print(firma_loli)
        print("\n")
        
    elseif(input == 3)
         print("Ingresa tu clave privada:\n")
         clave = parse(Int,readline())
         #print(firma_loli)
         
         #=
         print(identificar(firma_loli,α))
         print("\n")
         print(firmar(identificar(firma_loli,α)))
         print("\n")
         print("\n")
         print(lis_gf[firmar(identificar(firma_loli,α))])
         print(lis_gf[firmar(identificar(firma_ma,clave))])
         =#

        if(lis_gf[firmar(identificar(firma_ma,clave))] == lis_gf[firmar(identificar(firma_loli,α))])
            print("Tu acta ha sido firmada exitosamente\n")
        else
            print("Error al ingresar tu clave privada, fallo al autentificarte\n")
        end

    
    else
        print("Opción invalida\n")
    end
end