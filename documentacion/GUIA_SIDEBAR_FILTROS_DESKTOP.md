# Guía: Sidebar de Filtros en Desktop para Página de Categoría

> Guía paso a paso para implementar filtros laterales visibles permanentemente en escritorio en la página de lista de productos (categoría/colección). La versión móvil NO se modifica.

---

## Resumen de la implementación

**Objetivo:** Mostrar los filtros de producto en una sidebar fija al lado izquierdo del grid de productos, SOLO en la versión de escritorio (≥ 768px). En móvil, se mantiene el comportamiento original con el modal/drawer.

**Estrategia elegida:** "Dual Render" — Se renderizan los filtros en dos lugares:
- **Móvil:** dentro del modal existente (como siempre, sin cambios)
- **Escritorio:** en una sidebar nueva al lado izquierdo del grid

Se usan clases de Bootstrap (`d-md-none` y `d-none d-md-block`) para que cada versión solo sea visible en su viewport correspondiente. Nunca se muestran ambas al mismo tiempo.

**Archivos que se modifican (solo 2):**
1. `templates/category.tpl` — estructura HTML
2. `static/css/style-async.scss` — estilos de la sidebar

**Archivos que NO se tocan:**
- `snipplets/grid/filters-modals.tpl` — intacto
- `snipplets/grid/filters.tpl` — intacto
- `snipplets/grid/categories.tpl` — intacto
- `snipplets/modal.tpl` — intacto
- `snipplets/grid/product-list.tpl` — intacto
- `templates/search.tpl` — intacto
- Ningún archivo JS — intacto

---

## Requisitos previos

Antes de implementar, verifica que:

1. Los filtros estén **activados** en el admin de Tiendanube → Marketing → Filtros (URL: `/admin/v2/filters`)
2. La categoría que vas a probar tenga **productos** cargados
3. Los productos tengan **variantes o atributos** (color, talle, etc.) para que aparezcan filtros

Si los filtros no están activados en el admin, la variable `has_filters_enabled` será `false` y la sidebar no aparecerá.

---

## Paso 1: Entender la estructura ORIGINAL de `category.tpl`

Antes de editar, este es el código original de la zona que vamos a modificar (aproximadamente línea 28 en adelante):

```twig
{% include 'snipplets/grid/filters-modals.tpl' %}
<section class="js-category-controls-prev category-controls-sticky-detector"></section>

<section class="category-body section-category-exclusive" data-store="category-grid-{{ category.id }}">
    <div class="container mt-4 mb-5">
        <div data-store="category-grid-{{ category.id }}">
            {% include 'snipplets/grid/product-list.tpl' %}
        </div>
    </div>
</section>
```

**Lo que hace cada parte:**
- `filters-modals.tpl` → Renderiza la barra sticky con el botón "Filtrar" y el modal con los filtros
- `category-controls-sticky-detector` → Elemento centinela para el comportamiento sticky del JS nativo
- `category-body` → El contenedor principal del grid de productos
- `data-store="category-grid-..."` → Hook reactivo que Tiendanube usa para actualizar el grid vía AJAX cuando se aplica un filtro
- `product-list.tpl` → El grid de productos + paginación

---

## Paso 2: Envolver el modal en `d-md-none`

**Qué:** Envolver la inclusión del modal (`filters-modals.tpl`) y el detector sticky dentro de un `<div>` con la clase `d-md-none`.

**Por qué:** La clase `d-md-none` de Bootstrap significa "display: none en pantallas ≥ 768px". Esto oculta el botón "Filtrar" y todo el sistema de modal EN ESCRITORIO, pero lo deja completamente funcional en móvil.

**Código que debes escribir:**

Reemplaza estas dos líneas:
```twig
{% include 'snipplets/grid/filters-modals.tpl' %}
<section class="js-category-controls-prev category-controls-sticky-detector"></section>
```

Con este bloque:
```twig
{# Mobile: modal-based filters (hidden on desktop) #}
<div class="d-md-none">
    {% include 'snipplets/grid/filters-modals.tpl' %}
    <section class="js-category-controls-prev category-controls-sticky-detector"></section>
</div>
```

**Notas importantes:**
- NO elimines las líneas originales, solo envuélvelas en el `<div class="d-md-none">`
- El comentario Twig `{# ... #}` es opcional pero recomendado para documentar el propósito
- La indentación dentro del `<div>` es con tabulador, respetando el estilo del archivo

---

## Paso 3: Crear el layout de 2 columnas con la sidebar

**Qué:** Dentro del bloque `category-body`, crear un layout `<div class="row">` con dos columnas:
- Columna izquierda (sidebar): `col-md-3` con `d-none d-md-block` → solo visible en escritorio
- Columna derecha (grid): `col-md-9` (o `col-12` si no hay filtros)

**Por qué:** `d-none d-md-block` significa "oculto por defecto, visible desde 768px en adelante". Solo en escritorio aparece la sidebar. En móvil, el grid ocupa el 100% del ancho como siempre.

**Código que debes escribir:**

Busca la sección del grid de productos:
```twig
<section class="category-body section-category-exclusive" data-store="category-grid-{{ category.id }}">
    <div class="container mt-4 mb-5">
        <div data-store="category-grid-{{ category.id }}">
            {% include 'snipplets/grid/product-list.tpl' %}
        </div>
    </div>
</section>
```

Reemplázala con:
```twig
<section class="category-body section-category-exclusive" data-store="category-grid-{{ category.id }}">
    <div class="container mt-4 mb-5">
        <div data-store="category-grid-{{ category.id }}">
            <div class="row">
                {# Desktop: sidebar filters (hidden on mobile) #}
                {% if has_filters_available %}
                <aside class="col-md-3 d-none d-md-block">
                    <div class="category-sidebar-filters">
                        {% include "snipplets/grid/categories.tpl" %}
                        {% include "snipplets/grid/filters.tpl" %}
                    </div>
                </aside>
                {% endif %}
                {# Product grid #}
                <div class="{% if has_filters_available %}col-md-9{% else %}col-12{% endif %}">
                    {% include 'snipplets/grid/product-list.tpl' %}
                </div>
            </div>
        </div>
    </div>
</section>
```

**Explicación línea por línea:**

| Línea | Qué hace |
|---|---|
| `<div class="row">` | Crea un sistema de columnas Bootstrap dentro del contenedor |
| `{% if has_filters_available %}` | Solo renderiza la sidebar si realmente hay filtros disponibles. Si no hay filtros, el grid ocupa todo el ancho |
| `<aside class="col-md-3 d-none d-md-block">` | Sidebar de 3 columnas (25% del ancho) en desktop. `d-none` la oculta por defecto, `d-md-block` la muestra desde 768px |
| `<div class="category-sidebar-filters">` | Wrapper con clase propia para poder estilizar con CSS |
| `{% include "snipplets/grid/categories.tpl" %}` | Renderiza las subcategorías (SIN la variable `modal`, para que se renderice en modo no-modal) |
| `{% include "snipplets/grid/filters.tpl" %}` | Renderiza la lista completa de filtros con checkboxes (SIN la variable `applied_filters`, para que se renderice la lista, no los chips) |
| `<div class="{% if has_filters_available %}col-md-9{% else %}col-12{% endif %}">` | El grid de productos ocupa 9 columnas (75%) si hay sidebar, o 12 columnas (100%) si no hay filtros |
| `{% include 'snipplets/grid/product-list.tpl' %}` | El grid de productos exactamente como estaba antes |

**Notas importantes:**
- La etiqueta `<section class="category-body ...">` y los `<div data-store="...">` NO se modifican. Se mantienen idénticos al original
- El `{% include 'snipplets/grid/product-list.tpl' %}` se mantiene exactamente igual, solo se mueve dentro de una columna
- La variable `has_filters_available` ya existe en la línea 1 del archivo — NO hay que crearla ni declararla, ya la tienes disponible
- Ningún snippet que se incluye requiere pasar variables especiales. Se incluyen tal cual, sin `with {...}`

---

## Paso 4: Agregar CSS para la sidebar

**Qué:** Agregar un bloque de CSS al final del archivo `static/css/style-async.scss`.

**Por qué:** La sidebar necesita estilos mínimos: padding para separar el contenido del grid.

**Código que debes agregar al FINAL de `style-async.scss`:**

```scss
/* ==========================================================
   CATEGORY SIDEBAR FILTERS (Desktop only)
   ========================================================== */

@media (min-width: 768px) {
  .category-sidebar-filters {
    padding-right: 15px;
    padding-bottom: 40px;
  }
}
```

**Explicación de cada propiedad:**

| Propiedad | Valor | Para qué sirve |
|---|---|---|
| `@media (min-width: 768px)` | — | Todo el bloque solo aplica en escritorio. En móvil no existe este CSS |
| `padding-right: 15px` | 15px | Espacio entre los filtros y el grid de productos para que no estén pegados |
| `padding-bottom: 40px` | 40px | Espacio abajo de los filtros para que no se corte el último filtro |

**Variaciones opcionales que puedes añadir:**

Si quieres que la sidebar siga al scroll (posición fija al scrollear):
```scss
@media (min-width: 768px) {
  .category-sidebar-filters {
    position: sticky;
    top: 100px;          /* Ajustar según la altura del header */
    padding-right: 15px;
    padding-bottom: 40px;
  }
}
```

Si quieres que la sidebar tenga scroll propio (útil si hay MUCHOS filtros):
```scss
@media (min-width: 768px) {
  .category-sidebar-filters {
    position: sticky;
    top: 100px;
    max-height: calc(100vh - 120px);
    overflow-y: auto;
    padding-right: 15px;
    padding-bottom: 40px;
  }
}
```

---

## Paso 5: Verificar el resultado

### El archivo `category.tpl` completo debe verse así:

```twig
{% set has_filters_available = products and has_filters_enabled and (filter_categories is not empty or product_filters is not empty) %}

{# Only remove this if you want to take away the theme onboarding advices #}
{% set show_help = not has_products %}

{% if settings.pagination == 'infinite' %}
    {% paginate by 12 %}
{% else %}
    {% paginate by 24 %}
{% endif %}

{% if not show_help %}

{% set category_banner = (category.images is not empty) or ("banner-products.jpg" | has_custom_image) %}

<div class="container">
    {% embed "snipplets/page-header.tpl" with {container: false} %}
        {% block page_header_text %}{{ category.name }}{% endblock page_header_text %}
    {% endembed %}
    {% if category_banner %}
        {% include 'snipplets/category-banner.tpl' %}
    {% endif %}
    {% if category.description %}
        <p class="mt-2 mb-4 text-center">{{ category.description }}</p>
    {% endif %}
</div>

{# Mobile: modal-based filters (hidden on desktop) #}
<div class="d-md-none">
    {% include 'snipplets/grid/filters-modals.tpl' %}
    <section class="js-category-controls-prev category-controls-sticky-detector"></section>
</div>

<section class="category-body section-category-exclusive" data-store="category-grid-{{ category.id }}">
    <div class="container mt-4 mb-5">
        <div data-store="category-grid-{{ category.id }}">
            <div class="row">
                {# Desktop: sidebar filters (hidden on mobile) #}
                {% if has_filters_available %}
                <aside class="col-md-3 d-none d-md-block">
                    <div class="category-sidebar-filters">
                        {% include "snipplets/grid/categories.tpl" %}
                        {% include "snipplets/grid/filters.tpl" %}
                    </div>
                </aside>
                {% endif %}
                {# Product grid #}
                <div class="{% if has_filters_available %}col-md-9{% else %}col-12{% endif %}">
                    {% include 'snipplets/grid/product-list.tpl' %}
                </div>
            </div>
        </div>
    </div>
</section>
{% elseif show_help %}
    {# Category Placeholder #}
    {% include 'snipplets/defaults/show_help_category.tpl' %}
{% endif %}
```

### Checklist de verificación:

- [ ] **Versión escritorio (≥ 768px):**
  - La sidebar con filtros aparece a la izquierda
  - El grid de productos ocupa el 75% restante a la derecha
  - NO aparece el botón "Filtrar" ni la barra sticky
  - Al hacer clic en un filtro, el grid se actualiza por AJAX
  - Las subcategorías se muestran en la sidebar (si existen)

- [ ] **Versión móvil (< 768px):**
  - NO aparece ninguna sidebar
  - El botón "Filtrar" / "Ordenar" aparece como siempre
  - Al hacer clic se abre el modal/drawer desde la izquierda
  - Los filtros dentro del modal funcionan normalmente
  - El grid de productos ocupa el 100% del ancho

- [ ] **Categoría sin filtros:**
  - No aparece sidebar en ningún viewport
  - El grid ocupa el 100% del ancho
  - No se rompe el layout

---

## Cómo revertir los cambios

Si necesitas volver al comportamiento original, solo hay que deshacer 2 cosas:

### 1. En `templates/category.tpl`:

Reemplaza toda la zona desde el comentario `{# Mobile:` hasta el cierre de `</section>` con el código original:

```twig
{% include 'snipplets/grid/filters-modals.tpl' %}
<section class="js-category-controls-prev category-controls-sticky-detector"></section>

<section class="category-body section-category-exclusive" data-store="category-grid-{{ category.id }}">
    <div class="container mt-4 mb-5">
        <div data-store="category-grid-{{ category.id }}">
            {% include 'snipplets/grid/product-list.tpl' %}
        </div>
    </div>
</section>
```

### 2. En `static/css/style-async.scss`:

Elimina el bloque completo al final del archivo:
```scss
/* ==========================================================
   CATEGORY SIDEBAR FILTERS (Desktop only)
   ========================================================== */

@media (min-width: 768px) {
  .category-sidebar-filters {
    padding-right: 15px;
    padding-bottom: 40px;
  }
}
```

---

## Consideraciones técnicas

### ¿Por qué funciona el JS de filtros sin cambios?

Los filtros de Tiendanube funcionan con clases JavaScript como `.js-apply-filter` y `.js-remove-filter`. Estos hooks están definidos dentro de `snipplets/grid/filters.tpl`. Cuando incluimos ese snippet en la sidebar, las mismas clases se renderizan y el JS nativo de Tiendanube las detecta automáticamente.

Cuando el usuario hace clic en un filtro, Tiendanube:
1. Lee `data-filter-name` y `data-filter-value` del elemento clickeado
2. Hace una petición AJAX a la URL de la categoría con los parámetros del filtro
3. Reemplaza el contenido del `data-store="category-grid-..."` con el HTML nuevo
4. El HTML nuevo ya viene con los filtros actualizados (checkboxes marcados/desmarcados)

### ¿Por qué la sidebar se actualiza después de filtrar?

La sidebar está DENTRO del `<div data-store="category-grid-{{ category.id }}">`. Cuando Tiendanube reemplaza el contenido de ese div después de un filtrado AJAX, toda la sidebar se re-renderiza con el estado correcto de los filtros.

### ¿Hay DOM duplicado?

Sí. En escritorio, existen dos sets de filtros en el DOM:
1. Dentro del modal (oculto con `d-md-none` en el wrapper padre)
2. En la sidebar (visible)

Esto no causa problemas porque:
- En escritorio: el usuario NUNCA interactúa con el modal (el botón para abrirlo está oculto)
- En móvil: el usuario NUNCA interactúa con la sidebar (está oculta con `d-none`)
- El AJAX de TN recarga todo el bloque `data-store`, así que ambos se re-renderizan correctamente

### ¿Qué pasa con `sort-by` (Ordenar) en escritorio?

Con esta implementación, la opción de "Ordenar" está dentro del modal. Como en escritorio el modal no se abre, la funcionalidad de ordenar queda disponible solo en móvil. Si necesitas agregar ordenación en desktop, podrías añadir un `component('sort-by')` dentro de la sidebar o arriba del grid como un dropdown separado.

### Breakpoint utilizado

Se usa `768px` como punto de corte (clases `d-md-*` de Bootstrap). Esto significa:
- **< 768px:** comportamiento móvil (modal)
- **≥ 768px:** comportamiento escritorio (sidebar)

Si necesitas cambiar este breakpoint, ajusta las clases Bootstrap (ej: `d-lg-none` / `d-none d-lg-block` para 992px).
