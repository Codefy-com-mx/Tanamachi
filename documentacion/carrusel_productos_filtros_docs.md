# Guía Técnica: Creación de Carrusel de Productos con Filtros por Tags (Tiendanube / Codefy)

Este documento detalla exhaustivamente el funcionamiento y la implementación de la sección "Carrusel de Productos con Filtros". Su objetivo es servir como manual técnico para replicar este comportamiento interactivo (filtrado por tags en tiempo real mediante pestañas y deslizamiento táctil horizontal) en cualquier nueva sección o componente a futuro.

## Arquitectura y Archivos Involucrados

Para que la sección sea modular, editable desde el panel de administración y funcional en el frontend, intervienen los siguientes componentes:

1. **[snipplets/home/home-carrusel-productos-filtros.tpl](file:///Users/macpro/Documents/GitHub/scatola/snipplets/home/home-carrusel-productos-filtros.tpl) (o el nombre del nuevo componente)**: El núcleo HTML, Twig, CSS local y la lógica JavaScript de filtrado e integración con Embla.
2. **[snipplets/home/home-section-switch.tpl](file:///Users/macpro/Documents/GitHub/scatola/snipplets/home/home-section-switch.tpl)**: El enrutador que inyecta el componente en el Layout del Home.
3. **[config/settings.txt](file:///Users/macpro/Documents/GitHub/scatola/config/settings.txt) y [config/defaults.txt](file:///Users/macpro/Documents/GitHub/scatola/config/defaults.txt)**: Definen las variables editables por el comerciante (hasta 6 filtros, etiquetas, configuraciones de diseño, etc.).
4. **Librería de Terceros (Embla Carousel)**: Requerimiento obligatorio global que debe estar cargado en el `<head>` o al final del `<body>` del documento principal (`layout.tpl`) para manejar la función de deslizamiento físico (Swipe/Drag).

---

## 1. Lógica Backend (Twig) y Renderizado DOM

El proceso de recolección y filtrado inicial se maneja del lado del servidor usando el motor de plantillas Twig.

### A. Definición de Filtros en Base a Configuraciones
El administrador puede dar de alta hasta 6 pestañas. En el componente [.tpl](file:///Users/macpro/Documents/GitHub/scatola/snipplets/home/home-popup.tpl) se debe inicializar un arreglo `filters`. 
Por cada filtro configurado en [settings.txt](file:///Users/macpro/Documents/GitHub/scatola/config/settings.txt) (Nombre y Tag), se inyecta un objeto que servirá para construir el menú de pestañas.

```twig
{# Ejemplo del push al arreglo de filtros si el Tag está configurado #}
{% set filters = [] %}
{% if settings.mi_carrusel_filter_1_name and settings.mi_carrusel_filter_1_tag %}
    {% set filters = filters|merge([{
        'name': settings.mi_carrusel_filter_1_name,
        'tag': settings.mi_carrusel_filter_1_tag,
        'badge': settings.mi_carrusel_filter_1_badge | default(''),
        'id': 'filter-1'
    }]) %}
{% endif %}
```

### B. Consolidación del Listado Global de Productos
Dado que se busca mostrar productos de diferentes colecciones (Destacados, Nuevos, Ofertas), se debe generar un "Master Array" de productos usando la función `merge`.

```twig
{% set all_products = [] %}
{% if sections.primary.products %} {% set all_products = all_products | merge(sections.primary.products) %} {% endif %}
{% if sections.new.products %} {% set all_products = all_products | merge(sections.new.products) %} {% endif %}
{% if sections.sale.products %} {% set all_products = all_products | merge(sections.sale.products) %} {% endif %}
```

### C. Pre-filtrado Servidor (Seguridad Funcional)
Para evitar enviar miles de nodos HTML innecesarios al navegador (ahorro de latencia), cruzamos `all_products` contra los `tags` definidos en el arreglo `filters`. Si un producto tiene coincidencia, entra en `all_tagged_products`. 

### D. Renderizado HTML Crítico (`data-tags`)
Cada producto (`slide` dentro de la grilla de `Embla`) **DEBE** contener un atributo `data-tags` que imprima los tags en formato de texto separado por comas. El JavaScript utilizará esto como su "Base de Datos en Tiempo Real" en el navegador para saber qué tarjetas mostrar u ocultar.

```twig
<div class="embla-carrusel-productos__slide" data-tags="{{ product.tags | join(',') }}">
  {# Card de producto... #}
</div>
```

---

## 2. Construcción del Menú de Filtros (Tabs)

Se generan dinámicamente según el array bidimensional `filters` inicializado arriba. El primer elemento recibe la clase `--active`. 
Cada botón lleva como data-atributo el `tag` que le corresponde. 

```twig
<div class="filtros-container">
    {% for filter in filters %}
        <button class="filtro-btn {% if loop.first %}filtro-btn--active{% endif %}" data-tag="{{ filter.tag }}">
            {{ filter.name }}
        </button>
    {% endfor %}
</div>
```

---

## 3. Lógica Frontend (JavaScript y Embla Carousel)

Esta es la sección más delicada. El componente no realiza peticiones asíncronas (AJAX) al hacer click en las pestañas. Utiliza **Virtual DOM manual**.

Dado que `Embla Carousel` lee los elementos hijos de un contenedor (`.embla__container`) para calcular el ancho total de las pistas y los puntos de snap, si ocultamos elementos por CSS (`display: none`), Embla se "romperá" y dejará hoyos en blanco. La solución es **extraer y reinsertar nodos HTML puros**, y luego "destruir e inicializar" la librería Embla en milisegundos.

### A. Variables de Estado Global del Componente
```javascript
document.addEventListener('DOMContentLoaded', function() {
    const filterButtons = document.querySelectorAll('.filtro-btn');
    const slidesContainer = document.querySelector('.embla__container');
    
    // 1. Guardar todos los slides originales renderizados por Twig en memoria temporal
    let productSlides = Array.from(document.querySelectorAll('.embla__slide'));
    const originalSlidesData = productSlides.map(slide => ({
        tags: slide.getAttribute('data-tags') || '', // Para la validación del filtro
        html: slide.outerHTML                        // El "String" literal del nodo HTML
    }));

    let emblaApi = null;
    let currentFilter = '{{ filters[0].tag }}'; // Empezar con la primera tab de Twig
```

### B. Función de Filtrado Virtual
Cuando el usuario hace clic en una pestaña (`tag`):

1. Se vacía el contenedor del carrusel por completo.
2. Se itera el listado que guardamos en memoria `originalSlidesData`.
3. Si la propiedad `tags` del objeto cruza con el `tag` consultado, se vuelve a inyectar ese `html` crudo en el contenedor usando `insertAdjacentHTML`.

```javascript
    function filterProducts(tag) {
        if (!slidesContainer) return;

        slidesContainer.innerHTML = ''; // Vaciar el carrusel físico

        originalSlidesData.forEach(data => {
            // Verificar si el tag clickeado está dentro del listado de tags del HTML
            if (data.tags.includes(tag)) {
                slidesContainer.insertAdjacentHTML('beforeend', data.html);
                const newSlide = slidesContainer.lastElementChild;
                
                // Asegurar que sean visibles
                newSlide.classList.remove('hidden'); 
                newSlide.style.display = '';
            }
        });

        // NOTA: Agregar validación en caso de que un Tag no arroje resultados, 
        // puedes inyectar todo nuevamente (originalSlidesData) o mostrar un mensaje "Sin productos".

        // -------------------------
        // Manejo de Interfaz Activa
        // -------------------------
        document.querySelectorAll('.filtro-btn').forEach(btn => {
            btn.classList.toggle('filtro-btn--active', btn.getAttribute('data-tag') === tag);
        });

        // ---------------------------------
        // El Paso Crítico: Reborn de Embla
        // ---------------------------------
        if (emblaApi) {
            emblaApi.destroy(); // Matar los eventos táctiles viejos, dado que destruímos nodos hijos
            emblaApi = null;
        }

        // Deferir la reinicialización para asegurar que el navegador haya repintado el DOM
        setTimeout(() => initializeEmblaCarousel(0), 0); 
    }
```

### C. Función Inicializadora de Embla Carousel

Debemos verificar que la librería Embla exista (ya que a veces se carga diferida al final del body). Luego, configuramos el carrusel y lo almacenamos en `emblaApi`.

```javascript
    function initializeEmblaCarousel(startIndex = 0) {
        // Retry loop en caso de carga lenta del CDN de Embla
        if (typeof EmblaCarousel === 'undefined') {
            setTimeout(() => initializeEmblaCarousel(startIndex), 100);
            return;
        }

        const emblaNode = document.querySelector('.embla-carrusel-productos');
        if (!emblaNode) return;

        const options = { loop: false, align: 'start', startIndex };
        const plugins = [];
        // (Opcional) Autoplay Plugin de Embla si corresponde
        
        // Arrancar Motor
        emblaApi = EmblaCarousel(emblaNode, options, plugins);
        
        // Vincular flechas de navegación personalizadas a la API
        const prevBtn = document.querySelector('.embla__prev');
        if (prevBtn && !prevBtn.dataset.bound) {
            prevBtn.addEventListener('click', () => emblaApi && emblaApi.scrollPrev());
            prevBtn.dataset.bound = 'true';
        }
        // Repetir validación para botón 'next', etc.
    }
```

### D. Disparo Original y Event Listeners
Para finalizar y poner en marcha el componente cuando la página carga:

```javascript
    // Asignar los clics a las pestañas y derivarlas a filterProducts
    filterButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            filterProducts(this.getAttribute('data-tag'));
        });
    });

    // Iniciar con el filtro de la pestaña principal
    filterProducts(currentFilter);
});
```

---

## 4. Requisitos de Estilos (CSS)
Aunque el comportamiento recae en JS, `Embla` funciona mediante las mecánicas nativas de Flexbox en CSS.

Es de carácter **Obligatorio** que las siguientes reglas CSS se mantengan para que los cálculos matemáticos internos de la librería Embla Carousel no choquen al reinicializarse:

```css
.embla {
  overflow: hidden; /* Muy estricto, es el marco de la fotografía */
}
.embla__container {
  display: flex; /* Obligatorio */
  will-change: transform; /* Optimización del navegador */
}
.embla__slide {
  flex: 0 0 [porcentaje-de-ancho]; /* ej: calc(100% / 4) para desktop */
  min-width: 0; /* Evitar estiramiento de flexbox que corrompe el cálculo */
}
```

## Resumen del Flujo
1. **Twig/Servidor** junta todos los productos, revisa tags y ensambla un carrusel HTML gigante e invisible.
2. **Javascript** en su línea inicial *"Copia y Pega"* todo ese HTML gigante en una variable de memoria (`originalSlidesData`).
3. **Pestaña es presionada**, JS vacía la pantalla, filtra su memoria cruzando Tags contra el String del ID y clona solo lo que la pestaña requiere al DOM.
4. **Javascript** le avisa a `EmblaCarousel` que las tarjetas mutaron. Destruye la instancia actual y crea una nueva con las tarjetas exactas, lo que habilita que se pueda desplazar `swipe/tactil` correctamente las tarjetas con animaciones suaves.
