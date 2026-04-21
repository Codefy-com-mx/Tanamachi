# 📦 Guía Completa: Product Detail Page (PDP) — Tiendanube

> Referencia técnica del proyecto **Aguiar** para la página de detalle de producto.

---

## 📁 Arquitectura de Archivos

### Template Principal
| Archivo | Ruta | Descripción |
|---|---|---|
| **product.tpl** | `templates/product.tpl` | Template principal, ensambla todos los snipplets |
| **layout.tpl** | `layouts/layout.tpl` | Layout global (head, scripts, header, footer) |

### Snipplets del Producto (subcarpeta `snipplets/product/`)
| Archivo | Descripción |
|---|---|
| `product-form.tpl` | **Componente principal**: nombre, precio, variantes, CTA, envío |
| `product-image.tpl` | Galería de imágenes con Swiper (slider + thumbs) |
| `product-image-thumbs.tpl` | Thumbnails individuales para la galería vertical |
| `product-video.tpl` | Video del producto (YouTube / nativo) |
| `product-description.tpl` | Descripción del producto + comentarios de Facebook |
| `product-variants.tpl` | Selectores de variantes (dropdowns, botones de color/talla) |
| `product-quantity.tpl` | Selector +/- de cantidad |
| `product-payment-details.tpl` | Modal con detalles de medios de pago e cuotas |
| `product-related.tpl` | Productos relacionados (alternativos + complementarios) |

### Snipplets Auxiliares usados en la PDP
| Archivo | Ruta completa | Uso |
|---|---|---|
| `labels.tpl` | `snipplets/labels.tpl` | Etiquetas de oferta, envío gratis, sin stock |
| `social-share.tpl` | `snipplets/social/social-share.tpl` | Botones de compartir (WhatsApp, FB, Twitter, Pinterest) |
| `shipping-calculator.tpl` | `snipplets/shipping/shipping-calculator.tpl` | Calculadora de envío por código postal |
| `branches.tpl` | `snipplets/shipping/branches.tpl` | Sucursales/locales físicos |
| `shipping-free-rest.tpl` | `snipplets/shipping/shipping-free-rest.tpl` | Mensaje de "envío gratis faltando X" |
| `cross-selling.tpl` | `snipplets/cross-selling.tpl` | Cross-selling en notificación post add-to-cart |
| `item-structured-data.tpl` | `snipplets/structured_data/item-structured-data.tpl` | JSON-LD SEO |

---

## 🔀 Flujo de Renderizado

```
layout.tpl
  └── template_content → product.tpl
        ├── product-image.tpl
        │     ├── product-image-thumbs.tpl
        │     ├── product-video.tpl
        │     └── labels.tpl
        ├── product-form.tpl
        │     ├── product-variants.tpl
        │     ├── product-quantity.tpl
        │     ├── shipping-calculator.tpl
        │     ├── branches.tpl
        │     └── product-payment-details.tpl
        ├── product-description.tpl
        ├── social-share.tpl
        └── product-related.tpl
```

### Estructura HTML simplificada

```html
<div id="single-product" data-variants="...JSON..." data-store="product-detail">
  <div class="container">
    <div class="row">
      <!-- Col izquierda: 7/12 = Galería de imágenes -->
      <div class="col-md-7">
        {% include 'product-image.tpl' %}
      </div>
      
      <!-- Col derecha: 5/12 = Info del producto -->
      <div class="col" data-store="product-info-{{ product.id }}">
        {% include 'product-form.tpl' %}
        <!-- Descripción aquí si NO es full_width -->
        {% include 'product-description.tpl' %}
      </div>
    </div>
    
    <!-- Descripción aquí si ES full_width -->
    {% include 'product-description.tpl' %}
    
    <!-- Social share (mobile) -->
    {% include 'social-share.tpl' %}
  </div>
</div>

<!-- Productos relacionados (fuera del container principal) -->
{% include 'product-related.tpl' %}
```

---

## 🗃️ Variables del Objeto `product`

### Datos Principales

| Variable | Tipo | Descripción | Ejemplo de uso en template |
|---|---|---|---|
| `product.id` | int | ID único del producto | `{{ product.id }}` |
| `product.name` | string | Nombre del producto | `{{ product.name }}` |
| `product.description` | string (HTML) | Descripción rica del producto | `{{ product.description }}` |
| `product.seo_description` | string | Descripción SEO (texto plano) | Structured data |
| `product.url` | string | URL relativa del producto | `{{ product.url }}` |
| `product.social_url` | string | URL completa para compartir en redes | `{{ product.social_url }}` |
| `product.canonical_url` | string | URL canónica para SEO | Structured data |
| `product.sku` | string | Código SKU del producto | `{{ product.sku }}` |
| `product.brand` | string | Marca del producto | Structured data |

### Precios

| Variable | Tipo | Descripción | Uso |
|---|---|---|---|
| `product.price` | int (centavos) | Precio actual en centavos | `{{ product.price \| money }}` |
| `product.compare_at_price` | int (centavos) | Precio tachado (antes de descuento) | `{{ product.compare_at_price \| money }}` |
| `product.display_price` | bool | Si el precio debe mostrarse | Condicional de visibilidad |
| `product.currency` | string | Código de moneda (ej: "MXN") | Structured data |

### Stock y Disponibilidad

| Variable | Tipo | Descripción |
|---|---|---|
| `product.available` | bool | Si el producto está disponible |
| `product.has_stock` | bool | Si tiene stock |
| `product.stock` | int/null | Cantidad en stock (null = sin control) |
| `product.stock_control` | bool | Si tiene control de stock activo |
| `product.free_shipping` | bool | Si tiene envío gratis |
| `product.is_non_shippable` | bool | Si es un producto digital/no envíable |

### Imágenes y Media

| Variable | Tipo | Descripción |
|---|---|---|
| `product.media` | array | Array de objetos media (imágenes + videos) |
| `product.media_count` | int | Cantidad total de media |
| `product.featured_image` | object | Imagen principal |
| `product.featured_variant_image` | object | Imagen de la variante seleccionada |
| `product.video_url` | string | URL del video YouTube (si existe) |
| `product.other_images` | array | Imágenes adicionales (no principal) |
| `product.hasNativeVideos` | bool | Si tiene videos nativos de Cloudflare |

#### Propiedades de cada `media` en el loop:

```twig
{% for media in product.media %}
  {{ media.id }}                        {# ID del media #}
  {{ media.isImage }}                   {# bool: es imagen? #}
  {{ media.isVideo }}                   {# bool: es video? #}
  {{ media.dimensions['width'] }}       {# Ancho en px #}
  {{ media.dimensions['height'] }}      {# Alto en px #}
  {{ media.alt }}                       {# Texto alternativo #}
  {{ media.thumbnail }}                 {# URL del thumbnail (para videos) #}
  {{ media.next_video }}                {# ID del siguiente video #}
  
  {# Filtros para obtener URLs de distintos tamaños: #}
  {{ media | product_image_url('small') }}     {# ~100px #}
  {{ media | product_image_url('medium') }}    {# ~240px #}
  {{ media | product_image_url('thumb') }}     {# ~60px #}
  {{ media | product_image_url('large') }}     {# ~480px #}
  {{ media | product_image_url('huge') }}      {# ~640px #}
  {{ media | product_image_url('original') }}  {# Tamaño original #}
{% endfor %}
```

### Variantes

| Variable | Tipo | Descripción |
|---|---|---|
| `product.variations` | array | Array de grupos de variaciones (Talla, Color, etc.) |
| `product.variants` | array | Array de combinaciones de variantes con precio/stock |
| `product.variants_object` | object | Objeto JSON de variantes (para JS) |
| `product.default_options` | object | Opciones pre-seleccionadas |
| `product.selected_or_first_available_variant` | object | Variante seleccionada o primera disponible |

#### Estructura de `product.variations`:

```twig
{% for variation in product.variations %}
  {{ variation.id }}        {# ID de la variación (0, 1, 2) #}
  {{ variation.name }}      {# Nombre: "Talle", "Color", etc. #}
  
  {% for option in variation.options %}
    {{ option.id }}         {# ID de la opción #}
    {{ option.name }}       {# Valor: "S", "M", "L", "Rojo" #}
    {{ option.custom_data }} {# Dato personalizado (hex color) #}
  {% endfor %}
{% endfor %}
```

#### Estructura de `product.variants`:

```twig
{% for variant in product.variants %}
  {{ variant.id }}            {# ID del variant #}
  {{ variant.option1 }}       {# ID de opción 1 #}
  {{ variant.option2 }}       {# ID de opción 2 #}
  {{ variant.option3 }}       {# ID de opción 3 #}
  {{ variant.image }}         {# ID de imagen asociada #}
  {{ variant.available }}     {# bool: disponible #}
  {{ variant.stock }}         {# int: stock #}
  {{ variant.price }}         {# Precio en centavos #}
{% endfor %}
```

### Pagos y Cuotas

| Variable | Tipo | Descripción |
|---|---|---|
| `product.installments_info_from_any_variant` | object | Info de cuotas de cualquier variante |
| `product.show_installments` | bool | Si mostrar cuotas |
| `product.get_max_installments(false)` | method | Obtener máximo de cuotas |
| `product.has_direct_payment_only` | bool | Solo pago directo |
| `product.maxPaymentDiscount.value` | float | % descuento por medio de pago |
| `product.maxPaymentDiscount.paymentProviderName` | string | Nombre del método de pago |
| `product.showMaxPaymentDiscount` | bool | Mostrar descuento |
| `product.showMaxPaymentDiscountNotCombinableDisclaimer` | bool | Mostrar disclaimer |
| `product.showMaxPaymentDiscountCombinesWithSomeDiscounts` | bool | Combinable con algunos |

### Suscripciones

| Variable | Tipo | Descripción |
|---|---|---|
| `product.isSubscribable()` | method | Si acepta suscripciones |
| `product.isSubscriptionOnly()` | method | Si solo se vende por suscripción |

### Peso y Envío

| Variable | Tipo | Descripción |
|---|---|---|
| `product.weight` | float | Peso del producto |
| `product.weight_unit` | string | Unidad de peso |

### Metafields

| Variable | Tipo | Descripción |
|---|---|---|
| `product.metafields.related_products.related_products_ids` | string | IDs de productos relacionados (de app) |

### Promociones

| Variable | Tipo | Descripción |
|---|---|---|
| `product.hasVisiblePromotionLabel` | bool | Si tiene etiqueta de promo visible |

---

## 🎨 Mapa de Estilos CSS

### Ubicación de estilos por archivo

#### 1. `static/css/style-critical.scss` (carga sincrónica — primera pintura)

| Sección | Líneas aprox. | Clases/Selectores clave |
|---|---|---|
| **Product detail (mobile-first)** | `2077–2133` | `.product-slider-image`, `.product-description`, `.product-video-container`, `.product-video`, `.product-native-video-slide` |
| **Product detail (desktop >=768px)** | `2566–2607` | `.product-thumbs-container`, `.product-detail-slider`, `.swiper-product-thumb`, `.product-thumb`, `.swiper-product-thumb-control` |
| **Labels** | `2056–2075` | `.labels`, `.label` |
| **Price** | `1993–1997` | `.price-compare` |
| **Product grid (cards)** | `1886–2055` | `.item-product`, `.item-image`, `.item-name`, `.item-price-container`, `.item-colors-bullet` |

#### 2. `static/css/style-async.scss` (carga asincrónica — después de primera pintura)

| Sección | Líneas aprox. | Clases/Selectores clave |
|---|---|---|
| **Product detail** | `1361–1370` | `.section-fb-comments`, `.btn-add-to-cart + .alert` |
| **Fancybox (zoom de imagen)** | `1374–1830` | `.fancybox__container`, `.carousel`, `.carousel__slide` |
| **Quickshop** | `1348–1358` | `.quickshop-image`, `.quickshop-image-container` |
| **Product grid** | `1289–1358` | `.filters-overlay`, `.price-filter-container` |

#### 3. `static/css/style-colors.scss` (variables de color del tema)
- Los colores del producto heredan las variables CSS globales definidas en `style-tokens.tpl`

#### 4. `static/css/style-new-section.scss` (secciones custom)
- Secciones personalizadas del proyecto (carruseles por tag, hero editorial, etc.)

### Clases CSS importantes de la PDP

```css
/* Contenedor principal del producto */
#single-product { }

/* Slider de imágenes */
.product-detail-slider { }
.product-slider-image { }
.js-swiper-product { }

/* Thumbnails verticales */
.product-thumbs-container { width: 85px; }  /* desktop */
.swiper-product-thumb { height: 350px; }    /* desktop */
.product-thumb { }

/* Video */
.product-video-container { }
.product-video { }
.product-native-video-slide { }

/* Descripción */
.product-description { max-height: 150px; overflow: hidden; }
.product-description-full { max-height: fit-content; }

/* Precio */
.price-container { }
.price-compare { text-decoration: line-through; opacity: .5; }
.free-shipping-message { }

/* Variantes */
.btn-variant { }
.btn-variant-color { }
.btn-variant-no-stock { }
.btn-variant-content-square { }  /* imagen de variante de color */

/* Botón agregar al carrito */
.btn-add-to-cart { }
```

---

## ⚡ Funcionalidad JavaScript

Todo el JS del producto está en `static/js/store.js.tpl`, dentro de `LS.ready.then(function(){ ... })`.

### Funciones Principales

#### 1. **Slider de Imágenes** (Swiper)
- **Ubicación:** Líneas ~`2680–2840` en `store.js.tpl`
- **Selector:** `.js-swiper-product`
- **Configuración:** `slidesPerView: 'auto'`, paginación tipo `fraction`
- **Thumbs:** `.js-swiper-product-thumbs` — dirección vertical
- **Funcionalidad:**
  - Click en thumbnail → slide a imagen  
  - Cambio de variante → slide a imagen de variante
  - Click en imagen → abre Fancybox (zoom fullscreen)

```javascript
// Slider principal
createSwiper('.js-swiper-product', {
    slidesPerView: 'auto',
    pagination: { el: '.js-swiper-product-pagination', type: 'fraction' },
    navigation: { nextEl: '.js-swiper-product-next', prevEl: '.js-swiper-product-prev' },
});

// Thumbnails
createSwiper('.js-swiper-product-thumbs', {
    direction: 'vertical',
    slidesPerView: 'auto',
});

// Fancybox (zoom de imágenes)
Fancybox.bind('[data-fancybox="product-gallery"]', { ... });
```

#### 2. **Cambio de Variantes**
- **Ubicación:** Líneas ~`2087–2230` y `2314–2606` en `store.js.tpl`
- **Trigger:** Evento `change` en `.js-variation-option`
- **Flujo:** 
  1. Detecta si es PDP o quickshop
  2. Llama a `LS.changeVariant(changeVariant, '#single-product')`
  3. La función `changeVariant(variant)` actualiza:

```javascript
function changeVariant(variant) {
    // Actualiza SKU
    parent.find('.js-product-sku').text(variant.sku);
    
    // Actualiza stock
    parent.find('.js-product-stock').text(variant.stock);
    
    // Actualiza precio
    parent.find('.js-price-display').text(variant.price_short);
    parent.find('.js-compare-price-display').text(variant.compare_at_price_short);
    
    // Actualiza cuotas
    installment_helper(...);
    
    // Actualiza botón (cart/contact/nostock)
    button.val('Agregar al carrito' / 'Sin stock' / 'Consultar precio');
    
    // Actualiza shipping calculator
    LS.updateShippingProduct();
    
    // Actualiza imagen del slider
    productSwiper.slideTo(slideToGo);
    
    // Actualiza barra de envío gratis
    LS.freeShippingProgress(true, parent);
}
```

#### 3. **Variantes sin Stock (botones)**
- **Ubicación:** Líneas ~`2092–2162` 
- Función `noStockVariants()` marca botones no disponibles con clase `.btn-variant-no-stock`

#### 4. **Cantidad (+/-)**
- **Ubicación:** Líneas ~`2853–2864`
- Eventos click en `.js-quantity-up` y `.js-quantity-down`
- Modifica el input `.js-quantity-input`

#### 5. **Add to Cart**
- **Ubicación:** Líneas ~`2612–2622` (submit del form) y ~`2899–3170` (ajax)
- **Flujo Ajax:** 
  1. Previene submit si `settings.ajax_cart` está activo
  2. Muestra placeholder de botón (animación)
  3. Llama al API de Tiendanube
  4. Muestra notificación o abre carrito
  5. Opcionalmente muestra productos recomendados

#### 6. **Descripción expandible**
- **Ubicación:** Línea ~`1750`
- Si `.js-product-description` tiene overflow, toglea clase `.product-description-full`

#### 7. **Videos Nativos** (Cloudflare Stream)
- **Ubicación:** Líneas ~`2624–2678`
- Funciones: `initAllVideos()`, `pauseAllVideos()`
- Se pausan todos los videos al cambiar de slide

---

## ⚙️ Settings del Admin (Panel de Personalización)

Sección **"Detalle de producto"** en `config/settings.txt` (líneas ~1345–1430):

| Setting | Variable | Tipo | Descripción |
|---|---|---|---|
| Calculador de envío | `shipping_calculator_product_page` | checkbox_global | Mostrar calculador en PDP |
| Cuotas | `product_detail_installments` | checkbox | Mostrar info de cuotas |
| Descuento por pago | `payment_discount_price` | checkbox | Mostrar precio con descuento |
| Variantes como botones | `bullet_variants` | checkbox | Mostrar variantes como botones |
| Imagen de variante color | `image_color_variants` | checkbox | Foto de variante como botón de color |
| Guía de talles | `size_guide_url` | input | URL de página de guía de talles |
| SKU | `product_sku` | checkbox | Mostrar código SKU |
| Stock | `product_stock` | checkbox | Mostrar stock disponible |
| Último producto | `last_product` | checkbox | Mostrar mensaje de última unidad |
| Texto último producto | `last_product_text` | input | Mensaje personalizado |
| Descripción full width | `full_width_description` | checkbox | Descripción a ancho completo |
| Comentarios Facebook | `show_product_fb_comment_box` | checkbox | Permite comentarios con FB |
| FB Admin ID | `fb_admins` | text | ID para moderar comentarios |
| Título relacionados | `products_related_title` | input | Título sección alternativos |
| Título complementarios | `products_complementary_title` | input | Título sección complementarios |

### Cómo usar settings en el template:

```twig
{% if settings.product_sku and product.sku %}
    <span>{{ product.sku }}</span>
{% endif %}

{% if settings.full_width_description %}
    {# Descripción debajo de ambas columnas #}
{% endif %}

{% if settings.shipping_calculator_product_page %}
    {% include "snipplets/shipping/shipping-calculator.tpl" %}
{% endif %}
```

---

## 🧩 Componentes Nativos de Tiendanube

La PDP utiliza varios `{{ component() }}` que son renderizados por el core de Tiendanube:

| Componente | Uso | Template |
|---|---|---|
| `price-discount-disclaimer` | Disclaimer de precio con descuento | product-form.tpl |
| `price-without-taxes` | Precio sin impuestos | product-form.tpl |
| `payment-discount-price` | Precio con descuento por medio de pago | product-form.tpl |
| `subscriptions/subscription-price` | Precio de suscripción | product-form.tpl |
| `subscriptions/subscription-selector` | Selector de tipo de compra (única/recurrente) | product-form.tpl |
| `promotions-details` | Detalles de promociones activas | product-form.tpl |
| `installments` | Información de cuotas inline | product-form.tpl |
| `payments/payments-details` | Modal completo de medios de pago | product-payment-details.tpl |
| `labels` | Etiquetas (oferta, envío gratis, sin stock) | labels.tpl |
| `products-section` | Sección de productos (relacionados, complementarios) | product-related.tpl |
| `structured-data` | JSON-LD para SEO | item.tpl / layout.tpl |

> **Importante:** Estos componentes NO se pueden ver/editar en el código del tema. Son renderizados internamente por Tiendanube. Solo puedes controlar sus clases CSS vía el parámetro de configuración que pasas al componente.

---

## 📐 Selectores JS Importantes (data-attributes)

| Selector / Atributo | Ubicación | Propósito |
|---|---|---|
| `#single-product` | product.tpl | Contenedor principal del PDP |
| `data-variants` | #single-product | JSON con todas las variantes |
| `data-store="product-detail"` | #single-product | Identificador de store |
| `data-store="product-info-{id}"` | product.tpl | Info del producto |
| `data-store="product-price-{id}"` | product-form.tpl | Contenedor de precio |
| `data-store="product-form-{id}"` | product-form.tpl | Formulario |
| `data-store="product-image-{id}"` | product-image.tpl | Galería |
| `data-store="product-description-{id}"` | product-description.tpl | Descripción |
| `data-store="product-buy-button"` | product-form.tpl | Botón de compra |
| `data-product-price` | .js-price-display | Precio numérico |
| `data-image` | .js-product-slide | ID de imagen del slide |
| `data-image-position` | .js-product-slide | Posición en el slider |
| `data-thumb-loop` | .js-product-thumb | Índice del thumbnail |

---

## 🛠️ Guías Prácticas

### ¿Cómo agregar una nueva sección a la PDP?

1. **Crear el snipplet:** `snipplets/product/mi-seccion.tpl`
2. **Incluirlo en** `templates/product.tpl`:
   ```twig
   {# Mi nueva sección #}
   {% include 'snipplets/product/mi-seccion.tpl' %}
   ```
3. **Agregar estilos** en `static/css/style-async.scss` o `style-new-section.scss`
4. **Agregar JS** (si es necesario) en `static/js/store.js.tpl` dentro de:
   ```javascript
   {% if template == 'product' %}
       // Tu código aquí
   {% endif %}
   ```

### ¿Cómo cambiar el layout de la PDP?

El layout actual es **2 columnas** (7 + 5) en `product.tpl`:
```html
<div class="col-md-7">  <!-- Imágenes -->
<div class="col">       <!-- Info -->
```

Para cambiarlo:
- **50/50:** Cambiar `col-md-7` a `col-md-6` y `col` a `col-md-6`
- **Full width imágenes arriba:** Poner ambos como `col-12`
- **Invertir:** Swap el orden de los divs y usar `order-md-*`

### ¿Cómo acceder a datos del producto en JS?

```javascript
// Desde el data-attribute del contenedor
var variants = jQueryNuvem('#single-product').data('variants');

// Precio actual (ya formateado)
var price = jQueryNuvem('.js-price-display').text();

// Precio numérico raw
var priceNumber = jQueryNuvem('.js-price-display').data('productPrice');

// SKU actual
var sku = jQueryNuvem('.js-product-sku').text();

// Stock actual
var stock = jQueryNuvem('.js-product-stock').text();

// Nombre del producto
var name = jQueryNuvem('.js-product-name').text();
```

### ¿Cómo escuchar cambios de variante en JS custom?

```javascript
// Registrar un callback
LS.registerOnChangeVariant(function(variant) {
    console.log('Variante cambió:', variant);
    console.log('Precio:', variant.price_short);
    console.log('Stock:', variant.stock);
    console.log('Disponible:', variant.available);
    console.log('Imagen:', variant.image);
    console.log('SKU:', variant.sku);
});
```

### Propiedades del objeto `variant` (en JS):

| Propiedad | Tipo | Descripción |
|---|---|---|
| `variant.id` | int | ID de la variante |
| `variant.price_short` | string | Precio formateado ("$1,500.00") |
| `variant.price_number` | float | Precio numérico |
| `variant.price_number_raw` | int | Precio en centavos |
| `variant.compare_at_price_short` | string | Precio tachado formateado |
| `variant.available` | bool | Disponible |
| `variant.contact` | bool | Sin precio (contactar) |
| `variant.stock` | int | Stock |
| `variant.sku` | string | SKU |
| `variant.image` | int | ID de imagen |
| `variant.image_url` | string | URL de imagen |
| `variant.element` | string | Selector del contenedor |
| `variant.product_id` | int | ID del producto |
| `variant.installments_data` | string (JSON) | Data de cuotas |
| `variant.price_without_taxes` | string | Precio sin impuestos |

---

## 🔗 Filtros Twig Útiles para Productos

| Filtro | Uso | Ejemplo |
|---|---|---|
| `money` | Formatea precio | `{{ product.price \| money }}` |
| `product_image_url(size)` | URL de imagen en tamaño | `{{ media \| product_image_url('large') }}` |
| `json_encode` | Convierte a JSON | `{{ product.variants_object \| json_encode }}` |
| `translate` | Traduce string | `{{ "Agregar al carrito" \| translate }}` |
| `static_url` | URL de asset estático | `{{ 'images/placeholder.png' \| static_url }}` |
| `escape('js')` | Escape para JS | `{{ store.cart_url \| escape('js') }}` |
| `add_param(k,v)` | Agrega query param a URL | `{{ product.url \| add_param('variant', id) }}` |
| `get_products` | Convierte IDs a productos | `{{ ids \| get_products }}` |
| `pin_it(image)` | Genera botón de Pinterest | `{{ product.social_url \| pin_it(image) }}` |

---

## 📊 Variables Globales Disponibles en la PDP

Además del objeto `product`, tienes acceso a:

| Variable | Descripción |
|---|---|
| `store` | Info de la tienda (name, cart_url, contact_url, has_shipping, branches, etc.) |
| `settings` | Todas las settings del tema (de settings.txt) |
| `template` | Nombre del template actual ("product") |
| `cart` | Información del carrito (free_shipping, subtotal, etc.) |
| `category` | Categoría del producto actual |
| `pages` | Páginas de contenido (para guía de talles) |
| `languages` | Idiomas configurados |
| `customer` | Cliente logueado (si aplica) |
| `params` | Parámetros de URL |
| `related_products_from_controller` | Productos relacionados desde back-end |
| `complementary_product_list` | Productos complementarios |

---

## 🔍 Cheatsheet: Dónde editar cada cosa

| Quiero editar... | Archivo |
|---|---|
| Layout / orden de secciones | `templates/product.tpl` |
| Nombre del producto | `snipplets/product/product-form.tpl` (línea 7-11) |
| Precio y cuotas | `snipplets/product/product-form.tpl` (línea 27-97) |
| Variantes (selectores) | `snipplets/product/product-variants.tpl` |
| Galería de imágenes | `snipplets/product/product-image.tpl` |
| Botón agregar al carrito | `snipplets/product/product-form.tpl` (línea 218-227) |
| Calculadora de envío | `snipplets/shipping/shipping-calculator.tpl` |
| Descripción | `snipplets/product/product-description.tpl` |
| Productos relacionados | `snipplets/product/product-related.tpl` |
| Social share | `snipplets/social/social-share.tpl` |
| Etiquetas (oferta, envío) | `snipplets/labels.tpl` |
| Estilos de la PDP | `static/css/style-critical.scss` (L:2077+) |
| JS del slider | `static/js/store.js.tpl` (L:2680+) |
| JS de variantes | `static/js/store.js.tpl` (L:2314+) |
| Settings del admin | `config/settings.txt` (L:1345+) |
