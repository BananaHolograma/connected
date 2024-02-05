<p align="center">
	<img width="256px" src="https://github.com/bananaholograma/connected/blob/main/icon.png" alt="bananaholograma connected plugin logo" />
	<h1 align="center">Connected</h1>
	
[![LastCommit](https://img.shields.io/github/last-commit/bananaholograma/connected?cacheSeconds=600)](https://github.com/bananaholograma/connected/commits)
[![Stars](https://img.shields.io/github/stars/bananaholograma/connected)](https://github.com/bananaholograma/connected/stargazers)
[![Total downloads](https://img.shields.io/github/downloads/bananaholograma/connected/total.svg?label=Downloads&logo=github&cacheSeconds=600)](https://github.com/bananaholograma/connected/releases)
[![License](https://img.shields.io/github/license/bananaholograma/connected?cacheSeconds=1440)](https://github.com/bananaholograma/connected/blob/main/LICENSE.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat&logo=github)](https://github.com/bananaholograma/connected/pulls)
[![Kofi](https://badgen.net/badge/icon/kofi?icon=kofi&label)](https://ko-fi.com/bananaholograma)
</p>

[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/bananaholograma/connected/blob/main/README.md)

- - -

Un sistema de eventos minimalista orientado a nodos que encaja perfectamente con la filosofía de Godot.

- [Requerimientos](#requerimientos)
- [✨Instalacion](#instalacion)
	- [Automatica (Recomendada)](#automatica-recomendada)
	- [Manual](#manual)
- [Cómo usarlo](#cómo-usarlo)
	- [ActionInteractor](#actioninteractor)
	- [ActionEmitter](#actionemitter)
		- [Añadir a través del editor](#añadir-a-través-del-editor)
		- [Añadir mediante script](#añadir-mediante-script)
		- [Funciones disponibles](#funciones-disponibles)
			- [send(action: Action)](#sendaction-action)
			- [enable() \& disable()](#enable--disable)
		- [Señales](#señales)
	- [La clase Action](#la-clase-action)
		- [Propiedades](#propiedades)
		- [Hooks](#hooks)
	- [ActionListener](#actionlistener)
		- [Propiedades](#propiedades-1)
		- [Métodos disponibles](#métodos-disponibles)
			- [enable() \& disable()](#enable--disable-1)
		- [Escuchar acciones](#escuchar-acciones)
- [✌️Eres bienvenido a](#️eres-bienvenido-a)
- [🤝Normas de contribución](#normas-de-contribución)
- [📇Contáctanos](#contáctanos)

# Requerimientos
📢 No ofrecemos soporte para Godot 3+ ya que nos enfocamos en las versiones futuras estables a partir de la versión 4.
* Godot 4+

# ✨Instalacion
## Automatica (Recomendada)
Puedes descargar este plugin desde la [Godot asset library](https://godotengine.org/asset-library/asset/2039) oficial usando la pestaña AssetLib de tu editor Godot. Una vez instalado, estás listo para empezar
## Manual 
Para instalar manualmente el plugin, crea una carpeta **"addons"** en la raíz de tu proyecto Godot y luego descarga el contenido de la carpeta **"addons"** de este repositorio


# Cómo usarlo
Cuando llevas un tiempo trabajando con Godot descubres que tiene un sistema de nodos muy agradable de usar. Este plugin te ayuda a implementar un sistema de eventos minimalista muy fácil usando nodos.

## ActionInteractor
Este es el núcleo del plugin y recomendamos no alterar su funcionalidad ya que **sólo es responsable de recibir y propagar acciones**. Puedes usarlo en modo lectura ya que contiene los emitters y listeners activos en tu juego en caso de que quieras obtener su información.

Siempre que **deshabilites o habilites un ActionEmitter & ActionListener** este singleton emite la señal correspondiente para informar de su conexión o desconexión en caso de que quieras reaccionar a estos cambios.

***La propagación se basa en la propiedad `priority` de los `ActionListeners` que reaccionarán a esta acción, así que los listeners con un mayor prioridad recibirán la acción antes que los otros.***

```python
## Obten todos los ActionEmitter activos
ActionInteractor.emitters
## Obten todos los ActionListeners activos
ActionInteractor.listeners

## Señales disponibles para conectarse
signal action_emitter_connected(action_emitter: ActionEmitter)
signal action_emitter_disconnected(action_emitter: ActionEmitter)
signal action_listener_connected(action_listener: ActionListener)
signal action_listener_disconnected(action_listener: ActionListener)

## Una conexión normal con la sintaxis de Godot
ActionInteractor.action_emitter_disconnected.connect(##...)
```

## ActionEmitter
Su único propósito es enviar acciones al singleton `ActionInteractor`. Estas acciones están definidas por la clase proporcionada `Action` que te permite crear tus propios comportamientos personalizados.

### Añadir a través del editor
Es tan fácil como encontrar el nodo y añadirlo al árbol de escenas:

![action-emitter-search](images/action-emitter-search.png)
![action-emitter-node](images/action-emitter-node.png)

### Añadir mediante script
```python
## Dentro del script del nodo quieres añadir el ActionEmitter, usamos _ready como ejemplo pero podría estar en cualquier otro lugar
func _ready():
	var action_emitter = ActionEmitter.new()
	add_child(action_emitter)
```

### Funciones disponibles
#### send(action: Action)
Envía una acción al `ActionInteractor`, éste la propagará a los oyentes activos en el árbol de escena. Si tu Action está `disabled` esta función no enviará nada

``python
@onready var action_emitter: ActionEmitter = $ActionEmitter

func pressed():
	var action = Action.new()
	action_emitter.send(action)
```
```

#### enable() & disable()
Habilita o deshabilita este emisor de acciones para que no pueda enviar acciones al `ActionInteractor`. 

### Señales
```python
signal emitted_action(action: Action)
signal canceled_action(action: Action)
```

## La clase Action
Esta es la clase base minimalista que este plugin utiliza para enviar y recibir a través del `ActionInteractor`. Fue diseñada para heredarla y añadir nuevas propiedades o recursos así como sobrescribir sus funciones como un "hook" para proporcionar tus propios comportamientos.

### Propiedades
```python
var id: String # Si no provee un valor, se genera un id unico aleatorio
var priority := 1
var is_listened := true
var listened_by := []
var ignored_by := []

func _init(_id: String = _generate_random_id(), _is_listened: bool = true, _priority: int = 1):
	id = _id
	is_listened = _is_listened
	priority = _priority
```

`listened_by` y `ignored_by` se pueden utilizar para añadir la categoría a la que pertenece un listener. Si están vacías por defecto la acción se propagará a los listeners disponibles en el árbol de escena. La propiedad `category` en el listener distingue entre mayúsculas y minúsculas y deben establecerse en la propiedad editor de este nodo.

Puedes usar los métodos:

 - `add_listened_by_categories(categories: Array[String], overwrite: bool = false) -> void:`

 - `add_ignored_by_categories(categories: Array[String], overwrite: bool = false) -> void:`

Por ejemplo:
```python
var action = Action.new()
action.add_listened_by_categories(["enemies", "towers"])
action.add_ignored_by_categories(["weapons", "player"])
```

### Hooks
Si `before_emit()` devuelve un valor falso la `Action` disparará la señal `canceled_action` y el hook `after_cancel` será llamado como consecuencia. Siéntete libre de sobreescribir estas funciones pero **asegúrate de que `before_emit()` devuelve siempre un valor booleano.**

```python
func before_emit() -> bool:
	return true


func after_emit()-> void:
	pass


func after_cancel() -> void:
	pass
```
En el siguiente ejemplo de acción personalizada creamos una acción de habilidad imaginaria en la que comprobamos si el objetivo proporcionado es agua antes de emitir

```python

class_name FireballAction extends Action

var current_target

## If the target selected is water type we cancel the action
func before_emit() -> bool
	return not target.type is Water:


func select_target(target):
	current_target = target


### Send the action with any emitter available
var fireball = FireballAction.new()
fireball.select_target(enemy)
fireball.damage = 150

action_emitter.send(fireball)
```

## ActionListener
Este es el siguiente nodo más importante, dondequiera que se añada en el árbol de escena escuchará las acciones de cualquier `ActionEmitter` siempre y cuando la acción sea escuchada por la categoría seleccionada o no tenga restricciones.

El `ActionListener` no necesita ser añadido en la misma jerarquía que un `ActionEmitter`. El singleton `ActionInteractor` es responsable de propagar las acciones a los listeners apropiados.

![action-listener-search](images/action-listener-search.png)

![action-listener-node](images/action-listener-node.png)


### Propiedades
```python
@export var category: String
@export_range(1, 1000, 1) var priority := 1
@export var disabled := false:
```
### Métodos disponibles

#### enable() & disable()
Habilitar o deshabilitar este listener.

### Escuchar acciones
La forma de escuchar acciones es conectándose a la señal proporcionada `listened_action(action: Action)` desde este nodo. Cada vez que una `Acción` es enviada con éxito y el listener es válido para escucharla, podrás obtener la acción desde esta señal

```python
@onready var spell_listener: ActionListener = $ActionListener

func _ready():
	spell_listener.category = "spells" # Para que este listener sólo reciba Acciones donde la propiedad listened_by tenga esta categoría
	spell_listener.listened_action(on_listened_action)


func on_listened_action(action: Action):
	## Escribe tu lógica...

## Si sabes exactamente que este listener recibirá siempre una CustomAction concreta puedes tipar el parámetro con más precisión
func on_listened_action(action: SpellAction):
	## Escribe tu lógica...
```

# ✌️Eres bienvenido a
- [Dar feedback](https://github.com/bananaholograma/connected/pulls)
- [Sugerir mejoras](https://github.com/bananaholograma/connected/issues/new?assignees=BananaHolograma&labels=enhancement&template=feature_request.md&title=)
- [Reportar bugs](https://github.com/bananaholograma/connected/issues/new?assignees=BananaHolograma&labels=bug%2C+task&template=bug_report.md&title=)

Este plugin esta disponible de forma gratuita.

Si estas agradecido por lo que hacemos, por favor, considera hacer una donación. Desarrollar los plugins y contenidos requiere una gran cantidad de tiempo y conocimiento, especialmente cuando se trata de Godot. Incluso 1€ es muy apreciado y demuestra que te importa. ¡Muchas Gracias!

- - -
# 🤝Normas de contribución
**¡Gracias por tu interes en este plugin!**

Para garantizar un proceso de contribución fluido y colaborativo, revise nuestras [directrices de contribución](https://github.com/bananaholograma/connected/blob/main/CONTRIBUTING.md) antes de empezar. Estas directrices describen las normas y expectativas que mantenemos en este proyecto.

**📓Código de conducta:** En este proyecto nos adherimos estrictamente al [Código de conducta de Godot](https://godotengine.org/code-of-conduct/). Como colaborador, es importante respetar y seguir este código para mantener una comunidad positiva e inclusiva.
- - -

# 📇Contáctanos
Si has construido un proyecto, demo, script o algun otro ejemplo usando nuestros plugins haznoslo saber y podemos publicarlo en este repositorio para ayudarnos a mejorar y saber que lo que hacemos es útil.
