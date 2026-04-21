# 🚀 Propuesta: Botón de Compra Instanciado (Movilidad Total)

Este documento detalla cómo manipular el botón de "Agregar al Carrito" en el tema **Aguiar** de Tiendanube, permitiendo moverlo a cualquier rincón de la Product Detail Page (PDP) sin romper la lógica nativa (AJAX, variantes, stock).

---

## 🏗️ 1. Infraestructura Implementada

Para que el botón funcione en cualquier lugar, se ha expandido el alcance del **Scope del Formulario**. 

En el archivo `snipplets/product/product-form.tpl`, la etiqueta `<form>` ahora envuelve prácticamente toda la columna de información:

```twig
{# Abre antes de los precios y componentes #}
<form id="product_form" ...>
    <input type="hidden" name="add_to_cart" value="{{product.id}}" />

    {# Aquí vive el precio, variantes, cantidad, etc. #}
    <div class="product-pdp-wrapper"> ... </div>

    {# AQUÍ PUEDES INSTANCIAR EL BOTÓN #}
    
</form> {# Cierra al final del archivo #}
```

---

## 📋 2. El Bloque de Código a Mover

Si deseas reubicar el botón, debes mover este bloque completo para asegurar que la animación de "Agregando..." y las validaciones sigan funcionando:

```twig
<div class="js-buy-button-container {{ btn_container_classes }} {% if product.isSubscribable() %}mt-1{% endif %}">

    {# 1. Botón Real (Input Submit) #}
    <input type="submit" 
           class="js-addtocart js-prod-submit-form btn-add-to-cart btn btn-primary btn-big btn-block {{ state }}" 
           value="{{ texts[state] | translate }}" 
           {% if state == 'nostock' %}disabled{% endif %} 
           data-store="product-buy-button" 
           data-component="product.add-to-cart"/>

    {# 2. Botón de Carga (Placeholder invisible que aparece al hacer click) #}
    {% set adding_text = is_subscription_only_product ? ('our_components.subscriptions.buying_subscription_onetime' | tt) : ('Agregando' | translate) %}
    {% include 'snipplets/placeholders/button-placeholder.tpl' with {custom_class: "btn-big", adding_text: adding_text} %}

</div>
```

---

## 🛠️ 3. Opciones de Implementación Futura

### Opción A: Movimiento dentro de `product-form.tpl` (Recomendado)
Simplemente corta el bloque anterior y pégalo en cualquier parte del archivo. Como está dentro del `<form>`, funcionará automáticamente.

### Opción B: Botón en otra sección (Fuera del archivo)
Si necesitas el botón en un lugar totalmente diferente (ej. un sticky bar al pie de la página), debes usar el atributo HTML5 `form`:

1.  Copia el código del botón.
2.  Agrega el atributo `form="product_form"` al `<input type="submit">`.
3.  **Nota Crítica:** El JS nativo de Tiendanube usa `.closest('form')` para el AJAX. Si usas esta opción, podrías necesitar un pequeño script de "puente" que haga clic en el botón oculto original cuando presiones el nuevo.

### Opción C: Botón Espejo (Mirror Button)
Crea un botón puramente visual en cualquier parte:
```html
<button class="btn btn-primary" onclick="jQueryNuvem('.js-addtocart').click();">
    Comprar ahora
</button>
```
Este método disparará el botón original (aunque esté oculto o en otra sección) activando toda la lógica nativa del tema.

---

## ⚠️ Consideraciones de JS (store.js.tpl)

El funcionamiento depende de estas clases:
- `.js-addtocart`: Clase que el JS escucha para el evento `click`.
- `.js-addtocart-placeholder`: El bloque que se muestra mientras la petición AJAX está en curso.
- `.js-product-container`: El ancestro principal (`#single-product`) que ayuda al JS a recolectar los datos de variantes seleccionadas.

> [!TIP]
> Si el botón se mueve a un lugar muy alejado, asegúrate de que el usuario aún pueda ver los mensajes de error (ej: "Selecciona una variante") que suelen aparecer cerca del formulario original.
