# 🏗️ Guía Técnica: Carrusel de Productos Multi-Origen Filtrado por Tag

Esta guía detalla el proceso técnico, paso a paso, para implementar un **Carrusel de Productos** que consolida (fusiona) múltiples bandejas de productos nativas de Tiendanube y las filtra dinámicamente mediante una etiqueta (Tag) ingresada directamente desde el administrador, sin necesidad de recurrir a complejas re-inicializaciones mediante JavaScript.

La ventaja principal de este enfoque es la optimización del rendimiento, ya que el filtrado ocurre **del lado del servidor (Twig)** y no del lado del cliente.

---

## 🏛 Arquitectura y Reglas del Sistema

### Limitación del Motor de Tiendanube

A nivel global (fuera de las páginas de categoría), Tiendanube **no permite** llamar a la totalidad del catálogo por temas de rendimiento. Solo expone tres bandejas globales ("colecciones maestras") que el administrador alimenta manualmente:

1. `sections.primary.products` (Productos Destacados)
2. `sections.new.products` (Nuevos Productos / Novedades)
3. `sections.sale.products` (Productos en Oferta)

**Regla de Oro:** Para que un producto pueda ser capturado por este carrusel, debe cumplir dos condiciones obligatorias:

1. Tener la etiqueta (Tag) exacta configurada en el personalizador.
2. Pertenecer a al menos UNA de las tres bandejas mencionadas anteriormente.

---

## 🛠 Proceso de Implementación (Paso a Paso)

### PASO 1: Campos de Base de Datos (`config/settings.txt`)

Debemos habilitar el punto de entrada para que el administrador decida qué etiqueta filtrará.

**Acción:** En tu archivo `settings.txt`, dar de alta en una sección modular el bloque del Carrusel, obligando el uso de un campo `text` (nunca `input`).

```txt
	collapse
		name = mi_namespace_carrusel_collapse
		title = Carrusel Filtrado
		backto = mi_namespace_order_position
	checkbox
		name = mi_namespace_carrusel_show
		description = Mostrar carrusel
	i18n_input
		name = mi_namespace_carrusel_title
		description = Título de la sección
	text
		name = mi_namespace_carrusel_tag
		description = Tag de los productos a mostrar (ej: quince_anos)
```

No olvides inicializar los defaults en `config/defaults.txt`.

---

### PASO 2: La Lógica de Fusión y Filtrado (El Componente HTML/Twig)

El "corazón" de este componente requiere crear un arreglo vacío y utilizar el filtro `merge` nativo de Twig. Luego, se itera y se detectan coincidencias en la matriz `product.tags`.

**Acción:** Crear tu archivo `.tpl` en la carpeta `snipplets/` que corresponda e inyectar esta lógica:

```twig
{% if settings.mi_namespace_carrusel_show %}

    {# 1. Fusión de las bandejas maestras #}
    {% set all_products = [] %}

    {% if sections.primary.products %}
        {% set all_products = all_products | merge(sections.primary.products) %}
    {% endif %}
    {% if sections.new.products %}
        {% set all_products = all_products | merge(sections.new.products) %}
    {% endif %}
    {% if sections.sale.products %}
        {% set all_products = all_products | merge(sections.sale.products) %}
    {% endif %}

    {# 2. Obtención de la etiqueta y limpieza de espacios vacíos #}
    {% set filter_tag = settings.mi_namespace_carrusel_tag | default('') | trim %}
    {% set products_found = 0 %}

    <section class="section-my-carousel py-5 position-relative" data-store="my-custom-carousel">
        <div class="container position-relative">

            {% if settings.mi_namespace_carrusel_title %}
                <h2 class="h3 mt-3 mb-4 text-center">{{ settings.mi_namespace_carrusel_title | translate }}</h2>
            {% endif %}

            <div class="js-swiper-my-namespace-carousel swiper-container">
                <div class="swiper-wrapper">

                    {# 3. Intersección: Revisar cada producto. #}
                    {% for product in all_products %}
                        {# Si el campo está vacío, o el tag coincide, lo inyectamos #}
                        {% if not filter_tag or filter_tag in product.tags %}
                            {% set products_found = products_found + 1 %}
                            {# Inyectar la tarjeta normal o el item en formato slide #}
                            {% include 'snipplets/grid/item.tpl' with {'slide_item': true} %}
                        {% endif %}
                    {% endfor %}

                </div>
            </div>

            {# 4. Manejo de Errores (Empty State) #}
            {% if products_found == 0 %}
                <div class="text-center w-100 mt-4 mb-4" style="background: #f8f9fa; padding: 30px;">
                    <p class="mb-0">No encontramos productos con el Tag: <strong>{{ filter_tag | default('Vacío') }}</strong></p>
                    <small>Asegúrate de que haya productos en Destacados, Ofertas o Novedades con esa etiqueta.</small>
                </div>
            {% endif %}

            {# Flechas de Navegación (Opcionales) #}
            {% if products_found > 0 %}
                <div class="js-swiper-my-namespace-carousel-prev swiper-button-prev d-none d-md-flex"></div>
                <div class="js-swiper-my-namespace-carousel-next swiper-button-next d-none d-md-flex"></div>
            {% endif %}

        </div>
    </section>

    {# 5. Inicialización Responsiva (Swiper) #}
    {% if products_found > 0 %}
        <style>
            /* CSS Para mantener las flechas en medio y ocultas en móvil por Usabilidad Táctil */
            .section-my-carousel .swiper-button-prev,
            .section-my-carousel .swiper-button-next {
                position: absolute; top: 50%; transform: translateY(-50%); z-index: 10;
            }
        </style>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                var initCarousel = setInterval(function() {
                    if (typeof window.Swiper !== 'undefined') {
                        clearInterval(initCarousel);
                        new window.Swiper('.js-swiper-my-namespace-carousel', {
                            /* Configuraciones fraccionadas para inducir el scroll ("Affordance") */
                            slidesPerView: 1.2,
                            spaceBetween: 15,
                            navigation: {
                                nextEl: '.js-swiper-my-namespace-carousel-next',
                                prevEl: '.js-swiper-my-namespace-carousel-prev',
                            },
                            breakpoints: {
                                768: {
                                    slidesPerView: 3.5,
                                    spaceBetween: 20,
                                }
                            }
                        });
                    }
                }, 500);
            });
        </script>
    {% endif %}

{% endif %}
```

---

## 🎯 Resumen Teórico

Esta arquitectura resuelve 3 grandes retos:

1. **Evita la lentitud:** Transforma las limitaciones de Tiendanube en ventajas, uniendo inteligentemente (`| merge`) sólo las bandejas optimizadas, en lugar de intentar llamar a todo el catálogo mediante peticiones externas o APIs.
2. **Autenticidad Visual:** Permite inyectar fraccionamiento en Swiper.js (`1.2` en celulares) para indicar psicológicamente al comprador que existe más contenido lateral.
3. **Control Absoluto:** Le cede el control al administrador para reutilizar el mismo componente con múltiples tags distintos (`jeans`, `verano`, `liquidación`, etc.) a lo largo y ancho de las Landings del proyecto.
