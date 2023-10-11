"La función <es_letra> recibe un caracter y determina si es letra o no dentro de una lista de todas las letras válidas en el idioma español. 
Devuelve un vector con dos valores, el primero, un buleano sobre si es letra o no, y otro con la información sobre si la letra está acentuada.

Ejemplo: es_letra('á')
-> [true, true]"
function es_letra(char) # se inicializa la función con un caracter de parámetro
	# lista de todos los caracteres aceptados como letras en el español
	letras = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'ñ', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F','G', 'H', 'I', 'J', 'K', 'L', 'M','N', 'Ñ','O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'á', 'é', 'í', 'ó', 'ú', 'Á', 'É', 'Í', 'Ó', 'Ú']
	es = false # buleano que determinara si es una letra o no, por defecto inicializado en falso
	acento = false # buleano que determinara si es una letra acentuada o no, por defecto inicializado en falso
	for i in 1:64 # iteración con for por todos los elementos en la lista letras
		if char == letras[i] # si el caracter aparece en letras
			es = true # actualiza <es> a verdadero
			if i > 54 # si la posición del caracter en lista coincide con las letras acentuadas
				acento = true # actualiza <acento> a verdadero
			end
		end
	end
	return [es,acento] # regresa una lista con dos variables
end

"La función <separar> recibe una cadena de caracteres y regresa una 
lista con todas las palabras encontradas en la lista en orden de aparición y sin importar repeticiones.

Ejemplo: separar(''Mi mamá me mima'')
-> [''Mi'', ''mamá'', ''me'', ''mima'']"
function separar(frase) # Se inicializa la función recibiendo una cadena de texto llamada <frase>
	frase = lowercase(frase)
	i = 1 # inicializamos nuestra variable de iteración
	n = length(frase) # inicializamos n como la cantidad de caracteres en <frase>
	palabras = [] # inicializamos una lista vacía donde se colocarán todas las palabras
	palabra = "" # inicializamos una variable auxiliar vacía para ir generando las palabras a añadir en la lista <palabras>
	while i <= n # se detiene la iteración cuando i > n 
		res = es_letra(frase[i]) # determinamos si el caracter actual es una letra 
		if res[1] # si es letra
			palabra *= frase[i] # añadimos a la palabra el caracter actual
			if res[2] && i != n # si la letra es acentuada y no es el último caracter de la frase
				i += 1 # salta un valor
				n += 1 # agrega uno a la longitud, eso debido a la manera en la que funciona la iteración de Julia con respecto a los caracteres de unicode
			end
		else
			if palabra != "" # si la palabra no está vacía
				push!(palabras, palabra) # agregas en <palabras> la palabra
				palabra = "" # resetea la palabra a estar vacía
			end
		end
		i += 1 # continuas al siguiente caracter
	end
	if palabra != "" # si la última palabra no es vacía
		push!(palabras, palabra) # añade la palabra a palabras
	end
	return palabras # regresa la lista de palabras
end

"La función <insetrar> recibe una lista, un elemento y la posición deseada para el elemento en la lista, 
y regresa una lista con los elementos originales y con el elemento nuevo agregado en la posición deseada.

Ejemplo: insertar([2, 3, 5, 7], 4, 3)
-> [2, 3, 4, 5, 7]"
function insertar(lista, elemento, posición) # se inicializa la función 
	push!(lista, "") # se agrega un elemento cadena vacío al final de la lista
	n = length(lista) # se usa n como la cantidad de elementos de la lista
	for i in n:-1:posición + 1 # en una cuenta regresiva desde el último hasta el anterior a posición
		lista[i] = lista[i-1] # se recorren los valores a la derecha una posición
	end
	lista[posición] = elemento # y como último paso en la <posición> se actualiza el valor a <elemento>
	return lista # regresa la lista nueva
end

"La función <frecuencia> recibe una lista de palabras, y genera una nueva con cada palabra y su número de apariciones ordendas alfabéticamente. 

Ejemplo: insertar([''odio'', ''mi'', ''vida'', ''odio'', ''a'', ''mi'', ''suerte''])
-> [[''a'', 1], [''mi'', 2], [''odio'', 2], [''vida'', 1], [''suerte'', 1]]"
function frecuencia(lista) # la función frecuencia es el núcleo 
	resultado = [] # inicializamos una lista vacía
	for palabra in lista # iteramos por cada palabra en la lista
		pos_palabra = posición(palabra, resultado) # y obtenemos con la función <posición>, si la palabra está y cual es su posición en la lista <resultado>
		if pos_palabra[1] == 1 # si la palabra ya está en resultado, entonces
			resultado[pos_palabra[2]][2] += 1 # sumamos uno a las apariciones de la palabra
		else # si la palabra no estaba originalmente en resultado
			resultado = insertar(resultado, [palabra, 1], pos_palabra[2]) # insertamos [palabra, 1]en la posición correcta  
		end
	end
	return resultado # y regresamos la lista con el resultado de lista
end

"La función <posición> con un solo parámetro recibe un caracter y regresa su posición en una lista de orden de las letras. 

Ejemplo: posición('c')
-> 4"
function posición(caracter) # inicializamos la función recibiendo un caracter
	caracteres = " abcdefghijklmnopqrstuvwxyz" # establecemos la cadena de caracteres con el orden de las letras
	for i in 1:27 # iteramos en todas las posiciones de los caracteres
		if caracter == caracteres[i] # si el caracter actual coincide con alguno de la cadena <caracteres>
			return i # regresar la posición del caracter
		end
	end
	return 0
end

"La función <mayorque> recibe dos palabras y determina si la primera está en un orden alfabético superior 

Ejemplo: mayorque(''ha'', ''han'')
-> true"
function mayorque(primera, segunda)
	i = 1
	l_primera = length(primera)
	l_segunda = length(segunda) 
	
	while i <= l_segunda # iterar dentro de la segunda palabra
		if i <= l_primera # aún se puede iterar dentro de la primera?
			pos_primer = posición(primera[i]) # posiciones de ambos caracteres
			pos_segundo = posición(segunda[i])
			if pos_primer < pos_segundo # si el caracter del primero es menor, terminamos y es verdadero
				return false
			elseif pos_primer == pos_segundo # si son el mismo caracter entonces pasar a la siguiente posición
				i += 1
			else # si el caracter de la segunda palabra es mayor, es falso
				return true
			end
		else # ya no hay más letras en la primera palabra entonces terminamos
			return true
		end
	end
	if l_segunda == l_primera # si la cantidad de letras en ambas entonces son la misma palabra y terminamos
		return false	
	else # si hay más letras en la primer palabra y hasta ahora las letras son iguales terminamos, es falso
		return true
	end
end

"La función <posición> con dos argumentos recibe una palabra y una lista de palabras ordenada alfabéticamente, 
y determina si la palabra está dentro de la lista y su posición, o por el contrario, que no está y dónde debería de estar.

Es importante notar que la lista tiene un formato de [[palabra1, ...], [palabra2, ...], [palabra3, ...], ...]

Ejemplo: posición(''canguro'', [[''abeja, ...], [''abejorro'', ...], [''bambú'', ...]])
-> [0, 3]"
function posición(palabra, lista) # inicializamos la función posición pero ahora con dos parámetros
	ind_derecha = length(lista) # inicializamos el índice límite por la derecha como la última posición
	ind_izquierda = 1 # inicializamos el índice límite por la izquiera como la primera posición
	n = Int(floor(ind_derecha+ind_izquierda/2)) # e inicializamos el punto medio entre ambos
	
	while ind_izquierda < ind_derecha # mientras que los índices de los extremos sean diferentes
		if mayorque(palabra, lista[n][1]) # si la primera palabra es mayor alfabéticamente a la palabra a mitad del rango
			ind_izquierda = n + 1 # actualizamos el indice de la izquierda al siguiente de la mitad
		else # si la primera palabra es menor o igual, entonces
			if lista[n][1] == palabra # si la palabra es igual a la que está en la posición de la mitad del rango
				return [true, n] # regresamos que está en la lista y que su posición es n
			else
				ind_derecha = n # o en su defecto, actualizamos el límite de la derecha al punto medio
			end
		end
		n = Int(floor((ind_derecha+ind_izquierda)/2)) # actualizamos el punto medio con los nuevos límites izquierdo y derecho
	end
	if n == 0 # si la lista no tiene elementos
		return [false, 1] # regresamos que el elemento no está y debe ir en la primera posición
	elseif lista[n][1] == palabra # si por el contrario, la lista está en el punto medio una vez concluímos
		return [true, ind_izquierda] # regresamos que sí está en la lista y su posición
	elseif mayorque(palabra, lista[n][1]) # si la palabra es mayor que la última posición posible encontrada 
		return [false, n+1] # entonces debe ir inmediatamente después y no está en la lista
	else # si por el contrario es menor a la palabra en la última posición encontrada 
		return [false, n] # entonces no está y debe ir en la posición actual
	end
end

"La función <main> recibe una frase en cadena de caracteres y la separa en palabras creando así una lista, para con esta
contar el número de apariciones de cada palabra en la lista en orden alfabético.

Ejemplo:  main(''tres tristes tigres tragaban trigo en un trigal, en un trigal, tres tristes trigres tragaban trigo'')
-> Any[''en'', 2]
   Any[''tigres'', 1]
   Any[''tragaban'', 2]
   Any[''tres'', 2]
   Any[''trigal'', 2]
   Any[''trigo'', 2]
   Any[''trigres'', 1]
   Any[''tristes'', 2]
   Any[''un'', 2]"
function main(frase) # 
	lista = separar(frase)
	return frecuencia(lista)
end
