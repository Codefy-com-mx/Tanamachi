# Guía: Personalizar un Elemento Específico del Menú de Navegación

Esta guía explica cómo personalizar el estilo (color, fuente, tamaño, negrita) de un elemento específico del menú de navegación sin afectar los demás elementos.

## 📋 Caso de Uso

Personalizar el elemento "EMPRENDE" en el menú principal con:
- Color rosa personalizado
- Fuente handwritten (Patrick Hand)
- Tamaño más grande (1.65em)
- Negrita (font-weight: 700)

## 🔧 Pasos para Implementar

### 1. Modificar el Template de Navegación

**Archivo:** `snipplets/navigation/navigation-nav-list.tpl`

Agregar lógica para detectar el elemento específico y asignar clases CSS personalizadas:

```twig
{% for item in navigation %}
    {# Detectar el elemento específico (ejemplo: EMPRENDE) #}
    {% set is_emprende = item.name | upper == 'EMPRENDE' or item.name | upper == 'EMPRENDA' or 'EMPRENDE' in (item.name | upper) %}
    
    {% if item.subitems %}
        <li class="... nav-item {% if is_emprende %}nav-item-emprende{% endif %}" data-component="menu.item">
            <a class="... nav-list-link ... {% if is_emprende %}nav-link-emprende{% endif %}" href="...">
                {{ item.name }}
            </a>
            {# ... resto del código ... #}
        </li>
    {% else %}
        {% set is_emprende = item.name | upper == 'EMPRENDE' or item.name | upper == 'EMPRENDA' or 'EMPRENDE' in (item.name | upper) %}
        <li class="... nav-item {% if is_emprende %}nav-item-emprende{% endif %}" data-component="menu.item">
            <a class="nav-list-link ... {% if is_emprende %}nav-link-emprende{% endif %}" href="...">
                {{ item.name }}
            </a>
        </li>
    {% endif %}
{% endfor %}
```

**Nota:** Reemplazar `EMPRENDE` y `emprende` con el nombre del elemento que deseas personalizar.

### 2. Agregar Google Fonts (si es necesario)

**Archivo:** `layouts/layout.tpl`

Si necesitas una fuente personalizada de Google Fonts, agregar en la sección `<head>`:

```twig
{# Google Fonts - Nombre de la fuente #}
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nombre+Fuente&display=swap" rel="stylesheet">
```

**Ejemplo con Patrick Hand:**
```twig
<link href="https://fonts.googleapis.com/css2?family=Patrick+Hand&display=swap" rel="stylesheet">
```

### 3. Agregar Estilos CSS

#### Opción A: Archivo CSS Personalizado

**Archivo:** `static/css/custom.css`

```css
/*============================================================================
  Estilo específico para [NOMBRE_ELEMENTO] en el menú principal
==============================================================================*/

/* Estilo para el enlace en el menú de navegación DESKTOP - Alta especificidad */
.head-main .nav-desktop-list .nav-item-[nombre] .nav-link-[nombre],
.head-main .nav-desktop-list .nav-link-[nombre],
.nav-desktop-list .nav-item-[nombre] .nav-link-[nombre],
.nav-desktop-list .nav-link-[nombre] {
  color: #ff6b9d !important;                    /* Color personalizado */
  font-weight: 700 !important;                  /* Negrita (400=normal, 700=bold) */
  font-size: 1.65em !important;                 /* Tamaño (1em=normal, 1.65em=65% más grande) */
  font-family: 'Patrick Hand', cursive !important; /* Fuente personalizada */
  font-style: normal !important;
  text-decoration: none !important;
}

/* Hover state para DESKTOP - Alta especificidad */
.head-main .nav-desktop-list .nav-item-[nombre] .nav-link-[nombre]:hover,
.head-main .nav-desktop-list .nav-link-[nombre]:hover,
.nav-desktop-list .nav-item-[nombre] .nav-link-[nombre]:hover,
.nav-desktop-list .nav-link-[nombre]:hover {
  color: #ff4d8a !important;                    /* Color hover (más oscuro) */
  text-decoration: none !important;
}

/*============================================================================
  Estilo específico para [NOMBRE_ELEMENTO] en el menú móvil (Hamburger)
==============================================================================*/

/* Estilo para el enlace en el menú móvil - Alta especificidad */
.modal-nav-hamburger .nav-item-[nombre] .nav-link-[nombre],
.modal-nav-hamburger .nav-link-[nombre],
.nav-list-panel .nav-item-[nombre] .nav-link-[nombre],
.nav-list-panel .nav-link-[nombre],
.nav-body .nav-item-[nombre] .nav-link-[nombre],
.nav-body .nav-link-[nombre] {
  color: #ff6b9d !important;                    /* Color personalizado */
  font-weight: 700 !important;                  /* Negrita */
  font-size: 1.65em !important;                 /* Tamaño */
  font-family: 'Patrick Hand', cursive !important; /* Fuente personalizada */
  font-style: normal !important;
  text-decoration: none !important;
}

/* Hover state para MÓVIL - Alta especificidad */
.modal-nav-hamburger .nav-item-[nombre] .nav-link-[nombre]:hover,
.modal-nav-hamburger .nav-link-[nombre]:hover,
.nav-list-panel .nav-item-[nombre] .nav-link-[nombre]:hover,
.nav-list-panel .nav-link-[nombre]:hover,
.nav-body .nav-item-[nombre] .nav-link-[nombre]:hover,
.nav-body .nav-link-[nombre]:hover {
  color: #ff4d8a !important;                    /* Color hover */
  text-decoration: none !important;
}
```

#### Opción B: CSS Inline en Layout (Recomendado para asegurar carga)

**Archivo:** `layouts/layout.tpl`

Agregar en la sección `<head>`, después de los otros estilos:

```twig
{# Estilo específico para [NOMBRE_ELEMENTO] en el menú - Inline para asegurar carga #}
<style>
    /* Estilo para el enlace en el menú de navegación DESKTOP - Alta especificidad */
    .head-main .nav-desktop-list .nav-item-[nombre] .nav-link-[nombre],
    .head-main .nav-desktop-list .nav-link-[nombre],
    .nav-desktop-list .nav-item-[nombre] .nav-link-[nombre],
    .nav-desktop-list .nav-link-[nombre] {
        color: #ff6b9d !important;
        font-weight: 700 !important;
        font-size: 1.65em !important;
        font-family: 'Patrick Hand', cursive !important;
        font-style: normal !important;
        text-decoration: none !important;
    }

    /* Hover state para DESKTOP - Alta especificidad */
    .head-main .nav-desktop-list .nav-item-[nombre] .nav-link-[nombre]:hover,
    .head-main .nav-desktop-list .nav-link-[nombre]:hover,
    .nav-desktop-list .nav-item-[nombre] .nav-link-[nombre]:hover,
    .nav-desktop-list .nav-link-[nombre]:hover {
        color: #ff4d8a !important;
        text-decoration: none !important;
    }

    /* Estilo para el enlace en el menú móvil (Hamburger) - Alta especificidad */
    .modal-nav-hamburger .nav-item-[nombre] .nav-link-[nombre],
    .modal-nav-hamburger .nav-link-[nombre],
    .nav-list-panel .nav-item-[nombre] .nav-link-[nombre],
    .nav-list-panel .nav-link-[nombre],
    .nav-body .nav-item-[nombre] .nav-link-[nombre],
    .nav-body .nav-link-[nombre] {
        color: #ff6b9d !important;
        font-weight: 700 !important;
        font-size: 1.65em !important;
        font-family: 'Patrick Hand', cursive !important;
        font-style: normal !important;
        text-decoration: none !important;
    }

    /* Hover state para MÓVIL - Alta especificidad */
    .modal-nav-hamburger .nav-item-[nombre] .nav-link-[nombre]:hover,
    .modal-nav-hamburger .nav-link-[nombre]:hover,
    .nav-list-panel .nav-item-[nombre] .nav-link-[nombre]:hover,
    .nav-list-panel .nav-link-[nombre]:hover,
    .nav-body .nav-item-[nombre] .nav-link-[nombre]:hover,
    .nav-body .nav-link-[nombre]:hover {
        color: #ff4d8a !important;
        text-decoration: none !important;
    }
</style>
```

### 4. Cargar el Archivo CSS Personalizado (si usas Opción A)

**Archivo:** `layouts/layout.tpl`

Agregar después de los otros estilos CSS:

```twig
{# Custom CSS file #}
{{ 'css/custom.css' | static_url | static_inline }}
```

## 🎨 Personalización de Propiedades

### Color
```css
color: #ff6b9d !important;  /* Color hexadecimal */
color: rgb(255, 107, 157) !important;  /* RGB */
color: rgba(255, 107, 157, 1) !important;  /* RGBA con transparencia */
```

### Tamaño de Fuente
```css
font-size: 1em !important;      /* Tamaño normal */
font-size: 1.15em !important;  /* 15% más grande */
font-size: 1.3em !important;   /* 30% más grande */
font-size: 1.65em !important;  /* 65% más grande */
font-size: 18px !important;    /* Tamaño fijo en píxeles */
```

### Peso de Fuente (Negrita)
```css
font-weight: 400 !important;  /* Normal */
font-weight: 500 !important;  /* Medium */
font-weight: 600 !important;  /* Semi-bold */
font-weight: 700 !important;  /* Bold (negrita) */
font-weight: 800 !important;  /* Extra-bold */
font-weight: 900 !important;  /* Black */
```

### Fuente Personalizada
```css
/* Fuente del sistema */
font-family: 'Arial', sans-serif !important;

/* Google Fonts */
font-family: 'Patrick Hand', cursive !important;
font-family: 'Roboto', sans-serif !important;
font-family: 'Open Sans', sans-serif !important;

/* Múltiples fuentes (fallback) */
font-family: 'Patrick Hand', 'Comic Sans MS', cursive, sans-serif !important;
```

### Otros Estilos
```css
font-style: italic !important;     /* Cursiva */
text-decoration: underline !important;  /* Subrayado */
text-transform: uppercase !important;    /* Mayúsculas */
letter-spacing: 2px !important;   /* Espaciado entre letras */
```

## 📝 Ejemplo Completo: Personalizar "CONTACTO"

### 1. Template (`navigation-nav-list.tpl`)
```twig
{% set is_contacto = item.name | upper == 'CONTACTO' or 'CONTACTO' in (item.name | upper) %}
<li class="... nav-item {% if is_contacto %}nav-item-contacto{% endif %}">
    <a class="nav-list-link ... {% if is_contacto %}nav-link-contacto{% endif %}" href="...">
        {{ item.name }}
    </a>
</li>
```

### 2. CSS (`custom.css` o inline)
```css
.nav-desktop-list .nav-link-contacto {
  color: #007bff !important;           /* Azul */
  font-weight: 600 !important;        /* Semi-bold */
  font-size: 1.2em !important;         /* 20% más grande */
  font-family: 'Roboto', sans-serif !important;
}
```

## ⚠️ Notas Importantes

1. **Especificidad CSS**: Los selectores con mayor especificidad (más clases anidadas) tienen prioridad. Por eso usamos `.head-main .nav-desktop-list .nav-link-[nombre]` en lugar de solo `.nav-link-[nombre]`.

2. **!important**: Se usa `!important` para sobrescribir estilos del tema base que tienen alta especificidad.

3. **Desktop y Móvil**: Asegúrate de agregar estilos tanto para desktop (`.nav-desktop-list`) como para móvil (`.modal-nav-hamburger`, `.nav-list-panel`).

4. **Detección del Elemento**: La lógica de detección en el template debe ser flexible para capturar variaciones del nombre (mayúsculas, minúsculas, acentos, etc.).

5. **Caché del Navegador**: Después de hacer cambios, recarga la página con `Ctrl+F5` (Windows) o `Cmd+Shift+R` (Mac) para limpiar la caché.

## 🔍 Verificación

Para verificar que los estilos se aplicaron correctamente:

1. **Inspeccionar Elemento**: Abre las herramientas de desarrollador (F12) y busca el elemento en el HTML.
2. **Verificar Clases**: Confirma que las clases `nav-item-[nombre]` y `nav-link-[nombre]` están presentes.
3. **Verificar Estilos**: En la pestaña "Computed" o "Estilos", verifica que tus estilos CSS se están aplicando.
4. **Probar Desktop y Móvil**: Verifica que los estilos funcionan tanto en desktop como en móvil.

## 📚 Referencias

- **Google Fonts**: https://fonts.google.com/
- **Colores Hexadecimales**: https://htmlcolorcodes.com/
- **Especificidad CSS**: https://developer.mozilla.org/es/docs/Web/CSS/Specificity

---

**Última actualización:** 2024
**Versión:** 1.0

