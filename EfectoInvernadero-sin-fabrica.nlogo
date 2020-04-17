breed [ clouds cloud]
breed [ sunrays sunray]
breed [ IRs IR ]
breed [ heats heat]
breed [ CO2s CO2]
breed [ static-labels static-label]
breed [ circles circle]

clouds-own [ cloud-num ]
globals [ sky-top earth-top temperature num-CO2 num-clouds starter frozen? sun-brightness albedo]

to startup
  setup
end

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  setup-world
  setup-labels
  show-labels
  set temperature 20  ;
  ; set albedo_var albedo / 100
  ; ask patches [ update-albedo ]
  ; set frozen? false
  set-plot-y-range 0 40
  set-plot-x-range 0 5000
end

to setup-labels
  ; create and place the static labels and create the circles used to label rays and heat
  ; hide them all
  ;create-static-labels 1 [
  ;  setxy 0 0
  ;  set label "Atmosphere"]
  ;create-static-labels 1 [
  ;  setxy 0 Earth-top - .4
  ;  set label "Surface of Earth"]
  ;create-static-labels 1 [
  ;  setxy 0 max-pycor - 1
  ;  set label "Space"]
  ;create-static-labels 1 [
  ;  setxy 0 .8 * min-pycor
  ;  set label "Beneath surface of Earth"]
  ;ask static-labels [ht set size 0]

  create-circles 1 [   ; used to draw attention to a heat dot
     set color magenta set label "Radiación infrarroja"]
  create-circles 1 [   ; used to draw attention to a sunray
     set color yellow set label "Radiación Solar"]
  create-circles 1 [   ; used to draw attention to a IR ray
     set color red set label "Calor"]
  create-circles 1 [   ; used to draw attention to a GhGas
     set color black set label "Gas de efecto invernadero"]
  ask circles [ ht set size 3 set shape "circle 3" ] ; now the circles exist but are hidden.
end

to hide-labels
  ask static-labels [ht]  ; makes the lables invisible
  ask circles [ht]        ; makes the circles and their labels invisible
end

to show-labels              ; this shows all the static labels
                            ; and finds a representative sunray, heat dot, and IR ray
                            ; and circles each and adds a label
                            ; the representative cannot be too close to another or to the edges of its world
  ask static-labels [st]           ; show all the static labels

  let x 0 let y 0
  if any? sunrays [
    ask one-of sunrays [set x xcor set y ycor]
    ask circles with [color = yellow] [    ;place a circle on the sunray and show the circle and its label
      setxy x y st ]]
  let target one-of IRs
  if not (target = nobody) [
    set x [xcor] of target set y [ycor] of target
    ask circles with [color = magenta][
      setxy x y st]]
  set target one-of heats
  if not (target = nobody) [
    set x [xcor] of target set y [ycor] of target
    ask circles with [color = red][
    setxy x y st]]
  set target one-of CO2s
  if not (target = nobody) [
    set x [xcor] of target set y [ycor] of target
    ask circles with [color = black][
    setxy x y st]]
end

to-report good-location?

end


to execute
  hide-labels            ; every cycle all the labels are first hidden and, at the end of the cycle, shown
  wait 10 / (Velocidad_modelo ^ 2 + 15)
  if (starter = 0) [
    set starter 1
    setup-world]
  ask clouds [ fd .3 * (0.1 + (3 + cloud-num) / 10) ]  ; move clouds along
  run-sunshine
  run-heat  ;; moves heat dots
  run-IR    ;; moves the IR arrowheads
  run-CO2   ;; moves CO2 molecules
  every 1 [
    ; if temperature > 0 [ set frozen? "No" set albedo_var albedo / 100 ] ;; the slider controls the albedo above freezing
    ; if temperature < 0 [ set frozen? "YES" set albedo_var .95 ]  ;; if the temperature falls below zero, freeze the earth
    ; remove-CO2 1 + int num-CO2 / 20 ;; remove 5% of the GG molecules away every second
    ; ask patches [ update-albedo ]
    ]
  show-labels             ; if the forever execution loop is stopped, all the labels are on.
  tick
end

to update-albedo
 if (pycor = earth-top) [ set pcolor 50 + 9 * albedo  ]
end

to setup-world
  set albedo .4
  set sun-brightness 1
  set temperature 12
  set sky-top (max-pycor - 5)
  set earth-top (8 + min-pycor)
  ask patches [                           ;; set colors of the world
      if (pycor = max-pycor) [ set pcolor black ]
      if (pycor < max-pycor) and (pycor > sky-top) [
        set pcolor 9 - scale-color white pycor sky-top max-pycor   ]
      if ((pycor <= sky-top) and (pycor > earth-top)) [
        set pcolor blue + 2 * (pycor + max-pycor) / max-pycor  ]
      if (pycor < earth-top) [ set pcolor red + 3 ]
      update-albedo]
   create-heats 20 [ set heading random 360 ;; start with some heat energy in the earth
     setxy min-pxcor + random (max-pxcor - min-pxcor) min-pycor + random (earth-top - min-pycor) ;; scatter throughout earth
     set color 13 + random 4
     set breed heats
     set shape "dot"  ]
   create-sunrays 20  [ set heading 160 set color yellow    ; put in some sunrays
      setxy min-pxcor + random (max-pxcor - min-pxcor)  earth-top + random max-pycor - earth-top ]
     set-plot-y-range 0 40
   ;;; create a single IR so that we can have the appropriate labels at the start of the image
    create-IRs 1 [
        setxy 4 earth-top + 3
        set heading 20;; start the IR off in a random upward direction
        set color magenta
        set shape "default"
    ]
  set-plot-x-range 0 5000
end

to add-cloud            ;; erase clouds and then create new ones
  set num-clouds num-clouds + 1
  setup-clouds num-clouds
end

to remove-cloud
  if (num-clouds > 0 ) [
      set num-clouds num-clouds - 1
      setup-clouds num-clouds ]
end

to setup-clouds [ n ]
  ask clouds [ die ]
  let i 0
  repeat n
     [ make-cloud  i n
     set i i + 1]
end

to make-cloud [ k n ]                   ;; makes cloud number k out of n total
  let width sky-top - earth-top
  let mid ( sky-top + earth-top ) / 2
  let y mid + width * ((k / n) - 0.3 ) - 2  ;; the ratio k/n determines its altitude
  if k = 0 [set y 6 ]
  let x 2 * (random max-pxcor ) + min-pxcor
  repeat 3 + random 20 [ create-clouds 1  ;; lots of turtles make up a cloud
    [set cloud-num k
    setxy x + (random 9) - 4 y + random random 5
    set color white
    set size 2 + random 2
    set heading 90
    Set shape "cloud" ]  ]
end

to run-sunshine
  ask sunrays [
     fd .3    ;; move sunrays forward
     if ((heading = 20) and (ycor = max-pycor)) [ die ] ] ;; kill rays leaving upward
  create-sunshine  ;; start new sun rays from top
  reflect-sunrays-from-clouds  ;; check for reflection off clouds
  encounter-earth   ;; check for reflection off earth and absorbtion
 end

to create-sunshine
  if 10 * sun-brightness > random 50
    [ create-sunrays 1
      [ set heading 160
      set color yellow
      setxy min-pxcor + random (max-pxcor - min-pxcor)  max-pycor ] ] ;; start the sunrays anywhere along the top
end

to reflect-sunrays-from-clouds
 ask sunrays [
    if (count clouds-here > 0 ) [   ;; if sunray shares patch with a cloud
      set heading 180 - heading ]]  ;; turn the sunray around
end

to encounter-earth
  ask sunrays [
    if (ycor <= earth-top) [
      ifelse (100 * albedo > random 100)
          [ set heading 20  ]           ;; reflect
          [ set heading 95 + random 170 ;; morph into heat energy
            set color 13 + random 4
            set breed heats
            set shape "dot"  ]]]
end

to run-heat    ;; advances the heat energy turtles
  set temperature .99 * temperature + .01 * (-5 + .3 * count heats) ;; the temperature is related to the number of heat turtles
  plot temperature
  ask heats [
    fd .5 * ( random 11 ) / 10
    if (ycor <= 0 + min-pycor )[ set heading 70 - random 170 ] ;; if heading into the earth's core, bounce
    if (ycor >= earth-top ) [  ;; if heading back into sky
      ifelse (temperature > -20 + random 200)    ;; select some to escape, more if it is hot
        [ set breed IRs
        set heading -50 + random 100 ;; start the IR off in a random upward direction
        set color magenta
        set shape "default" ]           ;; let them escape as IR with arrowhead shapes
      [ set heading 100 + random 160 ]]] ;; otherwise return them to earth
end

to run-IR
  ask IRs [
    fd .1
    if (ycor >= max-pycor ) [ die ]
    if (ycor <= earth-top ) [   ;; convert to heat
      set breed heats
      set heading 95 + random 170
      set color 13 + random 4
      set shape "dot" ]
    if (count CO2s-here > 0)   ;; check for collision with CO2
      [ set heading random 360 ]] ;; send off in a new direction
end

to add-CO2 [N]  ;; adds 25 CO2 molecules to atmosphere at top of mountain
  let width sky-top - earth-top
  if (num-CO2 < 200) [  ;; stop adding CO2 at 250 molecules--more slow the model too much
    repeat N [
      create-CO2s 1
        [let i random 3
          if i = 0 [set shape "co2"]
          if i = 1 [set shape "molecule water"]
          if i = 2 [set shape "black ball"]
          set color black
          setxy min-pxcor + random (max-pxcor - min-pxcor) (earth-top + 1 + random (sky-top - earth-top) )
          set heading 45 - random 90 ]] ;; heading is used to spin molecule
  set num-CO2 count CO2s ]
end

to remove-CO2 [N] ;; randomly remove 25 CO2 molecules
  set N min (list N num-CO2)
  repeat N [
    if (count CO2s > 0 ) [
      ask one-of CO2s [ die ]]]
  set num-CO2 count CO2s
end

to with-CO2
  if (num-CO2 = 0) [
     add-CO2 100
  ]
  show-labels
end

to without-CO2
  remove-CO2 100
  show-labels
end

to run-CO2
  let d 0
  ask CO2s [
    set heading heading + (random 10) - 5 ;; turn a bit
    fd .02 * (5 + random 10) ;; move forward a bit
    if (ycor <= earth-top + 1) [set heading 45 - random 90 ] ;; bounce off earth
    if (ycor >= sky-top) [set heading 135 + random 90] ] ;; bounce off sky top
end

















@#$#@#$#@
GRAPHICS-WINDOW
279
55
817
420
24
15
10.78
1
10
1
1
1
0
1
1
1
-24
24
-15
15
0
0
0
ticks
30.0

BUTTON
5
55
82
88
Resetear
Setup
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
5
20
86
53
Ejecutar
execute
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
5
89
278
421
Temperatura global
Años
Celsius
0.0
10.0
10.0
20.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" ""

BUTTON
86
20
276
54
Con GEI en atmósfera
with-CO2
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
86
55
276
88
Sin GEI en atmósfera
without-CO2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
280
21
448
54
Velocidad_modelo
Velocidad_modelo
0
100
20
1
1
NIL
HORIZONTAL

BUTTON
450
21
575
54
Seguir rayo
watch one-of sunrays with [ycor > (max-pycor / 2 ) and heading > 90 ]
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
576
21
697
54
Seguir GEI
if num-CO2 > 0 [watch one-of CO2s]
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
698
21
818
54
No seguir GEI
create-sunrays 1 [ watch-me die]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## ¿DE QUE SE TRATA ESTE SIMULADOR?

Este es un modelo de flujo de energía en la tierra. Muestra la tierra de color rosa. En la superficie de la tierra hay una franja verde. Por encima de eso hay una atmósfera azul y un espacio negro en la parte superior. Se pueden agregar nubes y moléculas de CO2 a la atmósfera. Las moléculas de CO2 representan gases de efecto invernadero que bloquean la luz infrarroja que emite la tierra.

## ¿CÓMO FUNCIONA ESTE SIMULADOR?

Las puntas de flecha amarillas fluyen hacia abajo representando la energía de la luz solar. Parte de la luz solar se refleja en las nubes y más todavía puede reflejarse en la superficie de la tierra.

Si la la luz solar es absorbida por la Tierra, se convierte en un punto rojo, que representa la energía térmica. Cada punto representa la energía de una punta de flecha de luz solar amarilla. Los puntos rojos se mueven aleatoriamente alrededor de la tierra. La temperatura de la Tierra está relacionada con el número total de puntos rojos.

A veces, los puntos rojos se transforman en luz infrarroja (IR) que se dirige hacia el espacio, transportando energía. La probabilidad de que un punto rojo se convierta en luz IR depende de la temperatura de la Tierra. Cuando la tierra está fría, pocos puntos rojos causan luz IR; cuando hace calor, la mayoría lo hace. La energía IR está representada por una punta de flecha magenta. Cada uno lleva la misma energía que una punta de flecha amarilla y como un punto rojo. La luz IR atraviesa las nubes pero puede rebotar en las moléculas de CO2.

## ¿CÓMO SE USA ESTE SIMULADOR?

Pueden agregar y eliminar gases de efecto invernadero, representados como moléculas de CO2. El CO2 bloquea la luz IR pero no la luz solar. Los botones suman y restan moléculas en grupos de 25 a 150.

La temperatura de la tierra está relacionada con la cantidad de calor en la tierra. Cuantos más puntos rojos veas, más caliente será.

## COSAS A TENER EN CUENTRA

Sigan una sola punta de flecha de luz solar. Esto es más fácil si reducen la velocidad del modelo utilizando el deslizador en la parte superior del modelo.

Una mejor manera de seguir una punta de flecha es detener el modelo y presionar la tecla control y hacer clic en una punta de flecha, seleccionar el último elemento "tortuga" seguido de un número. Esto abre un submenú donde pueden seleccionar "ver" seguido de un número. Ahora, cuando ejecuten el modelo, verán un círculo alrededor de esa punta de flecha.

¿Qué le sucede a la punta de flecha cuando choca con la tierra? Describir su recorrido posterior. ¿Se escapa de la tierra? ¿Qué pasa entonces? ¿Todas las puntas de flecha siguen caminos similares?


## DETALLES ACERCA DEL MODELO

Existe una relación entre el número de puntos rojos en la tierra y la temperatura de la tierra. Esto se debe a que la temperatura de la tierra aumenta a medida que aumenta la energía térmica total. La energía térmica se agrega por la luz solar que llega a la tierra, así como por la luz infrarroja (IR) reflejada hacia la tierra. La energía térmica es eliminada por el IR emitido por la tierra. El equilibrio de estos determina que la energía en la tierra es proporcional a su temperatura.

Hay, por supuesto, muchas simplificaciones en este modelo. El CO2 absorbe algo de luz visible y parte de la luz IR rebota en las nubes. Ningún modelo es completamente exacto. Lo importante es que un modelo reaccione de alguna manera como el sistema que se supone que debe modelar. Este modelo hace eso, mostrando cómo el efecto invernadero es causado por el CO2 y otros gases que absorben IR.

## CREDITS AND REFERENCES

Creado en Nov 19, 2005 por Robert Tinker para el TELS project. Actualizado Ene 9, 2006.
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

black ball
true
0
Circle -7500403 true true 45 90 120
Circle -7500403 true true 135 90 120

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

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

circle 3
false
0
Circle -7500403 false true 0 0 300
Circle -7500403 false true 15 15 270
Circle -7500403 false true 30 30 240

cloud
false
0
Circle -7500403 true true 13 118 94
Circle -7500403 true true 86 101 127
Circle -7500403 true true 51 51 108
Circle -7500403 true true 118 43 95
Circle -7500403 true true 158 68 134

co2
true
0
Circle -16777216 true false 0 90 120
Circle -16777216 true false 180 90 120
Circle -13345367 true false 75 75 150

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
Circle -7500403 true true 90 75 120

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

molecule water
true
0
Circle -1 true false 183 63 84
Circle -16777216 false false 183 63 84
Circle -7500403 true true 75 75 150
Circle -16777216 false false 75 75 150
Circle -1 true false 33 63 84
Circle -16777216 false false 33 63 84

mountain
false
0
Polygon -6459832 true false 180 30 15 270 285 255
Polygon -6459832 true false 120 45 0 270 300 270
Polygon -1 true false 120 45 150 75 180 30 210 90 225 135 180 105 150 180 135 120 90 150 105 75

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
NetLogo 5.3.1
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
