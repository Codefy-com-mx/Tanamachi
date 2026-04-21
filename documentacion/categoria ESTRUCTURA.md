# Análisis Completo: Página de Lista de Productos (Category)

> Documentación técnica exhaustiva de cómo funciona la página de colecciones en el tema Aguiar para Tiendanube.

---

## 1. Punto de entrada: `templates/category.tpl`

Este es el **único archivo de template** que Tiendanube carga cuando el usuario visita una URL de categoría (colección). Todo parte de ahí.

```
templates/category.tpl
```

---

## 2. Flujo de renderizado completo (árbol de archivos)

```
templates/category.tpl
│
├── snipplets/page-header.tpl          ← Título H1 + breadcrumbs
│   └── snipplets/breadcrumbs.tpl
│
├── snipplets/category-banner.tpl      ← Imagen de banner (condicional)
│
├── snipplets/grid/filters-modals.tpl  ← BARRA STICKY "Filtrar / Ordenar" + MODAL
│   ├── snipplets/modal.tpl            ← Estructura base del modal (embed)
│   ├── snipplets/grid/filters.tpl     ← (applied_filters=true) chips de filtros activos
│   ├── component('sort-by', ...)      ← Componente nativo TN de ordenación
│   ├── snipplets/grid/categories.tpl  ← Subcategorías dentro del modal
│   └── snipplets/grid/filters.tpl     ← (modal=true) lista de filtros disponibles
│
└── (section.category-body)
    └── snipplets/grid/product-list.tpl  ← Grid de productos + paginación
        ├── snipplets/product_grid.tpl   ← Loop de productos
        │   └── snipplets/grid/item.tpl  ← Tarjeta individual de producto
        │       ├── snipplets/labels.tpl
        │       ├── snipplets/grid/item-colors.tpl
        │       ├── snipplets/product/product-variants.tpl  (si quickshop)
        │       ├── snipplets/product/product-quantity.tpl  (si quickshop)
        │       └── snipplets/placeholders/button-placeholder.tpl
        └── snipplets/grid/pagination.tpl
```

---

## 3. Variables Twig clave en `category.tpl`

| Variable | Tipo | Descripción |
|---|---|---|
| `category.name` | string | **Nombre/título** de la colección → va al `<h1>` |
| `category.description` | string | **Descripción** de la categoría |
| `category.images` | array | Imágenes asignadas a esta categoría en el admin |
| `category.id` | int | ID único de la categoría |
| `category.url` | string | URL de la categoría |
| `products` | array | Lista de productos (vacía si no hay) |
| `has_products` | bool | `true` si hay productos cargados |
| `has_filters_enabled` | bool | `true` si los filtros están activados en el admin |
| `product_filters` | array | Objetos de filtro disponibles (precio, color, talle…) |
| `filter_categories` | array | Subcategorías disponibles como filtro |
| `has_applied_filters` | bool | `true` si hay filtros activos en la URL actual |
| `template` | string | Siempre `'category'` en esta página |
| `breadcrumbs` | array | Miga de pan |
| `parent_category` | object | Categoría padre (si existe) |
| `pages` | object | Datos de paginación |

---

## 4. Sección: Título y Descripción

### ¿Dónde se edita?

**En el panel de administración de Tiendanube → Catálogo → Categorías → [editar categoría]**

No hay campo en `settings.txt` para esto. Es dato dinámico de la plataforma.

### ¿Qué archivo lo renderiza?

**`templates/category.tpl` líneas 17-25** + **`snipplets/page-header.tpl`**

```twig
{# templates/category.tpl #}
{% embed "snipplets/page-header.tpl" with {container: false} %}
    {% block page_header_text %}{{ category.name }}{% endblock %}
{% endembed %}

{% if category.description %}
    <p class="mt-2 mb-4 text-center">{{ category.description }}</p>
{% endif %}
```

```twig
{# snipplets/page-header.tpl #}
<section class="page-header py-4 text-center" data-store="page-title">
    {% include 'snipplets/breadcrumbs.tpl' %}
    <h1 class="h4">{% block page_header_text %}{% endblock %}</h1>
</section>
```

**Resultado HTML:**
- `<h1 class="h4">` → contiene `{{ category.name }}`
- `<p class="mt-2 mb-4 text-center">` → contiene `{{ category.description }}`

---

## 5. Sección: Banner de Categoría

### ¿De dónde viene la imagen?

```twig
{# templates/category.tpl ln 14 #}
{% set category_banner = (category.images is not empty) or ("banner-products.jpg" | has_custom_image) %}
```

**Prioridad de imagen:**
1. **Imagen específica de categoría** → se sube desde Admin → Catálogo → Categorías → imagen de portada
2. **`banner-products.jpg` global** → se sube desde el customizer del tema en **"Listado de productos → Imagen para las categorías"** (`settings.txt` línea 1332-1336)

**Archivo:** `snipplets/category-banner.tpl`

```twig
{# Renderiza en resoluciones: large, huge, original, 1080p #}
<section class="category-banner position-relative mb-3" data-store="category-banner">
    <img fetchpriority="high" src="..." srcset="..." />
</section>
```

> **Nota:** Si ninguna de las dos fuentes tiene imagen, el banner **no se muestra**.

---

## 6. El Sistema de Filtros — Análisis Completo

### 6.1 ¿Dónde se activan los filtros?

**En el panel admin de Tiendanube → Marketing → Filtros** (URL interna: `/admin/v2/filters`)

No hay `checkbox` en `settings.txt` para activar/desactivar filtros. La variable `has_filters_enabled` la devuelve Tiendanube según la config del admin.

### 6.2 Condición de visibilidad del sistema de filtros

```twig
{# filters-modals.tpl línea 1-6 #}
{% set has_filters_available = products and has_filters_enabled and product_filters is not empty %}
{% set search_page_filters = template == 'search' and search_filter %}
{% set category_page = template == 'category' %}
{% set show_filters = products or has_filters_available %}

{% if show_filters and (category_page or search_page_filters) %}
    {# Toda la barra de controles se muestra #}
{% endif %}
```

**Condición resumida:** Se muestra si `products` existe Y la plantilla es `category` (o `search`).

### 6.3 La barra sticky "Filtrar / Ordenar"

```twig
<section class="js-category-controls category-controls visible-when-content-ready">
    <div class="container category-controls-container text-center">
        <a href="#" class="js-modal-open btn-link" data-toggle="#nav-filters" data-component="filter-button">
            {% if has_filters_available %}
                {{ "Filtrar" | t }}
            {% else %}
                {{ "Ordenar" | t }}  {# Si no hay filtros, solo muestra "Ordenar" #}
            {% endif %}
            {% if has_applied_filters %}
                <span class="filters-badge ml-1">
                    (<span class="js-filters-badge"></span>)
                </span>
            {% endif %}
        </a>
    </div>
</section>
```

**El botón abre el modal `#nav-filters` mediante la clase `js-modal-open`.**

> **CSS key:** `.category-controls` tiene `position: sticky; top: 0; z-index: 100;` — está siempre visible al scrollear.

El sticky se activa con el elemento detector:
```html
<section class="js-category-controls-prev category-controls-sticky-detector"></section>
```
`.category-controls-sticky-detector { height: 1px; }` — sirve como centinela para el JS nativo.

### 6.4 El Modal de Filtros — Estructura Completa

**El modal se crea con embed de `snipplets/modal.tpl`:**

```twig
{% embed "snipplets/modal.tpl" with {
    modal_id: 'nav-filters',
    modal_class: 'filters',
    modal_position: 'left',
    modal_transition: 'slide',
    modal_header_title: true,
    modal_close_floating: true,
    modal_width: 'drawer modal-docked-small'
} %}
```

**Parámetros del modal:**

| Parámetro | Valor | Efecto |
|---|---|---|
| `modal_id` | `'nav-filters'` | ID del `<div>` del modal |
| `modal_position` | `'left'` | Desliza desde la izquierda (`.modal-left`) |
| `modal_transition` | `'slide'` | Animación de deslizamiento |
| `modal_width` | `'drawer modal-docked-small'` | Panel lateral angosto |
| `modal_close_floating` | `true` | Botón X flotante |

**HTML base generado por `snipplets/modal.tpl`:**
```html
<div id="nav-filters"
     class="js-modal modal modal-filters modal-left transition-slide modal-drawer modal-docked-small transition-soft"
     style="display: none;">
    <div class="js-modal-close modal-header">
        <div class="row no-gutters align-items-center">
            <div class="col">Filtrar / Ordenar</div>
            <div class="col-auto">
                <a class="js-modal-close modal-close modal-close-floating">✕</a>
            </div>
        </div>
    </div>
    <div class="modal-body">
        <!-- block modal_body -->
    </div>
</div>
<div class="js-modal-overlay modal-overlay" data-modal-id="#nav-filters" style="display: none;"></div>
```

### 6.5 Contenido del modal (block `modal_body`)

El interior del modal se arma en **`filters-modals.tpl` líneas 30-80**. Tiene 6 zonas en orden:

```
modal_body:
├── [1] filters.tpl {applied_filters: true}   ← Chips de filtros activos (tags eliminables)
├── [2] component('sort-by', {...})             ← Opciones de ordenación (componente nativo TN)
├── [3] categories.tpl {modal: true}           ← Subcategorías (si filter_categories not empty)
├── [4] filters.tpl {modal: true}              ← Lista de filtros disponibles (si product_filters not empty)
├── [5] .js-filters-overlay                    ← Overlay "Aplicando filtro..." (oculto por defecto)
└── [6] .js-sorting-overlay                    ← Overlay "Ordenando productos..." (oculto por defecto)
```

### 6.6 `filters.tpl` — Dos modos de uso

**Modo 1: `{applied_filters: true}` — Chips activos**

Muestra los filtros que YA están aplicados como "pills" eliminables:

```html
<button class="js-remove-filter js-remove-filter-chip chip"
        data-filter-name="color"
        data-filter-value="Rojo">
    Rojo <svg>✕</svg>
</button>
<a class="js-remove-all-filters btn-link">Borrar filtros</a>
```

**Modo 2: `{modal: true}` — Lista de filtros disponibles**

Itera `product_filters` y renderiza cada grupo:

```twig
{% for product_filter in product_filters %}
    {% if product_filter.type == 'price' %}
        {{ component('price-filter', {...}) }}  ← Componente nativo TN
    {% else %}
        {% if product_filter.has_products %}

            <div class="js-accordion-container" data-store="filters-group"
                 data-component="list.filter-{{ product_filter.type }}"
                 data-component-value="{{ product_filter.key }}">

                <div class="font-small font-weight-bold">{{ product_filter.name }}</div>

                {% for value in product_filter.values %}
                    {% if value.product_count > 0 %}
                        <label class="js-filter-checkbox
                                      {% if not value.selected %}js-apply-filter{% else %}js-remove-filter{% endif %}
                                      checkbox-container"
                               data-filter-name="{{ product_filter.key }}"
                               data-filter-value="{{ value.name }}">
                            <input type="checkbox" {% if value.selected %}checked{% endif %}/>
                            <span class="checkbox">
                                <span class="checkbox-text">
                                    {{ value.name }} <span>({{ value.product_count }})</span>
                                </span>
                                {# Swatch de color (solo si es tipo color + insta_color) #}
                                {% if product_filter.type == 'color' and value.color_type == 'insta_color' %}
                                    <span class="checkbox-color" style="background-color: {{ value.color_hexa }};"></span>
                                {% endif %}
                            </span>
                        </label>
                    {% endif %}
                    {# Si hay más de 8 valores: se genera accordion "Ver todos / Ver menos" #}
                {% endfor %}
            </div>

        {% endif %}
    {% endif %}
{% endfor %}
```

**Tipos de filtro soportados por el template:**

| Tipo | Renderizado |
|---|---|
| `price` | Componente nativo TN de rango de precios |
| `color` | Checkbox + swatch de color (si `color_type == 'insta_color'`) |
| Cualquier otro (talle, material, etc.) | Checkbox estándar con contador |

**Accordion automático:** Si un grupo de filtros tiene más de 8 valores con productos, los sobrantes se colapsan detrás de un enlace "Ver todos / Ver menos".

### 6.7 `component('sort-by')` — Ordenación

Componente 100% nativo de Tiendanube. Las clases CSS asignadas en `filters-modals.tpl`:

```twig
component('sort-by', {
    list: true,
    list_title: false,
    svg_sprites: true,
    sort_by_classes: {
        list: "list-unstyled radio-button-container",
        list_item: "radio-button-item",
        radio_button: "radio-button",
        radio_button_content: "radio-button-content",
        radio_button_icons_container: "radio-button-icons-container",
        radio_button_icons: "radio-button-icons",
        radio_button_icon: "radio-button-icon",
        radio_button_label: "radio-button-label",
        applying_feedback_message: "h5 mr-2",
        applying_feedback_icon: "icon-inline h5 icon-spin icon-w-2em svg-icon-text ml-2",
    },
    applying_feedback_svg_id: "spinner-third",
})
```

Opciones de ordenación que Tiendanube expone nativamente: relevancia, precio ascendente/descendente, nombre A-Z, más reciente.

### 6.8 `categories.tpl` — Subcategorías como filtro

Se muestra **dentro del modal** cuando `filter_categories is not empty`:

```twig
{# Modo modal #}
<div class="font-small font-weight-bold mt-3 mb-4">Categorías</div>
<ul class="js-accordion-container list-unstyled mb-3 pb-1">
    {% for category in filter_categories %}
        <li>
            <a href="{{ category.url }}" class="btn-link font-small no-underline">
                {{ category.name }}
            </a>
        </li>
        {# Si hay más de 8 categorías: accordion automático #}
    {% endfor %}
</ul>
```

### 6.9 Overlays de loading del modal

Durante la aplicación de un filtro:
```html
<div class="js-filters-overlay filters-overlay" style="display: none;">
    <div class="filters-updating-message">
        <span class="js-applying-filter h5" style="display: none;">Aplicando filtro</span>
        <span class="js-removing-filter h5" style="display: none;">Borrando filtro</span>
        <svg class="icon-spin"><!-- spinner --></svg>
    </div>
</div>
```

Durante la ordenación:
```html
<div class="js-sorting-overlay filters-overlay" style="display: none;">
    <div class="filters-updating-message">
        <span class="h5">Ordenando productos</span>
        <svg class="icon-spin"><!-- spinner --></svg>
    </div>
</div>
```

> **CSS de los overlays:** `.filters-overlay { position: fixed; top: 0; left: 0; z-index: 30000; width: 80%; height: 100%; }`

---

## 7. Grid de Productos

### Cadena de archivos

```
snipplets/grid/product-list.tpl
    → snipplets/product_grid.tpl
        → snipplets/grid/item.tpl  (por cada producto)
```

### `product-list.tpl`

- Si `products` existe → muestra `.js-product-table.row.row-grid` + paginación
- Si no hay productos → muestra mensaje "Próximamente" (sin filtros) o "No tenemos resultados para tu búsqueda. Por favor, intentá con otros filtros." (con filtros activos)

### `product_grid.tpl`

```twig
{% for product in products %}
    {# Los primeros 2 productos reciben image_priority_high: true (carga eager) #}
    {% include 'snipplets/grid/item.tpl' with {image_priority_high: image_priority_high_value} %}
{% endfor %}
```

### `item.tpl` — Variables que controlan columnas

```twig
{% set columns_desktop = settings.grid_columns_desktop %}  {# 2, 3, o 4 #}
{% set columns_mobile = settings.grid_columns_mobile %}    {# 1 o 2 #}
```

Clases Bootstrap generadas dinámicamente:
```twig
class="col-{% if columns_mobile == 1 %}12{% else %}6{% endif %}
       col-md-{% if columns_desktop == 2 %}6{% elseif columns_desktop == 3 %}4{% else %}3{% endif %}"
```

---

## 8. Paginación

**`snipplets/grid/pagination.tpl`** — controlado por `settings.pagination`:

| Valor | Comportamiento | Productos por página |
|---|---|---|
| `classic` | Paginación numérica (anterior / X de Y / siguiente) | 24 |
| `infinite` | Botón "Mostrar más productos" + carga infinita automática | 12 |

Definición en `templates/category.tpl`:
```twig
{% if settings.pagination == 'infinite' %}
    {% paginate by 12 %}
{% else %}
    {% paginate by 24 %}
{% endif %}
```

---

## 9. Configuración en `settings.txt` — Sección "Listado de productos" (línea 1326)

| Setting name | Tipo | Lo que controla |
|---|---|---|
| `banner-products.jpg` | image | Banner global de todas las categorías (fallback) |
| `grid_columns_mobile` | dropdown | Columnas en móvil: `1` ó `2` |
| `grid_columns_desktop` | dropdown | Columnas en desktop: `2`, `3`, ó `4` |
| `pagination` | dropdown | `classic` (páginas) ó `infinite` (carga infinita) |
| `quick_shop` | checkbox | Botón "Comprar" rápido en la tarjeta de producto |
| `product_color_variants` | checkbox | Swatches de color en la tarjeta |
| `product_hover` | checkbox | Segunda foto al hacer hover (desktop) |
| `product_item_slider` | checkbox | Carrusel de fotos por producto (solo en categoría y búsqueda) |
| `product_installments` | checkbox | Mostrar cuotas en el listado |

> ⚠️ Los filtros en sí **no tienen setting** en `settings.txt`. Se configuran exclusivamente desde el admin de Tiendanube en `/admin/v2/filters`.

---

## 10. CSS Relevante

### Archivos CSS implicados

| Archivo | Qué cubre |
|---|---|
| `static/css/style-critical.scss` | `.category-controls`, `.filters-badge`, `.item`, `.item-image`, `.item-description`, `.item-name`, `.item-price-container`, `.label` |
| `static/css/style-async.scss` | `.filters-overlay`, `.price-filter-container`, `.filter-input-price`, `.section-category-exclusive` |

### `.category-controls` (barra sticky)

```scss
// style-critical.scss
.category-controls {
    position: sticky;
    top: 0;
    z-index: 100;
    padding: 10px 0;
    transition: all 0.1s ease;
}

.category-controls-sticky-detector {
    height: 1px;   // Elemento centinela para el JS
}

.filters-badge {
    position: absolute;
    font-size: var(--font-base);
}
```

### `.filters-overlay` (overlay de carga del modal)

```scss
// style-async.scss
.filters-overlay {
    position: fixed;
    top: 0;
    left: 0;
    z-index: 30000;
    width: 80%;
    height: 100%;

    .filters-updating-message {
        position: absolute;
        top: 50%;
        left: 50%;
        width: 80%;
        text-align: center;
        transform: translate(-50%, -50%);
    }
}
```

### `.section-category-exclusive` (diseño editorial premium)

Clase aplicada directamente en `category.tpl`:
```html
<section class="category-body section-category-exclusive" data-store="category-grid-{{ category.id }}">
```

Activa desde `style-async.scss` el diseño de tarjetas exclusivo:
- Aspect ratio `3/4` en imágenes (verticales tipo retrato)
- Gradiente oscuro inferior para legibilidad
- Título de sección alineado a la izquierda en uppercase
- Oculta etiquetas, cuotas y colores para diseño minimalista
- Hover con `scale(1.05)` en la imagen

---

## 11. Señales JavaScript clave

| Clase / Atributo | Función |
|---|---|
| `.js-modal-open` + `data-toggle="#nav-filters"` | Abre el modal de filtros |
| `.js-modal-close` | Cierra el modal |
| `.js-modal-overlay` | Overlay oscuro de fondo del modal |
| `.js-apply-filter` | Aplica un filtro al hacer click en checkbox |
| `.js-remove-filter` | Elimina un filtro (desde chip O desde checkbox) |
| `.js-remove-all-filters` | Elimina todos los filtros activos |
| `.js-filters-badge` | Span que muestra el número de filtros activos |
| `.js-category-controls` | Detectado por JS para comportamiento sticky |
| `.js-category-controls-prev` | Centinela para activar sticky al cruzar el viewport |
| `.js-product-table` | Contenedor del grid que JS repinta tras filtrar (AJAX) |
| `.js-load-more` | Botón de carga infinita |
| `data-store="category-grid-{{ category.id }}"` | Hook reactivo de Tiendanube para el grid |
| `data-store="filters-nav"` | Hook de Tiendanube para el contenedor de filtros |
| `data-store="page-title"` | Hook reactivo del título de página |
| `data-store="category-banner"` | Hook reactivo del banner |

> **Importante:** El comportamiento del modal, los filtros vía AJAX y el sort-by son **manejados 100% por el JS nativo de Tiendanube** (`static/js/store.js.tpl`). El tema solo define la estructura HTML y los estilos.

---

## 12. Diagrama visual de zonas y archivos

```
┌─────────────────────────────────────────────────────────────────────────┐
│  ZONA VISUAL                → ARCHIVO QUE LA CONTROLA                   │
├─────────────────────────────────────────────────────────────────────────┤
│  Breadcrumbs (miga de pan)  → snipplets/breadcrumbs.tpl                 │
│  Título H1                  → snipplets/page-header.tpl                 │
│                               dato: category.name (admin TN)            │
│  Descripción párrafo        → templates/category.tpl líneas 23-25       │
│                               dato: category.description (admin TN)     │
│  Banner imagen              → snipplets/category-banner.tpl             │
│                               fuente 1: category.images (por categoría) │
│                               fuente 2: banner-products.jpg (global)    │
│  Barra sticky Filtrar       → snipplets/grid/filters-modals.tpl         │
│  Modal panel lateral        → snipplets/modal.tpl (via embed)           │
│  Chips filtros activos      → snipplets/grid/filters.tpl                │
│  Opciones ordenar           → component('sort-by') — nativo TN          │
│  Subcategorías en modal     → snipplets/grid/categories.tpl             │
│  Lista de checkboxes        → snipplets/grid/filters.tpl                │
│  Grid de productos          → snipplets/grid/product-list.tpl           │
│                             → snipplets/product_grid.tpl                │
│                             → snipplets/grid/item.tpl                   │
│  Paginación                 → snipplets/grid/pagination.tpl             │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 13. Quick Reference: ¿Qué quiero cambiar?

| Objetivo | Qué tocar |
|---|---|
| Cambiar el **título** de la categoría | Admin TN → Catálogo → Categorías → Nombre |
| Cambiar la **descripción** | Admin TN → Catálogo → Categorías → Descripción |
| Cambiar la **imagen de banner** por categoría | Admin TN → Catálogo → Categorías → Imagen de portada |
| Cambiar la **imagen de banner** global (fallback) | Customizer → Listado → subir `banner-products.jpg` |
| Quitar el banner | Dejar vacío `category.images` Y no subir `banner-products.jpg` |
| Cambiar **columnas del grid** | Customizer → Listado → `grid_columns_desktop` / `grid_columns_mobile` |
| Cambiar **paginación** | Customizer → Listado → `pagination` |
| Activar/desactivar **filtros** | Admin TN → Marketing → Filtros (`/admin/v2/filters`) |
| Editar la **estructura del modal** | `snipplets/grid/filters-modals.tpl` + `snipplets/modal.tpl` |
| Editar los **checkboxes de filtros** | `snipplets/grid/filters.tpl` |
| Editar las **subcategorías** en el modal | `snipplets/grid/categories.tpl` |
| Cambiar el **look de las tarjetas** (estilo exclusivo) | `static/css/style-async.scss` → `.section-category-exclusive` |
| Editar la **tarjeta de producto** | `snipplets/grid/item.tpl` |
| Activar/desactivar **compra rápida** | Customizer → `quick_shop` + `snipplets/grid/item.tpl` |
| Cambiar la **barra sticky** de controles | `snipplets/grid/filters-modals.tpl` líneas 7-21 |
| Cambiar **estilos** de la barra sticky | `static/css/style-critical.scss` → `.category-controls` |
