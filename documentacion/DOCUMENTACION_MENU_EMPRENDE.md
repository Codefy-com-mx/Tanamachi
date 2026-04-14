# Documentación: Aplicación de Color y Cambio de Fuente en el Menú Principal de EMPRENDE

Este documento describe cómo se implementó la personalización del elemento "EMPRENDE" en el menú principal de navegación, aplicando un color rosa personalizado y la fuente "Patrick Hand" (handwritten).

---

## 📋 Objetivo

Personalizar visualmente el elemento "EMPRENDE" en el menú de navegación para destacarlo del resto de elementos del menú, aplicando:
- **Color**: Rosa personalizado (#ff6b9d)
- **Fuente**: Patrick Hand (handwritten/cursiva)
- **Tamaño**: 1.65em (65% más grande que el tamaño normal)
- **Peso**: 700 (negrita)
- **Hover**: Color más oscuro (#ff4d8a)

---

## 🔧 Archivos Modificados

La implementación requirió modificar **3 archivos principales**:

1. **`snipplets/navigation/navigation-nav-list.tpl`** - Detección y asignación de clases CSS
2. **`layouts/layout.tpl`** - Carga de Google Fonts y estilos inline
3. **`static/css/custom.css`** - Estilos CSS para desktop y móvil

---

## 📝 Implementación Detallada

### Paso 1: Detección del Elemento en el Template de Navegación

**Archivo:** `snipplets/navigation/navigation-nav-list.tpl`

Se agregó lógica para detectar cuando un elemento del menú es "EMPRENDE" y asignarle clases CSS específicas.

#### Código Implementado:

```6:6:snipplets/navigation/navigation-nav-list.tpl
{% set is_emprende = item.name | upper == 'EMPRENDE' or item.name | upper == 'EMPRENDA' or 'EMPRENDE' in (item.name | upper) %}
```

Esta línea detecta el elemento "EMPRENDE" considerando variaciones como:
- "EMPRENDE" (mayúsculas)
- "Emprende" (capitalizado)
- "EMPRENDA" (variante en portugués)
- Cualquier texto que contenga "EMPRENDE"

#### Aplicación de Clases CSS:

**Para elementos con subitems:**
```8:12:snipplets/navigation/navigation-nav-list.tpl
<li class="{% if megamenu %}js-desktop-nav-item js-item-subitems-desktop nav-item-desktop {% if not subitem %}js-nav-main-item nav-dropdown nav-main-item {% endif %}{% endif %} nav-item item-with-subitems {% if is_emprende %}nav-item-emprende{% endif %}" data-component="menu.item">
			{% if megamenu %}
			<div class="nav-item-container">
			{% endif %}
				<a class="{% if hamburger %}js-toggle-menu-panel align-items-center{% endif %} nav-list-link position-relative {{ item.current ? 'selected' : '' }} {% if is_emprende %}nav-link-emprende{% endif %}" href="{% if megamenu and item.url %}{{ item.url }}{% else %}#{% endif %}">{{ item.name }}
```

**Para elementos sin subitems:**
```72:74:snipplets/navigation/navigation-nav-list.tpl
{% set is_emprende = item.name | upper == 'EMPRENDE' or item.name | upper == 'EMPRENDA' or 'EMPRENDE' in (item.name | upper) %}
		<li class="js-desktop-nav-item {% if megamenu %}{% if not subitem %}js-nav-main-item nav-main-item{% endif %} nav-item-desktop{% endif %} nav-item {% if is_emprende %}nav-item-emprende{% endif %}" data-component="menu.item">
			<a class="nav-list-link {{ item.current ? 'selected' : '' }} {% if is_emprende %}nav-link-emprende{% endif %}" href="{% if item.url %}{{ item.url | setting_url }}{% else %}#{% endif %}">{{ item.name }}</a>
```

**Clases CSS asignadas:**
- `nav-item-emprende` → Se agrega al `<li>` (contenedor)
- `nav-link-emprende` → Se agrega al `<a>` (enlace)

---

### Paso 2: Carga de Google Fonts (Patrick Hand)

**Archivo:** `layouts/layout.tpl`

Se agregaron los enlaces de Google Fonts en la sección `<head>` para cargar la fuente "Patrick Hand".

#### Código Implementado:

```15:18:layouts/layout.tpl
{# Google Fonts - Patrick Hand para EMPRENDE #}
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Patrick+Hand&display=swap" rel="stylesheet">
```

**Explicación:**
- `preconnect` → Establece conexión temprana con Google Fonts para mejorar rendimiento
- `display=swap` → Permite mostrar texto con fuente del sistema mientras carga Patrick Hand

---

### Paso 3: Estilos CSS Inline en Layout

**Archivo:** `layouts/layout.tpl`

Se agregaron estilos CSS inline después de la carga del archivo `custom.css` para asegurar que los estilos se apliquen correctamente.

#### Código Implementado:

```76:125:layouts/layout.tpl
{# Estilo específico para EMPRENDE en el menú - Inline para asegurar carga #}
        <style>
            /* Estilo para el enlace EMPRENDE en el menú de navegación - Alta especificidad */
            .head-main .nav-desktop-list .nav-item-emprende .nav-link-emprende,
            .head-main .nav-desktop-list .nav-link-emprende,
            .nav-desktop-list .nav-item-emprende .nav-link-emprende,
            .nav-desktop-list .nav-link-emprende {
                color: #ff6b9d !important;
                font-weight: 700 !important;
                font-size: 1.65em !important;
                font-family: 'Patrick Hand', cursive !important;
                font-style: normal !important;
                text-decoration: none !important;
            }

            /* Hover state para EMPRENDE - Alta especificidad */
            .head-main .nav-desktop-list .nav-item-emprende .nav-link-emprende:hover,
            .head-main .nav-desktop-list .nav-link-emprende:hover,
            .nav-desktop-list .nav-item-emprende .nav-link-emprende:hover,
            .nav-desktop-list .nav-link-emprende:hover {
                color: #ff4d8a !important;
                text-decoration: none !important;
            }

            /* Estilo para el enlace EMPRENDE en el menú móvil (Hamburger) - Alta especificidad */
            .modal-nav-hamburger .nav-item-emprende .nav-link-emprende,
            .modal-nav-hamburger .nav-link-emprende,
            .nav-list-panel .nav-item-emprende .nav-link-emprende,
            .nav-list-panel .nav-link-emprende,
            .nav-body .nav-item-emprende .nav-link-emprende,
            .nav-body .nav-link-emprende {
                color: #ff6b9d !important;
                font-weight: 700 !important;
                font-size: 1.65em !important;
                font-family: 'Patrick Hand', cursive !important;
                font-style: normal !important;
                text-decoration: none !important;
            }

            /* Hover state para EMPRENDE en móvil - Alta especificidad */
            .modal-nav-hamburger .nav-item-emprende .nav-link-emprende:hover,
            .modal-nav-hamburger .nav-link-emprende:hover,
            .nav-list-panel .nav-item-emprende .nav-link-emprende:hover,
            .nav-list-panel .nav-link-emprende:hover,
            .nav-body .nav-item-emprende .nav-link-emprende:hover,
            .nav-body .nav-link-emprende:hover {
                color: #ff4d8a !important;
                text-decoration: none !important;
            }
        </style>
```

**Características de los estilos:**

1. **Alta especificidad**: Múltiples selectores anidados para asegurar que los estilos se apliquen sobre los estilos del tema base
2. **Desktop y móvil**: Estilos separados para ambos contextos
3. **Estados hover**: Color más oscuro al pasar el mouse (#ff4d8a)
4. **!important**: Necesario para sobrescribir estilos del tema con alta especificidad

---

### Paso 4: Estilos CSS en Archivo Personalizado

**Archivo:** `static/css/custom.css`

Se agregaron los mismos estilos en el archivo CSS personalizado como respaldo y para mantener consistencia.

#### Código Implementado:

```278:332:static/css/custom.css
/*============================================================================
  Estilo específico para EMPRENDE en el menú principal
==============================================================================*/

/* Estilo para el enlace EMPRENDE en el menú de navegación - Alta especificidad */
.head-main .nav-desktop-list .nav-item-emprende .nav-link-emprende,
.head-main .nav-desktop-list .nav-link-emprende,
.nav-desktop-list .nav-item-emprende .nav-link-emprende,
.nav-desktop-list .nav-link-emprende {
  color: #ff6b9d !important;
  font-weight: 700 !important;
  font-size: 1.65em !important;
  font-family: 'Patrick Hand', cursive !important;
  font-style: normal !important;
  text-decoration: none !important;
}

/* Hover state para EMPRENDE - Alta especificidad */
.head-main .nav-desktop-list .nav-item-emprende .nav-link-emprende:hover,
.head-main .nav-desktop-list .nav-link-emprende:hover,
.nav-desktop-list .nav-item-emprende .nav-link-emprende:hover,
.nav-desktop-list .nav-link-emprende:hover {
  color: #ff4d8a !important;
  text-decoration: none !important;
}

/*============================================================================
  Estilo específico para EMPRENDE en el menú móvil (Hamburger)
==============================================================================*/

/* Estilo para el enlace EMPRENDE en el menú móvil - Alta especificidad */
.modal-nav-hamburger .nav-item-emprende .nav-link-emprende,
.modal-nav-hamburger .nav-link-emprende,
.nav-list-panel .nav-item-emprende .nav-link-emprende,
.nav-list-panel .nav-link-emprende,
.nav-body .nav-item-emprende .nav-link-emprende,
.nav-body .nav-link-emprende {
  color: #ff6b9d !important;
  font-weight: 700 !important;
  font-size: 1.65em !important;
  font-family: 'Patrick Hand', cursive !important;
  font-style: normal !important;
  text-decoration: none !important;
}

/* Hover state para EMPRENDE en móvil - Alta especificidad */
.modal-nav-hamburger .nav-item-emprende .nav-link-emprende:hover,
.modal-nav-hamburger .nav-link-emprende:hover,
.nav-list-panel .nav-item-emprende .nav-link-emprende:hover,
.nav-list-panel .nav-link-emprende:hover,
.nav-body .nav-item-emprende .nav-link-emprende:hover,
.nav-body .nav-link-emprende:hover {
  color: #ff4d8a !important;
  text-decoration: none !important;
}

/* Asegurar que el estilo se aplique solo a EMPRENDE y no afecte otros elementos */
```

**Carga del archivo CSS:**

El archivo `custom.css` se carga en `layouts/layout.tpl`:

```73:74:layouts/layout.tpl
{# Custom CSS file #}
        {{ 'css/custom.css' | static_url | static_inline }}
```

---

## 🎨 Propiedades CSS Aplicadas

### Color
- **Normal**: `#ff6b9d` (rosa vibrante)
- **Hover**: `#ff4d8a` (rosa más oscuro)

### Fuente
- **Familia**: `'Patrick Hand', cursive`
- **Peso**: `700` (negrita)
- **Tamaño**: `1.65em` (65% más grande que el tamaño base)
- **Estilo**: `normal` (no cursiva, aunque la fuente es handwritten)

### Otros Estilos
- **Decoración de texto**: `none` (sin subrayado)
- **Especificidad**: Alta (múltiples clases anidadas)
- **Importancia**: `!important` (para sobrescribir estilos del tema)

---

## 🔍 Selectores CSS Utilizados

### Desktop
- `.head-main .nav-desktop-list .nav-item-emprende .nav-link-emprende`
- `.head-main .nav-desktop-list .nav-link-emprende`
- `.nav-desktop-list .nav-item-emprende .nav-link-emprende`
- `.nav-desktop-list .nav-link-emprende`

### Móvil (Hamburger Menu)
- `.modal-nav-hamburger .nav-item-emprende .nav-link-emprende`
- `.modal-nav-hamburger .nav-link-emprende`
- `.nav-list-panel .nav-item-emprende .nav-link-emprende`
- `.nav-list-panel .nav-link-emprende`
- `.nav-body .nav-item-emprende .nav-link-emprende`
- `.nav-body .nav-link-emprende`

**Razón de múltiples selectores:**
- Asegurar que los estilos se apliquen en diferentes contextos del DOM
- Sobrescribir estilos del tema con mayor especificidad
- Cubrir diferentes estructuras HTML según el estado del menú

---

## ⚙️ Consideraciones Técnicas

### 1. Especificidad CSS
Los selectores con mayor especificidad tienen prioridad. Por eso se usan múltiples clases anidadas en lugar de un selector simple como `.nav-link-emprende`.

### 2. Uso de !important
Se utiliza `!important` porque los estilos del tema base de Tiendanube tienen alta especificidad y necesitan ser sobrescritos.

### 3. Estilos Duplicados
Los estilos están tanto en `layout.tpl` (inline) como en `custom.css` para:
- **Inline**: Asegurar carga inmediata y evitar problemas de caché
- **CSS externo**: Mantener código organizado y reutilizable

### 4. Compatibilidad Desktop y Móvil
Se implementaron estilos separados para desktop y móvil porque:
- Estructura HTML diferente
- Clases CSS diferentes según el contexto
- Menú hamburguesa tiene su propio sistema de clases

### 5. Detección Flexible
La lógica de detección en el template es flexible para capturar:
- Variaciones de mayúsculas/minúsculas
- Variantes en diferentes idiomas (EMPRENDE/EMPRENDA)
- Texto que contenga "EMPRENDE"

---

## ✅ Verificación

Para verificar que los estilos se aplicaron correctamente:

1. **Inspeccionar Elemento**: Abrir herramientas de desarrollador (F12) y buscar el elemento "EMPRENDE" en el HTML
2. **Verificar Clases**: Confirmar que las clases `nav-item-emprende` y `nav-link-emprende` están presentes
3. **Verificar Estilos**: En la pestaña "Computed" o "Estilos", verificar que los estilos CSS se están aplicando:
   - Color: `#ff6b9d`
   - Font-family: `'Patrick Hand', cursive`
   - Font-size: `1.65em`
   - Font-weight: `700`
4. **Probar Desktop y Móvil**: Verificar que los estilos funcionan en ambos contextos
5. **Probar Hover**: Verificar que el color cambia a `#ff4d8a` al pasar el mouse

---

## 📊 Resumen de Cambios

| Archivo | Líneas Modificadas | Tipo de Cambio |
|---------|-------------------|----------------|
| `snipplets/navigation/navigation-nav-list.tpl` | 6, 8, 12, 72, 74 | Lógica de detección y clases CSS |
| `layouts/layout.tpl` | 15-18, 76-125 | Google Fonts y estilos inline |
| `static/css/custom.css` | 278-332 | Estilos CSS externos |

---

## 🔄 Flujo de Implementación

```
1. Usuario carga la página
   ↓
2. layout.tpl carga Google Fonts (Patrick Hand)
   ↓
3. navigation-nav-list.tpl detecta elemento "EMPRENDE"
   ↓
4. Se asignan clases: nav-item-emprende y nav-link-emprende
   ↓
5. custom.css aplica estilos (o estilos inline en layout.tpl)
   ↓
6. Elemento "EMPRENDE" se muestra con color rosa y fuente Patrick Hand
```

---

## 📚 Referencias

- **Google Fonts - Patrick Hand**: https://fonts.google.com/specimen/Patrick+Hand
- **Especificidad CSS**: https://developer.mozilla.org/es/docs/Web/CSS/Specificity
- **Guía de Personalización**: Ver `GUIA_PERSONALIZAR_ELEMENTO_MENU.md`

---

## 🎯 Resultado Final

El elemento "EMPRENDE" en el menú principal ahora se muestra con:
- ✅ Color rosa personalizado (#ff6b9d)
- ✅ Fuente handwritten (Patrick Hand)
- ✅ Tamaño 65% más grande (1.65em)
- ✅ Negrita (font-weight: 700)
- ✅ Efecto hover con color más oscuro (#ff4d8a)
- ✅ Funciona en desktop y móvil

---

**Última actualización:** 2024  
**Versión:** 1.0  
**Autor:** Documentación técnica del proyecto

