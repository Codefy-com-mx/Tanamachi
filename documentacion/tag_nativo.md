# 🏷️ Implementación: Filtro por Etiqueta (Tag) en Carruseles Nativos

Esta guía documenta la implementación detallada para poder filtrar las bandejas maestras de productos nativos (como Destacados, Novedades u Ofertas) mediante una etiqueta (`tag`) definida en el panel de administración, **aprovechando el renderizado en servidor (Twig)** y sin romper el layout original de la tienda.

---

## 🏗 Arquitectura del Problema

El tema base de Tiendanube renderiza los carruseles nativos de la Home mediante dos archivos principales:

1. `snipplets/home/home-featured-products.tpl`: Determina qué bandejas mostrar y las envía a renderizar.
2. `snipplets/home/home-featured-grid.tpl`: Arma el loop (el bucle) que pinta el HTML de cada tarjeta de producto y configura su adaptación a Swiper (el motor de Javascript).

### 💣 El Error Común al Filtrar en la Grilla

Si intentamos filtrar los productos directamente enviándolos sobrepisados al archivo `home-featured-grid.tpl`, existe una línea en ese archivo que fuerza una reasignación: `{% set sections_products = sections.primary.products %}`. Si no somos cuidadosos, esto destruye la variable filtrada que le acabamos de enviar y devuelve el carrusel a su estado completo original, pintando todos los productos y arruinando nuestra lógica.

La solución es procesar (pre-filtrar) la bandeja original, guardarla en una nueva variable segura (ej. `custom_primary_products`) y modificar a la grilla receptora para que use esa nueva variable.

---

## 🛠 Paso a Paso: Ejemplo en Productos Destacados

Este esquema puede replicarse de manera idéntica para _Productos Nuevos_ (`new_products / sections.new.products`) o _En Oferta_ (`sale_products / sections.sale.products`).

### 1. Panel de Administración (`config/settings.txt` y `config/defaults.txt`)

Debes agregar el campo en la sección de tu carrusel para que se pueda habilitar la opción de poner la etiqueta de forma dinámica desde el administrador.

```text
// en config/settings.txt dentro del bloque 'Productos destacados'
	text
		name = featured_products_tag_filter
		description = Filtrar por etiqueta (Tag)

// en config/defaults.txt
featured_products_tag_filter =
```

### 2. Controlador de Secciones (`snipplets/home/home-featured-products.tpl`)

Es vital realizar el filtro **antes** de habilitar los atributos HTML de visualización. De este modo, si todos los productos no cumplen la condición y la colección queda vacía (una matriz `[]`), la etiqueta HTML principal no se dibuja y evitamos huecos feos en el inicio.

```twig
{# 1. Traemos la lista maestra y la etiqueta configurada #}
{% set primary_products = sections.primary.products %}
{% set featured_tag = settings.featured_products_tag_filter | trim %}

{# 2. Si la etiqueta fue cargada en ajustes, filtramos iterativamente #}
{% if featured_tag and has_featured %}
    {% set filtered_primary = [] %}
    {% for product in primary_products %}
        {% if featured_tag in product.tags %}
            {% set filtered_primary = filtered_primary | merge([product]) %}
        {% endif %}
    {% endfor %}
    {% set primary_products = filtered_primary %}
{% endif %}

{# 3. Recalculamos validando la cantidad remanente #}
{% set has_featured = has_featured | default(false) and primary_products | length > 0 %}

{# ... Al momento de hacer el include, usamos la variable secundaria que llamaremos custom_primary_products #}
{% if has_featured %}
    {% include 'snipplets/home/home-featured-grid.tpl' with {'featured_products': true, 'custom_primary_products': primary_products} %}
{% endif %}
```

### 3. Ajuste de Re-asignación de la Grilla (`snipplets/home/home-featured-grid.tpl`)

Hay que decirle al archivo base que si recibe `custom_primary_products`, asigne los productos listados sobre esta nueva variable. Si no la recibe (para mantener retrocompatibilidad o por defecto si no lo usan), que recurra a la clásica matriz del motor nativo.

```twig
{# Antes (Borrar): #}
{# {% set sections_products = sections.primary.products %} #}

{# Ahora: Aplicamos validación is defined #}
{% if featured_products %}
    {% if custom_primary_products is defined %}
        {% set sections_products = custom_primary_products %}
    {% else %}
        {% set sections_products = sections.primary.products %}
    {% endif %}

    {% set section_name = 'primary' %}
    {# ... etc ... #}
{% endif %}
```

### 4. Sincronización del JS de Swiper (`static/js/store.js.tpl`)

Este paso es crucial, porque si no recalculas los ítems antes de decirle a `Swiper` si usar el `loop: true` infinito o no, en móviles e iPads te sobraran tarjetas blancas inservibles generadas por JS.

Usualmente se busca la palabra **`sections.primary.products | length > 4`** y se reemplaza el bloque `loop: true,` por algo dinámico que considere nuestro filtro (que se expone desde liquid/twig al momento de compilar el JS):

```twig
{# Filtramos una vez más al compilar el store.js.tpl de ser necesario #}
            {% set primary_products_to_count = sections.primary.products %}
            {% set filter_tag_js = settings.featured_products_tag_filter | trim %}

            {% if filter_tag_js %}
                {% set filtered_primary_count = 0 %}
                {% for product in primary_products_to_count %}
                    {% if filter_tag_js in product.tags %}
                        {% set filtered_primary_count = filtered_primary_count + 1 %}
                    {% endif %}
                {% endfor %}
                {% set featured_count = filtered_primary_count %}
            {% else %}
                {% set featured_count = primary_products_to_count | length %}
            {% endif %}

            {% if featured_count > 4 %}
                loop: true,
            {% endif %}
```

### 5. Configuración Visual Aislada (Estilo Retrato y Títulos HTML)

Para asegurar que las tarjetas tengan un estilo de "fotografía continua" con una proporción mucho más alargada (aspect ratio vertical) y que no afecten a otros carruseles de la tienda, es crucial realizar dos cosas:

#### Aislar la sección:

En `snipplets/home/home-featured-grid.tpl`, aplicamos una clase adicional (`section-featured-exclusive`) en el contenedor principal y aprovechamos de pasar el título por un filtro `raw` si queremos aceptar etiquetas HTML fuertes (ej. `<STRONG>SESION</STRONG>`).

```twig
<div class="js-products-{{ section_id }}-container container {% if section_id == 'featured' %}section-featured-exclusive{% endif %}">
    <div class="row">
        <div class="col-12">
            {# Agregamos | raw para que parsee etiquetas HTML #}
            <h2>{{ section_title | raw }}</h2>
```

#### Aplicar Estilos CSS Exclusivos:

Al colocar esto al final del archivo principal de estilos de la tienda (generalmente `static/css/style-async.scss`), bloqueamos las dimensiones y arreglamos el espaciado automático de las fotos usando un `aspect-ratio` forzado:

````scss
/* ==========================================================
   CAROUSEL DESTACADOS (AISLADO)
   ========================================================== */
.section-featured-exclusive {
  /* Reposicionamiento del título a la izquierda, etc. */
  .section-title {
    text-align: left !important;
  }

#### Estilización del Botón Dinámico (Quickshop/Add to Cart):

Para que el botón active el pop-up de variantes (si existen) o agregue directamente al carrito (si no hay variantes), reutilizamos el contenedor nativo `.item-actions` y lo restilizamos como una cápsula minimalista dentro del grid flotante:

```scss
.section-featured-exclusive {
  .item-actions {
    grid-area: button;
    align-self: flex-end;
    border: 1px solid rgba(255, 255, 255, 0.7);
    transition: all 0.3s ease;
    z-index: 5;

    /* Estilo del botón y enlace interno */
    span, a, .js-addtocart, .js-open-quickshop-wording {
        color: #fff !important;
        font-size: 10px !important;
        padding: 6px 14px !important;
        text-transform: uppercase;
        cursor: pointer;
    }

    &:hover {
        background: #fff !important;
        span, a, .js-addtocart { color: #000 !important; }
    }

    /* Variación para productos SIN STOCK */
    &.item-actions-out-of-stock {
        border-color: rgba(255, 255, 255, 0.3);
        cursor: default;
        .item-out-of-stock-text {
            color: rgba(255, 255, 255, 0.5) !important;
            font-size: 10px;
            padding: 6px 14px;
            display: block;
        }
        &:hover { background: transparent !important; }
    }
  }
}
````

{% endif %}

````

### 7. Adaptación Móvil (Botón como Extensión)

Para móviles, se mueve el botón debajo de la imagen para liberar espacio visual sin perder la llamada a la acción, manteniendo el nombre y precio flotantes:

```scss
@media (max-width: 767px) {
  .item {
      margin-bottom: 55px !important; /* Espacio para el botón fuera de la caja */
      overflow: visible !important;

      .item-description {
          position: absolute; /* Vuelve a flotar sobre la foto */
          bottom: 0; left: 0; width: 100%;
      }

      .item-actions {
          position: absolute;
          top: 100%; /* Se posiciona justo al ras de la base de la foto */
          left: 0; width: 100% !important;
          background: transparent !important;

          span, a, .js-addtocart, .item-out-of-stock-text {
              color: #000 !important; /* Texto negro para fondo claro de página */
              border: 1px solid #ccc !important; /* Borde gris minimalista */
              border-top: none !important; /* Unión visual con la foto */
              padding: 12px 10px !important;
              text-align: center;
          }

          &.item-actions-out-of-stock {
              .item-out-of-stock-text {
                  color: #000 !important;
                  opacity: 0.5; /* Diferenciación visual de agotado */
              }
          }
      }
  }
}
````

### 8. Precauciones Críticas al Modificar Tarjetas (Cuidado con Quickshop)

Al alterar el diseño de la tarjeta de producto nativa (`snipplets/grid/item.tpl`) para crear layouts diferentes (ej. diseño editorial o revistas), existe un alto riesgo de romper funcionalidades del sistema de Tiendanube, **específicamente la ventana emergente de "Comprar" (Quickshop)**.

**Reglas de Oro para evitar romper el Quickshop y scripts JS:**

1. **Nunca elimines o reemplaces el componente nativo de imagen:**
   El archivo `item.tpl` inyecta la foto mediante `{{ component('product-item-image', ...) }}`. Esto genera elementos con clases vitales (`.js-item-image`, `.js-item-image-padding`). El script de la tienda necesita _obligatoriamente_ estas clases para calcular dimensiones y clonar la foto al abrir la ventana modal de compra. Si borras este componente para poner tu propio HTML de imagen, el Javascript crasheará al no encontrar el tamaño original y la **ventana modal aparecerá en blanco o rota**.

2. **Engaño Visual vía CSS (Z-index)**:
   Si necesitas que la "Portada" del carrusel sea la segunda foto del producto, no imprimas un HTML solo con la segunda foto. Deja que el componente nativo imprima ambas (como lo hace por defecto para el efecto hover) y fuerza a la imagen secundaria a estar permanentemente por encima usando CSS:

   ```scss
   .tu-seccion-exclusiva .item-image-secondary {
     display: block !important;
     opacity: 1 !important;
     visibility: visible !important;
     z-index: 2; /* Se sobrepone a la primera foto invisiblemente para JS */
   }
   ```

3. **Cuidado al reagrupar la descripción (Magia del display: contents):**
   Los nombres, precios y botones dentro de `item.tpl` tienen un agrupamiento y anidación específicos (muchas veces dentro de `<a class="item-link">`). Modificar ese HTML puede romper la vinculación de eventos JS.
   **La solución profesional** es dejar el HTML exactamente como está y usar `display: contents;` en los contenedores molestos (como `.item-link`). Esto te permitirá aplicar CSS Grid al padre contenedor (`.item-description`) y ubicar libremente el nombre, precio y botón en la pantalla como si fueran hijos directos, sin alterar el DOM real.

## Consideraciones Adicionales 💡

- **Retrocompatibilidad**: Al usar clases exclusivas como `.section-featured-exclusive`, estos cambios de "Sin stock" solo se verán en el formato de cápsula en el carrusel de la home, manteniendo el diseño original en el resto de la tienda.
- **Traducciones**: El texto "Sin stock" usa el filtro `| translate`, por lo que se adaptará automáticamente al idioma de la tienda.
- **HTML en Títulos**: Recuerda usar siempre el filtro `| raw` en el renderizado de títulos si planeas inyectar etiquetas como `<strong>` desde el administrador.
- **Performance**: Al filtrar en Twig (servidor), evitamos que el navegador descargue productos que no se van a mostrar, mejorando la velocidad de carga.
