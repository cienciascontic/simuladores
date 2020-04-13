globals [max-sertanas max-molvas] ;; para que la población no se haga demasiado grande
breed [sertanas sertana]
breed [molvas molva]
breed [cazadores cazador]
sertanas-own [energía enferma?] ;; las sertanas pueden ser afectadas por el virus S1
molvas-own [energía]

to setear
  clear-all
  ask patches [set pcolor brown]
  set max-sertanas 500
  set max-molvas 500
  crecer-pasto-y-yuyos
  set-default-shape sertanas "sertana"
  set-default-shape molvas "molva"
  create-sertanas 3 [
    set enferma? false
    set color white
    set size 5
    setxy random-xcor random-ycor
    set energía random 10  ;empieza con una cantidad de energía al azar
  ]
  create-molvas 2 [
    set color orange
    set size 8
    setxy random-xcor random-ycor
    set energía random 10  ;empieza con una cantidad de energía al azar
  ]
  ;;if virus? [ask one-of sertanas [enfermarse]]
  reset-ticks
end

to crecer-pasto-y-yuyos
  ;; let vel-yuyos 6 ;; entre 0 y 20
  ;; let vel-pasto 10 ;; entre 0 y 20
  ask patches [
    if pcolor = brown [
      if random-float 1000 < yuyos
        [ set pcolor violet ]
      if random-float 1000 < pasto
        [ set pcolor green ]
  ] ]
end

to ejecutar
  if (not any? sertanas OR not any? molvas) [ stop ]
  if count sertanas > max-sertanas [ user-message "Las sertanas han heredado la tierra" stop ]
  if count molvas > max-molvas [ user-message "Las molvas han heredado la tierra" stop ]

  crecer-pasto-y-yuyos

  ask sertanas [
    acciones-sertana
  ]

  ask molvas [acciones-molva]
  ;;ask cazadores [cazar]
  tick
end


; --- NETTANGO BEGIN ---

to acciones-molva
end

;; to molva-encuentra-pasto
;; end

;; to molva-encuentra-yuyos
;; end

;; to sertana-encuentra-pasto
;; end


to acciones-sertana
end


; --- NETTANGO END ---

; ====== BACKUP ===========

;; to molva-moverse  ;; procedimiento de molva
  ;; rt random 50
  ;; lt random 50
  ;; fd 2 ; se mueve el doble de rápido que la sertana
  ;; al moverse consume energía
  ;; set energía energía - 0.7 ;; pero también consume más energía (al moverse más rápido)
;; end

;; to sertana-moverse  ;; procedimiento de sertana
  ;; ifelse enferma?
   ;; [
     ;; let contagiada one-of sertanas-here
      ;; ask contagiada [set color yellow]
  ;; rt random 10 ;; movimientos más lentos que la molva
  ;; lt random 10 ;; movimientos más lentos que la molva
  ;; fd 0.5
  ;; set energía energía - 0.5 ;; al moverse consume energía
  ;; ]
  ;; [
  ;; rt random 25 ;; movimientos más lentos que la molva
  ;; lt random 25 ;; movimientos más lentos que la molva
  ;; fd 1
  ;; set energía energía - 0.5 ;; al moverse consume energía
  ;; ]
;; end

;; to sertana-comer-pasto  ;; procedimiento sertana
  ;; gana unidades de "energía-pasto" al comer pasto
  ;; let energía-pasto 7 ;; entre 0 y 10
  ;; if pcolor = green
  ;; [ set pcolor black
    ;; ifelse enferma?
    ;; [if random 1000 < 10 [set energía energía + energía-pasto]] ;; cuando está enferma no tiene tanto hambre
    ;; [set energía energía + energía-pasto]
  ;; ]
;; end

;; to molva-comer-pasto  ;; procedimiento molva
  ;; gana unidades de "energía-pasto" al comer pasto
  ;; let energía-pasto 7 ;; entre 0 y 10
  ;; if pcolor = green
  ;; [ set pcolor black
    ;; set energía energía + (energía-pasto * 1.2) ] ;; la molva aprovecha mejor los nutrientes que la sertana
;; end

;; to molva-comer-yuyos  ;; procedimiento molva
  ;; gana unidades de "energía-yuyos" al comer yuyos
  ;; let energía-yuyos 3 ;; entre 0 y 10
  ;; if pcolor = violet
  ;; [ set pcolor black
    ;; set energía energía + energía-yuyos ]
;; end

;; to agregar-cazador
 ;; if ticks != 0
 ;; [
  ;; create-cazadores 1 [set shape "cazador furtivo" set size 3 setxy random-xcor random-ycor]
 ;; ]
;; end

;; to cazar ;; procedimiento de cazador
  ;; let presa one-of molvas in-radius 3 ;; si hay una molva en un radio de 3 parcelas, se convierte en presa
  ;; if presa != nobody [ask presa [die]] ;; la presa muere
;; end

;;to enfermarse ;; procedimiento de sertana
  ;; set enferma? true
  ;; set color yellow
;; end

;; to sertana-reproducirse     ;; procedimiento sertana
  ;; da a luz a nueva sertana, pero eso le demanda mucha energía
  ;; let s-umbral-nacim 15 ;; entre 0 y 20
  ;; if energía > s-umbral-nacim
   ;; [ set energía energía / 2
    ;;  hatch 1 [ fd 1 ] ]
;; end

;; to molva-reproducirse     ;; procedimiento molva
  ;; da a luz a nueva molva, pero eso le demanda mucha energía
 ;; let m-umbral-nacim 15 ;; entre 0 y 20
  ;; if energía > m-umbral-nacim
   ;; [ set energía energía / 2
   ;;   hatch 1 [ fd 1 ] ]
;; endc

; ====== FIN DE BACKUP ====



; Copyright 2020 - Florencia Monzón y Cristián Rizzi Iribarren.
; Este modelo fue construido en el marco del trabajo con el Ministerio de Educación del Gobierno de la Ciudada Autónoma de Buenos Aires
; Este modelo está basado en Rabbits-Grass-Weeds de Uri Wilensky, 1997.-
; Gerencia Operativa de Currículum y Programa Enlace Ciencias
; Ver pestaña Info para más detalles sobre la licencia.
@#$#@#$#@
GRAPHICS-WINDOW
35
10
563
347
-1
-1
8.0
1
14
1
1
1
0
1
1
1
-32
32
-20
20
1
1
1
ticks
30.0

BUTTON
573
314
643
347
NIL
setear
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
650
315
731
348
ejecutar
ejecutar
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
573
10
956
301
Poblaciones
Tiempo (años)
Población
0.0
10.0
0.0
111.0
true
true
"set-plot-y-range 0 500" ""
PENS
"sertanas" 1.0 0 -14730904 true "" "plotxy ticks / 100 count sertanas"
"molvas" 1.0 0 -955883 true "" "plotxy ticks / 100 count molvas"

SLIDER
737
315
829
348
pasto
pasto
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
835
315
928
348
yuyos
yuyos
0
10
10.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## ¿QUÉ ES ESTE MODELO?

===== Agregado ===============

Las sertanas son una especie autóctona y las molvas una especie exótica. Las sertanas siempre estuvieron por acá, hasta que vinieron las molvas a complicarles la vida.
Tanto las sertanas como las molvas se mueven, comen, se reproducen, se enferman, se mueren. 
Las molvas se mueven más rápido que las sertanas pero también gastan más energía al moverse, aprovechan mejor los nutrientes que las sertanas (por lo tanto ganan más energía cuando comen pasto) y además tienen la capacidad de comer yuyos, no como las sertanas que solo comen pasto.

Las sertanas pueden enfermarse a través del virus S1 (que no afecta a las molvas). Las sertanas enfermas se mueven más lentamente y no tienen tanto apetito. Pueden tardar hasta un año en recuperarse (aprox. 90 ticks) y luego se vuelven inmunes.

NOTA: 10 años son aproximadamente 900 ticks

====== Fin del agregado ======

Este proyecto explora un ecosistema simple compuesto de sertanas, pasto y yuyos. Las sertanas deambulan al azar, y el pasto y los yuyos crecen al azar. Cuando una sertana se topa con pasto o yuyos, se come el pasto y gana energía. Si la sertana gana suficiente energía, se reproduce. Si no gana suficiente energía, muere.

El pasto y los yuyos se pueden ajustar para crecer a diferentes velocidades y darles a las sertanas diferentes cantidades de energía. El modelo puede usarse para explorar las ventajas competitivas de estas variables.

## CÓMO USAR EL MODELO

Hacer clic en el botón SETEAR para configurar las sertanas (blancas), el pasto (verde) y los yuyos (violeta). Hacer clic en el botón EJECUTAR para comenzar la simulación.

El control deslizante CANTIDAD controla el número inicial de sertanas. El control deslizante UMBRAL-NACIM establece el nivel de energía en el que se reproducen las sertanas. El control deslizante VEL-PASTO controla la velocidad a la que crece el pasto. El control deslizante VEL-YUYOS controla la velocidad a la que crecen los yuyos.

La configuración predeterminada del modelo es tal que al principio los yuyos no están presentes (vel-yuyos = 0, energía-yuyos = 0). Esto es para que se pueda observar la interacción de solo sertanas y pasto. Una vez visto esto, se puede entonces comenzar a explorar el efecto de los yuyos.

## UNA PRIMERA APROXIMACIÓN AL MODELO

Observar el monitor CANT-SERTANAS y el gráfico POBLACIONES para ver cómo cambia la población de sertanas con el tiempo. Al principio, no hay suficiente pasto para las sertanas, y muchas sertanas mueren. Pero eso permite que el pasto crezca más libremente, proporcionando abundancia de alimentos para las sertanas restantes. Las sertanas ganan energía y se reproducen. La abundancia de sertanas conduce a una escasez de pasto, y el ciclo comienza de nuevo.

La población de sertanas pasa por una oscilación amortiguada, eventualmente estabilizándose en un rango estrecho. La cantidad total de pasto también oscila, fuera de fase con la población de sertanas.

Estas oscilaciones duales son características de los sistemas predador-presa. Dichos sistemas generalmente se describen mediante un conjunto de ecuaciones diferenciales conocidas como ecuaciones de Lotka-Volterra. NetLogo proporciona una nueva forma de estudiar los sistemas de predador-presa y otros ecosistemas.

## COSAS A EXPLORAR

Dejando fijos los otros parámetros, cambiar la tasa de crecimiento del pasto y dejar que el sistema se estabilice nuevamente. ¿Esperarían que ahora hubiera más pasto? ¿Más sertanas?

Cambiar solo el umbral de nacimiento de los sertanas. ¿Cómo afecta esto a los niveles estables de sertanas y pasto?

Con la configuración actual, la población de sertanas pasa por una oscilación amortiguada. Al cambiar los parámetros, ¿pueden lograr una oscilación no amortiguada? ¿O una oscilación inestable?

En la versión actual, cada sertana tiene el mismo umbral de nacimiento. ¿Qué pasaría si cada sertana tuviera un umbral de nacimiento diferente? ¿Qué pasaría si el umbral de nacimiento de cada nueva sertana fuera ligeramente diferente del umbral de nacimiento de su progenitor? ¿Cómo evolucionarían los valores del umbral de nacimiento con el tiempo?

Ahora agreguen malezas haciendo que los controles deslizantes VEL-YUYOS valgan lo mismo que VEL-PASTO y ENERGÍA-YUYOS lo mismo que ENERGÍA-PASTO. Tener en cuenta que la cantidad de pasto y yuyos es casi la misma.

Ahora hagan crecer el pasto y los yuyos a diferentes velocidades. ¿Qué sucede?

¿Qué pasa si los yuyos crecen al mismo ritmo que el pasto, pero dan menos energía a los sertanas cuando los comen (ENERGÍA-YUYOS es menor que ENERGÍA-PASTO)?

Piensen en otras formas en que dos especies de plantas pueden diferir y pruébenlas para ver qué sucede con sus poblaciones relativas. Por ejemplo, ¿qué pasaría si un yuyo pudiera crecer donde ya había pasto, pero el pasto no pudiera crecer donde había yuyos? ¿Qué pasa si las sertanas prefieren la planta que les dio más energía?

Ejecuten el modelo por un momento, luego cambien repentinamente el umbral de nacimiento a cero. ¿Qué sucede?


## CARACTERÍSTICAS DE NETLOGO

Observar que cada parcela negra tiene una probabilidad aleatoria de que crezcan pasto o yuyos en cada turno, utilizando la regla:

    if random-float 1000 < vel-yuyos
      [ set pcolor violet ]
    if random-float 1000 < vel-pasto
      [ set pcolor green ]

## MODELOS RELACIONADOS

El modelo Wolf Sheep Predation es otro ecosistema con diferentes reglas.

## CÓMO CITAR ESTE MODELO

Si mencionan este modelo o el software NetLogo en una publicación, por favor incluyan la cita de acá abajo.

Para el modelo solo:

* Monzón, F.; Rizzi Iribarren, C. (2020). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Citar el software NetLogo de esta manera:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT Y LICENCIAS

Copyright 2020 Cristián Rizzi Iribarren y Florencia Monzón.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

Este trabajo está bajo la licencia Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  Para ver una copia de esta licencia, visitar https://creativecommons.org/licenses/by-nc-sa/3.0/ o enviar una carta a Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

También hay licencias comerciales disponibles. Para saber más sobre licencias comerciales, por favor contactar a Uri Wilensky en uri@northwestern.edu.

Este modelo fue creado como parte del trabajo: 
SECUENCIAS DIDÁCTICAS ED CIENCIAS, GERENCIA OPERATIVA DE CURRICULUM Y ENLACE CIENCIAS, MINISTERIO DE EDUCACIÓN DEL GOBIERNO DE LA CIUDAD AUTÓNOMA DE BUENOS AIRES.

Este modelo está basado en el modelo Rabbits-Grass-Weeds de Uri Wilensky, 1997, el cual, a su vez fue desarrollado en el marco del siguiente proyecto:

PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227.

* Wilensky, U. (2001).  NetLogo Rabbits Grass Weeds model.  http://ccl.northwestern.edu/netlogo/models/RabbitsGrassWeeds.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

<!-- 2001 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

cazador furtivo
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

molva
false
0
Polygon -7500403 true true 90 225 45 255 30 210 45 180 60 165 60 150 45 120 45 75 15 30 45 15 75 30 105 45 165 15 195 30 180 60 165 90 165 120 150 135 165 120 150 165 180 210 180 255 135 225
Circle -16777216 true false 74 78 24
Circle -16777216 true false 119 78 24
Line -16777216 false 90 120 90 150
Line -16777216 false 105 120 105 150
Line -16777216 false 120 120 120 150
Line -16777216 false 135 120 135 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rabbit
false
0
Circle -7500403 true true 76 150 148
Polygon -7500403 true true 176 164 222 113 238 56 230 0 193 38 176 91
Polygon -7500403 true true 124 164 78 113 62 56 70 0 107 38 124 91

sertana
false
0
Polygon -7500403 true true 75 150 90 195 210 195 225 150 255 120 255 45 180 0 120 0 45 45 45 120
Circle -16777216 true false 165 60 60
Circle -16777216 true false 75 60 60
Polygon -7500403 true true 225 150 285 195 285 285 255 300 255 210 180 165
Polygon -7500403 true true 75 150 15 195 15 285 45 300 45 210 120 165
Polygon -7500403 true true 210 210 225 285 195 285 165 165
Polygon -7500403 true true 90 210 75 285 105 285 135 165
Rectangle -7500403 true true 135 165 165 270

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
