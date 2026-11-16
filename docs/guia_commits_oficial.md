# Guía para pasar los cambios nuevos al repo oficial

Esta guía divide lo que le falta al repo oficial en commits chicos, para ir incorporándolos de a poco. Cada commit se puede hacer en una compu distinta y **después de cada uno el juego se abre y funciona**.

- Repo oficial: `https://github.com/SOrtiz1967/Silent-Gil-Proyecto-Final`
- Repo avanzado (de donde se copian los archivos): `https://github.com/lautyscanio/Videojuego-Silent-Gil`
  - commits 3 a 7: rama `main`, commit `611f288` (misma estructura que el oficial)
  - commits 8 y 9: rama `reestructuracion`, commit `a334d3a` (estructura nueva)

## Qué cambió respecto de la primera versión de la guía

La primera versión se armó contra un clon viejo del oficial. Mientras tanto, el oficial ya recibió casi todo lo nuevo, en la estructura de siempre (escenas sueltas en `escenas/`, scripts en camelCase):

- los commits de lulorojas del 26/10: objetivo en pantalla, ayuda con H, combate con aviso, pistola de bengalas, niveles 3 a 7, pathfinding, cliente;
- el PR #3 de lautyscanio (15/11): menos luz, el trato de las 3 hamburguesas con el Cliente, escondites y la tecla C para comer.

Por eso ahora la guía **sigue la estructura que ya tiene el oficial**:

- **Commits 3 a 7:** traen lo que falta sin mover nada de lugar. No tocan ninguna línea de lo que entró en el PR #3: donde se cruzan con esos archivos, solo agregan cosas.
- **Commits 8 y 9:** la reestructuración (carpetas por tema y snake_case), que antes eran el 1 y el 2. Quedan al final y son opcionales: se hacen solo si el equipo decide pasar a la estructura nueva.

Todo se probó en un clon del oficial (`main` en `667cd4cf`, con el PR #3 adentro): en cada paso los 7 niveles cargan sin errores. Al terminar el 7, el oficial queda igual al `main` del avanzado. Al terminar el 9, queda igual a `reestructuracion`.

| # | Commit | Qué entra | Estado |
|---|---|---|---|
| 3 | Objetivo del McDonald's | el objetivo sigue el trato de las 3 hamburguesas con el Cliente | **hecho**: rama `reestructura/03-objetivo` |
| 4 | Guarda | script propio del Guarda (`guarda.gd`) | **hecho**: rama `reestructura/04-personajes` |
| 5 | Piezas nuevas del mapa | zona de mensaje, tren fantasma, sprites de objetos y texturas | falta |
| 6 | Niveles | comisaría, celda, subte, estación que no existe y casa actualizados | falta |
| 7 | Plaza y McDonald's | texturas, llave del Mc accesible, README e historia | falta |
| 8 | Estructura de carpetas (opcional) | escenas por tema y archivos en `snake_case`. No cambia el código | falta |
| 9 | Scripts en snake_case (opcional) | todos los scripts reescritos con el estilo nuevo | falta |

## Antes de empezar (una sola vez por compu)

```
git clone https://github.com/SOrtiz1967/Silent-Gil-Proyecto-Final.git
cd Silent-Gil-Proyecto-Final
git remote add avanzado https://github.com/lautyscanio/Videojuego-Silent-Gil.git
git fetch avanzado
git cat-file -t 611f288
git cat-file -t a334d3a
```

Los dos últimos comandos tienen que imprimir `commit`. Si ya tenían el oficial clonado, solo hacen los 4 últimos.

Reglas para todos los commits:

1. **Un commit por vez y en orden.** Antes de empezar el siguiente, el anterior tiene que estar mergeado en `main` del oficial y cada uno hace `git pull`. La única excepción son el 3 y el 4: tocan archivos distintos, así que se pueden mergear en cualquier orden.
2. **Usar siempre los `git add` de esta guía**, nunca `git add .` ni `git add -A` solos. Cuando Godot abre el proyecto modifica archivos `.import` y no queremos subirlos.
3. Los archivos se traen del avanzado con `git checkout <commit> -- <archivos>`, que copia exacto el archivo de ese commit.
4. Después de cada paso hay que abrir el proyecto en Godot, apretar F5 y probar lo que dice "Probar".
5. El script de Python del commit 8 se guarda **fuera** de la carpeta del repo (por ejemplo en el Escritorio) y se ejecuta parado en la raíz del repo. Así no hace falta commitearlo.

El flujo de ramas es el mismo de siempre: rama nueva desde `main`, push, Pull Request y que otro del equipo lo revise.

---

## Commit 3: objetivo del McDonald's (hecho)

**Rama:** `reestructura/03-objetivo`, ya subida. Falta abrir el PR y que alguien lo revise.

**Qué hace:** el cartel de objetivo ya estaba en el oficial, igual que los controles en la pausa y el tutorial más grande. Pero en el McDonald's seguía diciendo "Pegale al Cliente", que era como funcionaba antes del PR #3. Ahora sigue el trato:

1. hablar con el Cliente;
2. buscar las hamburguesas, con la pista que da el Cliente y el conteo `x/3`;
3. llevársela al Cliente.

Si te comés una, el objetivo cambia a pelear con él.

| Archivo | Cambio |
|---|---|
| `scripts/objetivo.gd` | el paso del McDonald's usa `pasoHamburguesas` (la versión de lautyscanio en el avanzado) |
| `scripts/objetivo.gd.uid` | nuevo (faltaba en el oficial) |

Los textos nuevos del subte (cabina de señales) y del Guarda **no** entran acá, porque hablan de cosas que todavía no están en el mapa: entran en el commit 6, junto con esos niveles.

**Probar:** en el McDonald's el objetivo dice "Hablá con el Cliente...". Cuando encontrás una hamburguesa, dice que se la lleves. Después de entregarla, muestra la pista del Cliente y el conteo (`1/3`). Si te la comés (C), dice que el Cliente pelea a muerte.

---

## Commit 4: Guarda (hecho)

**Rama:** `reestructura/04-personajes`, ya subida. Falta abrir el PR y que alguien lo revise.

**Qué hace:** suma el script propio del Guarda. `cliente.gd`, `aparicion.gd` y `pathfinding.gd` ya estaban en el oficial y no se tocan.

| Archivo | Qué es |
|---|---|
| `scripts/guarda.gd` y `.uid` | el Guarda (hereda de `enemigo.gd`). Con la linterna prendida te ve de lejos. A oscuras camina despacio hacia donde vio tu luz. Si le pegás, toca el silbato y te persigue rápido un rato |

Todavía no lo usa ningún nivel: el Guarda de la estación que no existe pasa a usarlo en el commit 6.

**Probar:** el proyecto abre sin errores en la consola de Godot. El juego se ve igual.

---

## Commit 5: piezas nuevas del mapa

**Qué hace:** suma las piezas que usan los niveles de los commits 6 y 7.

| Archivo | Qué es |
|---|---|
| `scripts/zonaMensaje.gd` y `escenas/zonaMensaje.tscn` | muestra un mensaje una vez al entrar |
| `scripts/tren_fantasma.gd` | el tren vacío que cruza el subte |
| `assets/sube.svg`, `ganzua.svg`, `silbato.svg`, `pistola_bengalas.svg` (con sus `.import`) | sprites propios de la SUBE, la ganzúa, el silbato y la caja de bengalas |
| `scripts/objetoClave.gd` | usa esos sprites en vez de la llave para todo (solo agrega líneas) |
| `escenas/bengalas.tscn` | la caja de bengalas usa su sprite nuevo |
| `assets/texturas/` | 11 texturas de los niveles (con sus `.import`) |

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/05-piezas-mapa
git checkout 611f288 -- scripts/zonaMensaje.gd scripts/zonaMensaje.gd.uid escenas/zonaMensaje.tscn scripts/tren_fantasma.gd scripts/tren_fantasma.gd.uid scripts/objetoClave.gd escenas/bengalas.tscn assets/sube.svg assets/sube.svg.import assets/ganzua.svg assets/ganzua.svg.import assets/silbato.svg assets/silbato.svg.import assets/pistola_bengalas.svg assets/pistola_bengalas.svg.import assets/texturas
git add scripts/zonaMensaje.gd scripts/zonaMensaje.gd.uid escenas/zonaMensaje.tscn scripts/tren_fantasma.gd scripts/tren_fantasma.gd.uid scripts/objetoClave.gd escenas/bengalas.tscn assets/sube.svg assets/sube.svg.import assets/ganzua.svg assets/ganzua.svg.import assets/silbato.svg assets/silbato.svg.import assets/pistola_bengalas.svg assets/pistola_bengalas.svg.import assets/texturas
git status
git commit -m "piezas nuevas del mapa: zona de mensaje, tren fantasma, sprites de objetos y texturas"
git push origin reestructura/05-piezas-mapa
```

`git status` tiene que mostrar 37 archivos: 35 nuevos y 2 modificados (`scripts/objetoClave.gd` y `escenas/bengalas.tscn`). Las texturas son 11 `.png` y 11 `.png.import`.

**Probar:** abre sin errores. La SUBE, la ganzúa y el silbato tienen sprite propio, y la caja de bengalas de la comisaría también. Lo demás se ve igual.

---

## Commit 6: niveles

**Qué hace:** actualiza los niveles 3 a 7 y los textos del objetivo que dependen de ellos. Necesita el 3, el 4 y el 5 mergeados.

| Archivo | Cambio |
|---|---|
| `escenas/nivel_3.tscn`, `nivel_3_celda.tscn`, `nivel_7.tscn` | texturas (solo agrega líneas) |
| `escenas/nivel_5.tscn` | el tren fantasma; la puerta de servicio pide la llave de servicio, que está en la cabina de señales (se fuerza con F); 2 pálidos más; más oscuro; texturas |
| `escenas/nivel_6.tscn` | el Guarda usa `guarda.gd`; 3 zonas de mensaje (silbato lejos, pasos, silbato cerca); más oscuro; texturas |
| `scripts/objetivo.gd` | los pasos del subte (cabina de señales) y del Guarda |

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/06-niveles
git checkout 611f288 -- escenas/nivel_3.tscn escenas/nivel_3_celda.tscn escenas/nivel_5.tscn escenas/nivel_6.tscn escenas/nivel_7.tscn scripts/objetivo.gd
git add escenas/nivel_3.tscn escenas/nivel_3_celda.tscn escenas/nivel_5.tscn escenas/nivel_6.tscn escenas/nivel_7.tscn scripts/objetivo.gd
git status
git commit -m "niveles: tren fantasma y cabina de senales en el subte, guarda con silbato, mensajes y texturas"
git push origin reestructura/06-niveles
```

`git status` tiene que mostrar los 6 archivos modificados.

**Probar:**
- **Subte:** pasa el tren vacío. La puerta de servicio está cerrada y el objetivo manda a la cabina de señales, donde está la llave.
- **Estación que no existe:** con la linterna prendida el Guarda te ve de lejos. A oscuras va hacia donde vio tu luz. Si le pegás, toca el silbato.
- **Comisaría, celda y casa:** se ven con texturas.

Cada nivel se puede abrir solo con F6.

---

## Commit 7: plaza y McDonald's + documentación

**Qué hace:** con esto el oficial queda igual al `main` del avanzado.

| Archivo | Cambio |
|---|---|
| `escenas/nivel_1.tscn` | texturas, y la llave del McDonald's se mueve un poco a la derecha: estaba adentro de la colisión de la fachada de la comisaría y no se podía agarrar |
| `escenas/nivel_mc.tscn` | texturas (solo agrega líneas: el Cliente, los escondites y todo lo del PR #3 quedan igual) |
| `README.md` | al día con el recorrido |
| `docs/historia.md` | al día con la historia |

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/07-plaza-y-mcdonalds
git checkout 611f288 -- escenas/nivel_1.tscn escenas/nivel_mc.tscn README.md docs/historia.md
git add escenas/nivel_1.tscn escenas/nivel_mc.tscn README.md docs/historia.md
git status
git commit -m "plaza y mcdonalds con texturas, llave del mc accesible, readme e historia al dia"
git push origin reestructura/07-plaza-y-mcdonalds
```

**Probar (recorrido completo):**
1. Intro del tren, SUBE y molinetes.
2. Llave del Mc. Ahora se agarra con F.
3. McDonald's: el trato con el Cliente, los escondites, el powerbank y los bichos.
4. Reja del subte y subte: cabina de señales y puerta de servicio.
5. Estación que no existe: el Guarda y el silbato.
6. La casa.

Opcional: la comisaría, abajo a la derecha de la plaza.

**Comprobación:** con el 7 mergeado, esto no tiene que mostrar diferencias de código (solo puede haber diferencias en archivos `.import` y en finales de línea):

```
git fetch avanzado
git diff --stat 611f288 main -- escenas scripts project.godot README.md docs
```

---

## Commits 8 y 9: reestructuración (opcional)

Solo si el equipo decide pasar a la estructura nueva: escenas en carpetas por tema y todo en `snake_case`. Si no, la guía termina en el 7. Necesitan el 7 mergeado: parten de que el oficial ya es igual al `main` del avanzado.

### Commit 8: estructura de carpetas

**Qué hace:** mueve cada escena a una carpeta por tema y pasa los nombres de archivo a `snake_case`. No cambia ni una línea de código, solo las rutas `res://`.

```
escenas/niveles/        nivel_1, nivel_mc, nivel_3, nivel_3_celda, nivel_5, nivel_6, nivel_7
escenas/niveles/mapas/  estacion_visual, plaza_visual
escenas/jugador/        jugador, proyectil, bengala
escenas/enemigos/       enemigo
escenas/objetos/        consumible, objeto_clave, cartel, piedra, powerbank, punto_carga, farola, bengalas, escondite
escenas/mundo/          puerta, zona_tutorial, tren, entrada_nivel, teletransporte, zona_mensaje
escenas/interfaz/       inventario, tutorial, menu_pausa, objetivo
escenas/minijuegos/     cerradura, pernos
escenas/pruebas/        principal
scripts/                (sigue plano) objetoClave.gd pasa a objeto_clave.gd, entradaNivel.gd a entrada_nivel.gd,
                        puntoCarga.gd a punto_carga.gd, zonaTutorial.gd a zona_tutorial.gd, zonaMensaje.gd a zona_mensaje.gd
docs/                   TP_Investigacion_Pre_Viaje_Scanio.docx (estaba en la raíz)
```

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/08-estructura
```

Guardar el script `migrar_estructura.py` (más abajo) fuera del repo y correrlo desde la raíz del repo:

```
python C:\ruta\donde\lo\guardaron\migrar_estructura.py .
```

Tiene que imprimir `archivos con rutas actualizadas: 18` y `archivos movidos/renombrados: 103`. Si imprime `falta en la tabla: ...`, el oficial tiene una escena que no estaba cuando se armó la guía (avisen).

Abrir el proyecto en Godot, F5 y probar.

```
git add -A -- escenas scripts docs project.godot TP_Investigacion_Pre_Viaje_Scanio.docx
git status
git commit -m "estructura de carpetas: escenas agrupadas por tema y scripts en snake_case"
git push origin reestructura/08-estructura
```

`git status` tiene que mostrar 46 renombres (`renamed`) y 3 archivos modificados: `project.godot`, `scripts/enemigo.gd` y `scripts/jugador.gd` (cambian los `preload` por las rutas nuevas).

**Probar:** el juego abre y se juega idéntico a antes.

<details>
<summary><code>migrar_estructura.py</code></summary>

```python
"""Commit 8: mueve las escenas a escenas/<tema>/ y pasa los nombres de archivo a snake_case.
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
    "niveles": ["nivel_1", "nivel_mc", "nivel_3", "nivel_3_celda", "nivel_5", "nivel_6", "nivel_7"],
    "niveles/mapas": ["estacion_visual", "plaza_visual"],
    "jugador": ["jugador", "proyectil", "bengala"],
    "enemigos": ["enemigo"],
    "objetos": ["consumible", "objetoClave", "cartel", "piedra", "powerbank", "puntoCarga", "farola", "bengalas", "escondite"],
    "mundo": ["puerta", "zonaTutorial", "tren", "entradaNivel", "teletransporte", "zonaMensaje"],
    "interfaz": ["inventario", "tutorial", "menu_pausa", "objetivo"],
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

### Commit 9: scripts en snake_case

**Qué hace:** reemplaza los scripts y las escenas por las versiones con el estilo nuevo. No agrega mecánicas: todo lo que hacen ya está en el oficial.

- **Funciones y variables:** en `snake_case` (`tiene_llave`, `hamburguesas_entregadas`, `recibir_daño`).
- **Señales:** los métodos conectados pasan a `_on_...`.
- **Código:** comentarios, tipos, y un `enum` para el estado del tren.
- **Escenas:** usan los nombres nuevos de las propiedades (`ruta_textura`, `llave_requerida`...).
- **`nivel_mc`:** pasa a usar `nivel.gd` y se borra `nivel_mc.gd`.
- **Input:** `mover_arriba/abajo/izquierda/derecha` pasan a `arriba/abajo/izquierda/derecha`, y `golpear` pasa a `atacar`.
- **`README.md`:** explica la estructura nueva y las convenciones.
- **Regla del equipo:** las variables `@export` van **sin ñ** (`dano`, no `daño`), porque Godot no guarda bien en el `.tscn` las propiedades con ñ.

Como después del 8 las escenas del oficial son las mismas que usó la reestructuración, se copian directo de `a334d3a`. Ya no hace falta el `migrar_nombres.py` de la versión anterior.

**Pasos**

```
git checkout main
git pull origin main
git checkout -b reestructura/09-snake-case
git checkout a334d3a -- escenas scripts project.godot README.md
git rm scripts/nivel_mc.gd scripts/nivel_mc.gd.uid
git add -A -- escenas scripts project.godot README.md
git status
git commit -m "scripts en snake_case y estilo propio, handlers _on_ y nivel_mc usa nivel.gd"
git push origin reestructura/09-snake-case
```

`git status` tiene que mostrar 57 archivos, todos dentro de `escenas/`, `scripts/`, `project.godot` o `README.md` (2 de ellos borrados: `nivel_mc.gd` y su `.uid`).

**Probar:** se camina con WASD y flechas, Espacio golpea, `E` tira piedras o bengalas, `F` agarra y abre, `C` come, `T` abre el inventario, `Q` la linterna, `H` los controles y `Esc` la pausa. El recorrido completo funciona igual que después del 7.

**Comprobación final:** con el 9 mergeado, esto no tiene que mostrar diferencias de código:

```
git fetch avanzado
git diff --stat a334d3a main -- escenas scripts project.godot README.md docs
```

---

## Si algo falla

- **Godot dice "Failed to load script" o "Node not found":** casi siempre falta algún archivo de la lista del commit, o no está mergeado el commit anterior. Revisar con `git status` y `git log`.
- **`git checkout 611f288 -- ...` o `git checkout a334d3a -- ...` dice `pathspec ... did not match`:** falta hacer `git fetch avanzado`, o se escribió mal un nombre.
- **Godot modificó archivos `.import` y aparecen en `git status`:** no los agreguen. Se descartan con `git restore <archivo>`.
