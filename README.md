#  ࣪ ˖ Contingencia Estelar ⋆˙⟡

![Portada Contingencia Estelar](cover.png)

#### Juega a Contingencia Estelar [aquí](https://www.autumn64.xyz/contingencia.html).

## Descripción del juego
"Contingencia Estelar" es un videojuego estilo 16-bits lleno de tensión y misterio. 

El jugador ha sido abandonado en un asteroide perdido en el vacío. No ha recibido respuesta. Regresar es imposible. Debe encontrar la manera de sobrevivir. Las enormes criaturas no tardan en mostrar ser indóciles, su traje no resistirá más y le queda poco tiempo antes de que el oxígeno se agote.

¿Sobrevivir significa regresar a casa?

*Desarrollado por Mónica Gómez, Arturo Cervantes y Lilia Dávila.*\
*Foro de Ingeniería UVM 2025*

## Mecánicas implementadas
- Moverse lateralmente: A, D
- Saltar: Espacio
- Atacar: J
- Dash (sólo en diagonal): K

#### Soporte para controles de Xbox, PlayStation y Nintendo Switch incluido.

## Jugador
### Vida y oxígeno
El sistema de vida implementado depende de dos variables: salud, y oxígeno. El oxígeno se va acabando poco a poco y, si este
se agota, entonces el jugador comienza a perder salud. El oxígeno se puede recargar mediante burbujas distribuidas a lo largo
de los niveles del juego.

Una parte de la implementación de esta característica hace uso de eventos, que leen el estado del oxígeno y de la salud, y
ejecutan la acción correspondiente:

```gdscript
func life_events():
	calcular_burbujas()
	calcular_vida()
    # Lee si la salud se agotó
	if life <= 0:
		player_die()
```

## Enemigos
### Biiblet
Bamboleante y bulboso, esta critatura exhibe una extraña adaptación al entorno. Plaga al espacio a pesar de su falta de gracia y resilencia, agitando su cuerpo ante cualquier ser extraño.

Daño: Bajo
Resistencia: Media
Nivel de peligro: Bajo

### Akrita
De reacciones rápidas y agresivas los akrita se han cimentado como un depredador común en el cosmos abierto. Su caracter violento los vuelve sentencias de muerte a cualquiera que encuentre un enjambre de esta especie.

Daño: Medio
Resistencia: Media
Nivel de peligro: Medio

### Ohn-ohn
Criaturas territoriales de aspecto insectoide, viven largas vidas dentro de asteroides devorando sus ingentes materiales. Se teoriza que esta especie no tiene una esperanza de vida específica.

Daño: Alto
Resistencia: Alta
Nivel de peligro: Extremo

## Niveles
Se desarrrollaron 3 níveles haciendo uso de un tilemap con elementos necesarios para construir relieves, plataformas, abismos y elementos del entorno como estrellas y asteroides. Los níveles están situados en un sólo nodo, conforme el jugador avanza la paleta de colores cambia.

#### Todo el código en este repositorio está bajo la [Licencia Pública General Affero de GNU v3 o superior](./LICENSE), con algunas librerías y módulos pudiendo poseer distintas licencias permisivas compatibles con la licencia principal del proyecto. Los tiles, sprites y escenarios están bajo licencia CC BY-NC-SA, mientras que la música está bajo licencia CC BY. Este programa está destinado a su distribución para propósitos no comerciales, y ni la propietaria del proyecto ni sus colaboradores son responsables del uso que cualquiera fuera de éste pueda dar al software proporcionado y a sus insumos.

#### All the code in this repository is licensed under the [GNU Affero General Public License version 3 or later](./LICENSE), with some libraries and modules that may be under different permissive licenses compatible with the main project's license. The tiles, sprites and scenarios are licensed by the CC BY-NC-SA, while the music is under the CC BY license. This program is meant to be distributed for non-commercial purposes, and neither this project's owner nor its contributors are responsible for the use anyone outside of it may give to the software provided and its assets.