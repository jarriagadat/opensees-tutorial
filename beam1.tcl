######################################################################
# ejemplo viga
# jorge a arriagada
# 2023 01 16
######################################################################

######################################################################
# tutorial basado en 
# getting started OpenSees WIKI> https://opensees.berkeley.edu/wiki/index.php/Getting_Started
# video OpenSees Demos >  https://www.youtube.com/watch?v=sUq8Tk7vhWo&t=1s
######################################################################

######################################################################
# VSCODE
# plugins > 
# Name: Tcl bitwisecoook Link: https://marketplace.visualstudio.com/items?itemName=bitwisecook.tcl
# Name: OpenSees Language Link: https://marketplace.visualstudio.com/items?itemName=jamesmaj.vscode-language-opensees
# 
######################################################################

######################################################################
# se puede correr desde la terminal 1 cmd o desde 2 github
# 1 cmd > opensees > opensees beam1.tcl
# 2 newterminal > opensees > opensees beam1.tcl
######################################################################

######################################################################
# REFERENCIA
# wipe
# initialise the model...
# build model
# - nodes
# - constrains
# - transformation
# - elements
# - loads
# define analysis...
# run...
######################################################################


# borra todo lo que hay en la memoria
wipe 
#define el modelo basico
model BasicBuilder -ndm 2 -ndf 3 

# coordenadas globales x y z convencionales (de izquierda a derecha, de abajo a arriba, de atrás hacia adelante)
# carga puntual P = -10 kN
set P -10.0 
# longitud de la viga L = 2000 mm
set L 2000.0 
# modulo de elasticidad E = 200 kN/mm2
set E 200.0 
# altura de la viga h = 100 mm
set h 100.0 
# base de la viga b = 50 mm
set b 50.0 

# definir nodos
# nodo id x y 
node 1 0.0 0.0
node 2 [expr $L/2] 0.0
node 3 $L 0.0
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
# definir apoyos
# apoyo id ux uy rotz / 0 libre 1 fijo
fix 1 1 1 0
fix 3 0 1 0

# transformación geométrica
# comando tipo tag
geomTransf Linear 1

# definir elementos
# comando tipo id inicio fin area elasticidad inercia transformación
# A = b*h mm2
# I = b*h^3/1 mm4
element elasticBeamColumn 1  1 2 [expr $b*$h] $E [expr $b*$h*$h*$h/12] 1
element elasticBeamColumn 2  2 3 [expr $b*$h] $E [expr $b*$h*$h*$h/12] 1

# definir la serie de tiempo
# comando tipo tag
timeSeries Linear 1
# distribución de cargas
# comando tipo id tagtimeseries
pattern Plain 1 1 {
    load 2 0.0 $P 0.0
}

# ANÁLISIS
# se define el sistema
system BandSPD
# numberer
numberer RCM
# constraints handler
constraints Plain
# integrator para calcular el paso de tiempo, va a escalar la fuerza en 1.0
integrator LoadControl 1.0
# algortimo
algorithm Newton
# analisis
analysis Static

# RUN
analyze 1

# output

# escribe el desplazamiento en el nodo 2 x y rotz

puts "Desplazamiento horz en el nodo 1 : [format "%.3f" [nodeDisp 1 1]] mm"
puts "Desplazamiento horz en el nodo 2 : [format "%.3f" [nodeDisp 2 1]] mm"
puts "Desplazamiento horz en el nodo 3 : [format "%.3f" [nodeDisp 3 1]] mm"
puts "_____________________"
puts "Desplazamiento vertical en el nodo 1 : [format "%.3f" [nodeDisp 1 2]] mm"
puts "Desplazamiento vertical en el nodo 2 : [format "%.3f" [nodeDisp 2 2]] mm"
puts "Desplazamiento vertical en el nodo 3 : [format "%.3f" [nodeDisp 3 2]] mm"
puts "_____________________"
puts "giro en el nodo 1 : [format "%.3f" [nodeDisp 1 3]]"
puts "giro en el nodo 2 : [format "%.3f" [nodeDisp 2 3]]"
puts "giro en el nodo 3 : [format "%.3f" [nodeDisp 3 3]]"
puts "_____________________"
puts "comparando con la sol analitica"
puts "desp y [expr $P*$L*$L*$L/(48*$E*$b*$h*$h*$h/12)]"
puts "giro en 1 [expr -$P*$L*$L/(16*$E*$b*$h*$h*$h/12)]"
puts "giro en 3 [expr $P*$L*$L/(16*$E*$b*$h*$h*$h/12)]"




# desplazamieno es d = PL^3/(48EI)