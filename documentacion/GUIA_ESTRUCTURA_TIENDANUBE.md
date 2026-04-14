# 📚 Guía Completa: Estructura de Temas en Tiendanube

## 🏗️ Arquitectura General

Un tema de Tiendanube sigue una estructura modular que separa configuración, diseño y lógica.

```
tema-tiendanube/
├── config/              # Configuración del tema
│   ├── data.json       # Metadatos del tema
│   ├── settings.txt    # Opciones configurables en el admin
│   ├── defaults.txt    # Valores por defecto
│   ├── sections.txt    # Secciones del tema (deprecado)
│   ├── translations.txt # Traducciones personalizadas
│   └── variants.txt    # Variantes de colores/estilos
├── layouts/
│   └── layout.tpl      # Plantilla HTML base
├── templates/          # Páginas principales
│   ├── home.tpl
│   ├── product.tpl
│   ├── category.tpl
│   ├── cart.tpl
│   └── ...
├── snipplets/          # Componentes reutilizables
│   ├── home/
│   ├── product/
│   ├── grid/
│   └── ...
└── static/             # Archivos estáticos
    ├── css/
    ├── js/
    └── images/
```

---

## 📁 Directorio `/config/`

### `settings.txt` - El corazón del tema

Este archivo define **TODAS** las opciones que el administrador puede modificar desde el panel de Tiendanube.

#### Tipos de campos disponibles:

```txt
# 1. CHECKBOX - Activar/desactivar
checkbox
	name = mi_opcion
	description = Activar característica

# 2. INPUT - Texto simple
input
	name = mi_texto
	description = Ingresa un texto

# 3. I18N_INPUT - Texto multiidioma
i18n_input
	name = mi_titulo
	description = Título de la sección
	# Genera automáticamente: mi_titulo_es, mi_titulo_en, mi_titulo_pt

# 4. TEXTAREA - Texto largo
textarea
	name = mi_descripcion
	description = Descripción larga

# 5. COLOR - Selector de color
color
	name = mi_color
	description = Color de fondo
	# Devuelve: #FFFFFF o rgba(255, 255, 255, 0.5)

# 6. DROPDOWN - Lista desplegable
dropdown
	name = mi_opcion
	description = Selecciona una opción
	values
		opcion1 = Opción 1
		opcion2 = Opción 2
		opcion3 = Opción 3

# 7. RANGE_NUMBER - Número con slider
range_number
	name = mi_numero
	description = Tamaño (px)
	min = 0
	max = 100

# 8. FONT - Selector de fuente
font
	name = mi_fuente
	description = Fuente del texto
	# Devuelve: "Arial", sans-serif

# 9. IMAGE - Selector de imagen
image
	name = mi_imagen
	description = Sube una imagen
	# Devuelve la URL de la imagen

# 10. GALLERY - Galería de imágenes
gallery
	name = mi_galeria
	description = Imágenes del slider
	gallery_link = true           # Permite agregar enlaces
	gallery_width = 800           # Ancho recomendado
	gallery_height = 600          # Alto recomendado
	gallery_caption = true        # Campo de caption personalizado
	gallery_more_info = true      # Campos adicionales (title, description, button, color)
	# gallery_caption y gallery_more_info NO se pueden usar juntos

# 11. COLLAPSE - Agrupador de opciones
collapse
	name = mi_seccion_cfg
	description = Configuración de mi sección
	backto = home_order_position  # Link de retorno
	
	# Aquí van los campos de esta sección
	checkbox
		name = mostrar_seccion
		description = Mostrar sección
```

#### Ejemplo completo de una sección:

```txt
collapse
	name = featured_products_cfg
	description = Productos destacados
	backto = home_order_position
	
	checkbox
		name = featured_products_show
		description = Mostrar productos destacados
	
	i18n_input
		name = featured_products_title
		description = Título de la sección
	
	dropdown
		name = featured_products_format
		description = Formato de visualización
		values
			grid = Grilla
			slider = Carrusel
	
	dropdown
		name = featured_products_mobile
		description = Columnas en móvil
		values
			1 = 1 columna
			2 = 2 columnas
			3 = 3 columnas
	
	dropdown
		name = featured_products_desktop
		description = Columnas en desktop
		values
			2 = 2 columnas
			3 = 3 columnas
			4 = 4 columnas
```

---

### `defaults.txt` - Valores iniciales

**CADA** campo en `settings.txt` DEBE tener un valor por defecto aquí.

```txt
# Formato: nombre_del_campo = valor_por_defecto

# Checkbox (0 o 1)
featured_products_show = 1

# I18n_input (un valor por idioma)
featured_products_title_es = Productos Destacados
featured_products_title_en = Featured Products
featured_products_title_pt = Produtos em Destaque

# Dropdown (una de las opciones)
featured_products_format = grid
featured_products_mobile = 2
featured_products_desktop = 3

# Color (hex o rgba)
background_color = #FFFFFF
text_color = rgba(51, 51, 51, 1)

# Number
border_radius = 8
padding = 20

# Font
font_headings = "Roboto", sans-serif
font_rest = "Open Sans", sans-serif
```

**⚠️ IMPORTANTE:**
- Si un campo no tiene valor por defecto, puede causar errores
- Los nombres deben coincidir EXACTAMENTE con `settings.txt`
- Para `i18n_input`, agrega el sufijo del idioma: `_es`, `_en`, `_pt`

---

### `data.json` - Metadatos del tema

```json
{
  "name": "Mi Tema",
  "version": "1.0.0",
  "author": "Tu Nombre",
  "description": "Un tema increíble para Tiendanube",
  "preview_image": "preview.jpg",
  "supports": {
    "footer": true,
    "mobile": true,
    "responsive": true
  }
}
```

---

### `translations.txt` - Traducciones personalizadas

Agrega traducciones que no existen en el sistema base de Tiendanube:

```txt
es:
  mi_texto_personalizado: "Texto en español"
  boton_ver_mas: "Ver más productos"

en:
  mi_texto_personalizado: "Text in english"
  boton_ver_mas: "View more products"

pt:
  mi_texto_personalizado: "Texto em português"
  boton_ver_mas: "Ver mais produtos"
```

**Uso en templates:**
```twig
{{ 'mi_texto_personalizado' | translate }}
```

---

## 📄 Directorio `/layouts/`

### `layout.tpl` - El esqueleto HTML

Este archivo es el **layout maestro** que envuelve todas las páginas.

```twig
<!DOCTYPE html>
<html lang="{{ language.lang }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    {# Tiendanube inyecta automáticamente meta tags, CSS base, etc. #}
    {{ head_content }}
    
    {# Tus CSS personalizados #}
    {{ 'style.css' | static_url | css_tag }}
    
    {# Scripts específicos por template #}
    {% if template == 'home' %}
        {{ 'https://unpkg.com/embla-carousel/embla-carousel.umd.js' | script_tag(true) }}
    {% endif %}
</head>
<body class="{{ template }}-template">
    
    {# Header #}
    {% include 'snipplets/header/header.tpl' %}
    
    {# Contenido principal - cada template se inyecta aquí #}
    <main>
        {{ page_content }}
    </main>
    
    {# Footer #}
    {% include 'snipplets/footer/footer.tpl' %}
    
    {# Tiendanube inyecta scripts necesarios (jQuery, etc.) #}
    {{ body_content }}
    
    {# Tus scripts personalizados #}
    {{ 'scripts.js' | static_url | script_tag }}
</body>
</html>
```

**Variables importantes:**
- `{{ head_content }}` - Meta tags, CSS base de Tiendanube
- `{{ page_content }}` - Contenido del template actual
- `{{ body_content }}` - Scripts base de Tiendanube
- `{{ template }}` - Nombre del template actual (`home`, `product`, etc.)
- `{{ language.lang }}` - Idioma actual (`es`, `en`, `pt`)

---

## 📄 Directorio `/templates/`

Los templates son las **páginas principales** de la tienda.

### Templates disponibles:

```
templates/
├── home.tpl           # Página de inicio
├── product.tpl        # Página de producto individual
├── category.tpl       # Página de categoría
├── cart.tpl          # Carrito de compras
├── search.tpl        # Resultados de búsqueda
├── contact.tpl       # Página de contacto
├── page.tpl          # Páginas estáticas (Sobre nosotros, etc.)
├── 404.tpl           # Página de error 404
├── password.tpl      # Página de password (tienda privada)
└── account/
    ├── login.tpl     # Login de usuario
    ├── register.tpl  # Registro de usuario
    └── orders.tpl    # Pedidos del usuario
```

### Ejemplo: `home.tpl`

```twig
{#/*============================================================================
  #Home
==============================================================================*/#}

<div class="container">
    {# Selector de orden de secciones #}
    {% set show_help = not has_products %}
    
    {% for section_select in settings.home_order_position %}
        {% include 'snipplets/home/home-section-switch.tpl' %}
    {% endfor %}
</div>
```

**⚠️ IMPORTANTE:**
- Los templates se **inyectan** en `{{ page_content }}` del layout
- NO incluyas `<html>`, `<head>`, `<body>` aquí
- Usa `{% include %}` para componentes reutilizables

---

## 🧩 Directorio `/snipplets/`

Los snipplets son **componentes reutilizables** (como React components).

### Organización recomendada:

```
snipplets/
├── home/                    # Componentes del home
│   ├── home-section-switch.tpl
│   ├── home-slider.tpl
│   ├── home-featured-products.tpl
│   └── home-carrusel-secciones.tpl
├── product/                 # Componentes de producto
│   ├── product-form.tpl
│   ├── product-image.tpl
│   └── product-variants.tpl
├── grid/                    # Componentes de grilla
│   ├── item.tpl
│   └── filters.tpl
├── header/                  # Componentes del header
│   ├── header.tpl
│   ├── header-search.tpl
│   └── header-utilities.tpl
├── footer/
│   └── footer.tpl
└── defaults/               # Mensajes de ayuda
    └── home/
        └── slider_help.tpl
```

### Diferencia: `{% include %}` vs `{% snipplet %}`

```twig
{# include - Incluye el archivo directamente #}
{% include 'snipplets/header/header.tpl' %}

{# snipplet - Incluye solo si el archivo existe (más seguro) #}
{% snipplet 'snipplets/header/header.tpl' %}
```

**Recomendación:** Usa `{% include %}` para componentes que siempre existen, y `{% snipplet %}` para componentes opcionales o de ayuda.

---

## 🔄 Sistema de Secciones del Home

### `home-section-switch.tpl` - El director de orquesta

Este archivo controla **qué sección se muestra y en qué orden**.

```twig
{% if section_select == 'slider' %}
    {# Slider principal #}
    {% set has_slider = settings.slider and settings.slider is not empty %}
    {% if show_help or not has_slider %}
        {% snipplet 'defaults/home/slider_help.tpl' %}
    {% else %}
        {% include 'snipplets/home/home-slider.tpl' %}
    {% endif %}

{% elseif section_select == 'featured_products' %}
    {# Productos destacados #}
    {% if settings.featured_products_show %}
        {% include 'snipplets/home/home-featured-products.tpl' %}
    {% endif %}

{% elseif section_select == 'mi_nueva_seccion' %}
    {# Tu sección personalizada #}
    {% set has_items = settings.mi_nueva_seccion_items and settings.mi_nueva_seccion_items is not empty %}
    {% if show_help or not has_items %}
        {% snipplet 'defaults/home/mi_seccion_help.tpl' %}
    {% else %}
        {% include 'snipplets/home/home-mi-nueva-seccion.tpl' %}
    {% endif %}

{% endif %}
```

### Flujo de trabajo para agregar una sección:

1. **Define la sección en `settings.txt`:**
```txt
collapse
	name = mi_seccion_cfg
	description = Mi Sección
	backto = home_order_position
	
	checkbox
		name = mi_seccion_show
		description = Mostrar sección
```

2. **Agrega la sección al selector de orden:**
```txt
dropdown
	name = home_order_position
	description = Orden de las secciones
	values
		slider = Slider
		featured_products = Productos destacados
		mi_seccion = Mi Sección  # ← AGREGAR AQUÍ
```

3. **Agrega valores por defecto en `defaults.txt`:**
```txt
mi_seccion_show = 1
```

4. **Agrega el case en `home-section-switch.tpl`:**
```twig
{% elseif section_select == 'mi_seccion' %}
    {% if settings.mi_seccion_show %}
        {% include 'snipplets/home/home-mi-seccion.tpl' %}
    {% endif %}
{% endif %}
```

5. **Crea el snippet `snipplets/home/home-mi-seccion.tpl`:**
```twig
<section class="section-mi-seccion">
    <div class="container">
        <h2>Mi Sección</h2>
        {# Tu código aquí #}
    </div>
</section>
```

---

## 🎨 Directorio `/static/`

### Estructura:

```
static/
├── css/
│   ├── style.css        # CSS principal
│   └── custom.css       # CSS personalizado
├── js/
│   ├── script.js        # JavaScript principal
│   └── custom.js        # JavaScript personalizado
└── images/
    ├── logo.png
    ├── placeholder.png
    └── icons/
```

### Cómo referenciar archivos estáticos:

```twig
{# CSS #}
{{ 'css/style.css' | static_url | css_tag }}

{# JavaScript #}
{{ 'js/script.js' | static_url | script_tag }}

{# Imagen #}
<img src="{{ 'images/logo.png' | static_url }}" alt="Logo">

{# URL directa #}
{% set image_url = 'images/placeholder.png' | static_url %}
```

---

## 🔧 Motor de Templates: Twig

Tiendanube usa **Twig** como motor de templates.

### Variables globales disponibles:

```twig
{# Información de la tienda #}
{{ store.name }}
{{ store.url }}
{{ store.email }}

{# Idioma actual #}
{{ language.lang }}  {# es, en, pt #}
{{ language.country }}  {# AR, BR, MX, etc. #}

{# Template actual #}
{{ template }}  {# home, product, category, etc. #}

{# Usuario actual #}
{% if customer %}
    {{ customer.name }}
    {{ customer.email }}
{% endif %}

{# Configuraciones del tema #}
{{ settings.mi_opcion }}
{{ settings.background_color }}

{# Carrito #}
{{ cart.items_count }}
{{ cart.total }}
```

### Condicionales:

```twig
{% if settings.mostrar_seccion %}
    {# Contenido #}
{% endif %}

{% if products %}
    {# Hay productos #}
{% else %}
    {# No hay productos #}
{% endif %}

{% if template == 'home' %}
    {# Código solo para home #}
{% elseif template == 'product' %}
    {# Código solo para producto #}
{% endif %}
```

### Loops:

```twig
{% for product in products %}
    <div class="product">
        {{ product.name }}
        {{ product.price }}
    </div>
{% endfor %}

{% for slide in settings.slider %}
    <div class="slide">
        <img src="{{ slide.image | static_url }}" alt="">
    </div>
{% endfor %}
```

### Filtros útiles:

```twig
{# Traducir #}
{{ 'Mi texto' | translate }}

{# Formatear precio #}
{{ product.price | money }}

{# URL estática #}
{{ 'images/logo.png' | static_url }}

{# Redimensionar imagen #}
{{ product.image | product_image_url('large') }}
{{ slide.image | static_url | settings_image_url('medium') }}

{# URL de enlace de configuración #}
{{ settings.mi_link | setting_url }}

{# JSON encode (para debug) #}
{{ variable | json_encode }}

{# Truncar texto #}
{{ description | truncate(100) }}

{# Sin HTML #}
{{ texto | striptags }}
```

### Funciones útiles:

```twig
{# Incluir CSS #}
{{ 'style.css' | static_url | css_tag }}

{# Incluir JS #}
{{ 'script.js' | static_url | script_tag }}

{# Cargar librería externa #}
{{ 'https://unpkg.com/library@1.0.0/dist/library.js' | script_tag(true) }}
{# El parámetro 'true' indica que es una URL externa #}
```

---

## 🖼️ Trabajar con Imágenes

### Tipos de campos de imagen:

#### 1. **IMAGE** - Una sola imagen
```txt
image
	original = mi_banner.jpg    # ⚠️ OBLIGATORIO para campos image
	name = mi_banner
	description = Banner principal
	width = 800                 # Recomendado
	height = 600               # Recomendado
```

**⚠️ IMPORTANTE:** Los campos `image` DEBEN tener la línea `original = nombre_campo.jpg`

**Uso correcto:**
```twig
{# Verificar si la imagen existe #}
{% set banner_image = 'mi_banner.jpg' | has_custom_image %}

{# Mostrar imagen solo si existe #}
{% if banner_image %}
    <img 
        src="{{ 'images/empty-placeholder.png' | static_url }}" 
        data-src="{{ 'mi_banner.jpg' | static_url | settings_image_url('large') }}" 
        alt="Banner"
        class="lazyload img-fluid"
    >
{% endif %}

{# Como background-image #}
<section {% if banner_image %}style="background-image: url('{{ 'mi_banner.jpg' | static_url | settings_image_url('huge') }}');"{% endif %}>
```

**❌ INCORRECTO:**
```twig
{# NO funciona - settings.mi_banner no contiene la URL #}
<img src="{{ settings.mi_banner | static_url }}" alt="Banner">
```

#### 2. **GALLERY** - Múltiples imágenes

**Opción A: Solo imágenes (básico)**
```txt
gallery
	name = mi_galeria
	description = Galería de imágenes
	gallery_width = 800
	gallery_height = 600
```

**Uso:**
```twig
{% for imagen in settings.mi_galeria %}
    <img src="{{ imagen | static_url | settings_image_url('large') }}" alt="">
{% endfor %}
```

**Opción B: Con campos adicionales (avanzado)**
```txt
gallery
	name = mi_slider
	description = Slider de imágenes
	gallery_link = true        # Permite agregar enlaces
	gallery_width = 1200
	gallery_height = 600
	gallery_more_info = true   # Activa campos: title, description, button, color
```

**Uso:**
```twig
{% for slide in settings.mi_slider %}
    <div class="slide">
        {% if slide.link %}
            <a href="{{ slide.link | setting_url }}">
        {% endif %}
        
        <img 
            src="{{ 'images/placeholder.png' | static_url }}" 
            data-src="{{ slide.image | static_url | settings_image_url('large') }}" 
            alt="{{ slide.title }}"
            class="lazyload"
        >
        
        {% if slide.link %}
            </a>
        {% endif %}
        
        {% if slide.title %}
            <h3>{{ slide.title | translate }}</h3>
        {% endif %}
        
        {% if slide.description %}
            <p>{{ slide.description | translate }}</p>
        {% endif %}
    </div>
{% endfor %}
```

**⚠️ IMPORTANTE: Estructura de datos del Gallery**

Cuando usas `gallery_more_info = true`, cada item tiene esta estructura:

```javascript
{
    image: "...",        // URL de la imagen
    link: "...",         // URL del enlace (si gallery_link = true)
    title: "...",        // Título
    description: "...",  // Descripción
    button: "...",       // Texto del botón
    color: "..."         // Color
}
```

**Acceso correcto:**
```twig
{{ slide.image }}       ✅ Correcto
{{ slide.title }}       ✅ Correcto
{{ slide.link }}        ✅ Correcto

{{ slide | static_url }}  ❌ INCORRECTO
{{ item.image }}          ❌ Incorrecto (si usas 'slide' en el for)
```

### ⚠️ DIFERENCIAS CRÍTICAS: IMAGE vs GALLERY

**CAMPOS `image` (una sola imagen):**
- **Configuración:** `original = nombre_campo.jpg` (OBLIGATORIO)
- **Verificación:** `'nombre_campo.jpg' | has_custom_image`
- **Carga:** `'nombre_campo.jpg' | static_url | settings_image_url('tamaño')`
- **Uso:** Para banners, logos, imágenes individuales

**CAMPOS `gallery` (múltiples imágenes):**
- **Configuración:** Sin `original`, usa `gallery_width/height`
- **Verificación:** `settings.nombre_campo and settings.nombre_campo is not empty`
- **Carga:** `slide.image | static_url | settings_image_url('tamaño')`
- **Uso:** Para sliders, galerías, listas de imágenes

**Ejemplo práctico:**
```twig
{# IMAGE - Banner individual #}
{% set banner_exists = 'mi_banner.jpg' | has_custom_image %}
{% if banner_exists %}
    <div style="background-image: url('{{ 'mi_banner.jpg' | static_url | settings_image_url('huge') }}');">
{% endif %}

{# GALLERY - Slider de imágenes #}
{% for slide in settings.mi_slider %}
    <img src="{{ slide.image | static_url | settings_image_url('large') }}" alt="">
{% endfor %}
```

### Tamaños de imagen disponibles:

```twig
{# Imágenes de producto #}
{{ product.image | product_image_url('thumb') }}    {# 80x80 #}
{{ product.image | product_image_url('small') }}    {# 240x240 #}
{{ product.image | product_image_url('medium') }}   {# 480x480 #}
{{ product.image | product_image_url('large') }}    {# 1024x1024 #}
{{ product.image | product_image_url('huge') }}     {# Original #}

{# Imágenes de configuración (settings) #}
{{ settings.mi_imagen | static_url | settings_image_url('small') }}
{{ settings.mi_imagen | static_url | settings_image_url('medium') }}
{{ settings.mi_imagen | static_url | settings_image_url('large') }}

{# Imágenes del gallery #}
{{ slide.image | static_url | settings_image_url('large') }}
```

### Lazy Loading (recomendado):

```twig
<img 
    src="{{ 'images/empty-placeholder.png' | static_url }}" 
    data-src="{{ product.image | product_image_url('large') }}" 
    alt="{{ product.name }}"
    class="lazyload img-fluid"
>
```

Tiendanube carga automáticamente la librería de lazy loading.

---

## 📱 Responsive Design

### Breakpoints estándar:

```css
/* Mobile First (por defecto) */
.container {
    padding: 0 15px;
}

/* Tablet: 768px+ */
@media (min-width: 768px) {
    .container {
        max-width: 960px;
        margin: 0 auto;
    }
}

/* Desktop: 1024px+ */
@media (min-width: 1024px) {
    .container {
        max-width: 1140px;
    }
}

/* Large Desktop: 1200px+ */
@media (min-width: 1200px) {
    .container {
        max-width: 1320px;
    }
}
```

### Condicionales en Twig para device:

```twig
{# NO existe una variable directa de device en Twig #}
{# Usa CSS/JavaScript para responsive #}

{# Pero puedes crear settings diferentes para mobile/desktop #}
{% if settings.mobile_items %}
    data-mobile="{{ settings.mobile_items }}"
{% endif %}

{% if settings.desktop_items %}
    data-desktop="{{ settings.desktop_items }}"
{% endif %}
```

---

## 🎨 Variables CSS del Tema

Tiendanube genera automáticamente variables CSS basadas en `settings.txt`:

```css
:root {
    --main-background: #FFFFFF;
    --main-foreground: #333333;
    --accent-color: #80AA8D;
    --font-base: 14px;
    --font-small: 12px;
    --font-large: 18px;
    --font-xlarge: 24px;
}
```

**Uso:**
```css
.mi-elemento {
    background: var(--main-background);
    color: var(--main-foreground);
    font-size: var(--font-base);
}

.boton {
    background: var(--accent-color);
    color: var(--main-background);
}
```

---

## 🔍 Debug y Testing

### Ver contenido de variables:

```twig
{# Imprimir variable #}
{{ variable | json_encode }}

{# Ejemplo: ver estructura de slide #}
{% for slide in settings.mi_slider %}
    <pre>{{ slide | json_encode }}</pre>
{% endfor %}

{# Ver todos los settings #}
<pre>{{ settings | json_encode }}</pre>
```

### Verificar si existe:

```twig
{% if settings.mi_opcion is defined %}
    {# La opción existe #}
{% endif %}

{% if settings.mi_array and settings.mi_array is not empty %}
    {# El array existe y tiene elementos #}
{% endif %}
```

### Console.log en JavaScript:

```javascript
console.log('Debug:', {{ variable | json_encode | raw }});
```

---

## ⚡ Performance y Optimización

### 1. Cargar scripts solo cuando sea necesario:

```twig
{% if template == 'home' %}
    {{ 'home-scripts.js' | static_url | script_tag }}
{% endif %}

{% if template == 'product' %}
    {{ 'product-scripts.js' | static_url | script_tag }}
{% endif %}
```

### 2. Lazy loading de imágenes:

```twig
<img 
    src="{{ 'images/placeholder.png' | static_url }}" 
    data-src="{{ product.image | product_image_url('large') }}" 
    class="lazyload"
>
```

### 3. Defer/Async para scripts externos:

```twig
{{ 'https://cdn.example.com/library.js' | script_tag(true, 'defer') }}
```

### 4. Minificar CSS/JS:

Usa herramientas de build (Webpack, Gulp, etc.) antes de subir.

---

## 📊 Orden de Carga

```
1. layout.tpl - <head>
   ├── {{ head_content }}        # Meta tags, CSS base de Tiendanube
   ├── CSS personalizados
   └── Scripts en <head>

2. layout.tpl - <body>
   ├── Header (snipplet)
   ├── {{ page_content }}         # Template actual (home.tpl, product.tpl, etc.)
   │   └── Snipplets incluidos
   ├── Footer (snipplet)
   ├── {{ body_content }}         # Scripts base de Tiendanube (jQuery, etc.)
   └── Scripts personalizados
```

---

## 🚀 Workflow de Desarrollo

### 1. Planificación:
- Define qué settings necesitas
- Diseña la estructura HTML
- Piensa en la responsividad

### 2. Configuración (`settings.txt` + `defaults.txt`):
- Agrega todos los campos necesarios
- Define valores por defecto
- Si es una sección del home, agrégala a `home_order_position`

### 3. Template/Snipplet:
- Crea el archivo `.tpl`
- Define variables Twig desde `settings`
- Estructura HTML
- CSS inline o en archivo separado
- JavaScript si es necesario

### 4. Integración:
- Si es sección del home: actualiza `home-section-switch.tpl`
- Si necesita librerías: agrégalas en `layout.tpl`

### 5. Testing:
- Sube los archivos por SFTP
- Verifica en el panel de Tiendanube
- Prueba en diferentes dispositivos
- Revisa la consola del navegador

---

## 🐛 Errores Comunes

### ❌ Error: "Setting no definido"
**Causa:** Falta el valor en `defaults.txt`
**Solución:** Agrega el valor por defecto

### ❌ Error: "Variable no existe"
**Causa:** Nombre incorrecto o variable no definida
**Solución:** Verifica el nombre exacto en `settings.txt`

### ❌ Error: "Imagen no se muestra"

**Causa A: Campo `gallery` con sintaxis incorrecta**
**Solución:** Usa `{{ slide.image | static_url | settings_image_url('large') }}`

**Causa B: Campo `image` sin `original`**
**Solución:** Agrega `original = nombre_campo.jpg` en `settings.txt`

**Causa C: Campo `image` usando `settings.campo`**
**Solución:** Usa `'nombre_campo.jpg' | static_url | settings_image_url('tamaño')`

**Ejemplo correcto para campos `image`:**
```txt
# En settings.txt
image
	original = mi_banner.jpg    # ← OBLIGATORIO
	name = mi_banner
```

```twig
# En el template
{% set banner_exists = 'mi_banner.jpg' | has_custom_image %}
{% if banner_exists %}
    <img src="{{ 'mi_banner.jpg' | static_url | settings_image_url('large') }}">
{% endif %}
```

### ❌ Error: "Sección no aparece en el admin"
**Causa:** No agregaste la sección a `home_order_position`
**Solución:** Agrega el nombre de la sección al dropdown

### ❌ Error: "CSS no se aplica"
**Causa:** CSS inline mal cerrado o sintaxis Twig incorrecta
**Solución:** Verifica que todos los `{% %}` estén bien cerrados

---

## 💡 Mejores Prácticas y Aprendizajes

### 1. 📊 Organización de Settings con `title`

Usa `title` (sin `name`) para crear secciones visuales en el admin:

```txt
collapse
	title = Banner Custom (Codefy)
	backto = home_order_position
	
	checkbox
		name = side_banner_show
		description = Mostrar sección
	
	title = Configuración general
	
	image
		original = side_banner_image.jpg
		name = side_banner_image
		description = Imagen de fondo
	
	color
		name = side_banner_background_color
		description = Color de fondo (si no hay imagen)
	
	title = Configuración Desktop
	
	dropdown
		name = side_banner_desktop_layout
		description = Distribución en desktop
	
	range_number
		name = side_banner_desktop_title_size
		description = Tamaño del título en desktop
		min = 20
		max = 80
	
	title = Configuración Móvil
	
	range_number
		name = side_banner_mobile_title_size
		description = Tamaño del título en móvil
		min = 16
		max = 48
```

**✅ Ventajas:**
- Agrupa settings relacionados visualmente
- Mejora la UX del administrador
- No requiere `name` (solo decorativo)
- Facilita encontrar opciones específicas

### 2. 🎯 Usar `range_number` en lugar de `range`

**❌ INCORRECTO:**
```txt
range
	name = mi_numero
	description = Tamaño
	min = 0
	max = 100
	step = 2
	unit = px
```

**✅ CORRECTO:**
```txt
range_number
	name = mi_numero
	description = Tamaño
	min = 0
	max = 100
```

**Nota:** Tiendanube no soporta `range`, solo `range_number`. Los parámetros `step` y `unit` no son necesarios.

### 3. 🎨 CSS con Variables Twig (sin JavaScript)

Cuando necesites tamaños o colores personalizables, úsalos directamente en el CSS:

**❌ MALO: JavaScript innecesario**
```twig
<h1 data-desktop-size="42" data-mobile-size="28">Título</h1>
<script>
  // JavaScript para aplicar font-size...
</script>
```

**✅ BUENO: CSS directo**
```twig
<style>
.mi-titulo {
    font-size: {{ mobile_title_size }}px;
}

@media (min-width: 768px) {
    .mi-titulo {
        font-size: {{ desktop_title_size }}px;
    }
}
</style>
```

**✅ Ventajas:**
- Más rápido (sin JavaScript)
- Más simple de mantener
- No requiere event listeners
- Funciona sin esperar al DOM

### 4. 📐 Mobile-First para Responsive

Siempre define los estilos móviles primero, luego sobrescribe para desktop:

```css
/* Base: Mobile (por defecto) */
.side-banner-title {
    font-size: {{ mobile_title_size }}px;
}

/* Desktop: Sobrescribe */
@media (min-width: 768px) {
    .side-banner-title {
        font-size: {{ desktop_title_size }}px;
    }
}
```

**✅ Ventajas:**
- Carga más ligera en móviles
- Progresive enhancement
- Más fácil de mantener

### 5. 🎭 Colores de Botones con Eventos Inline

Para hover states de botones con colores personalizables:

```twig
<a href="{{ button_link | setting_url }}" 
   class="btn side-banner-button" 
   style="background-color: {{ button_bg_color }}; color: {{ button_text_color }};"
   onmouseover="this.style.backgroundColor='{{ button_hover_bg_color }}'; this.style.color='{{ button_hover_text_color }}';"
   onmouseout="this.style.backgroundColor='{{ button_bg_color }}'; this.style.color='{{ button_text_color }}';">
    {{ button_text | translate }}
</a>
```

**✅ Ventajas:**
- Sin JavaScript adicional
- Colores totalmente personalizables
- Sin clases CSS adicionales
- Funciona inmediatamente

### 6. 🔄 Layouts Flexibles con `order`

Para cambiar el orden visual sin mover HTML:

```css
/* Desktop: contenido derecha */
.side-banner-row[data-desktop-layout="content-right"] .side-banner-content-col {
    order: 2;
}

.side-banner-row[data-desktop-layout="content-right"] .side-banner-image-col {
    order: 1;
}

/* Mobile: necesita !important para sobrescribir */
@media (max-width: 767px) {
    .side-banner-row[data-mobile-layout="content-top"] .side-banner-content-col {
        order: 1 !important;
    }
    
    .side-banner-row[data-mobile-layout="content-top"] .side-banner-image-col {
        order: 2 !important;
    }
}
```

**⚠️ Nota:** Usa `!important` en mobile para asegurar que sobrescriba los estilos de desktop.

### 7. 📱 Imágenes Independientes para Mobile y Desktop

Usa clases de Bootstrap para mostrar/ocultar imágenes:

```twig
{# Imagen para desktop #}
<img 
    src="{{ 'side_banner_content_image.jpg' | static_url | settings_image_url('original') }}" 
    alt="Banner"
    class="d-none d-md-block"
>

{# Imagen para móvil #}
<img 
    src="{{ 'side_banner_mobile_content_image.jpg' | static_url | settings_image_url('large') }}" 
    alt="Banner"
    class="d-block d-md-none"
>
```

**✅ Ventajas:**
- Optimización por dispositivo
- Mayor control del diseño
- Mejor performance (solo carga la necesaria)

### 8. 🖼️ Background Image con Fallback

Siempre ofrece un fallback para imágenes de fondo:

```twig
<section {% if banner_image %}
    style="background-image: url('{{ 'side_banner_image.jpg' | static_url | settings_image_url('huge') }}');"
{% else %}
    style="background-color: {{ settings.side_banner_background_color | default('#f8f9fa') }};"
{% endif %}>
```

**✅ Ventajas:**
- Siempre muestra algo (imagen o color)
- Mejor UX
- Evita secciones en blanco

### 9. 🎬 Animaciones CSS Sutiles

Para efectos visuales profesionales sin JavaScript:

```css
.side-banner-image-animation-float {
    animation: side-banner-float 6s ease-in-out infinite;
}

@keyframes side-banner-float {
    0%, 100% { 
        transform: translateY(0px) rotate(0deg); 
    }
    25% { 
        transform: translateY(-8px) rotate(0.5deg); 
    }
    50% { 
        transform: translateY(-12px) rotate(0deg); 
    }
    75% { 
        transform: translateY(-8px) rotate(-0.5deg); 
    }
}
```

**✅ Consejos:**
- Movimientos sutiles (8-12px máximo)
- Rotaciones mínimas (0.5-1deg)
- Duraciones largas (4-6s) para suavidad
- `ease-in-out` para transiciones naturales

### 10. 📏 Proporciones Flexibles con Flexbox

Para layouts configurables sin cálculos complejos:

```css
/* Desktop: Proporciones */
.side-banner-content-50 { flex: 0 0 50%; max-width: 50%; }
.side-banner-image-50 { flex: 0 0 50%; max-width: 50%; }

.side-banner-content-60 { flex: 0 0 60%; max-width: 60%; }
.side-banner-image-40 { flex: 0 0 40%; max-width: 40%; }

/* Mobile: Alturas fijas para imagen, auto para contenido */
@media (max-width: 767px) {
    .side-banner-mobile-content-50 { width: 100%; height: auto; }
    .side-banner-mobile-image-50 { width: 100%; height: 300px; }
}
```

**✅ Ventajas:**
- Altamente flexible
- Fácil de mantener
- Sin JavaScript
- Responsive por defecto

### 11. 🚫 Controlar Scroll en Secciones

Para evitar scroll interno en secciones:

```css
@media (max-width: 767px) {
    .section-side-banner {
        overflow: hidden; /* Bloquea horizontal Y vertical */
    }
}
```

**⚠️ Nota:** Usa `overflow: hidden` (no `overflow-x: hidden`) para evitar que aparezca scroll vertical dentro de la sección.

### 12. 🏷️ Nombrado de Componentes Personalizados

Agrega un identificador a tus componentes custom:

```txt
dropdown
	name = home_order_position
	values
		slider = Slider principal
		featured = Productos destacados
		mi_componente = Mi Componente (Codefy)  # ← Identifica tu trabajo
```

**✅ Ventajas:**
- Fácil identificación en el admin
- Profesionalismo
- Evita confusiones con componentes del tema base

### 13. 🎯 Alineación de Contenido Configurable

Permite al administrador elegir la alineación:

```css
/* Desktop */
@media (min-width: 768px) {
    .side-banner-desktop-content-left { text-align: left; }
    .side-banner-desktop-content-center { text-align: center; }
    .side-banner-desktop-content-right { text-align: right; }
}

/* Mobile */
@media (max-width: 767px) {
    .side-banner-mobile-content-left { text-align: left; }
    .side-banner-mobile-content-center { text-align: center; }
    .side-banner-mobile-content-right { text-align: right; }
}
```

**✅ Ventajas:**
- Máxima flexibilidad para el cliente
- Sin JavaScript
- Funciona con todo el contenido (texto, botones, imágenes)

### 14. 📦 Containers Configurables (Full Width vs Normal)

Permite layouts que rompan el container o lo respeten:

```css
/* Móvil: Configuración independiente */
@media (max-width: 767px) {
    /* Container normal (con márgenes) */
    .carrusel-container-wrapper-mobile-normal {
        max-width: 100%;
        padding: 0 15px;
    }
    
    /* Full width (sin márgenes) */
    .carrusel-container-wrapper-mobile-full {
        max-width: 100vw;
        padding: 0;
        margin-left: 0;
        margin-right: 0;
    }
    
    /* Margen izquierdo, sin margen derecho */
    .carrusel-container-wrapper-mobile-left {
        max-width: 100vw;
        padding-left: 15px;
        padding-right: 0;
        margin-right: 0;
    }
}

/* Desktop: Configuración independiente */
@media (min-width: 768px) {
    .carrusel-container-wrapper-desktop-normal {
        max-width: 1170px;
        margin: 0 auto;
        padding: 0 15px;
    }
    
    .carrusel-container-wrapper-desktop-full {
        max-width: 100vw;
        padding: 0;
    }
    
    .carrusel-container-wrapper-desktop-left {
        max-width: 100vw;
        padding-left: 15px;
        padding-right: 0;
    }
}
```

**Uso en Twig:**
```twig
<div class="carrusel-container-wrapper 
     carrusel-container-wrapper-mobile-{{ mobile_container }} 
     carrusel-container-wrapper-desktop-{{ desktop_container }}">
```

**✅ Ventajas:**
- Configuración independiente mobile/desktop
- Layouts más versátiles
- Mejor control visual para carruseles y banners

### 15. 🎯 Valores Parciales para Items Visibles

Para mostrar parcialmente el siguiente elemento (efecto "peek"):

```twig
{% set mobile_items = settings.mobile_items | default(2.5) %}
{% set desktop_items = settings.desktop_items | default(4.5) %}
```

```css
.embla__slide {
    flex: 0 0 calc(100% / {{ mobile_items }});
    min-width: 0;
}

@media (min-width: 768px) {
    .embla__slide {
        flex: 0 0 calc(100% / {{ desktop_items }});
    }
}
```

**Settings:**
```txt
dropdown
	name = carrusel_mobile_items
	description = Elementos visibles en móvil
	values
		1.5 = 1.5 elementos
		2.5 = 2.5 elementos
		3.5 = 3.5 elementos

dropdown
	name = carrusel_desktop_items
	description = Elementos visibles en desktop
	values
		3.5 = 3.5 elementos
		4.5 = 4.5 elementos
		5.5 = 5.5 elementos
```

**✅ Ventajas:**
- Mejor UX (se ve que hay más contenido)
- Invita a hacer scroll
- Más moderno y profesional

### 16. 🎨 Aspect Ratio y Object Fit Configurables

Control total sobre cómo se muestran las imágenes:

```txt
dropdown
	name = image_aspect_ratio
	description = Proporción de las imágenes
	values
		original = Original
		landscape = Paisaje (16:9)
		square = Cuadrado (1:1)
		portrait = Retrato (4:5)

dropdown
	name = image_object_fit
	description = Ajuste de la imagen
	values
		cover = Cubrir (recorta si es necesario)
		contain = Contener (muestra completa)
		fill = Rellenar (puede distorsionar)
		scale-down = Escalar (la más pequeña entre contain y none)
```

**CSS:**
```css
/* Aspect Ratios */
.image-original { aspect-ratio: unset; }
.image-landscape { aspect-ratio: 16 / 9; }
.image-square { aspect-ratio: 1 / 1; }
.image-portrait { aspect-ratio: 4 / 5; }

/* Object Fit */
.image-cover { object-fit: cover; }
.image-contain { object-fit: contain; }
.image-fill { object-fit: fill; }
.image-scale-down { object-fit: scale-down; }
```

**✅ Ventajas:**
- Imágenes consistentes sin edición
- Control total desde el admin
- Evita distorsiones

### 17. 🔄 Integración de Embla Carousel

Para carruseles modernos y performantes:

**1. Cargar la librería en `layout.tpl`:**
```twig
{% if template == 'home' %}
    {{ 'https://unpkg.com/embla-carousel/embla-carousel.umd.js' | script_tag(true) }}
    {{ 'https://unpkg.com/embla-carousel-autoplay/embla-carousel-autoplay.umd.js' | script_tag(true) }}
{% endif %}
```

**2. Estructura HTML:**
```twig
<div class="embla">
    <div class="embla__container">
        {% for item in items %}
            <div class="embla__slide">
                {# Contenido del slide #}
            </div>
        {% endfor %}
    </div>
</div>
```

**3. Inicialización:**
```javascript
<script>
document.addEventListener('DOMContentLoaded', function() {
    const emblaNode = document.getElementById('embla');
    if (emblaNode && typeof EmblaCarousel !== 'undefined') {
        const options = {
            loop: {{ loop ? 'true' : 'false' }},
            align: '{{ align }}',
            skipSnaps: false,
            dragFree: false
        };
        
        {% if autoplay %}
        const autoplay = EmblaCarouselAutoplay({ delay: {{ autoplay_delay }} });
        const embla = EmblaCarousel(emblaNode, options, [autoplay]);
        {% else %}
        const embla = EmblaCarousel(emblaNode, options);
        {% endif %}
        
        // Navegación
        const prevBtn = document.querySelector('.embla__prev');
        const nextBtn = document.querySelector('.embla__next');
        
        if (prevBtn && nextBtn) {
            prevBtn.addEventListener('click', () => embla.scrollPrev());
            nextBtn.addEventListener('click', () => embla.scrollNext());
        }
    }
});
</script>
```

**✅ Ventajas:**
- Librería ligera y moderna
- Touch/swipe nativo
- Excelente performance
- Fácil de configurar

### 18. 🎭 Dots/Indicadores Dinámicos

Indicadores que se generan automáticamente:

```javascript
// Generar dots
function setupDots(embla, dotsContainer) {
    const scrollSnaps = embla.scrollSnapList();
    dotsContainer.innerHTML = scrollSnaps
        .map(() => '<button class="embla__dot" type="button"></button>')
        .join('');
    
    const dots = Array.from(dotsContainer.querySelectorAll('.embla__dot'));
    
    // Click en dots
    dots.forEach((dot, index) => {
        dot.addEventListener('click', () => embla.scrollTo(index));
    });
    
    // Actualizar activo
    const updateDots = () => {
        const selected = embla.selectedScrollSnap();
        dots.forEach((dot, i) => {
            dot.classList.toggle('embla__dot--selected', i === selected);
        });
    };
    
    embla.on('select', updateDots);
    updateDots();
}

// Uso
const dotsContainer = document.querySelector('.embla__dots');
if (dotsContainer) {
    setupDots(embla, dotsContainer);
}
```

**CSS:**
```css
.embla__dots {
    display: flex;
    gap: 8px;
    justify-content: center;
    padding: 20px 0;
}

.embla__dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: rgba(0, 0, 0, 0.2);
    border: none;
    cursor: pointer;
    transition: all 0.3s ease;
}

.embla__dot--selected {
    background: var(--accent-color);
    width: 24px;
    border-radius: 4px;
}
```

**✅ Ventajas:**
- Se generan automáticamente
- Responsive
- Fácil de estilizar

### 19. 🔧 Configuración de Autoplay Flexible

Autoplay con múltiples opciones:

```txt
dropdown
	name = carousel_autoplay
	description = Reproducción automática
	values
		none = Desactivado
		3000 = 3 segundos
		5000 = 5 segundos
		7000 = 7 segundos
		10000 = 10 segundos
```

**Uso en Twig:**
```twig
{% set autoplay_delay = settings.carousel_autoplay != 'none' ? settings.carousel_autoplay : false %}
```

**JavaScript:**
```javascript
{% if autoplay_delay %}
const autoplay = EmblaCarouselAutoplay({ 
    delay: {{ autoplay_delay }},
    stopOnInteraction: true  // Detener al interactuar
});
const embla = EmblaCarousel(emblaNode, options, [autoplay]);
{% else %}
const embla = EmblaCarousel(emblaNode, options);
{% endif %}
```

**✅ Ventajas:**
- Control total desde el admin
- UX mejorada (se detiene al interactuar)
- Opción de desactivar

### 20. 📏 Spacing/Gap Configurables

Control del espacio entre elementos:

```txt
range_number
	name = carousel_mobile_spacing
	description = Espacio entre elementos en móvil (px)
	min = 0
	max = 30

range_number
	name = carousel_desktop_spacing
	description = Espacio entre elementos en desktop (px)
	min = 0
	max = 50
```

**CSS:**
```css
.embla__container {
    display: flex;
    gap: {{ mobile_spacing }}px;
}

@media (min-width: 768px) {
    .embla__container {
        gap: {{ desktop_spacing }}px;
    }
}
```

**✅ Ventajas:**
- Layouts más limpios
- Control preciso del diseño
- Independiente mobile/desktop

---

## 📚 Recursos Útiles

- **Documentación oficial:** https://github.com/TiendaNube/api-docs
- **Twig documentation:** https://twig.symfony.com/doc/
- **Tiendanube Dev Center:** https://atencionalcliente.nuvemshop.com.br/es_ES/

---

**🎉 ¡Ahora tienes todo el conocimiento para crear themes increíbles en Tiendanube!**

