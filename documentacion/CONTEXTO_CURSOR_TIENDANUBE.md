# 🤖 Prompt de Contexto: Desarrollo de Temas Tiendanube

## 📋 Copia este prompt al iniciar una sesión de Cursor

```
Estoy trabajando en el desarrollo de un tema para Tiendanube (también conocida como Nuvemshop).

CONTEXTO DEL PROYECTO:
- Tema: Scatola
- Plataforma: Tiendanube/Nuvemshop
- Motor de templates: Twig
- Estructura modular con snipplets reutilizables
- Deployment: SFTP a ftp.tiendanube.com

ESTRUCTURA DEL TEMA:
- config/ : Configuración (settings.txt, defaults.txt, variants.txt, translations.txt)
- layouts/ : Layout principal (layout.tpl)
- templates/ : Páginas principales (home.tpl, product.tpl, category.tpl, etc.)
- snipplets/ : Componentes reutilizables organizados por sección
- static/ : Archivos CSS, JS, imágenes

CONOCIMIENTOS CLAVE ADQUIRIDOS:

1. SETTINGS Y DEFAULTS:
   - Cada campo en settings.txt DEBE tener un valor por defecto en defaults.txt
   - Los campos i18n_input generan variables con sufijos: _es, _en, _pt
   - El campo gallery con gallery_more_info = true expone: image, title, link, description, button, color
   - gallery_caption y gallery_more_info NO se pueden usar juntos

2. ACCESO A DATOS DEL GALLERY:
   - CORRECTO: {{ slide.image | static_url | settings_image_url('large') }}
   - INCORRECTO: {{ slide | static_url('large') }}
   - CORRECTO: {{ slide.title }}
   - Los items del gallery son objetos con propiedades, no URLs directas

3. SECCIONES DEL HOME:
   - Se definen en settings.txt dentro de home_order_position
   - Se manejan en snipplets/home/home-section-switch.tpl con {% elseif section_select == 'nombre' %}
   - Cada sección debe tener un collapse en settings.txt con backto = home_order_position

4. CARGA DE LIBRERÍAS EXTERNAS:
   - Se cargan en layouts/layout.tpl dentro del <head>
   - Usar condiciones para cargar solo en templates necesarios: {% if template == 'home' %}
   - Sintaxis: {{ 'https://cdn.url.com/library.js' | script_tag(true) }}
   - El parámetro 'true' indica que es una URL externa

5. CSS RESPONSIVE (MOBILE FIRST):
   - Definir estilos móviles primero (sin media query)
   - Sobrescribir con @media (min-width: 768px) para desktop
   - Breakpoint estándar de Tiendanube: 768px

6. VARIABLES CSS DEL TEMA:
   - var(--main-background)
   - var(--main-foreground)
   - var(--accent-color)
   - var(--font-base), var(--font-small), var(--font-large), var(--font-xlarge)
   - Usar estas variables mantiene consistencia con el tema

7. TRADUCCIONES:
   - Usar | translate en todos los textos
   - Para i18n_input: {{ settings.mi_titulo | translate }}
   - Para gallery titles: {{ slide.title | translate }}

PROBLEMAS RESUELTOS Y SOLUCIONES:

1. PROBLEMA: Imágenes del gallery no se mostraban
   CAUSA: Sintaxis incorrecta {{ item | static_url('large') }}
   SOLUCIÓN: {{ slide.image | static_url | settings_image_url('large') }}
   APRENDIZAJE: Los items del gallery son objetos, no URLs directas

2. PROBLEMA: Loop infinito del carrusel no funcionaba (se revertía al llegar al final)
   CAUSA: Conflictos entre align: 'start', containScroll: 'trimSnaps' y transiciones CSS manuales
   SOLUCIÓN: 
   - Eliminar containScroll y align (o usar con cuidado)
   - Agregar skipSnaps: false y dragFree: false
   - Eliminar transition: transform de .embla__container
   - Agregar backface-visibility: hidden y touch-action: pan-y
   APRENDIZAJE: Embla Carousel maneja sus propias transiciones, no agregar CSS transitions manuales

3. PROBLEMA: Flechas del carrusel cortadas
   CAUSA: Flechas dentro de un contenedor con overflow: hidden
   SOLUCIÓN: Estructura correcta de divs:
   ```html
   <div class="wrapper">                    <!-- overflow: visible -->
       <div class="embla">                  <!-- overflow: hidden -->
           <!-- slides -->
       </div>
       <button class="prev">...</button>    <!-- FUERA del overflow hidden -->
       <button class="next">...</button>
   </div>
   ```
   APRENDIZAJE: Elementos que sobresalen deben estar fuera de contenedores con overflow: hidden

4. PROBLEMA: Títulos de imágenes no aparecían en el admin
   CAUSA: Usando gallery_caption en lugar del campo title por defecto
   SOLUCIÓN: Usar gallery_more_info = true (sin gallery_caption) y acceder con {{ slide.title }}
   APRENDIZAJE: gallery_more_info expone campos por defecto de Tiendanube (title, description, button, color)

5. PROBLEMA: Settings de móvil no se aplicaban, desktop afectaba móvil
   CAUSA: CSS no estructurado con "Mobile First"
   SOLUCIÓN: Definir estilos móviles sin media query, luego sobrescribir con @media (min-width: 768px)
   APRENDIZAJE: Siempre usar Mobile First en Tiendanube

6. PROBLEMA: Autoplay del carrusel no funcionaba
   CAUSA: Plugin no inicializado correctamente
   SOLUCIÓN:
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
   APRENDIZAJE: Los plugins de Embla se pasan como tercer parámetro en un array

7. PROBLEMA: Dots navegaban de 2 en 2 en lugar de 1 en 1
   CAUSA: slidesToScroll: 2 en las opciones
   SOLUCIÓN: slidesToScroll: 1
   APRENDIZAJE: slidesToScroll controla cuántos slides se mueven, no cuántos se ven

8. PROBLEMA: Container del carrusel afectaba la visualización en móvil (se veía centrado, no natural)
   CAUSA: Márgenes del container evitaban que el carrusel llegara al borde
   SOLUCIÓN: Crear opciones de container configurables:
   - full: Sin márgenes (padding: 0)
   - full_left: Margen izquierdo, sin margen derecho (padding-left: 1rem, padding-right: 0)
   - minimal: Márgenes mínimos
   - normal: Container estándar
   - wide: Container amplio
   APRENDIZAJE: Carruseles móviles se ven más naturales cuando llegan hasta el borde de la pantalla

MEJORES PRÁCTICAS:

1. Siempre usa lazy loading para imágenes:
   ```twig
   <img 
       src="{{ 'images/empty-placeholder.png' | static_url }}" 
       data-src="{{ slide.image | static_url | settings_image_url('large') }}" 
       class="lazyload"
   >
   ```

2. Carga librerías solo cuando sean necesarias:
   ```twig
   {% if template == 'home' %}
       {{ 'library.js' | script_tag(true) }}
   {% endif %}
   ```

3. Usa variables CSS del tema para mantener consistencia:
   ```css
   color: var(--main-foreground);
   background: var(--main-background);
   ```

4. Verifica que existan datos antes de renderizar:
   ```twig
   {% set has_items = settings.mi_seccion_items and settings.mi_seccion_items is not empty %}
   {% if has_items %}
       {# render content #}
   {% endif %}
   ```

5. Usa | translate para todos los textos:
   ```twig
   {{ 'Mi texto' | translate }}
   {{ settings.mi_titulo | translate }}
   ```

6. Debug con json_encode:
   ```twig
   <pre>{{ variable | json_encode }}</pre>
   ```

ESTRUCTURA DE ARCHIVOS PARA NUEVA SECCIÓN:

1. config/settings.txt:
   - Agregar collapse con configuraciones
   - Agregar sección a home_order_position

2. config/defaults.txt:
   - Agregar valores por defecto para TODOS los campos

3. layouts/layout.tpl:
   - Cargar librerías si es necesario (con condición de template)

4. snipplets/home/home-section-switch.tpl:
   - Agregar case para la nueva sección

5. snipplets/home/home-[nombre-seccion].tpl:
   - Crear el snippet con HTML, CSS y JS

CARRUSEL EMBLA - CONFIGURACIÓN RECOMENDADA:

```javascript
const options = {
    loop: true,              // o false
    align: 'start',          // o 'center'
    slidesToScroll: 1,       // cuántos slides mover
    skipSnaps: false,        // no saltar snaps
    dragFree: false          // no drag libre
};

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

CSS IMPORTANTE:
```css
.embla__container {
    display: flex;
    backface-visibility: hidden;
    touch-action: pan-y;
    /* NO agregar: transition */
}
```

RECORDATORIOS IMPORTANTES:

⚠️ NO usar {{ slide | static_url }} para gallery items
✅ USAR {{ slide.image | static_url | settings_image_url('large') }}

⚠️ NO usar gallery_caption Y gallery_more_info juntos
✅ USAR solo gallery_more_info para acceder a campos por defecto

⚠️ NO definir estilos desktop primero
✅ USAR Mobile First: estilos móvil por defecto, desktop en media queries

⚠️ NO poner flechas dentro de overflow: hidden
✅ PONER flechas fuera del contenedor del carrusel

⚠️ NO agregar transiciones CSS manuales en carruseles Embla
✅ DEJAR que Embla maneje sus propias transiciones

VARIABLES COMUNES DE TIENDANUBE:

- {{ template }} : nombre del template actual
- {{ language.lang }} : idioma actual (es, en, pt)
- {{ store.name }} : nombre de la tienda
- {{ settings.nombre_campo }} : valor de configuración
- {{ customer }} : usuario logueado (si existe)
- {{ cart }} : carrito de compras

FILTROS COMUNES:

- | translate : traducir texto
- | static_url : URL de archivo estático
- | settings_image_url('size') : redimensionar imagen de settings
- | product_image_url('size') : redimensionar imagen de producto
- | setting_url : URL de enlace de configuración
- | money : formatear precio
- | json_encode : convertir a JSON (debug)

Con este contexto, estoy listo para continuar desarrollando el tema.
```

---

## 📝 Cómo usar este prompt

1. **Al iniciar una nueva sesión de Cursor**, copia todo el contenido del bloque de arriba
2. Pégalo en el chat de Cursor
3. Cursor tendrá todo el contexto necesario sobre:
   - La estructura del proyecto
   - Los problemas que enfrentaste y cómo los resolviste
   - Las mejores prácticas descubiertas
   - La sintaxis correcta para Tiendanube

---

## 🔄 Actualizaciones

Cada vez que descubras algo nuevo o resuelvas un problema:

1. Abre este archivo
2. Agrega el nuevo conocimiento en la sección correspondiente
3. Usa el prompt actualizado en futuras sesiones

---

## 💡 Ejemplos de uso

### Ejemplo 1: Crear una nueva sección
```
[Pega el prompt de contexto]

Ahora necesito crear una nueva sección para el home que muestre testimonios de clientes con nombre, foto, texto y calificación de estrellas. Debe ser responsive y tener opciones para cambiar el número de columnas en mobile y desktop.
```

### Ejemplo 2: Solucionar un problema
```
[Pega el prompt de contexto]

Tengo un problema: estoy intentando acceder a las imágenes de un gallery pero no se muestran. Estoy usando {{ item | static_url }}. ¿Cuál es la sintaxis correcta según el contexto del proyecto?
```

### Ejemplo 3: Agregar funcionalidad
```
[Pega el prompt de contexto]

Necesito agregar un carousel de marcas (logos) en el home. Debe usar Swiper.js y ser configurable desde el admin. ¿Qué archivos debo modificar y en qué orden?
```

---

## 🎯 Beneficios de usar este prompt

✅ **Contexto inmediato**: Cursor sabrá exactamente en qué estás trabajando
✅ **Soluciones rápidas**: Conocerá los problemas ya resueltos
✅ **Mejores prácticas**: Aplicará las lecciones aprendidas
✅ **Consistencia**: Mantendrá el estilo y estructura del proyecto
✅ **Menos errores**: Evitará cometer los mismos errores del pasado

---

**🚀 ¡Tu conocimiento ahora es reutilizable y transferible a todo tu equipo!**

