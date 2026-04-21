# 🚀 Guía Técnica: Migración de Secciones de Home a Landing Modular

Esta guía detalla el proceso para replicar una funcionalidad o sección existente en el Home (ej. Banners, Carruseles, Newsletter) dentro de una **Landing Modular** (como la de XV Años), evitando conflictos de variables y errores de visualización.

---

## 🏗️ La Estructura de Trabajo
Para que la landing sea independiente, cada sección migrada debe seguir este esquema de aislamiento:

1.  **Aislamiento de Código**: Copiar el `.tpl` del home a `snipplets/landing/[namespace]/`.
2.  **Namespace de Variables**: Renombrar cada `settings.variable` a `settings.landing_[namespace]_variable`.
3.  **Configuración Espejo**: Replicar los controles en `settings.txt` y `defaults.txt`.

---

## 🛠️ Paso a Paso: El Proceso Relámpago

### 1. Crear el Componente en la Landing
Si quieres migrar "Banners de Categorías" a la landing XV:
*   **Origen**: `snipplets/home/home-banners.tpl`
*   **Destino**: `snipplets/landing/xv/landing-xv-banners.tpl`

**⚠️ CRÍTICO**: Dentro del nuevo archivo, busca todos los `settings.XXX` y cámbialos por el namespace. 
*   Ejemplo: `settings.banner_columns_desktop` → `settings.landing_xv_banner_columns_desktop`.

### 2. Registrar en `config/settings.txt`
Debes añadir la sección al `section_order` de la landing y crear su bloque de configuración.

```txt
# En el section_order de la landing
sections
    ...
    landing_xv_banners = Banners de Campaña  # <--- Este nombre es el LINK

# El bloque de configuración
collapse
    title = Banners de Campaña  # <--- DEBE SER IDÉNTICO AL NOMBRE DE ARRIBA
    backto = landing_xv_order_position
checkbox
    name = landing_xv_banners_show
    description = Mostrar sección
... (resto de campos con namespace)
```

### 3. Definir Valores en `config/defaults.txt`
Toda variable nueva **REQUIERE** un valor inicial, especialmente la posición en el orden.

```txt
landing_xv_order_position_2 = landing_xv_banners
landing_xv_banners_show = 1
landing_xv_banners_columns_desktop = 3
```

### 4. Actualizar el "Director de Orquesta" (Switch)
Abre `snipplets/landing/landing-[namespace]-section-switch.tpl` y añade el nuevo caso:

```twig
{% elseif section_select == 'landing_xv_banners' %}
    {% if settings.landing_xv_banners_show %}
        {% include 'snipplets/landing/xv/landing-xv-banners.tpl' %}
    {% endif %}
```

---

## ⚠️ Checklist de "Errores de la Muerte" (Evitá estos!)

### ❌ Error 1: "Hago clic en la sección y no abre nada" (Title Mismatch)
**Causa**: El nombre en la lista de `sections` no coincide letra por letra con el `title` del `collapse`.
*   **Mal**: `landing_xv_featured = Productos` y `title = Productos Destacados`
*   **Bien**: `landing_xv_featured = Productos Destacados` y `title = Productos Destacados`

### ❌ Error 2: "La sección no aparece en el listado del admin"
**Causa**: Falta definir la posición en `defaults.txt`.
*   Asegúrate de tener `landing_xv_order_position_X = nombre_seccion` para cada número en el orden.

### ❌ Error 3: "Los carruseles (Swiper/Embla) no se mueven"
**Causa**: En Tiendanube, los carruseles se inicializan globalmente solo para el Home. 
*   **Solución**: Debes incluir un bloque `<script>` al final de tu archivo `.tpl` de la landing que ejecute la inicialización usando **`window.addEventListener('load')`** (ver Error 6 abajo).

### ❌ Error 4: "Filtros de Tags no funcionan"
**Causa**: Las etiquetas en Tiendanube a veces traen espacios invisibles.
*   **Mejor práctica**: Usa siempre el filtro `trim` al comparar: 
    `{% if tag | trim == settings.mi_tag_config | trim %}`

### ❌ Error 5: "Variables compartidas (Namespace)"
**Causa**: Si usas `settings.show_banner` sin prefijo, cuando el usuario desactive el banner del Home, se desactivará también en la Landing.
*   **Regla de Oro**: Si está en la carpeta de landing, **DEBE** tener prefijo de landing.

---

> ### 🚨🚨🚨 Error 6: "EL PERSONALIZADOR OCULTA LA ÚLTIMA SECCIÓN" 🚨🚨🚨
>
> **Problema Real Detectado:** El rango del loop en `page.tpl` (`1..N`) DEBE ser SIEMPRE mayor que el número de secciones registradas. Si tienes 10 secciones y el loop va hasta `1..10`, el personalizador de Tiendanube al reordenar puede empujar la última sección a una posición mayor, y el loop NUNCA la alcanzará. La sección simplemente desaparece.
>
> **Regla de Oro:** El rango del loop = **Número de secciones + 5 slots de respaldo**. Además, declara las posiciones sobrantes como `empty` en `defaults.txt`:
> ```txt
> landing_xv_order_position_11 = empty
> landing_xv_order_position_12 = empty
> ...
> landing_xv_order_position_15 = empty
> ```

---

> ### 🚨🚨🚨 Error 7: "DOS CARRUSELES NO PUEDEN CONVIVIR (Race Condition)" 🚨🚨🚨
>
> **Problema Real Detectado:** Si dos secciones con carrusel (ej. una con Embla y otra con Swiper) usan `setTimeout` para esperar a que sus librerías carguen, generan una **condición de carrera**. Los timeouts se acumulan y se bloquean mutuamente.
>
> **Causa Raíz:** En `layout.tpl`, los scripts inline de la landing se ejecutan ANTES de que Swiper y EmblaCarousel estén definidos. Cuando hay 2+ secciones haciendo polling simultáneo con `setTimeout`, compiten por el Event Loop.
>
> **NUNCA hagas esto:**
> ```javascript
> // ❌ INCORRECTO
> function init() {
>     if (typeof createSwiper !== 'undefined') { /* ... */ }
>     else { setTimeout(init, 500); }
> }
> ```
>
> **SIEMPRE usa esto:**
> ```javascript
> // ✅ CORRECTO
> window.addEventListener('load', function() {
>     (function() {
>         createSwiper('.js-swiper-mi-seccion', { /* config */ });
>     })();
> });
> ```

---

## 💡 Pro Tip: ¿Cómo saber qué código copiar?
Mira el archivo `snipplets/home/home-section-switch.tpl`. Ahí están todos los llamados a las secciones originales del Home (`include`). Puedes abrir esos archivos para usarlos de base (Template) para tus nuevas versiones modulares.
