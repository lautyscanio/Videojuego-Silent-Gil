# Guía para pasar los cambios nuevos al repo oficial

Esta guía divide todo lo nuevo (la versión avanzada) en **7 commits** para ir incorporándolos de a poco al repo oficial. Cada commit se puede hacer en una compu distinta, uno después del otro, y **después de cada uno el juego se abre y funciona**.

- Repo oficial: `https://github.com/SOrtiz1967/Silent-Gil-Proyecto-Final`
- Repo avanzado (de donde se copian los archivos): `https://github.com/lautyscanio/Videojuego-Silent-Gil`, rama `reestructuracion`, commit `a334d3a`.

Los 7 commits se probaron en un clon del oficial, uno por uno: el juego abre sin errores en cada paso y, al terminar el 7, el proyecto queda igual que el avanzado.

| # | Commit | Qué entra |
|---|---|---|
| 1 | Estructura de carpetas | escenas por tema, scripts en `snake_case`. No cambia el código |
| 2 | Scripts nuevos | todos los scripts reescritos, enemigos con aviso/aturdimiento, jugador con pistola, hamburguesas y ayuda (H) |
| 3 | Objetivo en pantalla | cartel de objetivo, controles en el menú de pausa |
| 4 | Personajes nuevos | Cliente, Guarda, aparición de bichos y pathfinding |
| 5 | Piezas nuevas del mapa | escondites, bengalas, entradas de nivel, teletransporte, tren fantasma y texturas |
| 6 | Niveles nuevos | comisaría, celda, subte, estación que no existe y casa |
| 7 | Plaza y McDonald's | se conectan con los niveles nuevos + README e historia |

## Antes de empezar (una sola vez por compu)

```
git clone https://github.com/SOrtiz1967/Silent-Gil-Proyecto-Final.git
cd Silent-Gil-Proyecto-Final
git remote add avanzado https://github.com/lautyscanio/Videojuego-Silent-Gil.git
git fetch avanzado
git cat-file -t a334d3a
```

El último comando tiene que imprimir `commit`. Si ya tenían el oficial clonado, solo hacen los 3 últimos.

Reglas para todos los commits:

1. **Un commit por vez y en orden.** Antes de empezar el siguiente, el anterior tiene que estar mergeado en `main` del oficial y cada uno hace `git pull`.
2. **Usar siempre los `git add` de esta guía**, nunca `git add .` ni `git add -A` solos. Cuando Godot abre el proyecto modifica archivos `.import` y no queremos subirlos.
3. Los archivos se traen del avanzado con `git checkout a334d3a -- <archivos>`. Es una copia exacta del archivo de ese commit.
4. Después de cada paso hay que abrir el proyecto en Godot, apretar F5 y probar lo que dice "Probar".
5. Los scripts de Python (commits 1 y 2) se guardan **fuera** de la carpeta del repo (por ejemplo en el Escritorio) y se ejecutan parados en la raíz del repo. Así no hace falta commitearlos.

El flujo de ramas es el mismo de siempre: rama nueva desde `main`, push, Pull Request y que otro del equipo lo revise.

---

## Commit 1: estructura de carpetas

**Qué hace:** mueve cada escena a una carpeta por tema y pasa los nombres de archivo a `snake_case`. No cambia ni una línea de código, solo las rutas `res://`.

```
escenas/niveles/        nivel_1, nivel_mc
escenas/niveles/mapas/  estacion_visual, plaza_visual
escenas/jugador/        jugador, proyectil
escenas/enemigos/       enemigo
escenas/objetos/        consumible, objeto_clave, cartel, piedra, powerbank, punto_carga, farola
escenas/mundo/          puerta, zona_tutorial, tren
escenas/interfaz/       inventario, tutorial, menu_pausa
escenas/minijuegos/     cerradura, pernos
escenas/pruebas/        principal
scripts/                (sigue plano) objetoClave.gd pasa a objeto_clave.gd, entradaNivel.gd a entrada_nivel.gd,
                        puntoCarga.gd a punto_carga.gd, zonaTutorial.gd a zona_tutorial.gd
docs/                   TP_Investigacion_Pre_Viaje_Scanio.docx (estaba en la raíz)
```

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/01-estructura
```

Guardar el script `migrar_estructura.py` (más abajo) fuera del repo y correrlo desde la raíz del repo:

```
python C:\ruta\donde\lo\guardaron\migrar_estructura.py .
```

Tiene que imprimir `archivos con rutas actualizadas: 10` y `archivos movidos/renombrados: 69`. Si imprime `falta en la tabla: ...` es que el oficial tiene una escena que no estaba cuando se armó la guía (avisen).

Abrir el proyecto en Godot, F5 y probar.

```
git add -A -- escenas scripts docs project.godot TP_Investigacion_Pre_Viaje_Scanio.docx
git status
git commit -m "estructura de carpetas: escenas agrupadas por tema y scripts en snake_case"
git push origin reestructura/01-estructura
```

`git status` tiene que mostrar solo renombres (`renamed`) y 3 archivos modificados: `project.godot`, `scripts/enemigo.gd` y `scripts/jugador.gd` (cambian los `preload` por las rutas nuevas).

**Probar:** el juego abre, la intro del tren funciona, se camina, se agarra la SUBE y se pasan los molinetes. Tiene que ser idéntico a antes.

<details>
<summary><code>migrar_estructura.py</code></summary>

```python
"""Commit 1: mueve las escenas a escenas/<tema>/ y pasa los nombres de archivo a snake_case.
No cambia ni una linea de codigo, solo rutas res://.
uso (desde la raiz del repo oficial):  python migrar_estructura.py ."""
import os
import re
import shutil
import sys

RAIZ = sys.argv[1] if len(sys.argv) > 1 else "."


def snake(n):
    return re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", n).lower()


CARPETAS = {
    "niveles": ["nivel_1", "nivel_mc"],
    "niveles/mapas": ["estacion_visual", "plaza_visual"],
    "jugador": ["jugador", "proyectil"],
    "enemigos": ["enemigo"],
    "objetos": ["consumible", "objetoClave", "cartel", "piedra", "powerbank", "puntoCarga", "farola"],
    "mundo": ["puerta", "zonaTutorial", "tren"],
    "interfaz": ["inventario", "tutorial", "menu_pausa"],
    "minijuegos": ["cerradura", "pernos"],
    "pruebas": ["principal"],
}

mapa = {}
for carpeta, nombres in CARPETAS.items():
    for n in nombres:
        mapa["escenas/%s.tscn" % n] = "escenas/%s/%s.tscn" % (carpeta, snake(n))
for f in os.listdir(os.path.join(RAIZ, "scripts")):
    if f.endswith((".gd", ".gd.uid")):
        mapa["scripts/" + f] = "scripts/" + snake(f)

# todo lo que hay en escenas/ tiene que estar en la tabla
for f in os.listdir(os.path.join(RAIZ, "escenas")):
    if f.endswith(".tscn") and "escenas/" + f not in mapa:
        sys.exit("falta en la tabla: escenas/" + f)

patron = re.compile(r"res://((?:escenas|scripts)/[A-Za-z0-9_]+\.(?:tscn|gd))")


def reemplazo(m):
    viejo = m.group(1)
    if viejo not in mapa:
        print("referencia rota:", viejo)
        return m.group(0)
    return "res://" + mapa[viejo]


tocados = 0
for base, dirs, files in os.walk(RAIZ):
    dirs[:] = [d for d in dirs if d not in (".git", ".godot", "silent-gil", "assets")]
    for f in files:
        if f.endswith((".tscn", ".gd", ".godot", ".tres")):
            ruta = os.path.join(base, f)
            txt = open(ruta, encoding="utf-8", newline="").read()
            nuevo = patron.sub(reemplazo, txt)
            if nuevo != txt:
                open(ruta, "w", encoding="utf-8", newline="").write(nuevo)
                tocados += 1
print("archivos con rutas actualizadas:", tocados)

for viejo, nuevo in mapa.items():
    if viejo == nuevo:
        continue
    origen = os.path.join(RAIZ, viejo)
    if not os.path.exists(origen):
        continue
    destino = os.path.join(RAIZ, nuevo)
    os.makedirs(os.path.dirname(destino), exist_ok=True)
    shutil.move(origen, destino)

docx = os.path.join(RAIZ, "TP_Investigacion_Pre_Viaje_Scanio.docx")
if os.path.exists(docx):
    os.makedirs(os.path.join(RAIZ, "docs"), exist_ok=True)
    shutil.move(docx, os.path.join(RAIZ, "docs", "TP_Investigacion_Pre_Viaje_Scanio.docx"))
print("archivos movidos/renombrados:", len(mapa))
```

</details>

---

## Commit 2: scripts nuevos

**Qué hace:** reemplaza todos los scripts por las versiones nuevas (nombres en `snake_case`, handlers `_on_...`, `recibir_daño`, comentarios, `enum` en el tren) y actualiza las escenas para que coincidan con los nombres.

Cambios de código que entran junto con la reescritura (todavía no se usan en el mapa hasta los commits siguientes):

- **Enemigo** (`enemigo.gd`): `class_name Enemigo`, avisa antes de pegar (se pone rojo medio segundo), se aturde y es empujado cuando le pegan, puede perseguir solo si el jugador tiene la linterna prendida, usa el pathfinding si el nivel lo tiene y puede soltar una llave al morir.
- **Jugador** (`jugador.gd`): tecla `C` para comer hamburguesas, disparo de bengalas con la pistola, golpe de 32 px (antes 24), cartel de ayuda con `H`.
- **Inventario** (`inventario.gd`): hamburguesas, pistola y bengalas en el inventario.
- **Tutorial** (`tutorial.gd`): textos nuevos (hamburguesa, fin, ayuda). Los textos se buscan por nombre (`texto_` + id).
- **Niveles**: `nivel.gd` (`class_name Nivel`) acomoda al jugador y muestra el texto de historia del nivel. `nivel_1.gd` hereda de él y `nivel_mc` pasa a usar `nivel.gd` (se borra `nivel_mc.gd`).
- **Objetos**: `objeto_clave.gd` muestra un sprite propio para la SUBE, el silbato y las ganzúas.
- **Input**: `mover_arriba/abajo/izquierda/derecha` pasan a `arriba/abajo/izquierda/derecha`, `golpear` pasa a `atacar` y aparecen `comer` (C) y `ayuda` (H).
- Regla del equipo: las variables `@export` **sin ñ** (`dano`, no `daño`). Godot no guarda bien en el `.tscn` las propiedades con ñ.

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/02-scripts
```

1. Traer los archivos del avanzado (todo en una línea):

```
git checkout a334d3a -- scripts/cambio_nivel.gd scripts/cambio_nivel.gd.uid scripts/cartel.gd scripts/cartel.gd.uid scripts/cerradura.gd scripts/cerradura.gd.uid scripts/consumible.gd scripts/consumible.gd.uid scripts/enemigo.gd scripts/enemigo.gd.uid scripts/entrada_nivel.gd scripts/entrada_nivel.gd.uid scripts/escalera.gd scripts/escalera.gd.uid scripts/farola.gd scripts/farola.gd.uid scripts/inventario.gd scripts/inventario.gd.uid scripts/jugador.gd scripts/jugador.gd.uid scripts/luz_parpadeo.gd scripts/luz_parpadeo.gd.uid scripts/menu_pausa.gd scripts/menu_pausa.gd.uid scripts/nivel.gd scripts/nivel.gd.uid scripts/nivel_1.gd scripts/nivel_1.gd.uid scripts/objeto_clave.gd scripts/objeto_clave.gd.uid scripts/pernos.gd scripts/pernos.gd.uid scripts/piedra.gd scripts/piedra.gd.uid scripts/proyectil.gd scripts/proyectil.gd.uid scripts/puerta.gd scripts/puerta.gd.uid scripts/punto_carga.gd scripts/punto_carga.gd.uid scripts/tren.gd scripts/tren.gd.uid scripts/tutorial.gd scripts/tutorial.gd.uid scripts/zona_tutorial.gd scripts/zona_tutorial.gd.uid escenas/jugador/bengala.tscn escenas/jugador/jugador.tscn assets/ganzua.svg assets/ganzua.svg.import assets/silbato.svg assets/silbato.svg.import assets/sube.svg assets/sube.svg.import project.godot
```

2. Borrar el script viejo del McDonald's:

```
git rm scripts/nivel_mc.gd scripts/nivel_mc.gd.uid
```

3. Abrir `project.godot` con un editor de texto y **borrar la línea** `Objetivo="*res://escenas/interfaz/objetivo.tscn"` de la sección `[autoload]` (esa escena entra en el commit 3). Lo demás del archivo (las acciones de input nuevas) se queda.

4. Correr el script `migrar_nombres.py` (más abajo) desde la raíz del repo. Renombra en los `.tscn` las propiedades (por ejemplo `rutaTextura` a `ruta_textura`, `idLlaveRequerida` a `llave_requerida`), los métodos de las conexiones de señales (`alEntrarCuerpo` a `_on_body_entered`) y cambia el script de `nivel_mc` por `nivel.gd`:

```
python C:\ruta\donde\lo\guardaron\migrar_nombres.py .
```

Tiene que imprimir `escenas modificadas: 11`.

5. Abrir Godot, F5 y probar. Después:

```
git add -A -- scripts escenas assets/ganzua.svg assets/ganzua.svg.import assets/silbato.svg assets/silbato.svg.import assets/sube.svg assets/sube.svg.import project.godot
git status
git commit -m "scripts en snake_case y estilo propio, enemigos con aviso y aturdimiento, jugador con pistola, hamburguesas y ayuda"
git push origin reestructura/02-scripts
```

`git status` tiene que mostrar solo cambios en `scripts/`, `escenas/`, `project.godot` y los 3 sprites nuevos (`ganzua`, `silbato`, `sube`).

**Probar:** se camina con WASD y flechas, Espacio golpea, `E` tira piedras, `F` agarra la SUBE y pasa los molinetes, `T` abre el inventario, `Q` la linterna, `H` abre los controles, `Esc` la pausa. Los vagabundos ahora se ponen rojos medio segundo antes de pegar y retroceden cuando les pegás. Ojo: el texto de la intro ya menciona el objetivo en pantalla, que aparece en el commit 3.

<details>
<summary><code>migrar_nombres.py</code></summary>

```python
"""Commit 2: renombra en los .tscn las propiedades exportadas y los metodos de las conexiones,
para que coincidan con los scripts nuevos (snake_case).
Tambien cambia el script de nivel_mc por nivel.gd.
uso (desde la raiz del repo oficial):  python migrar_nombres.py ."""
import os
import re
import sys

RAIZ = sys.argv[1] if len(sys.argv) > 1 else "."

# nombres que no salen de pasar camelCase a snake_case a secas
ESPECIALES = {
    "idLlaveRequerida": "llave_requerida",
    "idLlaveExtra": "llave_extra",
    "idTutorialPersonalizado": "tutorial_propio",
    "idTutorialAlAbrir": "tutorial_al_abrir",
    "forzarSiNoHayLlave": "forzar_sin_llave",
    "idLlaveBotin": "llave_botin",
    "idLlaveDisparadora": "llave_disparadora",
}


def snake(n):
    return re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", n).lower()


def nuevo(n):
    return ESPECIALES.get(n, snake(n))


METODOS = {
    "alEntrarCuerpo": "_on_body_entered",
    "alSalirCuerpo": "_on_body_exited",
    "ocultarMensaje": "_on_temporizador_mensaje_timeout",
}

prop = re.compile(r"^([a-z][A-Za-z0-9]*) = ", re.M)
conexion = re.compile(r'^(\[connection signal="[^"]*" from="[^"]*" to="[^"]*" method=")([^"]*)("\]\r?)$', re.M)

total = 0
for base, dirs, files in os.walk(os.path.join(RAIZ, "escenas")):
    for f in files:
        if not f.endswith(".tscn"):
            continue
        ruta = os.path.join(base, f)
        txt = open(ruta, encoding="utf-8", newline="").read()
        t2 = prop.sub(lambda m: nuevo(m.group(1)) + " = " if re.search(r"[A-Z]", m.group(1)) else m.group(0), txt)
        t2 = conexion.sub(lambda m: m.group(1) + METODOS.get(m.group(2), m.group(2)) + m.group(3), t2)
        # el golpe del jugador ya no tiene el print de debug
        t2 = re.sub(r'^\[connection signal="area_entered" from="ZonaGolpe"[^\n]*\n', "", t2, flags=re.M)
        if f == "nivel_mc.tscn":
            t2 = t2.replace('path="res://scripts/nivel_mc.gd"', 'path="res://scripts/nivel.gd"')
        if t2 != txt:
            open(ruta, "w", encoding="utf-8", newline="").write(t2)
            total += 1
print("escenas modificadas:", total)
```

</details>

---

## Commit 3: objetivo en pantalla

**Qué hace:** suma el cartel de objetivo de arriba a la derecha (dice qué hacer y hacia dónde queda, y se actualiza solo según las llaves que se tengan), agrega los controles al menú de pausa y agranda el cuadro de texto del tutorial.

| Archivo | Cambio |
|---|---|
| `scripts/objetivo.gd` y `.uid` | nuevo |
| `escenas/interfaz/objetivo.tscn` | nueva |
| `escenas/interfaz/menu_pausa.tscn` | agrega el texto `Controles` debajo de los botones |
| `escenas/interfaz/tutorial.tscn` | el cuadro de texto es más alto |
| `project.godot` | autoload `Objetivo` |

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/03-objetivo
git checkout a334d3a -- scripts/objetivo.gd scripts/objetivo.gd.uid escenas/interfaz/objetivo.tscn escenas/interfaz/menu_pausa.tscn escenas/interfaz/tutorial.tscn project.godot
```

Abrir Godot, F5 y probar. Después:

```
git add scripts/objetivo.gd scripts/objetivo.gd.uid escenas/interfaz/objetivo.tscn escenas/interfaz/menu_pausa.tscn escenas/interfaz/tutorial.tscn project.godot
git status
git commit -m "objetivo en pantalla con la direccion a seguir, controles en el menu de pausa y tutorial mas grande"
git push origin reestructura/03-objetivo
```

El `project.godot` que se trae es el final: a esta altura solo se agrega la línea `Objetivo=...`.

**Probar:** arriba a la derecha dice "OBJETIVO: Buscá la SUBE..." con la dirección y la distancia; cambia al agarrarla. La pausa (`Esc`) muestra los controles.

---

## Commit 4: personajes nuevos

**Qué hace:** suma los scripts de los personajes y sistemas nuevos. Todavía no aparecen en el mapa (se colocan en los niveles de los commits 6 y 7).

| Archivo | Qué es |
|---|---|
| `scripts/cliente.gd` | El Cliente del McDonald's (hereda de `Enemigo`): tiene la llave del subte, te la da a cambio de 3 hamburguesas, pelea a muerte si te comés una |
| `scripts/guarda.gd` | El Guarda: con linterna te ve de lejos, a oscuras camina hacia donde vio tu luz, si le pegás toca el silbato |
| `scripts/aparicion.gd` | hace aparecer bichos cuando el jugador consigue cierta llave (los de la cocina del Mc) |
| `scripts/pathfinding.gd` | grilla A* con las colisiones del nivel, para que los enemigos rodeen paredes |

(cada uno con su `.gd.uid`)

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/04-personajes
git checkout a334d3a -- scripts/cliente.gd scripts/cliente.gd.uid scripts/guarda.gd scripts/guarda.gd.uid scripts/aparicion.gd scripts/aparicion.gd.uid scripts/pathfinding.gd scripts/pathfinding.gd.uid
git add scripts/cliente.gd scripts/cliente.gd.uid scripts/guarda.gd scripts/guarda.gd.uid scripts/aparicion.gd scripts/aparicion.gd.uid scripts/pathfinding.gd scripts/pathfinding.gd.uid
git status
git commit -m "cliente, guarda, aparicion de bichos y pathfinding para los enemigos"
git push origin reestructura/04-personajes
```

**Probar:** el proyecto abre sin errores en la consola de Godot (los scripts nuevos compilan). El juego se ve igual que en el commit 3.

---

## Commit 5: piezas nuevas del mapa

**Qué hace:** suma las escenas y scripts que usan los niveles nuevos, más las texturas.

| Archivo | Qué es |
|---|---|
| `scripts/escondite.gd` y `escenas/objetos/escondite.tscn` | lugares donde está escondida una hamburguesa (F para revisar) |
| `scripts/bengalas.gd` y `escenas/objetos/bengalas.tscn` | caja de bengalas; la primera vez da la pistola |
| `assets/pistola_bengalas.svg` y `.import` | sprite de la caja |
| `escenas/mundo/entrada_nivel.tscn` (el script ya existía) | puerta para pasar de un nivel a otro |
| `scripts/teletransporte.gd` y `escenas/mundo/teletransporte.tscn` | zonas que te mandan a otro punto (puertas falsas y túnel de la estación que no existe) |
| `scripts/zona_mensaje.gd` y `escenas/mundo/zona_mensaje.tscn` | muestra un mensaje una vez al entrar |
| `scripts/tren_fantasma.gd` | el tren vacío que cruza el subte (usa `enum estado`) |
| `assets/texturas/` | 11 texturas de los niveles (con sus `.import`) |

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/05-piezas-mapa
git checkout a334d3a -- scripts/escondite.gd scripts/escondite.gd.uid escenas/objetos/escondite.tscn scripts/bengalas.gd scripts/bengalas.gd.uid escenas/objetos/bengalas.tscn assets/pistola_bengalas.svg assets/pistola_bengalas.svg.import escenas/mundo/entrada_nivel.tscn scripts/teletransporte.gd scripts/teletransporte.gd.uid escenas/mundo/teletransporte.tscn scripts/zona_mensaje.gd scripts/zona_mensaje.gd.uid escenas/mundo/zona_mensaje.tscn scripts/tren_fantasma.gd scripts/tren_fantasma.gd.uid assets/texturas
git add scripts/escondite.gd scripts/escondite.gd.uid escenas/objetos/escondite.tscn scripts/bengalas.gd scripts/bengalas.gd.uid escenas/objetos/bengalas.tscn assets/pistola_bengalas.svg assets/pistola_bengalas.svg.import escenas/mundo/entrada_nivel.tscn scripts/teletransporte.gd scripts/teletransporte.gd.uid escenas/mundo/teletransporte.tscn scripts/zona_mensaje.gd scripts/zona_mensaje.gd.uid escenas/mundo/zona_mensaje.tscn scripts/tren_fantasma.gd scripts/tren_fantasma.gd.uid assets/texturas
git status
git commit -m "piezas nuevas del mapa: escondites, bengalas, entrada de nivel, teletransporte, tren fantasma y texturas"
git push origin reestructura/05-piezas-mapa
```

`git status` tiene que mostrar 39 archivos nuevos, todos de la lista (las texturas son 11 `.png` y 11 `.png.import`).

**Probar:** abre sin errores. Se pueden instanciar las escenas nuevas en `escenas/pruebas/principal.tscn` si quieren verlas sueltas. El juego se ve igual.

---

## Commit 6: niveles nuevos

**Qué hace:** suma los 5 niveles nuevos. Todavía no se llega a ellos desde la plaza (eso es el commit 7), pero se pueden abrir y jugar desde Godot.

| Escena | Qué es |
|---|---|
| `escenas/niveles/nivel_3.tscn` | comisaría (opcional), tiene la pistola de bengalas |
| `escenas/niveles/nivel_3_celda.tscn` | la celda: se sale sacando los pernos de la rejilla |
| `escenas/niveles/nivel_5.tscn` | subte Línea C: pálidos, tren vacío, llave de servicio |
| `escenas/niveles/nivel_6.tscn` | la estación que no existe: puertas falsas, túnel, el Guarda |
| `escenas/niveles/nivel_7.tscn` | la casa (final) |

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/06-niveles
git checkout a334d3a -- escenas/niveles/nivel_3.tscn escenas/niveles/nivel_3_celda.tscn escenas/niveles/nivel_5.tscn escenas/niveles/nivel_6.tscn escenas/niveles/nivel_7.tscn
git add escenas/niveles/nivel_3.tscn escenas/niveles/nivel_3_celda.tscn escenas/niveles/nivel_5.tscn escenas/niveles/nivel_6.tscn escenas/niveles/nivel_7.tscn
git status
git commit -m "niveles nuevos: comisaria, celda, subte, estacion que no existe y casa"
git push origin reestructura/06-niveles
```

**Probar:** abrir cada nivel en Godot (doble clic en la escena) y apretar F6 para correr esa escena sola. Se ve oscuro (es a propósito), con la linterna se ve mejor, y el objetivo de arriba aparece con el texto de cada nivel. El juego normal (F5) sigue empezando en `nivel_1` y se ve igual.

---

## Commit 7: plaza y McDonald's conectados + documentación

**Qué hace:** reemplaza `nivel_1` y `nivel_mc` por las versiones nuevas. Con esto el recorrido completo queda jugable de punta a punta.

| Archivo | Cambio |
|---|---|
| `escenas/niveles/nivel_1.tscn` | entradas a la comisaría y al subte, niebla en las avenidas, carteles nuevos, más piedras, texturas, nodo `Pathfinding` |
| `escenas/niveles/nivel_mc.tscn` | el Cliente, los 3 escondites, el powerbank en la oficina, los bichos de la cocina, carteles, luces y oscuridad, `Pathfinding`, texto de historia del nivel |
| `escenas/niveles/mapas/estacion_visual.tscn` | color de ambiente más oscuro |
| `README.md` | nueva estructura de carpetas, convenciones, controles, recorrido y tablas de llaves |
| `docs/historia.md` | borrador de la historia |

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/07-plaza-y-mcdonalds
git checkout a334d3a -- escenas/niveles/nivel_1.tscn escenas/niveles/nivel_mc.tscn escenas/niveles/mapas/estacion_visual.tscn README.md docs/historia.md
git add escenas/niveles/nivel_1.tscn escenas/niveles/nivel_mc.tscn escenas/niveles/mapas/estacion_visual.tscn README.md docs/historia.md
git status
git commit -m "plaza y mcdonalds conectados con los niveles nuevos, readme con la estructura y la historia"
git push origin reestructura/07-plaza-y-mcdonalds
```

**Probar (recorrido completo):** intro del tren, SUBE, molinetes, llave del Mc, McDonald's (hablar con el Cliente, buscar hamburguesas, powerbank, los bichos), reja del subte, subte (tren vacío, llave de servicio), estación que no existe (Guarda, silbato, SUBE), casa. Opcional: la comisaría, abajo a la derecha de la plaza.

---

## Comprobación final

Cuando los 7 commits estén mergeados en `main` del oficial, esto no tiene que mostrar diferencias de código (solo puede haber diferencias en archivos `.import` y en finales de línea):

```
git fetch avanzado
git diff --stat a334d3a main -- escenas scripts project.godot README.md docs/historia.md
```

## Si algo falla

- **Godot dice "Failed to load script" o "Node not found"**: casi siempre falta algún archivo de la lista del commit o se copió en la carpeta equivocada. Revisar con `git status`.
- **Una propiedad de una escena aparece en su valor por defecto**: no se corrió `migrar_nombres.py` (commit 2).
- **`git checkout a334d3a -- ...` dice `pathspec ... did not match`**: falta hacer `git fetch avanzado`, o se escribió mal un nombre.
- **Godot modificó archivos `.import` y aparecen en `git status`**: no los agreguen, se descartan con `git restore <archivo>`.
