# 🏗️ Guía Técnica: Creación de Landings Modulares (Reordenables) en Tiendanube

Esta guía detalla estrictamente el proceso técnico, paso a paso, para implementar una página tipo "Landing" con secciones configurables y reordenables desde el administrador de Tiendanube.

El modelo nativo de Tiendanube restringe la creación de nuevos _templates_ globales con URLs a voluntad (ej. `/templates/landing.tpl`). Por lo tanto, el sistema requiere una arquitectura de **"Doble Enrutamiento" (Intercepción de URL)** usando las páginas estáticas (`page.tpl`), combinada con un espacio de nombres (namespace) estricto de variables para no superponer datos con futuras implementaciones.

---

## 🏛 Principios Base de la Arquitectura

Para asegurar la escalabilidad horizontal (poder crear N landings en el futuro sin conflictos), se deben cumplir las siguientes reglas estrictas:

1. **Namespace Estricto:** Nunca usar nombres genéricos. Toda variable en base de datos (`settings.txt` y `defaults.txt`) y archivo de enrutamiento DEBE llevar un prefijo o sufijo único para la campaña (ej. `_xv`, `_bfight`, `_bodas`).
2. **Carpetas Aisladas:** Todos los componentes visuales de la landing (HTML/Twig) deben vivir en un subdirectorio exclusivo.
3. **Iteradores Numéricos:** El componente visual de Tiendanube `section_order` no devuelve un arreglo iterable con `in`, sino que despliega _N_ variables dinámicas llamadas `prefijo_N` (ej. `landing_xv_order_position_1`). El rendering debe recrear el bucle `for` manual del Home.

---

## 🛠 Proceso de Implementación (Paso a Paso)

### PASO 1: Intercepción de la URL en la Plantilla (`templates/page.tpl`)

El objetivo es "secuestrar" el comportamiento predeterminado de la página estática cuando el usuario navega a la URL acordada.

**Acción:** Reemplazar o envolver el código original de `templates/page.tpl` definiendo un condicional exacto a la ruta (o _slug_) que se dará de alta desde el administrador.

```twig
{# 1. Detectamos si la URL actual coincide con nuestra landing. #}
{#    En este ejemplo, usamos 'nombre-campaña' para interceptar '/p/nombre-campana/' #}
{% if 'nombre-campana' in page.url | lower %}

    <div class="landing-sections-namespace">
        {% set newArrayNamespace = [] %}

        {# 2. Tiendanube requiere iteración numérica forzada, iteramos hasta 10 o 15 posiciones #}
        {% for i in 1..10 %}

            {# 3. Construimos el nombre de la variable dinámica declarada en settings.txt #}
            {% set section_name = 'landing_namespace_order_position_' ~ i %}
            {% set section_select = attribute(settings, section_name) %}

            {# 4. Invocamos el Enrutador y aseguramos no repetir elementos #}
            {% if section_select and section_select not in newArrayNamespace %}
                {% include 'snipplets/landing/landing-namespace-section-switch.tpl' %}
                {% set newArrayNamespace = newArrayNamespace|merge([section_select]) %}
            {% endif %}

        {% endfor %}
    </div>

{% else %}
    {# FALLBACK: El comportamiento normal de cualquier otra página estática (Contacto, FAQ, etc.) #}
    {% embed "snipplets/page-header.tpl" %} ... {% endembed %}
    <section class="user-content pb-5"> ... </section>
{% endif %}
```

---

### PASO 2: Variables y Controles en la Base de Datos (`config/settings.txt`)

Aquí damos de alta el espacio en el Editor Visual de Tiendanube.

**Acción:** Al final o en la sección pertinente de `settings.txt`, construir la estructura con su `section_order` principal.

**⚠️ REGLA DE ORO:** Todos los nombres (`name`) y referencias (`backto`) deben poseer el namespace.

```txt
Página Landing [Nombre de Campaña]
	meta
		icon = window
		advanced = true
		default = landing_namespace_order_position
	collapse
		title = Orden de las secciones
		backto = _top
	section_order
		name = landing_namespace_order_position
		start_index = 1
		sections
			landing_namespace_banner = Banner Principal  # ← Identificador único de bloque
            landing_namespace_otro = Otra Sección

    # ---> Componente: Banner Principal <---
    collapse
		title = Banner Principal
		backto = landing_namespace_order_position
	checkbox
		name = landing_namespace_banner_show
		description = Mostrar banner
	i18n_input
		name = landing_namespace_banner_title
		description = Título
```

---

### PASO 3: Valores Iniciales del Sistema (`config/defaults.txt`)

Las configuraciones anteriores requieren obligatoriamente un valor de inicio seguro para evitar cuelgues de compilación en Twig.

**Acción:** Agregar al final de `defaults.txt` los valores correspondientes a los campos agregados arriba. Se debe declarar la posición 1 del `section_order`.

```txt
# Landing Page [Nombre de Campaña] Defaults
landing_namespace_order_position_1 = landing_namespace_banner
landing_namespace_banner_show = 1
landing_namespace_banner_title_es = Título Inicial
landing_namespace_banner_title_en = Inicial Title
landing_namespace_banner_title_pt = Título Inicial
```

---

### PASO 4: El Director de Orquesta (`snipplets/landing/landing-namespace-section-switch.tpl`)

Este archivo traduce el texto (identificadores) recibidos de `settings.txt` en código HTML u sub-plantillas.

**Acción:** Crear un nuevo archivo en `snipplets/landing/` nombrado exclusivamente con el namespace.

```twig
{# Switch del Enrutador. Actuará según lo que traiga 'section_select' #}

{% if section_select == 'landing_namespace_banner' %}
    {# Validar siempre la bandera de visualización #}
    {% if settings.landing_namespace_banner_show %}
        {# Inyectar el componente visual desde la subcarpeta asilada #}
        {% include 'snipplets/landing/namespace/landing-namespace-banner.tpl' %}
    {% endif %}

{% elseif section_select == 'landing_namespace_otro' %}
    {# Lógica de la segunda sección... #}
    {% if settings.landing_namespace_otro_show %}
        {% include 'snipplets/landing/namespace/landing-namespace-otro.tpl' %}
    {% endif %}

{% endif %}
```

---

### PASO 5: Creación del Componente Físico

Por último, generamos la subcarpeta de aislamiento y el archivo visual puramente de interfaz.

**Acción:** Crear la carpeta `snipplets/landing/[namespace]/` y crear un archivo como `landing-namespace-banner.tpl`.

```twig
{# ⚠️ IMPORTANTE: Uso del filtro translate para los campos tipo i18n_input #}
<section class="landing-banner namespace-banner">
    <h2>
        {% if settings.landing_namespace_banner_title %}
            {{ settings.landing_namespace_banner_title | translate }}
        {% else %}
            Fallback Text
        {% endif %}
    </h2>
</section>
```

---

## 🚀 Resumen Final: Puesta en Producción

1. Crear el esquema en `settings.txt` y validarlo en `defaults.txt`.
2. Crear la sub-carpeta aislada y los archivos individuales (`.tpl`) por sección (Botones, Galerías, Formularios, etc.).
3. Ensamblarlos en un archivo con estructura Switch (_If - ElseIf_).
4. Interceptar correctamente en `page.tpl` iterando el arreglo forzado (`in 1..10`).
5. En el área de administración de Tiendanube, crear una _"Página"_ vacía. La URL que sea autogenerada o dictada (ej. `midominio.com/p/nombre-campana/`) será la que detone la renderización de la Landing Page entera.
