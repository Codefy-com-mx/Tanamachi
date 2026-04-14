# 📦 Guía de Migración: Carrusel de Secciones Personalizado

## 🎯 Descripción General

Esta sección permite crear un carrusel completamente personalizable usando Embla Carousel, con imágenes, títulos, enlaces y múltiples opciones de configuración responsivas.

---

## 📋 Checklist de Archivos a Modificar/Crear

### ✅ Archivos que debes modificar:
- [ ] `config/settings.txt`
- [ ] `config/defaults.txt`
- [ ] `layouts/layout.tpl`
- [ ] `snipplets/home/home-section-switch.tpl`

### ✅ Archivos que debes crear:
- [ ] `snipplets/home/home-carrusel-secciones.tpl`
- [ ] `snipplets/defaults/home/carrusel_secciones_help.tpl` (opcional)

---

## 🔧 PASO 1: Configuración en `config/settings.txt`

### Ubicación:
Agrega esta configuración dentro de la sección de **Home** (busca donde están otras secciones como `slider`, `featured_products`, etc.)

### Código a agregar:

```txt
collapse
	name = carrusel_secciones_cfg
	description = Carrusel de secciones personalizado
	backto = home_order_position
	
	checkbox
		name = carrusel_secciones_show
		description = Mostrar carrusel de secciones
	
	i18n_input
		name = carrusel_secciones_title
		description = Título de la sección
	
	dropdown
		name = carrusel_secciones_title_size_mobile
		description = Tamaño del título en móvil
		values
			small = Pequeño
			medium = Mediano
			large = Grande
	
	dropdown
		name = carrusel_secciones_title_size_desktop
		description = Tamaño del título en desktop
		values
			small = Pequeño
			medium = Mediano
			large = Grande
			xlarge = Extra grande
	
	dropdown
		name = carrusel_secciones_image_title_size_mobile
		description = Tamaño del título de las imágenes en móvil
		values
			small = Pequeño
			medium = Mediano
			large = Grande
	
	dropdown
		name = carrusel_secciones_image_title_size_desktop
		description = Tamaño del título de las imágenes en desktop
		values
			small = Pequeño
			medium = Mediano
			large = Grande
			xlarge = Extra grande
	
	dropdown
		name = carrusel_secciones_autoplay
		description = Reproducción automática
		values
			none = Sin reproducción automática
			3000 = 3 segundos
			4000 = 4 segundos
			5000 = 5 segundos
	
	checkbox
		name = carrusel_secciones_loop
		description = Carrusel infinito
	
	checkbox
		name = carrusel_secciones_dots
		description = Mostrar indicadores (dots)
	
	checkbox
		name = carrusel_secciones_arrows
		description = Mostrar flechas de navegación
	
	dropdown
		name = carrusel_secciones_aspect_ratio
		description = Relación de aspecto de las imágenes
		values
			auto = Automático
			square = Cuadrado (1:1)
			portrait = Vertical (3:4)
			landscape = Horizontal (4:3)
			wide = Panorámico (16:9)
	
	dropdown
		name = carrusel_secciones_object_fit
		description = Ajuste de imagen
		values
			contain = Contener (sin recortar)
			cover = Cubrir (con recorte)
			fill = Rellenar (puede distorsionar)
	
	range_number
		name = carrusel_secciones_border_radius
		description = Radio de borde (px)
		min = 0
		max = 20
	
	dropdown
		name = carrusel_secciones_align
		description = Alineación del carrusel
		values
			start = Inicio
			center = Centro
	
	dropdown
		name = carrusel_secciones_mobile_items
		description = Elementos visibles en móvil
		values
			1 = 1
			1.5 = 1.5
			2 = 2
			2.5 = 2.5
			3 = 3
			3.5 = 3.5
	
	dropdown
		name = carrusel_secciones_desktop_items
		description = Elementos visibles en desktop
		values
			2 = 2
			2.5 = 2.5
			3 = 3
			3.5 = 3.5
			4 = 4
			4.5 = 4.5
			5 = 5
			5.5 = 5.5
			6 = 6
	
	dropdown
		name = carrusel_secciones_mobile_container
		description = Ancho del carrusel en móvil
		values
			full = Sin márgenes (hasta el borde)
			full_left = Margen izquierdo, sin margen derecho
			minimal = Márgenes mínimos
			normal = Container normal
			wide = Container amplio
	
	dropdown
		name = carrusel_secciones_desktop_container
		description = Ancho del carrusel en desktop
		values
			full = Sin márgenes (ancho completo)
			full_left = Margen izquierdo, sin margen derecho
			normal = Container normal
			wide = Container amplio
	
	dropdown
		name = carrusel_secciones_mobile_spacing
		description = Espaciado entre elementos en móvil (px)
		values
			0 = Sin espacio
			5 = 5px
			10 = 10px
			15 = 15px
			20 = 20px
	
	dropdown
		name = carrusel_secciones_desktop_spacing
		description = Espaciado entre elementos en desktop (px)
		values
			0 = Sin espacio
			5 = 5px
			10 = 10px
			15 = 15px
			20 = 20px
	
	color
		name = carrusel_secciones_background
		description = Color de fondo de la sección
	
	gallery
		name = carrusel_secciones_items
		description = Imágenes del carrusel
		gallery_link = true
		gallery_width = 800
		gallery_height = 800
		gallery_more_info = true
```

### Agregar la sección al selector de orden:

Busca el dropdown `home_order_position` y agrega esta línea dentro de `values`:

```txt
carrusel_secciones = Carrusel de secciones personalizado
```

---

## 🎨 PASO 2: Valores por defecto en `config/defaults.txt`

### Código a agregar:

```txt
carrusel_secciones_show = 1
carrusel_secciones_title_es = Regalos Para Todas Las Ocasiones
carrusel_secciones_title_en = Gifts For All Occasions
carrusel_secciones_title_pt = Presentes Para Todas As Ocasiões
carrusel_secciones_title_size_desktop = large
carrusel_secciones_title_size_mobile = medium
carrusel_secciones_image_title_size_desktop = medium
carrusel_secciones_image_title_size_mobile = small
carrusel_secciones_autoplay = 4000
carrusel_secciones_loop = 1
carrusel_secciones_dots = 1
carrusel_secciones_arrows = 1
carrusel_secciones_aspect_ratio = square
carrusel_secciones_object_fit = cover
carrusel_secciones_border_radius = 8
carrusel_secciones_align = start
carrusel_secciones_mobile_items = 2.5
carrusel_secciones_desktop_items = 4.5
carrusel_secciones_mobile_container = full
carrusel_secciones_desktop_container = normal
carrusel_secciones_mobile_spacing = 5
carrusel_secciones_desktop_spacing = 10
carrusel_secciones_background = rgba(0, 0, 0, 0)
```

**Nota:** Ajusta los títulos (`_es`, `_en`, `_pt`) según los idiomas que maneje tu tienda.

---

## 📚 PASO 3: Cargar librería en `layouts/layout.tpl`

### Ubicación:
Dentro del `<head>`, preferiblemente cerca de donde se cargan otros scripts.

### Código a agregar:

```twig
{# Embla Carousel para home #}
{% if template == 'home' %}
    {{ 'https://unpkg.com/embla-carousel/embla-carousel.umd.js' | script_tag(true) }}
    {{ 'https://unpkg.com/embla-carousel-autoplay/embla-carousel-autoplay.umd.js' | script_tag(true) }}
{% endif %}
```

**⚠️ Importante:** La condición `{% if template == 'home' %}` asegura que solo se cargue en la página de inicio, optimizando el rendimiento.

---

## 🔀 PASO 4: Integrar en `snipplets/home/home-section-switch.tpl`

### Ubicación:
Dentro del switch/case donde se manejan las secciones del home.

### Código a agregar:

```twig
{% elseif section_select == 'carrusel_secciones' %}
    {#  **** Carrusel de secciones personalizado ****  #}
    {% set has_carrusel_secciones_items = settings.carrusel_secciones_items and settings.carrusel_secciones_items is not empty %}
    {% if show_help or (show_component_help and not has_carrusel_secciones_items) %}
        {% snipplet 'defaults/home/carrusel_secciones_help.tpl' %}
    {% else %}
        {% include 'snipplets/home/home-carrusel-secciones.tpl' %}
    {% endif %}
```

**Nota:** El `carrusel_secciones_help.tpl` es opcional. Si no lo creas, elimina esa parte del código.

---

## 🎨 PASO 5: Crear el snippet principal

### Archivo: `snipplets/home/home-carrusel-secciones.tpl`

**Ver el archivo completo en el repositorio.** Aquí te dejo la estructura principal:

```twig
{#/*============================================================================
  #Carrusel de secciones personalizado
==============================================================================*/#}

{% set has_carrusel_items = settings.carrusel_secciones_items and settings.carrusel_secciones_items is not empty %}
{% set carrusel_title = settings.carrusel_secciones_title %}
{# ... más variables ... #}

{% if has_carrusel_items %}
<section class="section-carrusel-secciones position-relative mb-5" data-store="home-carrusel-secciones">
    <div class="carrusel-container-wrapper">
        {% if carrusel_title %}
            <h2 class="h3 mt-3 mb-4 text-center carrusel-title-spacing">{{ carrusel_title | translate }}</h2>
        {% endif %}
        
        <div class="embla-carrusel-secciones-wrapper-outer">
            <div class="embla-carrusel-secciones-wrapper">
                <div class="embla-carrusel-secciones" id="embla-carrusel-secciones">
                    <div class="embla-carrusel-secciones__container">
                        {% for slide in settings.carrusel_secciones_items %}
                            {# ... slides ... #}
                        {% endfor %}
                    </div>
                </div>
                
                {# Flechas de navegación #}
                {% if show_arrows %}
                    {# ... arrows ... #}
                {% endif %}
            </div>
            
            {# Dots #}
            {% if show_dots %}
                {# ... dots ... #}
            {% endif %}
        </div>
    </div>
</section>

{# CSS #}
<style>
    {# ... estilos ... #}
</style>

{# JavaScript #}
<script>
    {# ... inicialización ... #}
</script>
{% endif %}
```

**📄 Copia el archivo completo desde:** `snipplets/home/home-carrusel-secciones.tpl`

---

## ✅ PASO 6: Verificación

### 1. Sube los archivos a tu tema:
```bash
# Si usas SFTP, sube:
- config/settings.txt
- config/defaults.txt
- layouts/layout.tpl
- snipplets/home/home-section-switch.tpl
- snipplets/home/home-carrusel-secciones.tpl
```

### 2. En el panel de Tiendanube:
1. Ve a **Diseño > Personalizar diseño**
2. Busca la sección **"Página de inicio"**
3. En **"Orden de las secciones"** deberías ver: **"Carrusel de secciones personalizado"**
4. Haz clic en la sección para configurarla
5. Agrega imágenes desde el **campo "Imágenes del carrusel"**

### 3. Configuración recomendada inicial:
- **Elementos visibles móvil:** 2.5 o 3
- **Elementos visibles desktop:** 4.5
- **Aspecto de imagen:** Square (1:1)
- **Ajuste de imagen:** Cover
- **Autoplay:** 4 segundos
- **Loop infinito:** Activado
- **Dots:** Activado
- **Flechas:** Activado

---

## 🐛 Problemas Comunes y Soluciones

### ❌ Problema 1: Las imágenes no se muestran
**Causa:** Sintaxis incorrecta en Twig para acceder a las imágenes del gallery.

**Solución:** Asegúrate de usar:
```twig
data-src="{{ slide.image | static_url | settings_image_url('large') }}"
```

**NO uses:**
```twig
{{ item | static_url('large') }}  ❌
```

---

### ❌ Problema 2: El loop infinito no funciona correctamente
**Causa:** Conflictos con `align: 'start'` y `containScroll: 'trimSnaps'`.

**Solución:** En el JavaScript, usa esta configuración:
```javascript
const options = {
    loop: true,  // o false según configuración
    align: 'start',
    slidesToScroll: 1,
    skipSnaps: false,
    dragFree: false
};
```

Y en el CSS, elimina transiciones manuales:
```css
.embla-carrusel-secciones__container {
    display: flex;
    backface-visibility: hidden;
    touch-action: pan-y;
    /* NO agregues: transition: transform 0.3s ease; */
}
```

---

### ❌ Problema 3: Las flechas se cortan
**Causa:** Las flechas están dentro de un contenedor con `overflow: hidden`.

**Solución:** Estructura correcta de divs:
```html
<div class="embla-carrusel-secciones-wrapper">  <!-- overflow: visible -->
    <div class="embla-carrusel-secciones">  <!-- overflow: hidden -->
        <!-- slides -->
    </div>
    <!-- arrows FUERA del div con overflow hidden -->
    <button class="embla-carrusel-secciones__prev">...</button>
    <button class="embla-carrusel-secciones__next">...</button>
</div>
```

---

### ❌ Problema 4: Los títulos de las imágenes no aparecen
**Causa:** Usando `gallery_caption` en lugar del campo `title` por defecto.

**Solución:**
- En `settings.txt`, usa `gallery_more_info = true` (NO uses `gallery_caption`)
- En el template, accede con `{{ slide.title }}`

---

### ❌ Problema 5: Configuración móvil no se aplica
**Causa:** CSS no estructurado con "Mobile First".

**Solución:** Define estilos móviles primero, luego sobrescribe con media queries:
```css
/* Móvil (por defecto) */
.carrusel-container-wrapper {
    padding: 0 0.75rem;
}

/* Desktop (sobrescribe) */
@media (min-width: 768px) {
    .carrusel-container-wrapper {
        max-width: 1140px;
        margin: 0 auto;
    }
}
```

---

### ❌ Problema 6: El autoplay no funciona
**Causa:** Plugin no cargado o configuración incorrecta.

**Solución:**
1. Verifica que ambas librerías se carguen en `layout.tpl`
2. Inicializa el plugin correctamente:

```javascript
const plugins = [];

if (autoplayDelay) {
    plugins.push(
        EmblaCarouselAutoplay({ 
            delay: autoplayDelay,
            stopOnInteraction: false,
            stopOnMouseEnter: true
        })
    );
}

const emblaApi = EmblaCarousel(emblaNode, options, plugins);
```

---

## 🎯 Consejos Pro

### 1. **Lazy Loading de Imágenes**
El carrusel usa `lazyload` de Tiendanube:
```html
<img 
    src="{{ 'images/empty-placeholder.png' | static_url }}" 
    data-src="{{ slide.image | static_url | settings_image_url('large') }}" 
    class="lazyload"
>
```

### 2. **Tamaños de Imagen Recomendados**
```txt
gallery_width = 800
gallery_height = 800
```
Esto optimiza la carga sin perder calidad.

### 3. **Variables CSS del Tema**
Usa las variables del tema para mantener consistencia:
- `var(--main-background)`
- `var(--main-foreground)`
- `var(--accent-color)`
- `var(--font-base)`, `var(--font-large)`, etc.

### 4. **Internacionalización**
Usa `| translate` para todos los textos:
```twig
{{ carrusel_title | translate }}
{{ slide.title | translate }}
```

### 5. **Responsive Breakpoint**
El breakpoint estándar en Tiendanube es `768px`:
```css
@media (min-width: 768px) { /* Desktop */ }
@media (max-width: 767px) { /* Mobile */ }
```

---

## 📊 Estructura de Datos del Gallery

Cuando usas `gallery` con `gallery_more_info = true`, cada item tiene:

```javascript
{
    image: "...",      // URL de la imagen
    title: "...",      // Título (campo por defecto)
    link: "...",       // URL del enlace
    description: "...", // Descripción (no usado en este carrusel)
    button: "...",     // Texto del botón (no usado)
    color: "..."       // Color (no usado)
}
```

**Acceso en Twig:**
```twig
{% for slide in settings.carrusel_secciones_items %}
    {{ slide.image }}
    {{ slide.title }}
    {{ slide.link }}
{% endfor %}
```

---

## 🔄 Personalización Adicional

### Cambiar el nombre de la sección:
Simplemente renombra todas las instancias de `carrusel_secciones` por tu nombre preferido (ej: `custom_carousel`).

### Agregar más opciones:
1. Define el nuevo setting en `settings.txt`
2. Agrega el valor por defecto en `defaults.txt`
3. Crea la variable en el template
4. Aplica en CSS/JavaScript

### Usar en otras páginas:
Cambia la condición en `layout.tpl`:
```twig
{% if template == 'home' or template == 'page' %}
```

---

## 📞 Soporte

Si encuentras problemas:
1. Verifica que todos los archivos estén subidos correctamente
2. Revisa la consola del navegador (F12) para errores de JavaScript
3. Comprueba que las librerías de Embla se carguen correctamente
4. Asegúrate de que las imágenes estén agregadas en el panel de administración

---

**🎉 ¡Listo! Tu carrusel personalizado debería estar funcionando perfectamente.**

