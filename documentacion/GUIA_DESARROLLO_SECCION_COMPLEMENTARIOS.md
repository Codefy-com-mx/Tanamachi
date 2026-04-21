# 🛠️ Guía de Desarrollo: Sección de Productos Complementarios Custom

Esta documentación detalla la implementación de una sección personalizada para mostrar productos complementarios (`complementary_product_list`) en la Página de Detalle de Producto (PDP), permitiendo una interacción directa con el sistema de **Quickshop** (Compra Rápida).

---

## 1. Conceptos Fundamentales

### ¿Qué es `complementary_product_list`?
Es una variable global disponible en el objeto `product` de Tiendanube. Contiene un arreglo (array) de objetos tipo producto que el administrador ha vinculado manualmente desde el panel de control bajo la lógica de "Productos para ofrecer juntos".

### Objetivos de la Sección:
- **Renderizado Condicional**: La sección se autodestruye visualmente si no hay productos vinculados.
- **Acceso Profundo**: Control total sobre el HTML para mostrar más información que un simple carrusel.
- **Interacción Nativa**: Integración con el carrito AJAX y el modal de variaciones sin escribir JS adicional.

---

## 2. Arquitectura de Implementación

### Estructura de Archivos
| Función | Ruta |
|---|---|
| **Lógica de la Sección** | `snipplets/product/complementary-custom.tpl` |
| **Inclusión en PDP** | `templates/product.tpl` |
| **Estilos Visuales** | `static/css/style-new-section.scss` |

---

## 3. Desarrollo Técnico (Código)

### Lógica Condicionada y Loop
La sección debe estar envuelta en una validación de longitud para evitar inyectar HTML vacío en el DOM.

```twig
{% if complementary_product_list | length > 0 %}
    {# Renderizado de la sección #}
{% endif %}
```

### Integración con el Sistema de Compra (Quickshop)
Para que los botones de "Agregar" funcionen con el sistema AJAX de la tienda, es obligatorio usar las clases y atributos de datos que los scripts globales (`store.js.tpl`) están escuchando:

1.  **Contenedor Padre**: Debe tener la clase `js-product-container` y `js-quickshop-container`.
2.  **Atributos de Datos**: 
    - `data-product-id="{{ item.id }}"`
    - `data-variants="{{ item.variants_object | json_encode }}"`
3.  **Botones de Acción**:
    - Para productos con variantes: Clase `js-quickshop-modal-open`.
    - Para productos sin variantes: Clase `js-addtocart`.

---

## 4. Snipplet de Implementación (Propuesta Final)

Este código debe colocarse en `snipplets/product/complementary-custom.tpl`:

```twig
{% if complementary_product_list | length > 0 %}
<section id="custom-complementary" class="section-complementary-custom py-5">
    <div class="container">
        <h2 class="h3 text-center mb-5 font-weight-bold">Completa tu pedido</h2>
        <div class="row justify-content-center">
            {% for item in complementary_product_list %}
                <div class="col-6 col-md-3 mb-4 text-center">
                    <div class="card-complementary h-100 js-product-container js-quickshop-container" 
                         data-product-id="{{ item.id }}" 
                         data-variants="{{ item.variants_object | json_encode }}">
                        
                        {# Imagen #}
                        <div class="mb-3">
                            <a href="{{ item.url }}">
                                <img src="{{ item.featured_image | product_image_url('medium') }}" 
                                     alt="{{ item.name }}" 
                                     class="img-fluid">
                            </a>
                        </div>

                        {# Info #}
                        <h4 class="h6 mb-2">{{ item.name }}</h4>
                        <div class="mb-3">
                            <span class="font-weight-bold text-primary">{{ item.price | money }}</span>
                            {% if item.compare_at_price > item.price %}
                                <small class="text-muted"><del>{{ item.compare_at_price | money }}</del></small>
                            {% endif %}
                        </div>

                        {# Botón #}
                        <div class="actions">
                            {% if item.available %}
                                {% if item.variations %}
                                    <button class="js-quickshop-modal-open js-modal-open btn btn-outline-dark btn-sm w-100" 
                                            data-toggle="#quickshop-modal" 
                                            data-modal-url="modal-fullscreen-quickshop"
                                            data-component="product-list-item.add-to-cart" 
                                            data-component-value="{{ item.id }}">
                                        Elegir opciones
                                    </button>
                                {% else %}
                                    <form class="js-product-form" method="post" action="{{ store.cart_url }}">
                                        <input type="hidden" name="add_to_cart" value="{{ item.id }}" />
                                        <button type="submit" class="js-addtocart js-prod-submit-form btn btn-dark btn-sm w-100">
                                            Agregar
                                        </button>
                                    </form>
                                {% endif %}
                            {% else %}
                                <span class="badge badge-secondary">Sin Stock</span>
                            {% endif %}
                        </div>
                    </div>
                </div>
            {% endfor %}
        </div>
    </div>
</section>
{% endif %}
```

---

## 5. Implementación en el Tema

1. **Vincular en PDP**: Abrir `templates/product.tpl` y añadir al final:
   `{% include 'snipplets/product/complementary-custom.tpl' %}`

2. **Estilos SCSS**: Añadir en `static/css/style-new-section.scss` para un acabado elegante.
