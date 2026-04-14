# Documentación: Fecha Estimada de Entrega en el Carrito

## 📋 Descripción General

Esta funcionalidad muestra de forma dinámica la fecha estimada de llegada del pedido dentro del carrito de compras. El cálculo se basa en días hábiles (lunes a viernes) y considera el horario de corte para determinar desde qué día comenzar a contar.

## 🎯 Objetivo

Proporcionar información clara y transparente a los clientes sobre cuándo recibirán su pedido, mejorando la experiencia de usuario y reduciendo consultas sobre tiempos de entrega.

## 📍 Ubicaciones Posibles para el Snippet

El snippet `cart-delivery-date.tpl` puede ser incluido en varios archivos del carrito dependiendo de dónde se desee mostrar la información. A continuación se listan todas las opciones disponibles:

### ✅ Opciones Recomendadas

#### 1. **`snipplets/cart-totals.tpl`** ⭐ (Implementación Actual)
- **Ubicación**: `/snipplets/cart-totals.tpl`
- **Líneas donde incluir**: 
  - Línea 90: Después de promociones en cart popup
  - Línea 156: Después de promociones en cart page
- **Ventajas**:
  - ✅ Se muestra tanto en popup como en página del carrito
  - ✅ Ubicación lógica (después de subtotal/promociones, antes del total)
  - ✅ Ya está implementado y funcionando
  - ✅ Contexto perfecto: información de entrega junto a totales
- **Desventajas**: Ninguna significativa
- **Uso**: `{% include "snipplets/cart-delivery-date.tpl" %}`

#### 2. **`snipplets/cart-panel.tpl`**
- **Ubicación**: `/snipplets/cart-panel.tpl`
- **Líneas donde incluir**:
  - Línea 8: Después de la lista de productos, antes del mensaje de carrito vacío
  - Línea 17: Después del mensaje de error de stock, antes de cart-totals
  - Línea 19: Dentro del contenedor `cart-row`, antes o después de cart-totals
- **Ventajas**:
  - ✅ Se muestra en el carrito popup (modal lateral)
  - ✅ Más visible para el usuario
  - ✅ Puede colocarse antes de los totales
- **Desventajas**:
  - ⚠️ Solo aparece en popup, no en página del carrito
  - ⚠️ Necesitaría duplicar en `templates/cart.tpl` para página completa
- **Uso**: `{% include "snipplets/cart-delivery-date.tpl" %}`

#### 3. **`templates/cart.tpl`**
- **Ubicación**: `/templates/cart.tpl`
- **Líneas donde incluir**:
  - Línea 54: Después de la lista de items, antes del row de shipping/totals
  - Línea 55: Dentro del row, en la columna de shipping o totals
  - Línea 59: Dentro de la columna de totals, antes o después de cart-totals
- **Ventajas**:
  - ✅ Control total sobre la ubicación en la página del carrito
  - ✅ Puede colocarse en layout específico de la página
- **Desventajas**:
  - ⚠️ Solo aparece en página del carrito, no en popup
  - ⚠️ Necesitaría duplicar en `cart-panel.tpl` para popup
- **Uso**: `{% include "snipplets/cart-delivery-date.tpl" %}`

### ⚠️ Opciones Alternativas (Menos Recomendadas)

#### 4. **`snipplets/shipping/cart-fulfillment.tpl`**
- **Ubicación**: `/snipplets/shipping/cart-fulfillment.tpl`
- **Líneas donde incluir**:
  - Línea 7: Dentro del contenedor `cart-fulfillment-info`
  - Línea 21: Dentro del contenedor `cart-shipping-container`
  - Línea 38: Al final del contenedor, después de shipping calculator
- **Ventajas**:
  - ✅ Contexto relacionado con envío
  - ✅ Se muestra junto a información de shipping
- **Desventajas**:
  - ⚠️ Solo se muestra si `show_cart_fulfillment` es true
  - ⚠️ Puede no aparecer si no hay shipping configurado
  - ⚠️ Menos visible para el usuario
- **Uso**: `{% include "snipplets/cart-delivery-date.tpl" %}`

#### 5. **`snipplets/cart-item-ajax.tpl`**
- **Ubicación**: `/snipplets/cart-item-ajax.tpl`
- **Líneas donde incluir**:
  - Al final del archivo, después de cada item
- **Ventajas**: Ninguna significativa
- **Desventajas**:
  - ❌ Se repetiría en cada item del carrito
  - ❌ No es la ubicación lógica para esta información
  - ❌ Generaría duplicación innecesaria
- **Uso**: No recomendado

### 📊 Comparativa de Ubicaciones

| Archivo | Popup | Página | Ubicación Lógica | Recomendación |
|---------|-------|--------|------------------|---------------|
| `cart-totals.tpl` | ✅ | ✅ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| `cart-panel.tpl` | ✅ | ❌ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| `templates/cart.tpl` | ❌ | ✅ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| `cart-fulfillment.tpl` | ✅ | ✅ | ⭐⭐⭐ | ⭐⭐⭐ |
| `cart-item-ajax.tpl` | ✅ | ✅ | ⭐ | ❌ |

### 💡 Recomendación Final

**La implementación actual en `cart-totals.tpl` es la opción más recomendada** porque:
1. Funciona en ambos contextos (popup y página)
2. Ubicación lógica junto a totales
3. No requiere duplicación de código
4. Mantiene consistencia visual
5. Fácil de mantener

Si se desea cambiar la ubicación, se recomienda:
- Para más visibilidad: `cart-panel.tpl` (línea 17)
- Para contexto de envío: `cart-fulfillment.tpl` (línea 38)
- Para control total: `templates/cart.tpl` (línea 59)

## 📁 Archivos Involucrados

### Archivos Creados

1. **`snipplets/cart-delivery-date.tpl`**
   - Snippet independiente que contiene el HTML y JavaScript para calcular y mostrar la fecha estimada
   - Ubicación: `/snipplets/cart-delivery-date.tpl`

### Archivos Modificados

1. **`snipplets/cart-totals.tpl`**
   - Se agregó la inclusión del snippet en dos ubicaciones:
     - **Línea 90**: Para el carrito popup (modal lateral)
     - **Línea 156**: Para la página del carrito

## 🔧 Funcionalidad Técnica

### Configuración

```javascript
var BUSINESS_DAYS = 5;        // Días hábiles totales (preparado + entrega)
var CUTOFF_HOUR = 12;          // Hora de corte (mediodía)
```

### Lógica de Cálculo

1. **Fecha Base**
   - Se obtiene la fecha y hora actual del cliente
   - Si la hora actual es >= 12:00 (mediodía), se comienza a contar desde el día siguiente
   - Si es antes de mediodía, se cuenta desde el día actual

2. **Cálculo de Días Hábiles**
   - Se cuentan solo días hábiles (lunes a viernes)
   - Se excluyen sábados (día 6) y domingos (día 0)
   - Se suman 5 días hábiles desde la fecha base

3. **Formato de Fecha**
   - La fecha se formatea en español con el siguiente formato:
   - `"día de la semana, día de mes de año"`
   - Ejemplo: `"viernes, 15 de marzo"`

### Ejemplos de Cálculo

#### Ejemplo 1: Antes del mediodía
- **Fecha actual**: Lunes 10 de marzo, 10:00 AM
- **Fecha base**: Lunes 10 de marzo (antes de mediodía)
- **Cálculo**: +5 días hábiles
- **Resultado**: Lunes 17 de marzo

#### Ejemplo 2: Después del mediodía
- **Fecha actual**: Lunes 10 de marzo, 14:00 PM
- **Fecha base**: Martes 11 de marzo (después de mediodía, cuenta desde mañana)
- **Cálculo**: +5 días hábiles
- **Resultado**: Martes 18 de marzo

#### Ejemplo 3: Cae en fin de semana
- **Fecha actual**: Jueves 13 de marzo, 10:00 AM
- **Fecha base**: Jueves 13 de marzo
- **Cálculo**: +5 días hábiles
- **Resultado**: Jueves 20 de marzo (se salta sábado y domingo automáticamente)

## 🎨 Estructura HTML

```html
<div class="js-visible-on-cart-filled js-cart-delivery-date mb-2" 
     {% if cart.items_count == 0 %}style="display:none;"{% endif %}>
    <div class="font-small text-secondary">
        <span>
            {{ "Tu pedido llegará el" | translate }} 
            <strong class="js-delivery-date text-accent">...</strong>
        </span>
    </div>
</div>
```

### Clases CSS Utilizadas

- `js-visible-on-cart-filled`: Clase estándar del tema para mostrar elementos solo cuando hay productos
- `js-cart-delivery-date`: Clase específica del contenedor de fecha
- `js-delivery-date`: Clase para el elemento que muestra la fecha calculada
- `font-small`: Tamaño de fuente pequeño
- `text-secondary`: Color de texto secundario
- `text-accent`: Color de acento para destacar la fecha

## 💻 Implementación JavaScript

### Funciones Principales

#### `calculateDeliveryDate()`
Calcula la fecha de entrega estimada basándose en:
- Fecha y hora actual
- Horario de corte (mediodía)
- Días hábiles requeridos (5 días)

#### `formatDate(date)`
Formatea la fecha en español con:
- Nombre del día de la semana
- Día del mes
- Nombre del mes

#### `updateDate()`
Actualiza el DOM con la fecha calculada:
- Verifica si hay productos en el carrito
- Calcula y formatea la fecha
- Actualiza el elemento en el DOM

### Observador de Cambios

El código utiliza `MutationObserver` para detectar cambios en el carrito:

```javascript
var observer = new MutationObserver(function() {
    setTimeout(updateDate, 100);
});
observer.observe(cartList, { childList: true, subtree: true });
```

Esto asegura que la fecha se actualice automáticamente cuando:
- Se agregan productos al carrito
- Se eliminan productos del carrito
- Se actualiza la cantidad de productos

## 📍 Ubicación en el Carrito

### Carrito Popup (Modal Lateral)

El snippet se muestra después de las promociones y antes del total:

```
┌─────────────────────────┐
│ Carrito de compras      │
├─────────────────────────┤
│ [Productos...]          │
├─────────────────────────┤
│ Subtotal: $XXX         │
│ Promociones: -$XX      │
│                         │
│ Tu pedido llegará el    │ ← AQUÍ
│ viernes, 15 de marzo   │
│                         │
│ Total: $XXX             │
│ [Iniciar Compra]        │
└─────────────────────────┘
```

### Página del Carrito

Misma ubicación relativa, después de promociones y antes del total.

## 🔄 Integración con el Sistema

### Compatibilidad

- ✅ Compatible con actualizaciones AJAX del carrito
- ✅ Funciona en carrito popup (modal lateral)
- ✅ Funciona en página del carrito
- ✅ Responsive (móvil y desktop)
- ✅ No interfiere con otros componentes

### Dependencias

- **Ninguna dependencia externa**: El código es completamente independiente
- **JavaScript vanilla**: No requiere jQuery ni otras librerías
- **MutationObserver API**: Navegadores modernos (IE11+)

## 🛠️ Personalización

### Cambiar Días Hábiles

Para modificar los días hábiles, edita la variable en `cart-delivery-date.tpl`:

```javascript
var BUSINESS_DAYS = 5;  // Cambiar a otro número
```

### Cambiar Horario de Corte

Para modificar el horario de corte, edita la variable:

```javascript
var CUTOFF_HOUR = 12;  // Cambiar a otra hora (0-23)
```

### Cambiar Texto del Mensaje

Edita el texto en la sección HTML del snippet:

```liquid
{{ "Tu pedido llegará el" | translate }}
```

O modifica directamente el texto sin usar translate:

```html
<span>Tu pedido llegará el <strong class="js-delivery-date text-accent">...</strong></span>
```

### Cambiar Estilo

Puedes agregar estilos personalizados modificando las clases CSS o agregando estilos inline:

```html
<div class="js-visible-on-cart-filled js-cart-delivery-date mb-2" 
     style="background-color: #f0f0f0; padding: 10px; border-radius: 5px;">
```

## 🧪 Testing

### Casos de Prueba

1. **Carrito vacío**: El mensaje no debe mostrarse
2. **Carrito con productos**: El mensaje debe mostrarse con fecha calculada
3. **Agregar producto**: La fecha debe actualizarse automáticamente
4. **Eliminar producto**: Si queda vacío, el mensaje debe ocultarse
5. **Diferentes horarios**: Probar antes y después de mediodía
6. **Fin de semana**: Verificar que se salten sábados y domingos

### Verificación Manual

1. Abrir el carrito con productos
2. Verificar que aparece el mensaje "Tu pedido llegará el [fecha]"
3. Verificar que la fecha es correcta (5 días hábiles desde hoy o mañana según hora)
4. Agregar/eliminar productos y verificar que se actualiza
5. Probar en móvil y desktop

## 📝 Notas Importantes

### Consideraciones

- ⚠️ **Zona horaria**: La fecha se calcula basándose en la zona horaria del cliente
- ⚠️ **Días festivos**: El sistema NO considera días festivos, solo sábados y domingos
- ⚠️ **Actualización**: La fecha se actualiza automáticamente cuando cambia el carrito

### Limitaciones

- No considera días festivos nacionales o regionales
- No diferencia entre diferentes métodos de envío
- No considera stock o disponibilidad de productos

## 🔮 Posibles Mejoras Futuras

1. **Configuración desde Admin**: Permitir configurar días hábiles desde el panel de administración
2. **Días festivos**: Agregar soporte para excluir días festivos
3. **Diferentes tiempos por método de envío**: Calcular según el método seleccionado
4. **Rango de fechas**: Mostrar un rango en lugar de fecha exacta
5. **Considerar stock**: Ajustar fecha según disponibilidad de productos

## 📞 Soporte

Para modificar o personalizar esta funcionalidad:

1. Editar `snipplets/cart-delivery-date.tpl` para cambios en lógica o diseño
2. Editar `snipplets/cart-totals.tpl` para cambiar la ubicación del snippet
3. Verificar que los cambios no afecten otros componentes del carrito

## 📅 Historial de Versiones

- **v1.0** (Fecha de creación): Implementación inicial
  - Cálculo de 5 días hábiles
  - Horario de corte a mediodía
  - Integración con carrito popup y página del carrito
  - Auto-actualización con MutationObserver

---

**Última actualización**: [Fecha de creación del documento]


