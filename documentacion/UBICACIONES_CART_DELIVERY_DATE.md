# 📍 Ubicaciones para Renderizar `cart-delivery-date.tpl`

Este documento detalla todas las ubicaciones posibles donde se puede incluir el snippet `cart-delivery-date.tpl` en el carrito de compras.

## 🎯 Ubicaciones Recomendadas

### 1. ⭐ `snipplets/cart-totals.tpl` (RECOMENDADO - Implementación Actual)

**Ubicación**: `/snipplets/cart-totals.tpl`

**Ventajas**:
- ✅ Se muestra tanto en popup como en página del carrito
- ✅ Ubicación lógica (después de subtotal/promociones, antes del total)
- ✅ Contexto perfecto: información de entrega junto a totales
- ✅ No requiere duplicación de código

**Ubicaciones específicas**:

#### Opción A: Después de promociones en popup (Línea ~90)
```liquid
{% if not cart_page %}
  {# ... código de promociones ... #}
  {% endfor %}
</div>
{% endif %}

{# INCLUIR AQUÍ para popup #}
{% include "snipplets/cart-delivery-date.tpl" %}

{% if cart_page %}
```

#### Opción B: Después de promociones en página (Línea ~156)
```liquid
{% if cart_page %}
  {# ... código de promociones ... #}
  {% endfor %}
</div>

{# INCLUIR AQUÍ para página del carrito #}
{% include "snipplets/cart-delivery-date.tpl" %}

{# Cart page shipping costs #}
```

#### Opción C: Después de shipping costs (Línea ~167)
```liquid
{% if show_calculator_on_cart %}
  {# ... shipping costs ... #}
  </div>
{% endif %}

{# INCLUIR AQUÍ después de shipping #}
{% include "snipplets/cart-delivery-date.tpl" %}
{% else %}
```

#### Opción D: Antes del total (Línea ~175)
```liquid
{% endif %}
  
{# INCLUIR AQUÍ antes del total #}
{% include "snipplets/cart-delivery-date.tpl" %}

{# Cart page and popup total #}
<div class="js-cart-total-container js-visible-on-cart-filled" ...>
```

**Resultado visual**:
```
┌─────────────────────────┐
│ Subtotal: $XXX         │
│ Promociones: -$XX      │
│                         │
│ Tu pedido llegará el    │ ← AQUÍ
│ viernes, 15 de marzo   │
│                         │
│ Total: $XXX             │
└─────────────────────────┘
```

---

### 2. `snipplets/cart-panel.tpl`

**Ubicación**: `/snipplets/cart-panel.tpl`

**Ventajas**:
- ✅ Se muestra en el carrito popup (modal lateral)
- ✅ Más visible para el usuario
- ✅ Puede colocarse antes de los totales

**Desventajas**:
- ⚠️ Solo aparece en popup, no en página del carrito
- ⚠️ Necesitaría duplicar en `templates/cart.tpl` para página completa

**Ubicaciones específicas**:

#### Opción A: Después de la lista de productos (Línea ~8)
```liquid
<div class="js-ajax-cart-list">
    {# Cart panel items #}
    {% if cart.items %}
      {% for item in cart.items %}
        {% include "snipplets/cart-item-ajax.tpl" %}
      {% endfor %}
    {% endif %}
</div>

{# INCLUIR AQUÍ después de productos #}
{% include "snipplets/cart-delivery-date.tpl" %}

<div class="js-empty-ajax-cart" ...>
```

#### Opción B: Después del mensaje de error de stock (Línea ~17)
```liquid
<div id="error-ajax-stock" style="display: none;">
	<div class="alert alert-warning m-3">
     	{{ "¡Uy! No tenemos más stock..." | translate }}
    </div>
</div>

{# INCLUIR AQUÍ después de error de stock #}
{% include "snipplets/cart-delivery-date.tpl" %}

<div class="cart-row mt-4">
```

#### Opción C: Dentro del contenedor cart-row, antes de totals (Línea ~19)
```liquid
<div class="cart-row mt-4">
    {# INCLUIR AQUÍ antes de totals #}
    {% include "snipplets/cart-delivery-date.tpl" %}
    
    {% include "snipplets/cart-totals.tpl" %}
</div>
```

**Resultado visual**:
```
┌─────────────────────────┐
│ [Productos...]          │
├─────────────────────────┤
│ Tu pedido llegará el    │ ← AQUÍ
│ viernes, 15 de marzo   │
├─────────────────────────┤
│ Subtotal: $XXX         │
│ Total: $XXX             │
└─────────────────────────┘
```

---

### 3. `templates/cart.tpl`

**Ubicación**: `/templates/cart.tpl`

**Ventajas**:
- ✅ Control total sobre la ubicación en la página del carrito
- ✅ Puede colocarse en layout específico de la página

**Desventajas**:
- ⚠️ Solo aparece en página del carrito, no en popup
- ⚠️ Necesitaría duplicar en `cart-panel.tpl` para popup

**Ubicaciones específicas**:

#### Opción A: Después de la lista de items (Línea ~54)
```liquid
<div class="js-ajax-cart-list">
    {# Cart items #}
    {% if cart.items %}
      {% for item in cart.items %}
        {% include "snipplets/cart-item-ajax.tpl" with {'cart_page': true} %}
      {% endfor %}
    {% endif %}
</div>

{# INCLUIR AQUÍ después de items #}
{% include "snipplets/cart-delivery-date.tpl" %}

<div class="row justify-content-between mt-4">
```

#### Opción B: Dentro del row, en la columna de shipping (Línea ~55-57)
```liquid
<div class="row justify-content-between mt-4">
    <div class="col-md-4">
        {% include "snipplets/shipping/cart-fulfillment.tpl" with {'cart_page': true} %}
        
        {# INCLUIR AQUÍ en columna de shipping #}
        {% include "snipplets/cart-delivery-date.tpl" %}
    </div>
    <div class="col-md-4">
        {% include "snipplets/cart-totals.tpl" with {'cart_page': true} %}
    </div>
</div>
```

#### Opción C: Dentro del row, en la columna de totals (Línea ~59-60)
```liquid
<div class="row justify-content-between mt-4">
    <div class="col-md-4">
        {% include "snipplets/shipping/cart-fulfillment.tpl" with {'cart_page': true} %}
    </div>
    <div class="col-md-4">
        {# INCLUIR AQUÍ en columna de totals, antes de cart-totals #}
        {% include "snipplets/cart-delivery-date.tpl" %}
        
        {% include "snipplets/cart-totals.tpl" with {'cart_page': true} %}
    </div>
</div>
```

#### Opción D: Después de cart-totals (Línea ~60)
```liquid
<div class="col-md-4">
    {% include "snipplets/cart-totals.tpl" with {'cart_page': true} %}
    
    {# INCLUIR AQUÍ después de totals #}
    {% include "snipplets/cart-delivery-date.tpl" %}
</div>
```

**Resultado visual**:
```
┌─────────────────────────────────────┐
│ [Productos...]                      │
├──────────────────┬──────────────────┤
│ Shipping Info    │ Subtotal: $XXX   │
│                  │ Promociones: -$XX│
│                  │                  │
│                  │ Tu pedido llegará│ ← AQUÍ
│                  │ viernes, 15 mar  │
│                  │                  │
│                  │ Total: $XXX       │
└──────────────────┴──────────────────┘
```

---

## ⚠️ Ubicaciones Alternativas (Menos Recomendadas)

### 4. `snipplets/shipping/cart-fulfillment.tpl`

**Ubicación**: `/snipplets/shipping/cart-fulfillment.tpl`

**Ventajas**:
- ✅ Contexto relacionado con envío
- ✅ Se muestra junto a información de shipping

**Desventajas**:
- ⚠️ Solo se muestra si `show_cart_fulfillment` es true
- ⚠️ Puede no aparecer si no hay shipping configurado
- ⚠️ Menos visible para el usuario

**Ubicaciones específicas**:

#### Opción A: Dentro del contenedor cart-fulfillment-info (Línea ~7)
```liquid
{% if show_cart_fulfillment %}
  <div class="js-fulfillment-info ... cart-fulfillment-info ...">
    {# INCLUIR AQUÍ al inicio del contenedor #}
    {% include "snipplets/cart-delivery-date.tpl" %}
    
    <div class="js-visible-on-cart-filled js-has-new-shipping ...">
```

#### Opción B: Dentro del contenedor cart-shipping-container (Línea ~21)
```liquid
<div id="cart-shipping-container" ...>
  {# INCLUIR AQUÍ dentro del contenedor de shipping #}
  {% include "snipplets/cart-delivery-date.tpl" %}
  
  {# Used to save shipping #}
  <span id="cart-selected-shipping-method" ...>
```

#### Opción C: Al final del contenedor (Línea ~38)
```liquid
        {% if store.branches %}
          {% include "snipplets/shipping/branches.tpl" with {'product_detail': false} %}
        {% endif %}
      </div>
      
      {# INCLUIR AQUÍ al final, después de shipping calculator #}
      {% include "snipplets/cart-delivery-date.tpl" %}
    </div>
  </div>
{% endif %}
```

---

### 5. ❌ `snipplets/cart-item-ajax.tpl` (NO RECOMENDADO)

**Ubicación**: `/snipplets/cart-item-ajax.tpl`

**Desventajas**:
- ❌ Se repetiría en cada item del carrito
- ❌ No es la ubicación lógica para esta información
- ❌ Generaría duplicación innecesaria

**Ubicación posible** (NO RECOMENDADA):
```liquid
  {% endif %}
</div>

{# NO RECOMENDADO: Se repetiría en cada item #}
{% include "snipplets/cart-delivery-date.tpl" %}
```

---

## 📊 Comparativa de Ubicaciones

| Archivo | Popup | Página | Ubicación Lógica | Visibilidad | Recomendación |
|---------|-------|--------|------------------|-------------|---------------|
| `cart-totals.tpl` | ✅ | ✅ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| `cart-panel.tpl` | ✅ | ❌ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| `templates/cart.tpl` | ❌ | ✅ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| `cart-fulfillment.tpl` | ✅ | ✅ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| `cart-item-ajax.tpl` | ✅ | ✅ | ⭐ | ⭐⭐ | ❌ |

---

## 💡 Recomendación Final

### Implementación Recomendada: `cart-totals.tpl`

**La mejor opción es incluir el snippet en `cart-totals.tpl`** porque:

1. ✅ Funciona en ambos contextos (popup y página)
2. ✅ Ubicación lógica junto a totales
3. ✅ No requiere duplicación de código
4. ✅ Mantiene consistencia visual
5. ✅ Fácil de mantener

**Ubicación específica recomendada**:

```liquid
{# En cart-totals.tpl, después de promociones #}

{% if not cart_page %}
  {# Cart popup promos #}
  <div class="js-total-promotions text-accent">
    {# ... código de promociones ... #}
  </div>
{% endif %}

{# INCLUIR AQUÍ para popup #}
{% if not cart_page %}
  {% include "snipplets/cart-delivery-date.tpl" %}
{% endif %}

{% if cart_page %}
  {# Cart page subtotal #}
  {# ... código ... #}
  
  {# Cart page promos #}
  <div class="js-total-promotions text-accent">
    {# ... código de promociones ... #}
  </div>
  
  {# INCLUIR AQUÍ para página del carrito #}
  {% include "snipplets/cart-delivery-date.tpl" %}
  
  {# Cart page shipping costs #}
{% endif %}
```

---

## 🔧 Cómo Implementar en Cada Ubicación

### Paso 1: Elegir la ubicación
Decide dónde quieres mostrar la fecha estimada según tus necesidades.

### Paso 2: Abrir el archivo
Abre el archivo correspondiente en tu editor.

### Paso 3: Agregar el include
Agrega la siguiente línea en la ubicación deseada:

```liquid
{% include "snipplets/cart-delivery-date.tpl" %}
```

### Paso 4: Verificar
- Guarda el archivo
- Recarga la página del carrito
- Verifica que la fecha se muestre correctamente
- Prueba en popup y página del carrito

---

## 🎨 Personalización por Ubicación

Si deseas diferentes estilos según la ubicación, puedes pasar variables al snippet:

```liquid
{% include "snipplets/cart-delivery-date.tpl" with {'location': 'totals'} %}
```

Y luego en el snippet usar:
```liquid
{% if location == 'totals' %}
  {# Estilos específicos para totals #}
{% endif %}
```

---

## 📝 Notas Importantes

- ⚠️ Si incluyes el snippet en múltiples ubicaciones, aparecerá múltiples veces
- ⚠️ El snippet ya tiene lógica para ocultarse cuando el carrito está vacío
- ⚠️ El JavaScript se ejecuta una vez, no importa cuántas veces se incluya el snippet
- ✅ El snippet es independiente y no interfiere con otros componentes

---

**Última actualización**: [Fecha actual]

